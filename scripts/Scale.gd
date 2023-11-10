extends RigidBody3D

@export var lift_height := 0.5

@onready var weigh_area := $"Weigh Area"
@onready var scale_readout := $Label3D
@onready var desk := get_tree().get_first_node_in_group("desk")
@onready var spawn_marker = get_tree().get_first_node_in_group("package_spawn")


var bodies_on_scale = []
var current_total_weight : float = 0
var current_visual_weight : float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	input_event.connect(on_input_event)
	weigh_area.body_entered.connect(scale_body_entered)
	weigh_area.body_exited.connect(scale_body_exited)

func on_input_event(_camera, event:InputEvent, _position, _normal, _shape_idx):
	if event.is_action_pressed("move_object"):
		ObjectInteractor.start_moving_object(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	check_scale()
	var new_scale_weight = lerpf(current_visual_weight, current_total_weight, 0.1)
	update_scale_readout(new_scale_weight)

func check_scale():
	var new_total_weight := 0.0
	for body in bodies_on_scale:
		if "is_touching_desk" in body and not body.is_touching_desk:
			if "weight" in body:
				new_total_weight += body.weight
	current_total_weight = new_total_weight

func scale_body_entered(body: Node3D):
	bodies_on_scale.append(body)
	print(str(body, " entered scale."))

func scale_body_exited(body:Node3D):
	bodies_on_scale.remove_at(bodies_on_scale.find(body))
	print(str(body, " removed from scale."))

func update_scale_readout(new_weight) -> void:
	current_visual_weight = new_weight
	new_weight = snappedf(new_weight, 0.01)
	scale_readout.text = str(new_weight, " lbs")

func _physics_process(_delta):
	if self.position.y <= -2:
		self.linear_velocity = Vector3.ZERO
		self.angular_velocity = Vector3.ZERO
		self.position = spawn_marker.position
