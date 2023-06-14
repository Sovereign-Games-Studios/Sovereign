extends MeshInstance3D


var max_depth = 40.0 # this in combination with black rect overdraw alpha value on fogMap determines how fast fog rises back up

var fog_map_size = Vector2(200, 200) # resolution of the fogMap image
var fog_mesh_width = 0
var fog_reveal_distance = 5

func startFog():
	var MAIN = get_node("../World")
	self.fog_mesh_width = self.size.x * 1
	# set shader params
	self.mesh.material.set_shader_parameter("fogMaxDepth", self.max_depth)
	self.mesh.material.set_shader_parameter("maxRange", self.fog_reveal_distance)
	self.mesh.material.set_shader_parameter("mapWidth", self.fog_mesh_width)
	self.show()
	
func getFogMapPixelForUnit(unit):
	if unit == null:
		return Vector2(0,0)
	var x = (unit.x + (self.fogMeshWidth / 2)) / self.fogMeshWidth * self.fogMapSize.x
	var z = (unit.z + (self.fogMeshWidth / 2)) / self.fogMeshWidth * self.fogMapSize.y
	return Vector2(x, z)
