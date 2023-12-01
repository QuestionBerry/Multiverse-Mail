extends GridContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_fullscreen_toggled(button_pressed):
	if button_pressed:
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED


func _on_music_volume_drag_ended(_value_changed):
	var index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(index, $MusicVolume.value)
	
	var mute = false
	if $MusicVolume.value == -50:
		mute = true
	AudioServer.set_bus_mute(index, mute)


func _on_sfx_volume_drag_ended(_value_changed):
	var index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(index, $SFXVolume.value)
	
	var mute = false
	if $MusicVolume.value == -50:
		mute = true
	AudioServer.set_bus_mute(index, mute)


func _on_back_button_pressed():
	self.hide()
	get_parent().show_menu()


func _on_rotate_speed_slider_drag_ended(value_changed):
	if value_changed:
		Global.rotate_speed = $RotateSpeedSlider.value
