extends Camera3D

var align_time = .2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var desired_pos = Vector3.ZERO
	if Input.is_action_pressed("A"):
		desired_pos.x += -25 * delta
	if Input.is_action_pressed("D"):
		desired_pos.x += 25 * delta
	if Input.is_action_pressed("W"):
		desired_pos.z += -25 * delta
	if Input.is_action_pressed("S"):
		desired_pos.z += 25 * delta

	self.transform.origin.x += desired_pos.x
	self.transform.origin.z += desired_pos.z

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 4:
			self.transform.origin.y -= 5
		elif event.button_index == 5:
			self.transform.origin.y += 5			
	#var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	#tween.tween_property(self, "position", desired_pos, align_time).from_current()
	pass
