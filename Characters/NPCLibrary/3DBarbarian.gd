extends NPC

var isReady: bool
var bought: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.add_to_group("Player Entities")
	await get_tree().create_timer(0.1).timeout
	nav_map = get_world_3d().get_navigation_map()
	set_destination(Vector3(-71, 0, 0))
	bought = false
	isReady = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isReady:
		if self.global_position.distance_to(get_node("../Rock").global_position) < 5 and not bought and false:
			$NavigationAgent3D.set_velocity(Vector3.ZERO)
			var building = get_node("../Rock")
			building.services[0].sellItem(self, "Sword of Bashing", building)
			self.equipped_items.equipItem(self, "Sword of Bashing")
			bought = true
			# leaveBuilding(self, building)
		if $NavigationAgent3D.is_target_reachable():
			var target = $NavigationAgent3D.get_next_path_position()
			$NavigationAgent3D.set_velocity(velocity)
		else:
			$NavigationAgent3D.set_velocity(Vector3.ZERO)
	move_and_slide()
	pass


	
func set_destination(new_destination:Vector3):
	var destination = new_destination
	$NavigationAgent3D.set_target_position(destination)

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	set_velocity(safe_velocity)
	pass # Replace with function body.
