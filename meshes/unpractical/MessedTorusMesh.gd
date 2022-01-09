tool
extends ArrayMesh
#class_name MessedTorusMesh

export (float) var base_radius : float = 20.0 setget set_base_radius
func set_base_radius(val):
	base_radius = val
	regen_mesh()

export (int) var base_segments : int = 20 setget set_base_segments
func set_base_segments(val):
	base_segments = val
	regen_mesh()

export (float) var tube_radius : float = 5.0 setget set_tube_radius
func set_tube_radius(val):
	tube_radius = val
	regen_mesh()

export (int) var tube_segments : int = 20 setget set_tube_segments
func set_tube_segments(val):
	tube_segments = val
	regen_mesh()

export (Material) var material : Material = null setget set_material
func set_material(val):
	material = val
	var id = get_surface_count() - 1
	surface_set_material(id, val)

func _init():
	regen_mesh()

func regen_mesh():
	var verts = PoolVector3Array()
	var uvs = PoolVector2Array()
	var normals = PoolVector3Array()
	var indices = PoolIntArray()
	
	for i in range(base_segments + 1):
		var u = float(i) / base_segments
		for j in range(tube_segments + 1):
			var v = float(j) / tube_segments
			
			#trig stolen from https://lindenreidblog.com/2017/11/06/procedural-torus-tutorial/
			var x = cos(u * PI * 2.0) * (base_radius + cos(v * PI * 2.0) * tube_radius)
			var y = sin(v * PI * 2.0) * tube_radius
			var z = sin(u * PI * 2.0) * (base_radius + cos(v * PI * 2.0) * tube_radius)
			
			var vert = Vector3(x, y, z)
			verts.append(vert)
			normals.append(vert.normalized())
			uvs.append(Vector2(u, v))		
			var rings = (tube_segments+1)*j		
			var vertices = rings + i
			
			if i > 0 and j > 0:
				indices.append(vertices - 1)
				indices.append(vertices)
				indices.append(vertices - rings + 1)
				
				indices.append(vertices - rings + 1)
				indices.append(vertices - rings)
				indices.append(vertices - 1)
	
	var mesh_arrays = []
	mesh_arrays.resize(Mesh.ARRAY_MAX)
	mesh_arrays[Mesh.ARRAY_VERTEX] = verts
	mesh_arrays[Mesh.ARRAY_TEX_UV] = uvs
	mesh_arrays[Mesh.ARRAY_NORMAL] = normals
	mesh_arrays[Mesh.ARRAY_INDEX] = indices
	
	clear_surfaces()
	add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_arrays)
	set_material(material)
	emit_changed()
