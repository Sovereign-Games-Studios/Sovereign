class_name NPC
extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

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
	$NavigationAgent3D.target_position = position
	pass # Replace with function body.

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	var overlapping = $Vision.get_overlapping_bodies()
	for node in overlapping:
		if node.team == "enemy":
			set_destination(node.position)
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
