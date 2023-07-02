class_name KingdomState
extends GameState

var available_items
var available_enchants
var heroes
var objectives
var is_palace_alive
var size
var gold
var test
var palace_ui
var is_fow_explored = false
var fog_bitmap
# Called when the node enters the scene tree for the first time.
func _ready():
	available_items = []
	available_enchants = []
	heroes = []
	objectives = []
	is_palace_alive = true
	var fog = get_node("Fog")
	var bitmap_node = get_node("SubViewportContainer/SubViewport/Camera2D/Sprite2D")
	fog_bitmap = bitmap_node.fogMapImg
	gold = 2000
	fog.startFog()
	var user_interface = load("res://UserInterface/UserInterface.tscn")
	palace_ui = user_interface.instantiate()
	add_child(palace_ui)
	var palace_scene = load("res://Buildings/building_node.tscn")
	var palace = palace_scene.instantiate()
	palace.initialize(Vector3(6, 20, 37), "Palace", "player")
	add_child(palace)
	var gold_counter = get_node("PassiveIncome")
	gold_counter.wait_time = 5
	gold_counter.timeout.connect(_gold_on_timer_timeout)
	var fow_timer = get_node("CheckFogOfWar")
	fow_timer.wait_time = 30
	fow_timer.timeout.connect(_refresh_fow_state)
	pass # Replace with function body.

func _refresh_fow_state():
	if fog_bitmap:
		if not is_fow_explored:
			for pixelx in fog_bitmap.size().x:
				for pixely in fog_bitmap.size().y:
					var pixel_color = fog_bitmap.color(pixelx, pixely)
					if pixel_color == Color(0.0, 0.0, 0.0):
						is_fow_explored = false
						return
		is_fow_explored = true
	
func _gold_on_timer_timeout():
	print("adding_gold")
	gold += 100
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
