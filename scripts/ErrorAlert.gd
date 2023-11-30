extends Label


func show_errors(errors : Array) -> void:
	if not errors:
		return
	await get_tree().create_timer(1).timeout
	$AudioStreamPlayer.play()
	
	var label_text = ""
	var duration = 4
	for error in errors:
		label_text = str(label_text, "\n", error)
		duration += 1
	
	self.text = label_text
	
	await get_tree().create_timer(duration).timeout
	
	self.text = ""
