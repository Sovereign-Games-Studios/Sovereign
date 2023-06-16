extends NPC

# Get the gravity from the project settings to be synced with RigidBody nodes.
var last_attack = 0
var target = null
var current_path: PackedVector3Array
var nav_map: RID
# Temporary until I implement Barbarian Guilds
func _ready():
	nav_map = get_world_3d().get_navigation_map()
	pass # Replace with function body.

func _physics_process(_delta):
	var overlapping = self.get_node("Vision").get_overlapping_bodies()
	for node in overlapping:
		if node.team == "enemy":
			set_destination(node.global_position)
	if $NavigationAgent3D.is_target_reachable():
		var target = $NavigationAgent3D.get_next_path_position()
		velocity = global_transform.origin.direction_to(target).normalized() * speed
		$NavigationAgent3D.set_velocity(velocity)
	else:
		$NavigationAgent3D.set_velocity(Vector3.ZERO)
	move_and_slide()

func initialize(start_position):
	set_global_position(start_position)
	char_class = "Guard"
	team = "player"
	level = 1
	exp = 0
	$Timer.wait_time = 5
	inventory = []
	gold = 20
	equipped_items = []
	behaviour = "Hunt"
	spells = "TODO implement spells"
	stats = Statistics.getStats("generic_npc")
	attack = Attacks.getAttack("generic_npc")
	max_health = 10 + stats["Stamina"]
	current_health = 10 + stats["Stamina"]
	speed = 1
	$Timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout():
	# If we don't have a target start hunting enemies
	if(target == null):
		var offset = Behaviours.hunt()
		set_destination(self.position+offset)
		
func set_destination(new_destination:Vector3):
	var destination = new_destination
	$NavigationAgent3D.set_target_position(destination)

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	set_velocity(safe_velocity)
	pass # Replace with function body.

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
