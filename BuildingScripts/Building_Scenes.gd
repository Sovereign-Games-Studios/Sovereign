class_name Building_Scenes

func get_building_scene(building_name):
	match building_name:
		"Barbarian Encampment":
			print("Loading Barbarian Encampment")
			return preload("res://BuildingScripts/barbarian_encampment3d.tscn")
		
