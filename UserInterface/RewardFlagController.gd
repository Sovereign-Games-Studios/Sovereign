extends Control

var camera
var selected_ui = null
var reward_flag_creation_node = preload("res://UserInterface/reward_flag_creation_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("../../../Camera3D")


func _input(event):
	if event.type==InputEventMouseButton:
		if event.double_click:
			if camera.colliding_entity is Node3D:
				if camera.colliding_entity is NPC or camera.colliding_entity is Building: 
					if(selected_ui):
						selected_ui.queue_free()
						selected_ui = null
					selected_ui = reward_flag_creation_node.instantiate()
					selected_ui.initialize(camera.colliding_entity)
					add_sibling(selected_ui)
			else:
				if(selected_ui):
					selected_ui.queue_free()
					selected_ui = null
