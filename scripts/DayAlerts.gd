extends Control


var papertext = {
	1 : "[center]Welcome to the your first day at [b]Multiverse Post[/b].
		\nAs the first step into trans-dimensional mail, our rules and regulations are still developing.
		\nYour job is to ensure the letters coming through abide by our regulations.
		\n\nVisually inspect each letter and cross-reference with the rulebook.
		\n\nStamp [color=green]APPROVED[/color] and send to the destination universe
		\n--OR--
		\nStamp [color=red]RETURN TO SENDER[/color] and return to the origin universe.
		[/center]",
	2 : "[center]Congrats on making it through your first day!
		\nDue to \"security concerns\" from nobility, all letters from The Yonder Vale will [b]require seals[/b] on the back.
		\n\nAdditionally, we are also seeing letters without addresses.
		\n[color=red]RETURN TO SENDER[/color] all letters without a destination.
		\nLetters without origin addresses are [b]allowed[/b] if they abide by all other rules.
		\nIf there are errors and no origin is supplied, please sort the letter to our [b]\"No Return\"[/b] facility, where we will safely store the letter in our dimensional deconstructor.
		[/center]",
	3 : "[center]Valued Employee,
		\nDue to temporary staffing shortages, you will be required to operate the front desk in addition to your current duties.
		\n\n[b]Your new responsibilites are as follows:[/b]
		\nReceive packages from customers. 
		\nPlace package on scale and let the weight settle. 
		\nPrint and apply weight label.
		\nApply appropriate destination label to package and place on conveyor.
		\n\nCheck back often to keep customers from waiting. [b]Don't let the line get too long.[/b][/center]",
	4 : "[center]We have received reports of a number of parcels arriving to their destination broken or in the \"wrong quantum state\". 
		\nTo ease public perceptions, customers can now request their shipment to be labeled fragile. 
		\n[b]Apply the fragile label[/b] to their parcel in addition to all other required labels.
		\n\nIn other news, we are monitoring our sorting efficiency amongst our facilities.
		\nEach employee is hereby required to correctly process at least [b]10 letters per shift.[/b]
		\nTo aid in your efforts, we have added tabs to all standard issue Multiverse Post Rulebooks.[/center]",
	5 : "[center]Valued Employee,
		\n\nIt has come to our attention that some messages passing through our facility are impersonating residents and addresses of other universes.
		\n\nHowever, Multiverse Post Stamps are only accessible from the respective universe.
		\n\nStarting today, when inspecting letters, [b]cross-reference the stamp against the origin universe[/b].
		\n\nIf they do not align, stamp [color=red]RETURN TO SENDER[/color] and pass it to the \"No Return\" tube for further inspection.[/center]",
	6 : "[center]Attention all staff,
		\nOur speed and efficiency are the pride of Multiverse Post. 
		\nMoving forward, we are offering expedited shipping to our customers. 
		\nFor the customers that request it, [b]apply the expedited label[/b] to their parcel in addition to all other required labels.[/center]",
	7 : "[center]Employee,
		\nEveryone learns at their own pace.
		\nFor example you have made [b]%s mistakes[/b] in your first six days of employment out of a total of %s sorted parcels and envelopes.
		\nShould you make it through the day, a Multiverse Post representative will be by to discuss your continued role within the organization.
		[/center]"
}


func _ready():
	reset()

func reset() -> void:
	$Paper.position = Vector2(450, 1100)
	$Envelope.position = Vector2(2564, 542)
	$Envelope.frame = 0
	$Paper/BeginButton.visible = false
	if Global.game_day == 7:
		var total_mistakes = Global.total_wrong_letters + Global.total_wrong_packages
		var total_shipments = Global.total_correct_letters + Global.total_correct_packages + total_mistakes
		$Paper/Label.text = papertext[Global.game_day] % [total_mistakes, total_shipments]
	else:
		$Paper/Label.text = papertext[Global.game_day]


func slide_in():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	await tween.tween_property($Envelope, "position", Vector2(960, 540), 1).finished
	await get_tree().create_timer(0.5).timeout
	$Envelope.frame = 2
	await get_tree().create_timer(1).timeout
	$Envelope.frame = 1
	$AudioStreamPlayer2D.play()

func show_paper():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	await tween.tween_property($Paper, "position", Vector2(450,70), 1).finished
	await get_tree().create_timer(1).timeout
	$Paper/BeginButton.visible = true


func _on_begin_button_pressed():
	$Envelope.queue_free()
	$Paper.queue_free()
	var tween = get_tree().create_tween()
	await tween.tween_property($ColorRect, "color:a", 0, 2).finished
	
	get_parent().start_day()
