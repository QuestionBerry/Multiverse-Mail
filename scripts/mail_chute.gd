extends StaticBody3D

@export var letter_group_node : Node3D

@onready var letter = load("res://scenes/letter.tscn")


func create_letter():
	var new_letter : RigidBody3D = letter.instantiate()
	new_letter.origin_universe = NameList.universe.CYBER
	new_letter.destination_universe = NameList.universe.EARTH
	new_letter.has_stamp = false
	
	for child in new_letter.get_children():
		if child is MeshInstance3D:
			#Duplicate material so all instances will be unique
			var new_material :StandardMaterial3D = child.get_active_material(0).duplicate()
			var letter_texture = await get_tree().get_first_node_in_group("letter_texture").create_letter_texture(
				new_letter.origin_universe,
				new_letter.destination_universe,
				new_letter.has_stamp,
				new_letter.has_seal
			)
			new_material.albedo_texture = letter_texture
			child.set_surface_override_material(0, new_material)
	
	letter_group_node.add_child(new_letter)
	new_letter.global_position = get_tree().get_first_node_in_group("letter_spawn").global_position
