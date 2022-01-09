tool
extends "res://meshes/AbstractMesh.gd"
class_name TorusMesh

export (float) var major_radius : float = 20.0 setget set_major_radius
func set_major_radius(val):
	if val <= 0: val = 1
	major_radius = val
	regenereate_surface()

export (int) var major_segments : int = 10 setget set_major_segments
func set_major_segments(val):
	if val < 3: val = 3
	major_segments = val
	regenereate_surface()

export (float) var minor_radius : float = 5.0 setget set_minor_radius
func set_minor_radius(val):
	if val <= 0: val = 1
	minor_radius = val
	regenereate_surface()

export (int) var minor_segments : int = 10 setget set_minor_segments
func set_minor_segments(val):
	if val < 3: val = 3
	minor_segments = val
	regenereate_surface()

func generate_mesh_arrays():
	var verts = PoolVector3Array()
	var uvs = PoolVector2Array()
	var normals = PoolVector3Array()
	for i in range(major_segments):
		var u = float(i) / float(major_segments)
		for j in range(minor_segments):
			var v = float(j) / float(minor_segments)
			
			#trig stolen from https://lindenreidblog.com/2017/11/06/procedural-torus-tutorial/
			var x = cos(u * PI * 2.0) * (major_radius + cos(v * PI * 2.0) * minor_radius)
			var y = sin(v * PI * 2.0) * minor_radius
			var z = sin(u * PI * 2.0) * (major_radius + cos(v * PI * 2.0) * minor_radius)
			
			var vert = Vector3(x, y, z)
			verts.append(vert)
			normals.append(vert.normalized())
			uvs.append(Vector2(u, v))
	
	var indices = PoolIntArray()
	for ring in range(major_segments):
		var next_ring = (ring + 1) % major_segments
		for vert in range(minor_segments):
			var mod_vert = (vert + 1) % minor_segments
			indices.append_array(join_quad(
				ring * minor_segments + vert,
				next_ring * minor_segments + vert,
				next_ring * minor_segments + mod_vert,
				ring * minor_segments + mod_vert 
			))
	
	var mesh_arrays = []
	mesh_arrays.resize(Mesh.ARRAY_MAX)
	mesh_arrays[Mesh.ARRAY_VERTEX] = verts
	mesh_arrays[Mesh.ARRAY_TEX_UV] = uvs
	mesh_arrays[Mesh.ARRAY_NORMAL] = normals
	mesh_arrays[Mesh.ARRAY_INDEX] = indices
	
	return mesh_arrays
