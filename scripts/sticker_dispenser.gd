extends RigidBody3D

@export var type : Sticker.types
@export var destination_sprite : texture
@export var lift_height : float = 0.5

enum texture {EARTH, MAGIC, CYBER}

var has_sticker = false

@onready var sticker_scene := load("res://scenes/sticker-destination.tscn")

func _ready():
	create_sticker()
	input_event.connect(on_input_event)

func on_input_event(_camera, event:InputEvent, _position, _normal, _shape_idx):
	if event.is_action_pressed("move_object"):
		ObjectInteractor.start_moving_object(self)


func create_sticker()->void:
	if has_sticker:
		return
	
	var new_sticker = sticker_scene.instantiate()
	new_sticker.type = Sticker.types.DESTINATION
	new_sticker.get_child(0).get_child(0).frame = destination_sprite
	new_sticker.destination = destination_sprite+1 #Offset by 1 because of 
	add_child(new_sticker)
	has_sticker = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(new_sticker, "position", Vector3(0,0,0.65), 0.75)
	
