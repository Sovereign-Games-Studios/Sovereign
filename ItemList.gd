extends ItemList

var currently_selected_item
var item_scenes
var selected_sprite
var item_images
# Called when the node enters the scene tree for the first time.
func _ready():
	item_scenes = preload("res://BuildingScripts/Building_Scenes.gd").new()
	item_images = preload("res://BuildingScripts/Building_Images.gd").new()
	currently_selected_item = null
	pass # Replace with function body.

func _gui_input(event):
	currently_selected_item = get_selected_items()
	if(currently_selected_item.size() > 0):
		currently_selected_item = get_item_text(currently_selected_item[0])
		selected_sprite = Sprite3D.new()
		selected_sprite.texture = item_images.get_building_sprite(currently_selected_item)
		print("IMAGE_LOADED: ", selected_sprite)
		
func _input(event):
	if currently_selected_item != null && selected_sprite != null:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			# Place Building
			print("PLACING: ", currently_selected_item)
			var building_scene = item_scenes.get_building_scene(currently_selected_item)
			print("BUILDING SCENE: ", building_scene)
			var building = building_scene.instantiate()
			building.initialize(selected_sprite.position, "player", currently_selected_item)
			add_child(building)
			deselect_all()
			selected_sprite = null
			currently_selected_item = null
			
		if event is InputEventMouseMotion:
			# Move sprite to show where building will be on click
			var camera = get_node("../../../Camera3D")
			var mouse_pos = get_viewport().get_mouse_position()
			var dropPlane  = Plane(Vector3(1, 1, 1), 1)
			var position3D = dropPlane.intersects_ray(
								 camera.project_ray_origin(mouse_pos),
								 camera.project_ray_normal(mouse_pos))
			if(position3D != null):
				var transform = camera.get_global_transform()
				print("Position before transform: ", position3D)
				position3D = transform * position3D
				#position3D -= camera.original_position
				selected_sprite.set_position(Vector3(position3D.x, 1, position3D.y))
				print("Sprite Position: ", selected_sprite.position)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	pass
