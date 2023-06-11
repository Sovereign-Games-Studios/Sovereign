extends NPC




# Get the gravity from the project settings to be synced with RigidBody nodes.

func _physics_process(_delta):
	if current_health <= 0:
		print("The ", self.char_class, " has been slain!")
		queue_free()
		
	var overlapping = self.get_node("Area2D").get_overlapping_bodies()
	for node in overlapping:
		if node.team == "player":
			print(self.char_class, " is pursuing Player!")
			var target_pos = node.global_position
			var fullv = target_pos - self.global_position
			var unitv = fullv.normalized()
			velocity = unitv * 10
	move_and_slide()

func initialize(start_position, player_position):
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	char_class = "grue"
	look_at(player_position)
	set_global_position(start_position)
	team = "enemy"
	stats = Statistics.getStats("generic_npc")
	max_health = 10
	current_health = 10
	var vel = player_position - self.global_position
	var unitv = vel.normalized()
	velocity = unitv * 10
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

	
