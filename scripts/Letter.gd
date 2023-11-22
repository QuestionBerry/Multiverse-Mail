extends RigidBody3D
class_name Letter

@export var lift_height : float = 1.5

@onready var spawn_marker = get_tree().get_first_node_in_group("letter_spawn")

var has_origin := true
var origin_universe = NameList.universe.EARTH

var has_destination := true
var destination_universe = NameList.universe.EARTH
var has_stamp := false
var has_seal := false

var sorted_bin_location = null
var is_processed := false
var is_approved := false
var is_returned := false



func _ready():
	input_event.connect(on_input_event)

func on_input_event(_camera, event:InputEvent, _position, _normal, _shape_idx):
	if event.is_action_pressed("move_object"):
		ObjectInteractor.start_moving_object(self)
	elif event.is_action_pressed("rotate_object_drag"):
		ObjectInteractor.start_rotating_object(self)

func _physics_process(_delta):
	if self.position.y <= -2:
		respawn()

func respawn()->void:
	self.linear_velocity = Vector3.ZERO
	self.angular_velocity = Vector3.ZERO
	self.position = spawn_marker.position

func check_if_correct()->void:
	var is_correct = get_parent().check_letter_correct(self)
	if is_correct:
		Global.correct_letters += 1
		print("Correct")
	else:
		Global.wrong_letters += 1
		print("Wrong")
	self.queue_free()
	get_tree().get_first_node_in_group("mail_chute").create_letter()
