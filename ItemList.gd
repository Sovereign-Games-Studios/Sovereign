extends ItemList

var currently_selected_item
var item_scenes
var item_images
var camera
# Called when the node enters the scene tree for the first time.
func _ready():
	item_scenes = preload("res://BuildingScripts/Building_Scenes.gd").new()
	item_images = preload("res://BuildingScripts/Building_Images.gd").new()
	camera = get_node("../../../Camera3D")
	currently_selected_item = null
	
	pass # Replace with function body.

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var item_list = get_selected_items()
			if(item_list.size() > 0):
				currently_selected_item = get_item_text(item_list[0])
				$Sprite3D.texture = item_images.get_building_sprite(currently_selected_item)
				$Sprite3D.show()
		
func _input(event):
	if currently_selected_item:
	
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
				# Place Building
				print("PLACING: ", currently_selected_item)
				var building_scene = item_scenes.get_building_scene(currently_selected_item)
				print("BUILDING SCENE: ", building_scene)
				var building = building_scene.instantiate()
				building.initialize(camera.current_global_mouse_position, "player", currently_selected_item)
				add_child(building)
				deselect_all()
				$Sprite3D.hide()
				currently_selected_item = null
				
		if event is InputEventMouseMotion:
			$Sprite3D.position = camera.current_global_mouse_position
			$Sprite3D.position.y += 1
			print("Sprite position, ", $Sprite3D.position)
			pass

func _process(delta):
	pass
