extends Control



func _ready():
	$AudioStreamPlayer2D.play(6.0)
	await get_tree().create_timer(2.0).timeout
	$Node3D/AnimationPlayer.play("TitleEntry")


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_options_button_pressed():
	$VBoxContainer.visible = false
	$Options.visible = true

func _on_credits_button_pressed():
	pass # Replace with function body.

func _on_quit_button_pressed():
	get_tree().quit()

func show_menu():
	$VBoxContainer.show()
