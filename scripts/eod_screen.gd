extends Control


func _ready():
	hide_labels()


func show_screen() -> void:
	$ColorRect.visible = true
	var tween = get_tree().create_tween()
	await tween.tween_property($ColorRect, "color:a", 1.0, 3).finished
	$Title.text = str("End of Day ", Global.game_day)
	$Title.visible = true
	
	if Global.game_day < 7:
		tally_score()
	else:
		######## ADD FINAL SCORE SCREEN ######
		tally_score()
		pass

func hide_screen() -> void:
	hide_labels()
	var tween = get_tree().create_tween()
	await tween.tween_property($ColorRect, "color:a", 0, 2).finished
	$ColorRect.visible = false

func tally_score() -> void:
	await show_label_then_wait($GridContainer/LettersTotal)
	await animate_number($GridContainer/LettersTotalNumber, Global.correct_letters + Global.wrong_letters)
	await show_label_then_wait($GridContainer/LettersCorrect)
	await animate_number($GridContainer/LettersCorrectNumber, Global.correct_letters)
	await show_label_then_wait($GridContainer/LettersWrong)
	await animate_number($GridContainer/LettersWrongNumber, Global.wrong_letters)
	
	if Global.game_day >= 3:
		await show_label_then_wait($GridContainer/PackagesTotal)
		await animate_number($GridContainer/PackagesTotalNumber, Global.correct_packages + Global.wrong_packages)
		await show_label_then_wait($GridContainer/PackagesCorrect)
		await animate_number($GridContainer/PackagesCorrectNumber, Global.correct_packages)
		await show_label_then_wait($GridContainer/PackagesWrong)
		await animate_number($GridContainer/PackagesWrongNumber, Global.wrong_packages)
	
	$Button.visible = true

func hide_labels() -> void:
	$Title.visible = false
	$Button.visible = false
	$ColorRect.visible = false
	for child in $GridContainer.get_children():
		child.visible = false

func show_label_then_wait(label) -> void:
	label.visible = true
	await get_tree().create_timer(0.5).timeout

func animate_number(target, number) -> void:
	target.visible = true
	var current_number = 0
	while(current_number != number):
		target.text = str(current_number)
		await get_tree().create_timer(0.05).timeout
		current_number += 1
	target.text = str(current_number)
	await get_tree().create_timer(0.25).timeout


func _on_button_pressed():
	hide_screen()
	Global.game_day += 1
	get_tree().reload_current_scene()
