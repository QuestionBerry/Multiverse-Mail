extends Control


func _ready():
	hide_labels()

func update_totals():
	Global.total_correct_letters += Global.correct_letters
	Global.total_correct_packages += Global.correct_packages
	Global.total_wrong_letters += Global.wrong_letters
	Global.total_wrong_packages += Global.wrong_packages

func show_screen() -> void:
	$ColorRect.visible = true
	var tween = get_tree().create_tween()
	await tween.tween_property($ColorRect, "color:a", 1.0, 3).finished
	$Title.text = str("End of Day ", Global.game_day)
	$Title.visible = true
	
	tally_score()

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
	
	if Global.game_day >= 5:
		if Global.correct_letters < 10:
			Global.day_failed = true
			$FailCondition.text = "Failed: Didn't meet letters quota"
	
	if Global.day_failed:
		$Button.text = "Retry Day"
		if Global.excess_customers >= 3:
			$FailCondition.text = "Failed: Customers line left too long"
		elif Global.wrong_letters + Global.wrong_packages > 5:
			$FailCondition.text = "Failed: Too many sorting mistakes"
	
	$Button.visible = true

func hide_labels() -> void:
	$Title.visible = false
	$Button.visible = false
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
	#Final screen
	if Global.game_day == 7 and not Global.day_failed:
		update_totals()
		hide_labels()
		show_final_score()
		return
	
	hide_screen()
	if not Global.day_failed:
		update_totals()
		Global.game_day += 1
	get_tree().reload_current_scene()


func show_final_score():
	$FinalScore/VBoxContainer/GridContainer/GridContainer2/LettersTotalNumber.text = str(Global.total_correct_letters + Global.total_wrong_letters)
	$FinalScore/VBoxContainer/GridContainer/GridContainer2/LettersCorrectTotalNumber.text = str(Global.total_correct_letters)
	$FinalScore/VBoxContainer/GridContainer/GridContainer2/LettersWrongTotalNumber.text = str(Global.total_wrong_letters)
	
	$FinalScore/VBoxContainer/GridContainer/GridContainer/PackagesTotalNumber.text = str(Global.total_correct_packages + Global.total_wrong_packages)
	$FinalScore/VBoxContainer/GridContainer/GridContainer/PackagesCorrectTotalNumber.text = str(Global.total_correct_packages)
	$FinalScore/VBoxContainer/GridContainer/GridContainer/PackagesWrongTotalNumber.text = str(Global.total_wrong_packages)
	$FinalScore.visible = true
