extends Node

var BUILDING_DEF_DIR = "res://Resources/Buildings/BuildingDefinitions/"
var NPC_DEF_DIR
var SERVICE_DEF_DIR
var ITEM_DEF_DIR

var list_of_buildings = {}
var list_of_npcs = []
var list_of_services = []
var list_of_items = []
var constructed_buildings = {"Palace": 1}

func _init():
	var directory = DirAccess.open(BUILDING_DEF_DIR)		
	var files = directory.get_files()
	for file in files:
		if file.ends_with(".tres"):
			print("File: ", file)
			var building_definition = load(BUILDING_DEF_DIR + file)
			building_definition.get_script()
			if(building_definition.constructable):
				list_of_buildings[file.get_slice(".", 0)] = building_definition
				print("Added ", file.get_slice(".", 0))
	print(list_of_buildings)
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
