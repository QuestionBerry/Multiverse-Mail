extends RigidBody3D
class_name Letter

@export var lift_height : float = 1.5

@onready var spawn_marker = get_tree().get_first_node_in_group("letter_spawn")

# Called when the node enters the scene tree for the first time.
func _ready():
	input_event.connect(on_input_event)

func on_input_event(_camera, event:InputEvent, _position, _normal, _shape_idx):
	if event.is_action_pressed("move_object"):
		ObjectInteractor.start_moving_object(self)
	elif event.is_action_pressed("rotate_object_drag"):
		ObjectInteractor.start_rotating_object(self)

func _physics_process(delta):
	if self.position.y <= -2:
		self.linear_velocity = Vector3.ZERO
		self.angular_velocity = Vector3.ZERO
		self.position = spawn_marker.position
