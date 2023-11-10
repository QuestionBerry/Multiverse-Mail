extends RigidBody3D

@export var lift_height := 0.5
#Currently unused
@export var stamp_sprite : Texture2D
@export var stamp_color : Color
@export var speed : float = 0.15


@onready var stamp_decal = load("res://scenes/decal.res")

# Called when the node enters the scene tree for the first time.
func _ready():
	input_event.connect(on_input_event)

func on_input_event(_camera, event:InputEvent, _position, _normal, _shape_idx):
	if event.is_action_pressed("move_object"):
		ObjectInteractor.start_moving_object(self)

func _input(event):
	if event.is_action_pressed("rotate_object_drag") and ObjectInteractor.acting_object == self:
		stamp_down()
		get_viewport().set_input_as_handled()

func stamp_down():
	ObjectInteractor.stop_interacting()
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN)
	var new_position = position
	new_position.y -= lift_height*1.5
	tween.tween_property(self, "position", new_position, speed)


func _on_stamp_area_body_entered(body):
	if body is RigidBody3D and body != self:
		print(str("Stamped ", body))
		var new_decal :Decal= stamp_decal.instantiate()
		body.add_child(new_decal)
		new_decal.global_position = $Marker3D.global_position
		new_decal.global_rotation = $Marker3D.global_rotation
