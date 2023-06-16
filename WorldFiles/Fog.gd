extends MeshInstance3D



var fog_map_size = Vector2(200, 200) # resolution of the fogMap image
var fog_mesh_width = 145
var fog_reveal_distance = 5
var fog_max_depth = 5

func startFog():
	print("Fog Initializing")
	var MAIN = get_node("../World")
	# set shader params
	self.material_override.set_shader_parameter("maxRange", self.fog_reveal_distance)
	self.material_override.set_shader_parameter("mapWidth", self.fog_mesh_width)
	self.material_override.set_shader_parameter("fogMaxDepth", self.fog_max_depth)
	self.show()
	
func getFogMapPixelForUnit(unit):
	if unit == null:
		print("Null Unit")
		return Vector2(0,0)
	var x = (unit.global_position.x / self.fog_mesh_width * self.fog_map_size.x)
	var z = (unit.global_position.z  / self.fog_mesh_width * self.fog_map_size.y)
	return Vector2(x, z)
