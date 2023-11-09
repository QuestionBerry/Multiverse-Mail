extends Node

@onready var camera : Camera3D = get_tree().get_first_node_in_group("camera")

var is_dragging := false
var target = null

const RAY_LENGTH = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().input_event.connect(on_input_event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_released("move_object"):
		is_dragging = false
		if target:
			print("Stuck to package")
			var prev_transform = get_parent().global_transform
			get_parent().get_parent().remove_child(get_parent())
			target.add_child(get_parent())
			get_parent().global_transform = prev_transform
			
			#Disable Input
			get_parent().input_ray_pickable = false
			set_process(false)
	
	if is_dragging:
		var mouse_position = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_position)
		var to = from + camera.project_ray_normal(mouse_position) * RAY_LENGTH
		
		var result = ObjectInteractor.raycast(from, to, [get_parent()], 1)
		if result:
			if result.collider.is_in_group("package") or result.collider.is_in_group("letter"):
				target = result.collider
			else:
				target = null
			if result.normal.y > 0.99999 or result.normal == Vector3.UP:
				get_parent().rotation_degrees = Vector3(90,0, 180)
				get_parent().position = result.position
			else:
				get_parent().look_at_from_position(result.position, result.position+result.normal)
		else:
			target = null


func on_input_event(_camera, event: InputEvent, _position, _normal, _shape_idx):
	if event.is_action_pressed("move_object"):
		is_dragging = true
