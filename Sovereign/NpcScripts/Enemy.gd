extends CharacterBody2D


var min_speed = 15.0
var max_speed = 30.0

# Get the gravity from the project settings to be synced with RigidBody nodes.

func _physics_process(_delta):
	var overlapping = self.get_node("Area2D").get_overlapping_bodies()
	for node in overlapping:
		if node.get_meta("Team") == "player":
			print("Pursuing Player!")
			var target_pos = node.global_position
			var fullv = target_pos - self.global_position
			var unitv = fullv.normalized()
			var random_speed = randi_range(min_speed, max_speed)
			velocity = unitv * random_speed
	move_and_slide()

func initialize(start_position, player_position):
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at(player_position)
	set_global_position(start_position)
	self.set_meta("Team", "enemy")
	var random_speed = randi_range(min_speed, max_speed)

	var vel = player_position - self.global_position
	var unitv = vel.normalized()
	velocity = unitv * random_speed
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
