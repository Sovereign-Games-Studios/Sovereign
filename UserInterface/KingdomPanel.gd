extends Control

var camera
var selected_ui: SelectedBuildingUi = null
var ui_node = preload("res://UserInterface/selected_building_ui.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("../../Camera3D")
	$BuildList.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera.colliding_entity != null:
		if camera.colliding_entity.definition.name == "Palace":
			$BuildList.show()			
			#selected_ui = ui_node.instantiate()
			#selected_ui.initialize(camera.colliding_entity)
			#selected_ui.position = Vector2(0, 150)
			#add_sibling(selected_ui)
		elif camera.colliding_entity is Building and selected_ui == null:
			$BuildList.hide()		
			selected_ui = ui_node.instantiate()
			selected_ui.initialize(camera.colliding_entity)
			add_sibling(selected_ui)
		elif camera.colliding_entity is NPC:
			$BuildList.hide()
			print("You've selected a unit.")
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
