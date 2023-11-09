extends MeshInstance3D


func _ready():
	set_mesh_texture()

func set_mesh_texture():
	var material :StandardMaterial3D= get_active_material(0)
	material.albedo_texture = get_tree().get_first_node_in_group("package_texture").get_package_texture()
