extends CharacterBody2D


var SPEED = 30.0
var min_speed = 5.0
var max_speed = 20.0

# Get the gravity from the project settings to be synced with RigidBody nodes.

func _physics_process(_delta):
	move_and_slide()

func initialize(start_position, player_position):
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at(player_position)
	
	var random_speed = randi_range(min_speed, max_speed)

	
	var vel = player_position - self.global_position
	var unitv = vel.normalized()
	velocity = unitv * SPEED
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
