extends CharacterBody2D


var SPEED = 30.0

# Get the gravity from the project settings to be synced with RigidBody nodes.

func _process(delta):
	velocity.y = 15
	move_and_slide()
