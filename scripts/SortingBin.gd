extends StaticBody3D
class_name Bin

@export var target_universe : NameList.universe
@export var rotation_speed : float = 1.0
@export var label_text : String

var objects_in_area = []

func _ready():
	$Label3D.text = label_text

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

func send_mail(target):
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(target, "rotation_degrees", Vector3(0,0,-90), 0.2)
	await tween.tween_property(target, "position", Vector3.UP*5, 0.5).as_relative().finished
	target.check_if_correct()

func hold_in_bin( target: RigidBody3D)->void:
	var delta = get_viewport().get_process_delta_time()
	target.global_position = $Marker3D.global_position
	target.rotate_x(rotation_speed * delta)
	pass

#Doesn't enter until mouse is let go because rigidbody is frozen
func _on_area_3d_body_entered(body):
	if body not in objects_in_area:
		print(str(body.name, " entered"))
		objects_in_area.append(body)

func _on_area_3d_body_exited(body):
	if body in objects_in_area:
		objects_in_area.remove_at(objects_in_area.find(body))
