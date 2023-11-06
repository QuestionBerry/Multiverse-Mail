extends Area3D

@onready var camera : Camera3D = get_tree().get_first_node_in_group("camera")

var is_dragging := false
var target = null

const RAY_LENGTH = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	self.input_event.connect(on_input_event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("move_object"):
		is_dragging = false
		if target:
			print("Stuck to package")
			var prev_transform = self.global_transform
			get_parent().remove_child(self)
			target.add_child(self)
			self.global_transform = prev_transform
			print(rotation)
			
			set_process(false)
	
	if is_dragging:
		var mouse_position = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_position)
		var to = from + camera.project_ray_normal(mouse_position) * RAY_LENGTH
		
		var parameters = PhysicsRayQueryParameters3D.new()
		parameters.from = from
		parameters.to = to
		parameters.exclude = [self]
		parameters.collision_mask = 1
		var result = camera.get_world_3d().direct_space_state.intersect_ray(parameters)
		if result:
			if result.collider.is_in_group("package"):
				target = result.collider
			if result.normal.y > 0.99999 or result.normal == Vector3.UP:
				rotation_degrees = Vector3(90,0, 180)
				position = result.position
			else:
				self.look_at_from_position(result.position, result.position+result.normal)
		else:
			target = null


func on_input_event(camera, event: InputEvent, position, normal, shape_idx):
	if event.is_action_pressed("move_object"):
		is_dragging = true
