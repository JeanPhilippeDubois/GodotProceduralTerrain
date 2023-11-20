@tool
extends StaticBody3D

@export var size: int = 64
@export var subdivide: int = 63
@export var amplitude: int = 16
@export var noise: FastNoiseLite = FastNoiseLite.new()
func _ready():
	generate_the_mesh()
	

func generate_the_mesh():
	print("Generating Mesh...")
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(size,size)
	plane_mesh.subdivide_depth = subdivide
	plane_mesh.subdivide_width = subdivide
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(plane_mesh,0)
	var data = surface_tool.commit_to_arrays()
	var vertices = data[ArrayMesh.ARRAY_VERTEX]
	
	
	
	for i in vertices.size():
		var vertex = vertices[i]
		vertices[i].y = noise.get_noise_2d(vertex.x,vertex.z) * amplitude
	data[ArrayMesh.ARRAY_VERTEX] = vertices
		
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,data)
	
	surface_tool.create_from(array_mesh,0)
	surface_tool.generate_normals()

	$MeshInstance.mesh = surface_tool.commit()
	$CollisionShape.shape = array_mesh.create_trimesh_shape()
