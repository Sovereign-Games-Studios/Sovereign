class_name NPC
extends CharacterBody3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var target: Node3D
var current_path: PackedVector3Array
var nav_map: RID
var definition: Resource
var attributes: Attributes
var current_health: int
var sprite
var team: String
var healing_potions = 0
var basic_attack: Attack
var level: int
var exp: int
var gold: int
var behaviour: BehaviourTree
var personality: Personality
var brain: NpcBrain
# Array of actions to be done in order of queue starting at index 0.
var action_queue: Array
var occupied_building: Building
# State the NPC is currently in.
var state: String
var mutex = Mutex.new()
var root_node = GameStateInit.list_of_bts["idle"]
var home: Building
var team_state: TeamState
var ability_list = []
var ability_cooldown = false

var max_health

signal death_signal

'''
Runs as soon as the NPC enters the world.
'''
func _ready():
	$NavigationAgent3D.set_target_position(self.global_position)
	self.team_state = get_node("/root/World").teams[self.team]	
	self.behaviour.initialize(self.team_state.list_of_bts["idle"], self.team_state, self)
	add_child(self.behaviour)
	if self.definition.character_type == "Hero":
		self.healing_potions = 10
	pass # Replace with function body.

	
'''
Runs every game tick.
'''
func _process(delta):
	var current_percent = self.current_health/self.definition.max_health
	if current_percent < .20 and self.state != "retreat":
		_handle_state_change("low_health")				
		
	if self.current_health < 0:
		self.team = "corpse"
		var gold_roll = 0
		if self.definition.character_type == "Monster":
			gold_roll = randi_range(self.definition.min_drop, self.definition.max_drop)
			for node in $Vision.get_overlapping_bodies():
				if node is NPC and node.definition.character_type == "Hero" and node.team != self.team:
					node.exp += self.definition.exp_value
					node.gold += gold_roll
					print(self.definition.name, " has died! Gold and exp has been distributed to ", node.definition.name)
				
		self.death_signal.emit()
		self.queue_free()
		self.hide()
	
	# Every character handles the level up differently as defined in their definiton.
	if self.exp > 1000:
		self.exp -= 1000
		self.level += 1
		if self.definition.character_type == "Hero":
			print(self.definition.name, " has levelled up! Previous Strength: ", self.attributes.strength)
			self.definition._handle_level_up(self)
			print("New Strength: ", self.attributes.strength)
			
		
'''
Runs every physics tick
'''
func _physics_process(delta):
	velocity.y -= gravity * delta
	# Add the gravity.
	if self.global_position.y < -10:
		self.global_position.y = 10 
	var overlapping = $Vision.get_overlapping_bodies()	
			
	for node in overlapping:
		if self.team == "player" and node.team == "enemy":
			if not node in self.brain.enemies_in_range:
				mutex.lock()			
				self.brain.enemies_in_range.append(node)
				mutex.unlock()
				_handle_state_change("combat")
		elif self.team == "enemy" and node.team == "player":
			if not node in self.brain.enemies_in_range:
				mutex.lock()
				self.brain.enemies_in_range.append(node)
				mutex.unlock()		
				_handle_state_change("combat")				
				
	# TODO: temporary fix -- do not use pathplanning. Just walk in direction
	if is_on_floor():
		var vec = ($NavigationAgent3D.target_position - self.global_position).normalized() * self.attributes.speed
		velocity.x = vec.x
		velocity.z = vec.z
		
	move_and_slide()
	
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var body := collision.get_collider()
		# Only perform alignment when hit with terrain?
		# Could apply to other scenarios
		if (body.name == "Terrain"):
			# Get the normal right below us 
			var n = $RayCast3D.get_collision_normal()
			# Transform and interpolate with current orientation
			var xform = align_with_y(global_transform, n)
			global_transform = global_transform.interpolate_with(xform, 0.2)

'''
Called before placing the NPC in the world, sets the initial conditions and primary attributes of the NPC.
'''
func initialize(start_position, character_name, team, home: Building):
	self.home = home
	self.set_position(start_position)
	self.definition = ResourceLoader.load("res://Resources/Characters/CharacterDefinitions/"+character_name.to_lower()+".tres")
	self.definition.get_script()
	self.team = team
	self.max_health = self.definition.max_health	
	self.current_health = self.definition.max_health
	self.state = "idle"
	# Used to track Fog of War Reveal
	if(team == "player"):
		self.add_to_group("Player Entities")
	
	# Handle Sprite
	if(self.definition.sprite_override):
		self.sprite = load("res://Resources/Characters/Images/"+self.definition.sprite_override+".png")
	else:
		self.sprite = load("res://Resources/Characters/Images/"+character_name.to_lower()+".png")
	$Sprite.texture = self.sprite
	
	# Level and Experience - Not yet implemented.
	self.level = 1
	self.exp = 0

	# Attributes
	self.attributes = Attributes.new()
	self.attributes.initialize(self, self.definition)

	# Attacks
	self.basic_attack = Attack.new()
	if(self.definition.basic_attack != null):
		self.basic_attack.initialize(ResourceLoader.load("res://Resources/AttackDefinitions/"+self.definition.basic_attack.to_lower()+"_attack.tres"))
	else:
		self.basic_attack.initialize(ResourceLoader.load("res://Resources/AttackDefinitions/basic_attack.tres"))
	self.basic_attack.get_script()		
	$AttackSpeed.wait_time = self.basic_attack.attack_speed
	$AttackSpeed.timeout.connect(_attack_target)
	
	# Ability Handling
	if(self.definition.abilities.size() > 0):
		for ability_name in self.definition.abilities:
			self.ability_list.append(ResourceLoader.load("res://Resources/AbilityDefinitions/"+ability_name+".tres"))
	
	# instantiate personality of NPC.
	self.personality = Personality.new()
	self.personality.initialize(self.definition)
	
	# The NPC's blackboard/knowledge of its own state
	self.brain = NpcBrain.new()
	self.brain.initialize(self.personality)
	
	# The NPC's behaviour Tree which handles basic actions and decides which ones to take. 
	self.behaviour = BehaviourTree.new()

'''
Sets the NPC's destination in the Nav Agent.
'''
func set_destination(new_destination):
	var destination = new_destination
	$NavigationAgent3D.set_target_position(destination)

'''
Computes velicty and sets it.
'''
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	set_velocity(safe_velocity)
	pass # Replace with function body.

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


'''
Utility function to align our NPC.
'''
func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
	
func _attack_target():
	if self.state == "combat":
		if is_instance_valid(self.target):
			var distance_to_target = distance(self, self.team_state)
			if distance_to_target < self.basic_attack.range:
				if self.definition.character_type == "Hero":	
					self.exp += 50				
				var damage = Damage.calculateDamage(self, self.target)
				self.target.current_health -= damage
				if self.target is NPC:
					self.target._handle_state_change("combat")
				for ability in ability_list:
					if not self.ability_cooldown:
						if distance_to_target < ability.range:
							handle_ability_cast(ability)
							if self.definition.character_type == "Hero":							
								self.exp += 100

func handle_ability_cast(ability):
	
	self.ability_cooldown = true
	if ability.type == "Damage":
		if ability.target == "Area":
			ability.damage_ability(self, self.target.global_position)

'''
Signal handling function that connects to the target's death signal.
'''
func _handle_target_death():
	mutex.lock()
	self.brain.enemies_in_range.remove_at(self.brain.enemies_in_range.find(self.target))
	mutex.unlock()
	self.target = null
	if self.brain.enemies_in_range.size() > 0:
		self.behaviour.interrupt(self.team_state.list_of_bts["combat"])
	else: 
		_handle_state_change("idle")

'''
Handling function for when the NPC's state has changed due to external factors
Will not be called when normally setting NPC state. 

Examples of when to call this function and use it to set state:
	- You recieve damage
	- An enemy comes within vision range
	
Examples of when NOT to call this function and set state directly:
	- Starting exploration
	- Attacking an enemy 
'''
func _handle_state_change(new_state):
	if new_state != self.state:
		self.state = new_state
		await self.behaviour.interrupt(self.team_state.list_of_bts[self.state])	

'''
Tell NPC to exit building
'''
func leaveBuilding(target_building:Building):
	var found = target_building.current_occupants.find(self)
	if found >= 0:
		target_building.current_occupants.remove_at(found) 
		self.show()
		
'''
Tell NPC to enter building
'''
func enterBuilding(target_building:Building):
	if self.global_position.distance_to(target_building.global_position) < 10:
		target_building.current_occupants.append(self) 
		self.hide()

func distance(npc: NPC, team_state: TeamState):
	var enemy_npc = npc.target
	var enemy_pos = enemy_npc.global_position
	var enemy_x = enemy_pos.x
	var enemy_y = enemy_pos.y
	var enemy_z = enemy_pos.z
	var npc_pos = npc.global_position
	var npc_x = npc_pos.x
	var npc_y = npc_pos.y
	var npc_z = npc_pos.z
	
	var distance = sqrt(pow((enemy_x - npc_x), 2) + pow((enemy_y - npc_y), 2) + pow((enemy_z - npc_z), 2)) 
	return distance
