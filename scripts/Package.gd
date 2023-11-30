extends RigidBody3D
class_name Package

@export var weight :float= 0.0
@export var lift_height : float = 1.0

@onready var spawn_marker = get_tree().get_first_node_in_group("package_spawn")

var has_origin := true
var origin_universe = NameList.universe.EARTH
var has_destination := true
var destination_universe = NameList.universe.EARTH

var is_priority_mail := false
var is_fragile := false

var is_processed = false

var sticker_offset :int= 0

#Used in checking if it is fully on the Scale
var is_touching_desk := false

func _ready():
	self.body_entered.connect(on_body_entered)
	self.body_exited.connect(on_body_exited)
	self.input_event.connect(on_input_event)
	respawn()

func _physics_process(_delta):
	if self.position.y <= -2:
		respawn()

func respawn()->void:
	self.linear_velocity = Vector3.ZERO
	self.angular_velocity = Vector3.ZERO
	self.position = spawn_marker.position

func check_if_correct()->void:
	var is_correct = get_parent().check_package_correct(self)
	if is_correct:
		Global.correct_packages += 1
		print("Correct")
	else:
		Global.wrong_packages += 1
		print("Wrong")
		if Global.wrong_letters + Global.wrong_packages > 5:
			Global.day_failed = true
			get_tree().get_first_node_in_group("main").end_day()
	
	self.queue_free()
	get_tree().get_first_node_in_group("character_manager").move_up_queue()

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
