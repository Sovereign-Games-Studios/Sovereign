extends CharacterBody2D

var SPEED = 30.0
var overlapping
var target_pos
var fullv
var unitv

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	overlapping = self.get_node("Area2D").get_overlapping_bodies()
	for node in overlapping:
		if node.get_meta("tags")["name"] == "enemy":
			target_pos = node.global_position
			print(target_pos)
			fullv = target_pos - self.global_position
			unitv = fullv.normalized()
			velocity = unitv * SPEED
	move_and_slide()
	
	
	pass
