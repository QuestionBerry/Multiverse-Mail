extends Node2D

@export var letter : Sprite2D
@export var package : Sprite2D
@export var earth : Sprite2D
@export var yonder : Sprite2D
@export var stardock : Sprite2D

var is_shown := true
var speed := 0.75

var pages = [0, 1, 6, 7, 8]
var tabs = [letter, package, earth, yonder, stardock]

func update_available_pages()->void:
	match Global.game_day:
		2:
			var index = pages.find(1)
			pages.remove_at(index)
			pages.insert(index, 2)
		3:
			var index = pages.find(2)
			pages.remove_at(index)
			pages.insert(index, 3)
			
			pages.insert(index+1, 4)
			show_tabs()
		4:
			var index = pages.find(4)
			pages.remove_at(index)
			pages.insert(index, 5)
		_:
			pass
	change_page(0)


func show_tabs()->void:
	for tab in tabs:
		tab.visible = true

func _input(event): 
	if event.is_action_pressed("view_notebook"):
		move_notebook()

func move_notebook()->void:
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	
	is_shown = not is_shown
	if is_shown:
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property($Book, "position", $VisiblePosition.position, speed)
	else:
		tween.set_ease(Tween.EASE_IN )
		tween.tween_property($Book , "position", $HiddenPosition.position, speed)


func change_page(page):
	$Book.frame = page
	$Book/PreviousPage.visible = true
	match page:
		0: #Cover Page
			update_tab(letter, true)
			update_tab(package, true)
			update_tab(earth, true)
			update_tab(yonder, true)
			update_tab(stardock, true)
			$Book/PreviousPage.visible = false
		1, 2, 3: #Letter Rules
			update_tab(letter, true, true)
			update_tab(package, true)
			update_tab(earth, true)
			update_tab(yonder, true)
			update_tab(stardock, true)
		4, 5: #Package Rules
			update_tab(letter, false)
			update_tab(package, true, true)
			update_tab(earth, true)
			update_tab(yonder, true)
			update_tab(stardock, true)
		6:  #Earth Reference
			update_tab(letter, false)
			update_tab(package, false)
			update_tab(earth, true, true)
			update_tab(yonder, true)
			update_tab(stardock, true)
		7:   #Yonder Vale Reference
			update_tab(letter, false)
			update_tab(package, false)
			update_tab(earth, false, false, true)
			update_tab(yonder, true, true)
			update_tab(stardock, true)
		8:   #Stardock Reference
			update_tab(letter, false)
			update_tab(package, false)
			update_tab(earth, false, false, true)
			update_tab(yonder, false, false, true)
			update_tab(stardock, true, true)

func update_tab(tab, right:bool, show_bottom = false, flip = false):
	if right == true:
		tab.position.x = abs(tab.position.x)
	else:
		tab.position.x = -abs(tab.position.x)
	
	if show_bottom:
		tab.frame_coords.y = 0
	else:
		tab.frame_coords.y = 1
	
	if flip:
		tab.flip_h = true
		tab.flip_v = true
	else:
		tab.flip_h = false
		tab.flip_v = false


func _on_next_page_gui_input(event: InputEvent):
	if event.is_action_pressed("move_object"):
		var current_page = $Book.frame
		if pages.find(current_page) == len(pages)-1:
			return
		change_page(pages[pages.find(current_page)+1])

func _on_previous_page_gui_input(event):
	if event.is_action_pressed("move_object"):
		var current_page = $Book.frame
		if pages.find(current_page) == 0:
			return
		change_page(pages[pages.find(current_page)-1])

func _on_tab_button_gui_input(event, page_number):
	if event.is_action_pressed("move_object"):
		#Catch when rule pages have updated but not number
		#passed by Tab
		if page_number == 1 or page_number == 4:
			while not page_number in pages:
				page_number += 1
			change_page(page_number)
		else:
			change_page(page_number)
