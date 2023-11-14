extends StaticBody3D

@export var target_universe : NameList.universe
var objects_in_area = []

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
					object.check_if_correct()

func _on_area_3d_body_entered(body):
	if body not in objects_in_area:
		print(str(body.name, " entered"))
		objects_in_area.append(body)

func _on_area_3d_body_exited(body):
	objects_in_area.remove_at(objects_in_area.find(body))
