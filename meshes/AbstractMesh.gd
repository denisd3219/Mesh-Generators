extends ArrayMesh

export (Material) var material : Material = null setget set_material
func set_material(val):
	material = val
	if get_surface_count() > 0:
		var id = get_surface_count() - 1
		surface_set_material(id, val)

func _init():
	call_deferred("regenereate_surface")
	
func regenereate_surface():
	clear_surfaces()
	add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, generate_mesh_arrays())
	set_material(material)
	emit_changed()

func generate_mesh_arrays():
	pass
	
func join_quad(idx1, idx2, idx3, idx4):
	var res = PoolIntArray()
	res.append(idx1)
	res.append(idx2)
	res.append(idx3)
	res.append(idx3)
	res.append(idx4)
	res.append(idx1)
	return res
