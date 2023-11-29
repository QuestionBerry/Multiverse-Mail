extends Node

var game_day : int = 5

var can_interact := true
var player_at_counter := false

#Reset these per day
var correct_letters : int = 15
var correct_packages : int = 0
var wrong_letters : int = 0
var wrong_packages : int = 0

#Total for the end
var total_correct_letters : int = 0
var total_correct_packages : int = 0
var total_wrong_letters : int = 0
var total_wrong_packages : int = 0

func reset_score():
	correct_letters = 0
	correct_packages = 0
	wrong_letters = 0
	wrong_packages = 0
