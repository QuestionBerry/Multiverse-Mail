extends Node3D
class_name Character

#Flag for package

var entry_text : String
var exit_text : String

var origin_universe 
var destination_universe
var is_fragile := false
var is_priority := false

var colors = [
	Color.BLUE_VIOLET,
	Color.DARK_SALMON,
	Color.TOMATO,
	Color.TEAL,
	Color.DARK_OLIVE_GREEN,
	Color.DARK_RED,
	Color.DODGER_BLUE,
	Color.SIENNA,
	Color.SEA_GREEN,
	Color.REBECCA_PURPLE,
	Color.ORANGE,
	Color.MEDIUM_ORCHID,
	Color.MAROON
]


func _ready():
	var color :Color= colors.pick_random().darkened(0.4)
	$Sprite3D.modulate = color 
	$Sprite3D.frame = randi()%3
	$AnimationPlayer.play("idle")

func get_sprite()->Sprite3D:
	return $Sprite3D

func pick_sprite():
	match origin_universe:
		NameList.universe.EARTH:
			$Sprite3D.frame = randi_range(0,9)
		NameList.universe.MAGIC:
			$Sprite3D.frame = randi_range(10,19)
		NameList.universe.CYBER:
			$Sprite3D.frame = randi_range(20,29)
	print(str("Origin Universe: ", origin_universe))
	print(str("Sprite frame: ", $Sprite3D.frame))

func pick_destination():
	var possible_destinations = [
		NameList.universe.EARTH,
		NameList.universe.MAGIC,
		NameList.universe.CYBER,
		]
	if randf() < 0.2: #Smaller chance that destination will be same as origin
		destination_universe = origin_universe
	else:
		possible_destinations.remove_at(possible_destinations.find(origin_universe))
		destination_universe = possible_destinations.pick_random()

