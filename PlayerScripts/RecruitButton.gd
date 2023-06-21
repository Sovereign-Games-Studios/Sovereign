extends Button

@export var npc_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	var enemy = npc_scene.instantiate()
	var enemy_spawn_location = get_node("../../SpawnPath/SpawnLocation").position
	enemy.initialize(enemy_spawn_location)
	add_child(enemy)
