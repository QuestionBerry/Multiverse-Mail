extends Area3D
class_name Sticker

@onready var camera : Camera3D = get_tree().get_first_node_in_group("camera")

var is_dragging := false
var target = null
var label_text = "0.0lbs"
var weight : float

const RAY_LENGTH = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	input_event.connect(on_input_event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_released("move_object"):
		is_dragging = false
		if target:
			print("Stuck to package")
			var prev_transform = self.global_transform
			get_parent().has_sticker = false
			get_parent().remove_child(self)
			target.add_child(self)
			self.global_transform = prev_transform
			
			#Disable Input
			input_ray_pickable = false
			set_process(false)
	
	if is_dragging:
		var mouse_position = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_position)
		var to = from + camera.project_ray_normal(mouse_position) * RAY_LENGTH
		
		var result = ObjectInteractor.raycast(from, to, [self])
		if result:
			if result.collider.is_in_group("package") or result.collider.is_in_group("letter"):
				target = result.collider
			else:
				target = null
			if result.normal.y > 0.99999 or result.normal == Vector3.UP:
				self.rotation_degrees = Vector3(90,0, 180)
				self.global_position = result.position
			else:
				self.look_at_from_position(result.position, result.position+result.normal)
		else:
			target = null

func on_input_event(_camera, event: InputEvent, _position, _normal, _shape_idx):
	if event.is_action_pressed("move_object"):
		is_dragging = true
		$AnimationPlayer2.play("RESET")

func print_out(scale_weight: float)->void:
	$CollisionShape3D2/Label3D.text = str(scale_weight, "lbs")
	self.weight = scale_weight
	$AnimationPlayer2.play("printing")
	await $AnimationPlayer2.animation_finished
	self.input_ray_pickable = true
