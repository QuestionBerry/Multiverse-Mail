extends Node3D
class_name Character

#Flag for package

var entry_text : String
var exit_text : String

var origin_universe :
	set(value):
		origin_universe = value
		pick_sprite()
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
