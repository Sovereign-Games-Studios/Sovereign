extends Camera3D

var align_time = .2
var original_position
var colliding_entity = null
var selected_ui = null
var ui_node

## the speed of the camera scroll is computed as scroll_speed_base^x + 1
## where x is the distance from camera to the object
var scroll_speed_base = 1.03

## how close the camera allowed to zoom
var min_distance = 1
## how far the camera is allowed
var max_distance = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	ui_node = preload("res://UserInterface/selected_building_ui.tscn")
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
	if event is InputEventKey:
		if colliding_entity and event.keycode == KEY_ESCAPE:
			colliding_entity = null
	if event is InputEventMouse:
		var mouse = event.position
		var ground_plane = get_node("../GroundPlane/CollisionShape3D").shape.get_plane()
		var start = project_ray_origin(mouse)
		var end = start + project_ray_normal(mouse) * 10000
		
		if event is InputEventMouseButton:
			# Select Entity
			if event.button_index == MOUSE_BUTTON_LEFT:
				var worldspace = get_world_3d().direct_space_state		
				var check_colliding_entity = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(start, end))
				if(check_colliding_entity.has("collider")):
					colliding_entity = check_colliding_entity["collider"]
					
			# Scroll Wheel interaction to Zoom in 
			if event.button_index == 4:
				var object_below = get_ray_intersect(event.position)
				var distance = global_position.distance_to(object_below)
				if distance > min_distance:
					self.transform.origin.y -= pow(scroll_speed_base, distance) - 1
			# Scroll Wheel interaction to Zoom out
			elif event.button_index == 5:
				var object_below = get_ray_intersect(event.position)
				var distance = global_position.distance_to(object_below)
				if distance < max_distance:
					self.transform.origin.y += pow(scroll_speed_base, distance) - 1

func get_ray_intersect(mouse):

	var start = project_ray_origin(mouse)
	var end = start + project_ray_normal(mouse) * 10000
	
	var worldspace = get_world_3d().direct_space_state		
	var check_colliding_entity = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(start, end))
	
	# check that position exists
	if(check_colliding_entity.has("collider")):
		colliding_entity = check_colliding_entity["collider"]
		return check_colliding_entity.position
	return Vector3(0,0,0)
	
