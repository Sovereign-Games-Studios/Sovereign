extends Button

@export var enemy_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	
	var enemy = enemy_scene.instantiate()
	var player_position = get_node("../../Barbarian").global_position
	print(player_position)
	var enemy_spawn_location = get_node("../../SpawnLocation")
	print(enemy_spawn_location)	
	enemy.initialize(enemy_spawn_location.position, player_position)
	add_child(enemy)
