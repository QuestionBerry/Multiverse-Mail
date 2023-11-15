extends RigidBody3D

@export var lift_height := 0.5

@export var stamp_sprite : Texture2D
@export var stamp_color : Color
@export var speed : float = 0.15
enum status {APPROVED, RETURNED}
@export var stamp_type : status

@onready var stamp_decal = load("res://scenes/decal.res")

# Called when the node enters the scene tree for the first time.
func _ready():
	input_event.connect(on_input_event)
	$Model/Top/Decal.texture_albedo = stamp_sprite
	var material :StandardMaterial3D = $Model/Top.get_surface_override_material(0).duplicate()
	material.albedo_color = stamp_color
	$Model/Top.set_surface_override_material(0, material)

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

func stamp_animation():
	$AnimationPlayer.play("stamp_down")
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play("stamp_up")

func _on_stamp_area_body_entered(body):
	if body is RigidBody3D and body != self:
		stamp_animation()
		print(str("Stamped ", body))
		var new_decal :Decal= stamp_decal.instantiate()
		new_decal.texture_albedo = stamp_sprite
		new_decal.modulate = Color.BLACK
		body.add_child(new_decal)
		new_decal.global_position = $Marker3D.global_position
		new_decal.global_rotation = $Marker3D.global_rotation
		if body is Letter:
			body.is_processed = true
			match stamp_type:
				status.APPROVED:
					body.is_approved = true
				status.RETURNED:
					body.is_returned = true
