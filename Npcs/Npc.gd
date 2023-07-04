class_name NPC
extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var target = null
var current_path: PackedVector3Array
var nav_map: RID
var definition: Resource
var current_health
var collision_info
var sprite
var team
var target_array
var healing_potions = 0
var basic_attack: Resource
var level
var exp
var behaviour
var personality: Personality
var brain: NpcBrain
# Array of actions to be done in order of queue starting at index 0.
var action_queue: Array
var thinking
var occupied_building: Building
# State the NPC is currently in.
var state: String
signal death_signal

func _ready():
	$NavigationAgent3D.target_position = position
	pass # Replace with function body.

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func _handle_target_death():
	self.thinking = true
	self.brain.enemies_in_range.remove_at(self.target_array)
	self.target = null
	print("Size of Array in npc after queue free: ", self.brain.enemies_in_range.size(), " NPC name is ", self.name)
	self.thinking = false
	
func _process(delta):
	if current_health < 0:
		self.death_signal.emit()
		self.queue_free()
		
func _physics_process(delta):
	velocity.y -= gravity * delta
	# Add the gravity.
	#if not is_on_floor():
	var overlapping = $Vision.get_overlapping_bodies()
	for node in overlapping:
		if self.team == "player" and node.team == "enemy":
			if not node in self.brain.enemies_in_range:
				self.brain.enemies_in_range.append(node)
		elif self.team == "enemy" and node.team == "player":
			if not node in self.brain.enemies_in_range:
				self.brain.enemies_in_range.append(node)		
	# TODO: temporary fix -- do not use pathplanning. Just walk in direction
	if is_on_floor():
		var vec = ($NavigationAgent3D.target_position - self.global_position).normalized() * definition.speed
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


func initialize(start_position, character_name, team):
	self.set_position(start_position)
	self.definition = ResourceLoader.load("res://Resources/Characters/CharacterDefinitions/"+character_name.to_lower()+".tres")
	self.definition.get_script()
	if(self.definition.basic_attack != null):
		self.basic_attack = ResourceLoader.load("res://Resources/AttackDefinitions/"+self.definition.basic_attack.to_lower()+"_attack.tres")	
	else:
		self.basic_attack = ResourceLoader.load("res://Resources/AttackDefinitions/basic_attack.tres")
	self.basic_attack.get_script()	
	self.team = team		
	self.current_health = self.definition.max_health
	if(team == "player"):
		self.add_to_group("Player Entities")
	# Handle Building Sprite
	if(self.definition.sprite_override):
		self.sprite = load("res://Resources/Characters/Images/"+self.definition.sprite_override+".png")
	else:
		self.sprite = load("res://Resources/Characters/Images/"+character_name.to_lower()+".png")
	$Sprite.texture = self.sprite
	level = 1
	exp = 0
	$Timer.wait_time = 5
	$Timer.timeout.connect(_on_timer_timeout)
	self.personality = Personality.new()
	self.personality.initialize(self.definition)
	self.brain = NpcBrain.new()
	self.brain.initialize(self.personality)
	self.behaviour = Behaviour.new()
	self.behaviour.root_node = GameStateInit.list_of_bts["idle"]

	
func _on_timer_timeout():
	self.behaviour.think(self, GameStateInit.list_of_bts["idle"])
		
func set_destination(new_destination:Vector3):
	var destination = new_destination
	$NavigationAgent3D.set_target_position(destination)

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	set_velocity(safe_velocity)
	pass # Replace with function body.

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func leaveBuilding(target_building:Building):
	var found = target_building.current_occupants.find(self)
	if found >= 0:
		target_building.current_occupants.remove_at(found) 
		self.show()

func enterBuilding(target_building:Building):
	if self.global_position.distance_to(target_building.global_position) < 10:
		target_building.current_occupants.append(self)
		self.hide()
		self.status = "Inside Building"
