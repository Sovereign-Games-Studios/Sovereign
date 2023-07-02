class_name NPC
extends CharacterBody3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var target = null
var current_path: PackedVector3Array
var nav_map: RID
var definition: Resource
var current_health
var sprite
var team
var healing_potions = 0
var basic_attack: Resource
var level
var exp
var behaviour
var personality: Personality
var brain: NpcBrain
# Array of actions to be done in order of queue starting at index 0.
var action_queue: Array
var occupied_building: Building
# State the NPC is currently in.
var state: String

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	var overlapping = $Vision.get_overlapping_bodies()
	for node in overlapping:
		if node.team == "enemy":
			set_destination(node.global_position)
	if $NavigationAgent3D.is_target_reachable():
		var target = $NavigationAgent3D.get_next_path_position()
		velocity = (target - self.global_position).normalized() * definition.speed
		$NavigationAgent3D.set_velocity(velocity)
	else:
		
		$NavigationAgent3D.set_velocity(Vector3.ZERO)
	move_and_slide()

func initialize(start_position, character_name, team):
	self.set_position(start_position)
	self.definition = ResourceLoader.load("res://Resources/Characters/CharacterDefinitions/"+character_name.to_lower()+".tres")
	self.definition.get_script()
	if(self.definition.basic_attack):
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
	print("New Destination: ", destination)
	print("Current location: ", self.global_position )
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
