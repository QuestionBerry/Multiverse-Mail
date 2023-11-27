extends Node3D


func _ready():
	#Called here b/c autoload script happens before camera is created
	#creating a null reference otherwise
	ObjectInteractor.camera = get_tree().get_first_node_in_group("camera")


func start_day() -> void:
	#tell systems to update rulesets
	#spawn first letter
	#start person timer
	#move screen
	pass

func end_day() -> void:
	#stop interacting()
	#stop timers
	#bring up end of day screen
	#tally score
	#check for upgrade
	
	#pick decorative upgrade
	pass

func pause_game() -> void:
	#pause timers
	#pause interaction
	#bring up pause screen
	#have option to quit game or resume
	pass
