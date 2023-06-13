extends Building


# Called when the node enters the scene tree for the first time.
func _ready():
	building_type = "building"
	team = "player"
	level = 1

	stats = Statistics.getStats(building_type)
	max_health = 10 + stats["Stamina"]
	current_health = 10 + stats["Stamina"]
	recruitable_npc_type = Barbarian
	# array of existing npcs tied to this building, the length of which is compared against maximum to determine if more can be recruited/spawned
	npcs = []
	maximum_npcs = []
	# array of npcs currently occupying this building
	current_occupants = []
	
	# Must check to see if these are on the map before construction is allowed
	# This is for checks and tells us to look for a palace level 1 on the map. unused currently
	prerequisites = [{"Palace": 1}]
	# only relevant to pc buildings
	cost = 2400
	var itemService = ItemServices.new()
	var weapon = SwordOfBashing.new()
	weapon.initialize()
	itemService.instantiate([weapon])
	services = [itemService]
	upgrades = []
	pass # Replace with function body.

func initialize(start_position, team, building_type):
	set_global_position(start_position)
	building_type = "building"
	team = "player"
	level = 1

	stats = Statistics.getStats(building_type)
	max_health = 10 + stats["Stamina"]
	current_health = 10 + stats["Stamina"]
	recruitable_npc_type = Barbarian
	# array of existing npcs tied to this building, the length of which is compared against maximum to determine if more can be recruited/spawned
	npcs = []
	maximum_npcs = []
	# array of npcs currently occupying this building
	current_occupants = []
	
	# Must check to see if these are on the map before construction is allowed
	# This is for checks and tells us to look for a palace level 1 on the map. unused currently
	prerequisites = [{"Palace": 1}]
	# only relevant to pc buildings
	cost = 2400
	services = [ItemServices.new().instantiate(SwordOfBashing.new().initialize())]
	upgrades = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
