extends RigidBody3D

@export var weight :float= 0.0
@export var lift_height : float = 1.0

@onready var spawn_marker = get_tree().get_first_node_in_group("package_spawn")

#Used in checking if it is fully on the Scale
var is_touching_desk := false

func _ready():
	self.body_entered.connect(on_body_entered)
	self.body_exited.connect(on_body_exited)
	self.input_event.connect(on_input_event)

func on_body_entered(body: Node):
	if body.is_in_group("desk"):
		is_touching_desk = true

func on_body_exited(body:Node):
	if body.is_in_group("desk"):
		is_touching_desk = false

func on_input_event(_camera, event:InputEvent, _position, _normal, _shape_idx):
	if event.is_action_pressed("move_object"):
		ObjectInteractor.start_moving_object(self)
	elif event.is_action_pressed("rotate_object_drag"):
		ObjectInteractor.start_rotating_object(self)

func _physics_process(_delta):
	if self.position.y <= -2:
		self.linear_velocity = Vector3.ZERO
		self.angular_velocity = Vector3.ZERO
		self.position = spawn_marker.position
