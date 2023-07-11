extends Control

var camera
var selected_ui = null
var building_ui_node = preload("res://UserInterface/selected_building_ui.tscn")
var npc_ui_node = preload("res://UserInterface/selected_unit_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("../../../Camera3D")
	$BuildList.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera.colliding_entity is Node3D:
		if camera.colliding_entity is NPC or camera.colliding_entity is Building: 
			if camera.colliding_entity.definition.name == "Palace":
				if(selected_ui):
					selected_ui.queue_free()
					selected_ui = null
				$BuildList.show()			
				selected_ui = building_ui_node.instantiate()
				selected_ui.initialize(camera.colliding_entity)
				selected_ui.position = Vector2(0, 150)
				add_sibling(selected_ui)
			elif camera.colliding_entity is Building:
				if(selected_ui):
					selected_ui.queue_free()
					selected_ui = null
				$BuildList.hide()		
				selected_ui = building_ui_node.instantiate()
				selected_ui.initialize(camera.colliding_entity)
				add_sibling(selected_ui)
			elif camera.colliding_entity is NPC:
				if(selected_ui):
					selected_ui.queue_free()
					selected_ui = null
				$BuildList.hide()		
				selected_ui = npc_ui_node.instantiate()
				selected_ui.initialize(camera.colliding_entity)
				add_sibling(selected_ui)
	else:
		if(selected_ui):
			selected_ui.queue_free()
			selected_ui = null
		$BuildList.hide()

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			if(selected_ui):
				selected_ui.queue_free()
				selected_ui = null
			$BuildList.hide()
