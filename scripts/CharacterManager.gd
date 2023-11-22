extends Node3D

@export var marker1 : Marker3D
@export var marker2 : Marker3D
@export var marker3 : Marker3D
@export var spawn_countdown : Timer
@export var packages : Node3D

@onready var character_scene = load("res://scenes/Character.tscn")
@onready var package_scene = load("res://scenes/package.tscn")

var position_markers = [marker1, marker2, marker3]
var character_queue = []

class Character_Rules:
	var spawn_chance : float
	var spawn_time : float
	var origin_universe 
	var fragile_chance : float
	var priority_chance : float
	
	func _init(_spawn_chance, _spawn_time, _origin_universe, _fragile_chance, _priority_chance):
		spawn_chance = _spawn_chance
		spawn_time = _spawn_time
		origin_universe = _origin_universe
		fragile_chance = _fragile_chance
		priority_chance = _priority_chance

#                     spawn_chance, spawn_time,    universe,  fragile, priority
var day1 = Character_Rules.new(0.9, 10, NameList.universe.EARTH, 0.0, 0.0)
var day2 = Character_Rules.new(0.75, 15, NameList.universe.MAGIC, 0.5, 0.0)
var day3 = Character_Rules.new(0.8, 20, NameList.universe.CYBER, 0.3, 0.5)

var rules = [null, day1, day2, day3]

func _ready():
	spawn_countdown.wait_time = 5
#Spawning: generate character flags, pass to character
#Track character positions in queue,
#animate characters between positions; pass positions and let characters self animate
#If position == 1 and player.view != package counter:
#     start patience countdown
#IF position == 1: spawn package from character needs,
#  Play character dialo

func on_timer_ended():
	if len(character_queue) >= 3:
		print("Too many Characters")
		spawn_countdown.start(rules[Global.game_day].spawn_time)
	elif randf() < rules[Global.game_day].spawn_chance:
		create_character()
		print("Spawned Character")
		spawn_countdown.start(rules[Global.game_day].spawn_time)
	else:
		#If spawn failed, restart timer with original short duration
		print("Restarting Timer")
		spawn_countdown.start()


func create_character()->Character:
	var new_character :Character= character_scene.instantiate()
	new_character.origin_universe = rules[Global.game_day].origin_universe
	if randf() < rules[Global.game_day].fragile_chance:
		new_character.is_fragile = true
	if randf() < rules[Global.game_day].priority_chance:
		new_character.is_priority = true
	
	self.add_child(new_character)
	character_queue.append(new_character)
	
	var new_position
	match character_queue.find(new_character):
		0:
			new_position = marker1.position
			spawn_package(new_character)
		1:
			new_position = marker2.position
		2:
			new_position = marker3.position
	new_character.position = new_position
	
	return new_character

func spawn_package(character:Character):
	var new_package :Package= package_scene.instantiate()
	new_package.origin_universe = character.origin_universe
	new_package.destination_universe = character.destination_universe
	new_package.is_fragile = character.is_fragile
	new_package.is_priority_mail = character.is_priority
	
	for child in new_package.get_children():
		if child is MeshInstance3D:
		#Duplicate material so all instances will be unique
			var material :StandardMaterial3D = child.get_active_material(0).duplicate()
			var package_texture = await get_tree().get_first_node_in_group("package_texture").create_package_texture(
				new_package.origin_universe,
				new_package.destination_universe
			)
			material.albedo_texture = package_texture
			child.set_surface_override_material(0, material)
	print("New package made")
	
	packages.add_child(new_package)
	pass

#func move_up_queue():
#	for character in character_queue:
#		var tween = get_tree().create_tween()
#		var next_position = character_queue.find(character)-1
#		if next_position <= 0:
#			continue
#		else:
#			await tween.tween_property(character, "position", position_markers[next_position].position, 1.5).as_relative().finished
