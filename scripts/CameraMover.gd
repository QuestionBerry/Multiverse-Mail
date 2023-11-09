extends Control

@onready var camera = get_tree().get_first_node_in_group("camera")
@export var counter_marker : Marker3D
@export var desk_marker  : Marker3D
@export var move_time : float = 2.0

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
