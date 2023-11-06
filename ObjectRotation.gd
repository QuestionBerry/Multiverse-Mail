extends Node
#Attach script to Node child to Node3D of object to be rotated
#parent(Node3D)
#  |-> Node (+This script)

const ROTATION_SPEED := .5

var is_rotating : bool = false
var prev_mouse_position
var next_mouse_position

func _ready():
	get_parent().input_event.connect(on_object_input)

func on_object_input(camera :Camera3D, event: InputEvent, position, normal, shape_idx):
	if event.is_action_pressed("rotate_object_drag"):
		is_rotating = true
		prev_mouse_position = get_viewport().get_mouse_position()
		get_parent().freeze = true
		get_parent().position.y = 1.1

func _input(event):
	if event.is_action_released("rotate_object_drag"):
		is_rotating = false
		get_parent().freeze = false

func _process(delta):
	if(is_rotating):
		next_mouse_position = get_viewport().get_mouse_position()
		get_parent().rotate_y((next_mouse_position.x - prev_mouse_position.x) * ROTATION_SPEED * delta)
		get_parent().rotate_x((next_mouse_position.y - prev_mouse_position.y) * ROTATION_SPEED * delta)
		prev_mouse_position = next_mouse_position

