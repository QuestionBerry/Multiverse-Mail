extends Node

@export var lift_height : float = 1.0

@onready var camera : Camera3D = get_tree().get_first_node_in_group("camera")

var is_dragging := false
var prev_mouse_position
var next_mouse_position
var object_position_offset

const RAY_LENGTH = 100

func _ready():
	get_parent().input_event.connect(_on_package_input_event)

func _on_package_input_event(camera :Camera3D, event: InputEvent, position, normal, shape_idx):
	if event.is_action_pressed("move_object"):
		is_dragging = true
		object_position_offset = get_parent().position - position
		get_parent().freeze = true
		get_parent().position.y += lift_height

func _process(delta):
	if is_dragging:
		var mouse_position = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_position)
		var to = from + camera.project_ray_normal(mouse_position) * RAY_LENGTH
		
		var parameters = PhysicsRayQueryParameters3D.new()
		parameters.from = from
		parameters.to = to
		parameters.exclude = [get_parent()]
		parameters.collision_mask = 1
		var result = camera.get_world_3d().direct_space_state.intersect_ray(parameters)
		if result:
			get_parent().position.x = result.position.x 
			get_parent().position.z = result.position.z

func _input(event):
	if event.is_action_released("move_object"):
		is_dragging = false
		get_parent().freeze = false



