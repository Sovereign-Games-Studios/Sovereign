class_name NPC
extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var target = null
var current_path: PackedVector3Array
var nav_map: RID
var definition: Resource
var sprite
var team
var basic_attack: Resource
var level
var exp
# Temporary until I implement Barbarian Guilds
func _ready():
	nav_map = get_world_3d().get_navigation_map()
	pass # Replace with function body.

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var overlapping = $Vision.get_overlapping_bodies()
	for node in overlapping:
		if node.team == "enemy":
			set_destination(node.global_position)
	if $NavigationAgent3D.is_target_reachable():
		var target = $NavigationAgent3D.get_next_path_position()
		velocity = global_transform.origin.direction_to(target).normalized() * definition.speed
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
	$Timer.wait_time = self.basic_attack.attack_speed
	$Timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout():
	# If we don't have a target start hunting enemies
	if(target == null):
		var offset = Behaviours.hunt()
		set_destination(self.position+offset)
	elif self.global_position.distance_to(target.global_position) < 10:
		var damage_dealt = Attacks.calculateDamage(self.basic_attack, target.definition)
		target.current_health -= damage_dealt
		
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
