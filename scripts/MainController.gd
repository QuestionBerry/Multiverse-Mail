extends Node3D

@onready var sticker_dispenser = load("res://scenes/sticker_dispenser.tscn")

func _ready():
	#Called here b/c autoload script happens before camera is created
	#creating a null reference otherwise
	ObjectInteractor.camera = get_tree().get_first_node_in_group("camera")
	
	setup_world()

func setup_world():
	#spawn dispencers
	
	#enable camera controls per day
	
	#reset score
	Global.reset_score()
	
	#set initial camera location
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
	#spawn new additions to world
	#have button to start day
	pass


func start_day() -> void:
	#tell systems to update rulesets
	#spawn first letter
	#start person timer
	#move screen
	pass

func end_day() -> void:
	#Play sound
	#stop interacting()
	Global.can_interact = false
	ObjectInteractor.stop_interacting()
	#stop timers
	$PackageCounterView/CharacterManager.stop_timer()

	await get_tree().create_timer(1).timeout
	#bring up end of day screen
	$GUI/EODScreen.show_screen()
	#check for upgrade
	
	#pick decorative upgrade
	pass

func pause_game() -> void:
	#pause timers
	#pause interaction
	#bring up pause screen
	#have option to quit game or resume
	pass
