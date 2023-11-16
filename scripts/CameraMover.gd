extends Control

@onready var camera = get_tree().get_first_node_in_group("camera")
@onready var letter = load("res://scenes/letter.tscn")
@onready var package = load("res://scenes/package.tscn")

@export var counter_marker : Marker3D
@export var desk_marker  : Marker3D
@export var move_time : float = 2.0

@export var letter_group_node : Node3D
@export var package_group_node : Node3D

func _on_to_desk_pressed():
	move_camera(desk_marker)

func _on_to_counter_pressed():
	move_camera(counter_marker)

func move_camera(destination : Marker3D):
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(camera, "position", destination.position, move_time)
	tween.tween_property(camera, "rotation", destination.rotation, move_time)


#Move this test elsewhere later
func _on_create_letter_pressed():
	var new_letter : RigidBody3D = letter.instantiate()
	new_letter.origin_universe = NameList.universe.CYBER
	new_letter.destination_universe = NameList.universe.EARTH
	new_letter.has_stamp = true
	
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


func _on_package_button_pressed():
	var new_package : RigidBody3D = package.instantiate()
	new_package.origin_universe = NameList.universe.MAGIC
	new_package.destination_universe = NameList.universe.EARTH

	for child in new_package.get_children():
		if child is MeshInstance3D:
		#Duplicate material so all instances will be unique
			var material :StandardMaterial3D = child.get_active_material(0).duplicate()
			var package_texture = await get_tree().get_first_node_in_group("package_texture").create_package_texture(
				new_package.origin_universe,
				new_package.destination_universe
			)
			material.albedo_texture = package_texture
			child.set_surface_override_material(0, material)
	print("NewPackage made")
	package_group_node.add_child(new_package)
	new_package.global_position = get_tree().get_first_node_in_group("package_spawn").global_position
