extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var building_type = "building"
	var team = "player"
	var level = 1
	self.add_to_group("Player Entities")
	var stats = Statistics.getStats(building_type)
	var max_health = 10 + stats["Stamina"]
	var current_health = 10 + stats["Stamina"]
	var recruitable_npc_type = "Barbarian"
	# array of existing npcs tied to this building, the length of which is compared against maximum to determine if more can be recruited/spawned
	var npcs = []
	var maximum_npcs = []
	# array of npcs currently occupying this building
	var current_occupants = []
	
	# Must check to see if these are on the map before construction is allowed
	# This is for checks and tells us to look for a palace level 1 on the map. unused currently
	var prerequisites = [{"Palace": 1}]
	# only relevant to pc buildings
	var cost = 2400
	var itemService = ItemServices.new()
	var weapon = SwordOfBashing.new()
	weapon.initialize()
	itemService.instantiate([weapon])
	var services = [itemService]
	var upgrades = []
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
