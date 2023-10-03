extends Control

var camera
var selected_ui = null
var building_ui_node = preload("res://UserInterface/selected_building_ui.tscn")
var npc_ui_node = preload("res://UserInterface/selected_unit_ui.tscn")
var reward_flag_creation_node = preload("res://UserInterface/reward_flag_creation_ui.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("../../../Camera3D")
	$BuildList.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		# Ignore events happening on ui, find a better way to determine this. 
		if event.position.x <= 300:
			return
		elif event.double_click:
			if camera.colliding_entity is Node3D:
				if camera.colliding_entity is NPC or camera.colliding_entity is Building: 
					if(selected_ui):
						selected_ui.queue_free()
						selected_ui = null
					selected_ui = reward_flag_creation_node.instantiate()
					selected_ui.initialize(camera.colliding_entity)
					add_sibling(selected_ui)
		elif event.pressed:
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
	elif event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			if(selected_ui):
				selected_ui.queue_free()
				selected_ui = null
			$BuildList.hide()
