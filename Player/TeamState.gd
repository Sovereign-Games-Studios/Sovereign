class_name TeamState
extends Node3D

var team_name
var expedition_state
var hostile_teams
var gold
var available_items
var available_enchants
var team_npcs
var objectives
var is_palace_alive
var is_fow_explored
var team_buildings
var relaxation_buildings: Array
var list_of_bts = {}
var consider_list = {}
var combat_reward_flags = []
var exploration_reward_flags = []
# NPC Object:Observed Location
var observed_enemies: Dictionary = {}
signal items_added
# Called when the node enters the scene tree for the first time.
func _ready():
	self.available_items = {}
	self.available_enchants = []
	self.team_npcs = []
	self.team_buildings = []
	self.relaxation_buildings = []
	self.objectives = []
	self.is_palace_alive = true
	self.list_of_bts = self.expedition_state.game_state.list_of_bts 
	self.consider_list = self.expedition_state.game_state.consider_list 
	self.combat_reward_flags = []
	self.exploration_reward_flags = []
	self.gold = 2000
	var user_interface = load("res://UserInterface/UserInterface.tscn")
	if team_name == "player":
		var palace_ui = user_interface.instantiate()
		add_child(palace_ui)
		var palace_scene = load("res://Buildings/building_node.tscn")
		var palace = palace_scene.instantiate()
		palace.initialize(Vector3(6, 20, 37), "Palace", "player")
		add_child(palace)
		var gold_counter = get_node("../PassiveIncome")
		gold_counter.wait_time = 5
		gold_counter.timeout.connect(_gold_on_timer_timeout)
	pass # Replace with function body.

func _add_items(building, items):
	self.available_items[building] = items
	self.items_added.emit()
	
func initialize(team_name: String, expedition_state: ExpeditionState , hostile_teams):
	self.team_name = team_name
	self.expedition_state = expedition_state
	self.hostile_teams = hostile_teams
	
func _gold_on_timer_timeout():
	self.gold += 100
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.is_fow_explored = self.expedition_state.is_fow_explored
	pass
