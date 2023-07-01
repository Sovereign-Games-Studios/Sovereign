extends GridMap

var noise := FastNoiseLite.new()

var height = 10



# Called when the node enters the scene tree for the first time.
func _ready():
	# noise.seed = 3.1415

	for x in range(-100,100):
		for z in range(-100,100):
			# creates randomness in [-height/2-1,height/2]
			var y = noise.get_noise_2d(x, z) * height
			if y < -height/2 + 2:
				set_cell_item(Vector3i(x,y,z),0)
				
			elif y > -height/2 + 2 and y < height/2 - 2:
				set_cell_item(Vector3i(x,y,z),1)
			else:
				set_cell_item(Vector3i(x,y,z),2)
				
	
	var grid = get_used_cells()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# var me = get_used_cells()
	pass
