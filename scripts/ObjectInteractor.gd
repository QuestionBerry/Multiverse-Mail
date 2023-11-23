extends Node

@onready var camera : Camera3D = get_tree().get_first_node_in_group("camera")

var acting_object : RigidBody3D
var is_moving_object := false
var is_rotating_object := false

var prev_mouse_position : Vector2
var prev_object_position : Vector3
var mouseMotion : Vector2

const RAY_LENGTH := 100
const ROTATION_SPEED := .02

func start_moving_object(object:RigidBody3D)->void:
	if is_moving_object or is_rotating_object:
		return
	acting_object = object
	is_moving_object = true
	is_rotating_object = false
	acting_object.freeze = true
	prev_object_position = acting_object.position

func start_rotating_object(object:RigidBody3D)->void:
	if is_moving_object or is_rotating_object:
		return
	acting_object = object
	is_moving_object = false
	is_rotating_object = true
	acting_object.freeze = true
	prev_mouse_position = get_viewport().get_mouse_position()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var below_result = raycast_below(object)
	if below_result:
		acting_object.position.y = below_result.position.y + acting_object.lift_height

func stop_interacting()->void:
	acting_object.freeze = false
	acting_object = null
	is_moving_object = false
	is_rotating_object = false
	if prev_mouse_position:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Input.warp_mouse(prev_mouse_position)
		prev_mouse_position = Vector2.ZERO

func _input(event):
	if event.is_action_released("move_object") and is_moving_object:
		stop_interacting()
	elif event.is_action_released("rotate_object_drag") and is_rotating_object:
		stop_interacting()
	
	if event is InputEventMouseMotion:
		mouseMotion = event.relative

func _physics_process(delta):
	if is_moving_object:
		var mouse_position = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_position)
		var to = from + camera.project_ray_normal(mouse_position) * RAY_LENGTH
		var raycast_result = raycast(from, to, [acting_object])
		if raycast_result:
			#if Bin, lets Bin process() modify position instead
			if raycast_result.collider is Bin and (acting_object is Letter or acting_object is Package) :
				raycast_result.collider.hold_in_bin(acting_object)
				return
			var below_result = raycast_below(acting_object)
			if below_result:
				print(acting_object.position.y)
				print(below_result.position.y + acting_object.lift_height)
				acting_object.position.y = below_result.position.y + acting_object.lift_height
			acting_object.position.x = raycast_result.position.x 
			acting_object.position.z = raycast_result.position.z
	elif is_rotating_object:
		acting_object.rotate_y((mouseMotion.x) * ROTATION_SPEED * delta)
		acting_object.rotate_x((mouseMotion.y) * ROTATION_SPEED * delta)

func raycast(from:Vector3, to:Vector3, exclusions:Array, collision_mask:int = 4294967295) -> Dictionary:	
	var parameters = PhysicsRayQueryParameters3D.new()
	parameters.from = from
	parameters.to = to
	parameters.exclude = exclusions
	parameters.collision_mask = collision_mask
	return camera.get_world_3d().direct_space_state.intersect_ray(parameters)

#func is_anything_above() -> bool:
#	var from = acting_object.position
#	var to = from + Vector3.UP * RAY_LENGTH
#	return true if raycast(from, to, [acting_object], 1) else false

func raycast_below(object):
	var from = object.position
	var to = from + Vector3.DOWN * RAY_LENGTH
	return raycast(from, to, [object])

