extends ItemList

var building_name
var camera
var building
var gold_costs
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("../../../Camera3D")
	for item in range(self.item_count):
		var item_name = self.get_item_text(item)
		var stats = Statistics.getStats(building_name)
	pass # Replace with function body.

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var item_list = get_selected_items()
			if(item_list.size() > 0):
				building_name = get_item_text(item_list[0])
				building = Building_Library.get_building(building_name)
				$Sprite3D.texture = building[2]
				$Sprite3D.show()
		
func _input(event):
	if building:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
				# Place Building
				print("PLACING: ", building_name)
				var building_scene = building[1].instantiate()
				building.initialize(camera.current_global_mouse_position, "player", building_name)
				add_child(building)
				deselect_all()
				$Sprite3D.hide()
				building = null
				building_name = null
				
		if event is InputEventMouseMotion:
			$Sprite3D.position = camera.current_global_mouse_position
			$Sprite3D.position.y += 1
			print("Sprite position, ", $Sprite3D.position)
			pass

func _process(delta):

		
	pass
