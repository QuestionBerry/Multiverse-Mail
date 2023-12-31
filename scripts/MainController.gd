extends Node3D

@onready var sticker_dispenser = load("res://scenes/sticker_dispenser.tscn")
@onready var audio_player = $AudioStreamPlayer

var day_over := false

func _ready():
	#Called here b/c autoload script happens before camera is created
	#creating a null reference otherwise
	ObjectInteractor.camera = get_tree().get_first_node_in_group("camera")
	
	setup_world()
	show_new_day_screen()


func setup_world():
	#reset score
	Global.reset_score()
	
	#set initial camera location & enable camera controls
	if Global.game_day < 3:
		$World/Camera3D.position = $LetterSortingView/EnvelopeView.position
		$World/Camera3D.rotation = $LetterSortingView/EnvelopeView.rotation
		$CameraControl.visible = false
	else:
		$World/Camera3D.position = $PackageCounterView/PackageView.position
		$World/Camera3D.rotation = $PackageCounterView/PackageView.rotation
		#Enable Camera Movement
		$CameraControl.visible = true
		Global.player_at_counter = true
	
	#Spawn dispencers
	if Global.game_day >= 4:
		var fragile_dispenser = sticker_dispenser.instantiate()
		fragile_dispenser.type = Sticker.types.FRAGILE
		fragile_dispenser.sprite = Sticker_Dispenser.texture.FRAGILE
		fragile_dispenser.color = Color(0.522, 0, 0.027)
		$PackageCounterView/Dispensers.add_child(fragile_dispenser)
		fragile_dispenser.position = Vector3(-1.256, 1.069, -1.973)
	if Global.game_day >= 6:
		var expedited_dispenser = sticker_dispenser.instantiate()
		expedited_dispenser.type = Sticker.types.EXPEDITED
		expedited_dispenser.sprite = Sticker_Dispenser.texture.EXPEDITED
		expedited_dispenser.color = Color(0.624, 0.486, 0)
		$PackageCounterView/Dispensers.add_child(expedited_dispenser)
		expedited_dispenser.position = Vector3(-0.221, 1.069, -1.972)
	
	##TEMP
	Global.can_interact = true


func show_new_day_screen():
	#show new rules
	await $DayBegin.slide_in()
	$DayBegin.show_paper()


func start_day() -> void:
	#spawn first letter
	$LetterSortingView/MailChute.create_letter()
	
	#start music
	if Global.game_day%2:
		$AudioStreamPlayer.stream = load("res://assets/audio/Music/Title 2-Loop.mp3")
	else:
		$AudioStreamPlayer.stream = load("res://assets/audio/Music/22-Dark fantasy studio- Reggae time.mp3")
	$AudioStreamPlayer.play()
	
	
	#start person timer
	if Global.game_day >= 3:
		$PackageCounterView/CharacterManager/SpawnerCountdown.start()
		
		$DayTimer.wait_time = 300
		$DayTimer.start()
	else:
		$DayTimer.start()

func end_day() -> void:
	day_over = true
	#Play sound
	if Global.day_failed:
		audio_player.stream = load("res://assets/audio/SFX/Arcade Negative Feedback 01.wav")
		audio_player.play()
	else:
		audio_player.stream = load("res://assets/audio/SFX/Arcade_Positive_Event_01_1.wav")
		audio_player.play()
	
	#stop interacting()
	Global.can_interact = false
	ObjectInteractor.stop_interacting()
	#stop timers
	$PackageCounterView/CharacterManager.stop_timer()

	await get_tree().create_timer(1).timeout
	#bring up end of day screen
	$GUI/EODScreen.show_screen()


func _on_audio_stream_player_finished():
	if not day_over:
		await get_tree().create_timer(30).timeout
		$AudioStreamPlayer.play()
