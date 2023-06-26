extends Building


# Called when the node enters the scene tree for the first time.
func _ready():
	var building_type = "Palace"
	var team = "player"
	var name = "Palace"
	var level = 1
	self.add_to_group("Player Entities")
	var stats = Statistics.getStats(building_type)
	var max_health = 10 + stats["Stamina"]
	var current_health = 10 + stats["Stamina"]
	# array of existing npcs tied to this building, the length of which is compared against maximum to determine if more can be recruited/spawned
	var npcs = {"Peasant": [], "Guard": [], "Tax Collector": []}
	var maximum_npcs = {"Peasant": 0, "Guard": 2, "Tax Collector": 0}
	# array of npcs currently occupying this building
	current_occupants = []

	# Must check to see if these are on the map before construction is allowed
	# This is for checks and tells us to look for a palace level 1 on the map. unused currently
	var prerequisites = [{"Palace": 1}]
	# only relevant to pc buildings
	var upgrades = {"Level 2": 5000, "Level 3": 7500}
	pass # Replace with function body.

func _process(delta):
	pass
