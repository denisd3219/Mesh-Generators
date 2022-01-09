tool
extends "res://meshes/AbstractMesh.gd"
class_name ConeMesh

export (float) var height : float = 10.0 setget set_height
func set_height(val):
	if val <= 0: val = 1
	height = val
	regenereate_surface()

export (float) var radius : float = 5.0 setget set_radius
func set_radius(val):
	if val <= 0: val = 1
	radius = val
	regenereate_surface()

export (int) var segments : int = 5 setget set_segments
func set_segments(val):
	if val < 3: val = 3
	segments = val
	regenereate_surface()

func generate_mesh_arrays():
	var verts = PoolVector3Array()
	var uvs = PoolVector2Array()
	var normals = PoolVector3Array()

	var base_vert = Vector3(0, 0, 0)
	verts.append(base_vert)
	normals.append(Vector3.DOWN)
	uvs.append(Vector2(1, 0))

	var apex_vert = Vector3(0, height, 0)
	verts.append(apex_vert)
	normals.append(apex_vert.normalized())
	uvs.append(Vector2(0, 1))

	for i in range(segments):
		var u = float(i) / segments
		var x = sin(u * PI * 2.0)
		var z = cos(u * PI * 2.0)

		var vert = Vector3(x * radius, 0, z * radius)
		verts.append(vert)
		normals.append(vert.normalized())
		uvs.append(Vector2(u, 1))

	var indices = PoolIntArray()
	for i in range(segments):
		indices.append_array(join_quad(
			(i + 1) % segments + 2,
			0,
			i + 2,
			1
		))


	var mesh_arrays = []
	mesh_arrays.resize(Mesh.ARRAY_MAX)
	mesh_arrays[Mesh.ARRAY_VERTEX] = verts
	mesh_arrays[Mesh.ARRAY_TEX_UV] = uvs
	mesh_arrays[Mesh.ARRAY_NORMAL] = normals
	mesh_arrays[Mesh.ARRAY_INDEX] = indices
	return mesh_arrays

