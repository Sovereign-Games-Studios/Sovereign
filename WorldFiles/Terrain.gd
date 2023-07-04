# We allow this to run from within the editor!
@tool
extends StaticBody3D
@export var generate: bool = false : set = generate_mesh
@export var size: int = 200
@export var subdivide: int = 199
@export var amplitude: int = 16
@export var noise: FastNoiseLite = FastNoiseLite.new()

var team = "map"

func generate_mesh(new_value: bool) -> void:
	print("Generating Terrain mesh...")
	var noise2 = noise.duplicate()
	
	if noise2.seed == 0:
		noise2.seed = randi()
	
	# create mesh
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(size,size)
	plane_mesh.subdivide_depth = subdivide
	plane_mesh.subdivide_width = subdivide
	
	# get individual points from the mesh via the Surface tool
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(plane_mesh,0)
	var data = surface_tool.commit_to_arrays()
	var vertices = data[ArrayMesh.ARRAY_VERTEX]
	
	# set the height of the points randomly
	for i in vertices.size():
		var vertex = vertices[i]
		vertices[i].y = noise2.get_noise_2d(vertex.x,vertex.z) * amplitude
	data[ArrayMesh.ARRAY_VERTEX] = vertices
	
	# construct back the mesh
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,data)
	
	# generate normals for getting good lighting
	surface_tool.create_from(array_mesh,0)
	surface_tool.generate_normals()

	# set the mesh
	$MeshInstance3D.mesh = surface_tool.commit()
	$Fog.mesh = surface_tool.commit()	
	
	# set the collision
	$CollisionShape3D.shape = array_mesh.create_trimesh_shape()

# Generate dynamically in game
func _ready():
	generate_mesh(true)
