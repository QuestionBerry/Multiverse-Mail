extends StaticBody3D
class_name Bin

@export var target_universe : NameList.universe
@export var rotation_speed : float = 1.0
@export var label_text : String
@export var color : Color = Color.WHITE

var objects_in_area = []

func _ready():
	for child in get_children():
		if child is Label3D:
			$Label3D.text = label_text
		if child is SpotLight3D:
			$SpotLight.light_color = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if objects_in_area.is_empty():
		return
	for object in objects_in_area:
		#Only checks if it has not been sorted
		if object is Letter and object.sorted_bin_location == null:
			if ObjectInteractor.acting_object != object:
				if not object.is_processed:
					print(str(object.name, " not processed"))
					object.respawn()
				else:
					object.sorted_bin_location = target_universe
					objects_in_area.remove_at(objects_in_area.find(object))
					send_mail(object)
		elif object is Package:
			if not object.is_processed:
					print(str(object.name, " not processed"))
					object.respawn()
			else:
				pass

func send_mail(target):
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(target, "rotation_degrees", Vector3(0,0,-90), 0.2)
	await tween.tween_property(target, "position", Vector3.UP*5, 0.5).as_relative().finished
	target.check_if_correct()

func hold_in_bin( target: RigidBody3D)->void:
	var delta = get_viewport().get_process_delta_time()
	target.global_position = $Marker3D.global_position
	if target is Letter:
		target.rotate_x(rotation_speed * delta)
	if target is Package:
		target.rotate_y(rotation_speed * delta)
	pass

#Doesn't enter until mouse is let go because rigidbody is frozen
func _on_area_3d_body_entered(body):
	if body not in objects_in_area:
		print(str(body.name, " entered"))
		objects_in_area.append(body)

func _on_area_3d_body_exited(body):
	if body in objects_in_area:
		objects_in_area.remove_at(objects_in_area.find(body))
