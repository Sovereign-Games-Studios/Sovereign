extends Building


# Called when the node enters the scene tree for the first time.
func _ready():
	building_type = "Palace"
	team = "player"
	level = 1
	self.add_to_group("Player Entities")
	stats = Statistics.getStats(building_type)
	max_health = 10 + stats["Stamina"]
	current_health = 10 + stats["Stamina"]
	# array of existing npcs tied to this building, the length of which is compared against maximum to determine if more can be recruited/spawned
	npcs = {"Peasant": [], "Guard": [], "Tax Collector": []}
	maximum_npcs = {"Peasant": 4, "Guard": 2, "Tax Collector": 2}
	# array of npcs currently occupying this building
	current_occupants = []
	var NpcScenes = preload("res://NpcScripts/NpcScenes.gd").new()
	print(NpcScenes.get_npc_scene("Guard"))
	$Timer.wait_time = 5
	$Timer.timeout.connect(_recruit_on_timer_timeout.bind(NpcScenes))
	# Must check to see if these are on the map before construction is allowed
	# This is for checks and tells us to look for a palace level 1 on the map. unused currently
	prerequisites = [{"Palace": 1}]
	# only relevant to pc buildings
	upgrades = {"Level 2": 5000, "Level 3": 7500}
	pass # Replace with function body.

func initialize():
	building_type = "Palace"
	team = "player"
	level = 1
	self.add_to_group("Player Entities")
	stats = Statistics.getStats(building_type)
	max_health = 10 + stats["Stamina"]
	current_health = 10 + stats["Stamina"]
	# array of existing npcs tied to this building, the length of which is compared against maximum to determine if more can be recruited/spawned
	npcs = {"Peasant": [], "Guard": [], "Tax Collector": []}
	maximum_npcs = {"Guard": 2}
	# array of npcs currently occupying this building
	current_occupants = []
	$Timer.wait_time = 1
	$Timer.timeout.connect(_recruit_on_timer_timeout.bind())
	# Must check to see if these are on the map before construction is allowed
	# This is for checks and tells us to look for a palace level 1 on the map. unused currently
	prerequisites = [{"Palace": 1}]
	# only relevant to pc buildings
	upgrades = {"Level 2": 5000, "Level 3": 7500}
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
