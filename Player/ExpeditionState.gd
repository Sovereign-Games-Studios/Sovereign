class_name ExpeditionState
extends Node3D

var size
var test
var is_fow_explored = false
var bitmap_node
var teams = {}
var objectives = []
var reward_flag_entities = []
var game_state: GameState

'''
Called during Expedition Instantiation.
'''
func initialize(game_state: GameState, teams = {"player": ["enemy"], "enemy": ["player"]}, objectives = []):
	self.objectives = objectives
	self.game_state = game_state
	# Teams are nodes that store all the faction relevant information which is usually a subset of the Expedition's status.
	for team in teams:
		var team_state = TeamState.new()
		team_state.initialize(team, self, teams[team])
		self.teams[team] = team_state
		add_child(team_state)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.initialize(GameStateInit)
	var fog = get_node("Terrain/Fog")
	bitmap_node = get_node("SubViewportContainer/SubViewport/Camera2D/Sprite2D")
	fog.startFog()
	var fow_timer = get_node("CheckFogOfWar")
	fow_timer.wait_time = 1
	fow_timer.timeout.connect(_refresh_fow_state)
	scatter_lairs(4)
	pass # Replace with function body.

func scatter_lairs(num: int):
	for loc in range(0, num):
		var randomx = randi_range(-50, 50)
		var randomz = randi_range(-50, 50)
		var lair_scene = load("res://Buildings/building_node.tscn")
		var lair = lair_scene.instantiate()
		lair.initialize(Vector3(randomx, 20, randomz), "greblin_den", "enemy")
		add_child(lair)
		
func _refresh_fow_state():
	var fog_bitmap = bitmap_node.fogMapImg
	if fog_bitmap:
		if not is_fow_explored:
			for pixelx in fog_bitmap.get_size().x:
				for pixely in fog_bitmap.get_size().y:
					var pixel_color = fog_bitmap.get_pixel(pixelx, pixely)
					if pixel_color == Color(0.0, 0.0, 0.0):
						is_fow_explored = false
						return
		is_fow_explored = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
