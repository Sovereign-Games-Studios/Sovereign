class_name Building_Library


static func get_building(building_name):
	var stats = Statistics.getStats(building_name)
	building_name = building_name.replace(" ", "_")
	building_name = building_name.to_lower()
	var scene = load("res://Buildings/BuildingScenes/"+building_name+".tscn")
	var image = load("res://Resources/Buildings/Images/"+building_name+".png")
	print(scene)
	
	return [stats, scene, image]
