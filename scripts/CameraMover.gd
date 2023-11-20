extends Control

@onready var camera = get_tree().get_first_node_in_group("camera")
@onready var letter = load("res://scenes/letter.tscn")
@onready var package = load("res://scenes/package.tscn")

@export var counter_marker : Marker3D
@export var desk_marker  : Marker3D
@export var move_time : float = 2.0

@export var package_group_node : Node3D

#### DEBUGGING QUIT : MOVE OR REMOVE LATER
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

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
