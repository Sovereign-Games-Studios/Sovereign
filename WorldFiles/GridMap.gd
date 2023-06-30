extends GridMap

var noise := FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(-100,100):
		for y in range(-10, 30):
			for z in range(-100,100):
				if y < noise.get_noise_2d(x, z) * 20 + 10:
					set_cell_item(Vector3i(x,y-20,z),0)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
