extends Building


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(start_position, team, building_type):
	set_global_position(start_position)
	building_type = "building"
	team = team
	level = 1

	stats = Statistics.getStats(building_type)
	max_health = 10 + stats["Stamina"]
	current_health = 10 + stats["Stamina"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
