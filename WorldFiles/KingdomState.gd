extends Node

var available_items
var available_enchants
var heroes
var objectives
var is_palace_alive
var size

# Called when the node enters the scene tree for the first time.
func _ready():
	available_items = []
	available_enchants = []
	heroes = []
	objectives = []
	is_palace_alive = true
	var fog = get_node("Fog")
	fog.startFog()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
