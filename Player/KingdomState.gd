extends Node

var available_items
var available_enchants
var heroes
var objectives
var is_palace_alive
var size
var gold
var test
var palace_ui

# Called when the node enters the scene tree for the first time.
func _ready():
	available_items = []
	available_enchants = []
	heroes = []
	objectives = []
	is_palace_alive = true
	var fog = get_node("Fog")
	gold = 2000
	fog.startFog()
	var user_interface = load("res://UserInterface/UserInterface.tscn")
	palace_ui = user_interface.instantiate()
	add_child(palace_ui)
	var palace_scene = load("res://Buildings/building_node.tscn")
	var palace = palace_scene.instantiate()
	palace.initialize(Vector3(6, 0, 37), "Palace", "player")
	add_child(palace)
	var gold_counter = get_node("PassiveIncome")
	gold_counter.wait_time = 5
	gold_counter.timeout.connect(_gold_on_timer_timeout)
	pass # Replace with function body.

func _gold_on_timer_timeout():
	print("adding_gold")
	gold += 100
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
