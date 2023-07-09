class_name GameState
extends Node

var BUILDING_DEF_DIR = "res://Resources/Buildings/BuildingDefinitions/"
var NPC_DEF_DIR = "res://Resources/Characters/CharacterDefinitions/"
var OP_DEF_DIR = "res://Resources/OptionDefinitions/"
var ACT_DEF_DIR = "res://Resources/ActionDefinitions/"
var CONSIDER_DEF_DIR = "res://Resources/ConsiderationDefinitions/"
var SERVICE_DEF_DIR
var ITEM_DEF_DIR

var lair_list = {}
var buildable_list = {}
var list_of_npcs = {}
var list_of_services = {}
var list_of_items = {}
var list_of_bts = {}
var consider_list = {}
var constructed_buildings = {"Palace": 1}

func _init():
	define_bts()
	define_consider()
	define_npcs()
	var directory = DirAccess.open(BUILDING_DEF_DIR)		
	var files = directory.get_files()
	for file in files:
		if file.ends_with(".tres"):
			var building_definition = load(BUILDING_DEF_DIR + file)
			building_definition.get_script()
			if(building_definition.constructable):
				buildable_list[file.get_slice(".", 0)] = building_definition
			else:
				lair_list[file.get_slice(".", 0)] = building_definition				
	pass
	
func define_npcs():
	var directory = DirAccess.open(NPC_DEF_DIR)		
	var files = directory.get_files()
	for file in files:
		if file.ends_with(".tres"):
			var npc_definition = load(NPC_DEF_DIR + file)
			npc_definition.get_script()
			list_of_npcs[file.get_slice(".", 0)] = npc_definition
			
func define_consider():
	var directory = DirAccess.open(CONSIDER_DEF_DIR)		
	var files = directory.get_files()
	for file in files:
		if file.ends_with(".tres"):
			var behaviour_definition = load(CONSIDER_DEF_DIR + file)
			behaviour_definition.get_script()
			consider_list[file.get_slice(".", 0)] = behaviour_definition
			print("Added: ", file.get_slice(".", 0), " resource ", behaviour_definition)			
	directory = DirAccess.open(ACT_DEF_DIR)		
	files = directory.get_files()
	
func define_bts():
	var directory = DirAccess.open(OP_DEF_DIR)		
	var files = directory.get_files()
	for file in files:
		if file.ends_with(".tres"):
			var behaviour_definition = load(OP_DEF_DIR + file)
			behaviour_definition.get_script()
			var behaviour
			behaviour = BehaviourNode.new()
			behaviour.initialize(behaviour_definition)
			list_of_bts[file.get_slice(".", 0)] = behaviour
			print("Added: ", file.get_slice(".", 0), " resource ", behaviour)			
	directory = DirAccess.open(ACT_DEF_DIR)		
	files = directory.get_files()
	for file in files:
		if file.ends_with(".tres"):
			var behaviour_definition = load(ACT_DEF_DIR + file)
			behaviour_definition.get_script()
			var behaviour
			behaviour = BehaviourNode.new()
			behaviour.initialize(behaviour_definition)
			list_of_bts[file.get_slice(".", 0)] = behaviour	
			print("Added: ", file.get_slice(".", 0), " resource: ", behaviour)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
