extends StaticBody3D

@export var letter_group_node : Node3D

@onready var letter = load("res://scenes/letter.tscn")

class Spawn_Rules:
	var earth_chance : float
	var magic_chance : float
	var cyber_chance : float
	var origin_chance : float
	var destination_chance : float
	var stamp_chance : float
	var seal_chance : float
	
	func _init(_earth_chance, _magic_chance, _cyber_chance, _origin_chance, _destination_chance, _stamp_chance, _seal_chance):
		earth_chance = _earth_chance
		magic_chance = _magic_chance
		cyber_chance = _cyber_chance
		origin_chance = _origin_chance
		destination_chance = _destination_chance
		stamp_chance = _stamp_chance
		seal_chance = _seal_chance

								#Earth, magic, cyber, origin, dest, stamp, seal
var day1rules := Spawn_Rules.new( 1.0,  1.0,    1.0,   1.0,   1.0,   0.75, 0.0)
var rules = { 1 : day1rules} #add in later


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
	properties.has_seal = true if randf() < rules.seal_chance else false
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
	var properties := roll_letter_properties(day1rules)
	var new_letter : Letter = letter.instantiate()
	new_letter.has_origin = properties.has_origin
	new_letter.origin_universe = properties.origin_universe
	new_letter.has_destination = properties.has_destination
	new_letter.destination_universe = properties.destination_universe
	new_letter.has_stamp = properties.has_stamp
	new_letter.has_seal = properties.has_seal
	
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
	
