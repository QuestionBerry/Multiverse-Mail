extends StaticBody3D

@export var letter_group_node : Node3D

@onready var letter = load("res://scenes/letter.tscn")

var metal_sounds = [
	"res://assets/audio/SFX/metal thunk 1.wav",
	"res://assets/audio/SFX/metal thunk 2.wav",
	"res://assets/audio/SFX/metal thunk 3.wav"
]

class Spawn_Rules:
	var earth_chance : float
	var magic_chance : float
	var cyber_chance : float
	var origin_chance : float
	var destination_chance : float
	var stamp_chance : float
	var seal_chance : float
	var fake_origin : float
	
	func _init(_earth_chance, _magic_chance, _cyber_chance, _origin_chance, _destination_chance, _stamp_chance, _seal_chance, _fake_origin):
		earth_chance = _earth_chance
		magic_chance = _magic_chance
		cyber_chance = _cyber_chance
		origin_chance = _origin_chance
		destination_chance = _destination_chance
		stamp_chance = _stamp_chance
		seal_chance = _seal_chance
		fake_origin = _fake_origin

								#Earth, magic, cyber, origin, dest, stamp, seal, fake
var day1rules := Spawn_Rules.new( 1.0,  1.0,    1.0,    1.0,   1.0,   0.75, 0.0,  0.0)
var day2rules := Spawn_Rules.new( 0.75,  1.0,    0.6,   0.9,   0.75,  0.8,  0.7,  0.0)
var day3rules := Spawn_Rules.new( 0.75, 0.75,   1.0,    0.8,   0.75,  0.75, 0.75, 0.0)
var day4rules := Spawn_Rules.new( 1.0,   1.0,    1.0,  0.75,   0.8,   0.6,  0.8,  0.0)
var day5rules := Spawn_Rules.new( 0.5,  0.75,    0.8,   0.85,   0.9,   0.8,  0.6,  0.5)
var day6rules := Spawn_Rules.new( 1.0,   1.0,    1.0,   0.9,   1.0,   0.8,  0.75, 0.4)
var day7rules := Spawn_Rules.new( 1.0,   1.0,    1.0,   0.7,   0.8,   0.7,  0.6,  0.4)

var rules = { 
	1 : day1rules,
	2 : day2rules,
	3 : day3rules,
	4 : day4rules,
	5 : day5rules,
	6 : day6rules,
	7 : day7rules
}


func roll_letter_properties(rules: Spawn_Rules)->Dictionary:
	var properties = {}
	properties.has_origin = true if randf() < rules.origin_chance else false
	properties.origin_universe = pick_universe_from_chance(
		rules.earth_chance,
		rules.magic_chance,
		rules.cyber_chance
	)
	properties.has_destination = true if randf() < rules.destination_chance else false
	properties.destination_universe = pick_universe_from_chance(
		rules.earth_chance,
		rules.magic_chance,
		rules.cyber_chance
	)
	properties.has_stamp = true if randf() < rules.stamp_chance else false
	#Only has a chance for seal if origin is Magic
	if properties.origin_universe == NameList.universe.MAGIC:
		properties.has_seal = true if randf() < rules.seal_chance else false
	else:
		properties.has_seal = false
	
	#Origin can only be fake if it has one
	if properties.has_origin and properties.has_stamp:
		properties.is_fake = true if randf() < rules.fake_origin else false
	else:
		properties.is_fake = false
	
	print(properties)
	return properties

#Combines all the chances of each universe and picks one randomly
func pick_universe_from_chance(earth : float, magic : float, cyber : float)->int:
	var randomf = randf_range(0,  earth + magic + cyber)
	if randomf <= earth:
		return NameList.universe.EARTH
	elif randomf <= (earth + magic): 
		return NameList.universe.MAGIC
	else:
		return NameList.universe.CYBER


func create_letter():
	var properties := roll_letter_properties(rules[Global.game_day])
	var new_letter : Letter = letter.instantiate()
	new_letter.has_origin = properties.has_origin
	new_letter.origin_universe = properties.origin_universe
	new_letter.has_destination = properties.has_destination
	new_letter.destination_universe = properties.destination_universe
	new_letter.has_stamp = properties.has_stamp
	new_letter.has_seal = properties.has_seal
	new_letter.is_fake = properties.is_fake
	
	for child in new_letter.get_children():
		if child is MeshInstance3D:
			#Duplicate material so all instances will be unique
			var new_material :StandardMaterial3D = child.get_active_material(0).duplicate()
			var letter_texture = await get_tree().get_first_node_in_group("letter_texture").create_letter_texture(new_letter)
			new_material.albedo_texture = letter_texture
			child.set_surface_override_material(0, new_material)
	
	letter_group_node.add_child(new_letter)
	new_letter.global_position = $Marker3D.global_position
	new_letter.linear_velocity = Vector3.RIGHT * 18
	new_letter.angular_velocity = Vector3(randi()%5, randi()%5, randi()%5)
	
	$AudioStreamPlayer3D.stream = load(metal_sounds.pick_random())
	$AudioStreamPlayer3D.play()
