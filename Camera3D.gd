extends Camera3D

var align_time = .2
var original_position
var current_global_mouse_position
# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = get_global_position()
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
	if event is InputEventMouse:
		var mouse = event.position
		var worldspace = get_world_3d().direct_space_state
		var ground_plane = get_node("../GroundPlane/CollisionShape3D").shape.get_plane()
		var start = project_ray_origin(mouse)
		var end = project_position(mouse, 100000)
		current_global_mouse_position = ground_plane.intersects_ray(start, end)
		
	if event is InputEventMouseButton:
		if event.button_index == 4:
			self.transform.origin.y -= 5
		elif event.button_index == 5:
			self.transform.origin.y += 5			
	pass
