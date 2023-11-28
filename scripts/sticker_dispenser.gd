extends RigidBody3D

@export var type : Sticker.types
@export var sprite : texture
@export var lift_height : float = 0.5

enum texture {EARTH, MAGIC, CYBER, FRAGILE, EXPEDITED}

var has_sticker = false

@onready var sticker_scene := load("res://scenes/sticker-destination.tscn")

func _ready():
	create_sticker()
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
	self.position = get_tree().get_first_node_in_group("package_spawn").position


func create_sticker()->void:
	if has_sticker:
		return
	
	var new_sticker = sticker_scene.instantiate()
	new_sticker.type = self.type
	new_sticker.get_child(0).get_child(0).frame = sprite
	if type == Sticker.types.DESTINATION:
		new_sticker.destination = sprite+1 #Offset by 1 because of RTS destination
	add_child(new_sticker)
	has_sticker = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(new_sticker, "position", Vector3(0,0,0.65), 0.75)
	
