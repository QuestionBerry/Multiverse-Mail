extends Node2D

var is_shown := true
var speed := 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event): 
	if event.is_action_pressed("view_notebook"):
		move_notebook()

func move_notebook()->void:
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	
	is_shown = not is_shown
	if is_shown:
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property($Book, "position", $VisiblePosition.position, speed)
	else:
		tween.set_ease(Tween.EASE_IN )
		tween.tween_property($Book , "position", $HiddenPosition.position, speed)
