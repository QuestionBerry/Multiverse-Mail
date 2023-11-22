extends Node3D
class_name Character

#Flag for package

var entry_text : String
var exit_text : String

var origin_universe :
	set(value):
		origin_universe = value
		pick_destination()
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
	$Sprite3D.modulate = colors.pick_random()
	$Sprite3D.frame = randi()%3
	$AnimationPlayer.play("idle")

func pick_destination():
	var possible_destinations = []
	match origin_universe:
		NameList.universe.EARTH:
			possible_destinations.append(NameList.universe.MAGIC)
			possible_destinations.append(NameList.universe.CYBER)
		NameList.universe.MAGIC:
			possible_destinations.append(NameList.universe.EARTH)
			possible_destinations.append(NameList.universe.CYBER)
		NameList.universe.CYBER:
			possible_destinations.append(NameList.universe.MAGIC)
			possible_destinations.append(NameList.universe.EARTH)
	destination_universe = possible_destinations.pick_random()
