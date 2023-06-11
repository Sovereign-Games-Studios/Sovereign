extends CharacterBody2D

var SPEED = 30.0
var overlapping
var target_pos
var fullv
var unitv

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_meta("Team", "player")
	pass # Replace with function body.

func _process(delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	overlapping = self.get_node("Area2D").get_overlapping_bodies()
	for node in overlapping:
		if node.get_meta("Team") == "enemy":
			target_pos = node.global_position
			fullv = target_pos - self.global_position
			unitv = fullv.normalized()
			velocity = unitv * SPEED
	move_and_slide()
	
	pass
