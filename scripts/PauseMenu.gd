extends Control

var in_options := false
var confirm_quit := false:
	set(value):
		confirm_quit = value
		if value:
			$ColorRect/CenterContainer/VBoxContainer/VBoxContainer/QuitButton.text = "Really?"
		else:
			$ColorRect/CenterContainer/VBoxContainer/VBoxContainer/QuitButton.text = "Quit"

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_game_pause()

func toggle_game_pause():
	if in_options:
		return
	if get_tree().paused:
		$ColorRect.visible = false
		confirm_quit = false
		get_tree().paused = false
	else:
		$ColorRect.visible = true
		get_tree().paused = true

func show_menu():
	in_options = false
	$Options.hide()
	$ColorRect/CenterContainer/VBoxContainer.show()


func _on_resume_button_pressed():
	toggle_game_pause()

func _on_options_button_pressed():
	in_options = true
	confirm_quit = false
	$Options.show()
	$ColorRect/CenterContainer/VBoxContainer.hide()

func _on_quit_button_pressed():
	if not confirm_quit:
		confirm_quit = true
	else:
		get_tree().quit()
