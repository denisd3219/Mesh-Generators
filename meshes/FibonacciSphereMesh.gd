tool
extends "res://meshes/AbstractMesh.gd"
class_name FibonacciSphereMesh

export (int) var points : int = 7 setget set_points
func set_points(val):
	if val < 7: val = 7
	points = val
	regenereate_surface()

func generate_mesh_arrays():
	var verts = PoolVector3Array()
	var uvs = PoolVector2Array()
	var normals = PoolVector3Array()

	var projected_verts = PoolVector2Array()
	var golden_ratio = PI * (3.0 - sqrt(5.0))
	for i in range(1, points):
		var y = 1 - (i / float(points - 1)) * 2
		var u = i / float(points)
		var sphere_dist = sqrt(1 - y * y)
		var theta = golden_ratio * i
		var x = cos(theta) * sphere_dist
		var z = sin(theta) * sphere_dist
		var vert = Vector3(x, y, z)
		verts.append(vert)
		normals.append(vert.normalized())
		uvs.append(Vector2(u, y))
		var proj = Vector2(x/(1-y), z/(1-y))
		projected_verts.append(proj)

	var indices = Geometry.triangulate_delaunay_2d(projected_verts)
	
	verts.append(Vector3.UP)
	normals.append(Vector3.UP)
	uvs.append(Vector2(0, 0))
	var north_idx = verts.size() - 1
	for i in range(0, 5):
		var next_i = (i+2) % 5
		indices.append(north_idx)
		indices.append(next_i)
		indices.append(i)
	
	var mesh_arrays = []
	mesh_arrays.resize(Mesh.ARRAY_MAX)
	mesh_arrays[Mesh.ARRAY_VERTEX] = verts
	mesh_arrays[Mesh.ARRAY_TEX_UV] = uvs
	mesh_arrays[Mesh.ARRAY_NORMAL] = normals
	mesh_arrays[Mesh.ARRAY_INDEX] = indices
	return mesh_arrays
