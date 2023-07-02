extends ItemList

var selected_building = null
var camera
var building_node = preload("res://Buildings/building_node.tscn")
var npc_node = preload("res://Npcs/npc_node.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("../../../Camera3D")
	for building in GameStateInit.buildable_list.values():
		var building_sprite
		if(building.sprite_override):
			print("res://Resources/Buildings/Images/"+building.sprite_override+".png")
			building_sprite = load("res://Resources/Buildings/Images/"+building.sprite_override+".png")
		else:
			var filename = get_filename(building.name)
			building_sprite = load("res://Resources/Buildings/Images/"+filename+".png")		
		print("Added item to list: ", building.name)
		add_item(building.name, building_sprite, false)
	pass # Replace with function body.

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var item_list = get_selected_items()
			if(item_list.size() > 0):
				selected_building = GameStateInit.buildable_list[get_filename(get_item_text(item_list[0]))]
				print("Selected Building: ", selected_building)
				$Sprite3D.texture = get_item_icon(item_list[0])
				$Sprite3D.show()
		
func _input(event):
	if selected_building != null:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			var new_building = building_node.instantiate()
			# if player builds it, its on their team. 
			new_building.initialize(camera.get_ray_intersect(event.position), get_filename(selected_building.name), "player")
			add_child(new_building)
			# Place Building
			deselect_all()
			$Sprite3D.hide()
			selected_building = null
				
		if event is InputEventMouseMotion:
			$Sprite3D.position = camera.get_ray_intersect(event.position)
			$Sprite3D.position.y += 1
			pass
			
func get_filename(building_name):
	building_name = building_name.replace(" ", "_")
	building_name = building_name.to_lower()
	return building_name

func _process(delta):
	for index in range(item_count):
		if is_item_selectable(index):
			continue
		var item = get_item_text(index)
		var filename = get_filename(item)
		var building = GameStateInit.buildable_list[filename]
		var is_buildable = false
		for prereq in building.prerequisites.keys():
			var required_level = building.prerequisites[prereq]
			if prereq in GameStateInit.constructed_buildings:
				var existing_level = GameStateInit.constructed_buildings[prereq]
				if required_level <= existing_level:
					is_buildable = true
		if is_buildable:
			set_item_selectable(index, true)
			print(building.name, " now buildable")
	pass
