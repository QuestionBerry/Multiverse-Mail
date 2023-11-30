extends Control

@onready var camera = get_tree().get_first_node_in_group("camera")

@export var counter_marker : Marker3D
@export var desk_marker  : Marker3D
@export var move_time : float = 2.0

@export var package_group_node : Node3D

func _on_to_desk_pressed():
	move_camera(desk_marker)

func _on_to_counter_pressed():
	move_camera(counter_marker)

func move_camera(destination : Marker3D):
	if destination == desk_marker:
		Global.player_at_counter = false
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(camera, "rotation", destination.global_rotation, move_time)
	await tween.tween_property(camera, "position", destination.global_position, move_time).finished
	if destination == counter_marker:
		Global.player_at_counter = true
