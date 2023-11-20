extends Node2D

var letter_backgrounds = [
	"res://assets/sprites/letters/letter_0.png",
	"res://assets/sprites/letters/letter_1.png",
	"res://assets/sprites/letters/letter_2.png",
	"res://assets/sprites/letters/letter_3.png"
]

func reset_text()->void:
	$SubViewport/OriginName2.text = ""
	$SubViewport/OriginLocation2.text = ""
	$SubViewport/DestinationName2.text = ""
	$SubViewport/DestinationLocation2.text = ""

func create_letter_texture(letter: Letter):
	reset_text()
	
	if letter.has_origin:
		$SubViewport/OriginName2.text = NameList.get_random_name(letter.origin_universe)
		$SubViewport/OriginLocation2.text = NameList.get_random_location(letter.origin_universe, true)
	if letter.has_destination:
		$SubViewport/DestinationName2.text = NameList.get_random_name(letter.destination_universe)
		$SubViewport/DestinationLocation2.text = NameList.get_random_location(letter.destination_universe, true)
	
	if letter.has_stamp:
		set_stamp(letter.origin_universe)
	else:
		$SubViewport/Stamp.frame = 0
	
	if letter.has_seal:
		$SubViewport/Seal.frame = randi_range(1,5)
	else:
		$SubViewport/Seal.frame = 0
	
	$SubViewport/LetterTexture.texture = load(letter_backgrounds.pick_random())
	
	#Sets the Subviewport to render once, then waits for frame to draw
	$SubViewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	#Takes image data from viewport and makes a new imageTexture 
	#Otherwise all instance would reference the same dynamic viewport texture
	var img : Image = $SubViewport.get_texture().get_image()
	img.resize(256*2, 320*2, Image.INTERPOLATE_NEAREST)
	var newTexture := ImageTexture.create_from_image(img)
	return newTexture


func set_stamp(universe):
	match universe:
		NameList.universe.EARTH:
			$SubViewport/Stamp.frame = randi_range(1, 7)
		NameList.universe.MAGIC:
			$SubViewport/Stamp.frame = randi_range(8, 13)
		NameList.universe.CYBER:
			$SubViewport/Stamp.frame = randi_range(14, 19)
	
	var stamp_position = Vector2(229, 25)
	stamp_position.x += randi_range(-4, 4)
	stamp_position.y += randi_range(-3, 3)
	$SubViewport/Stamp.position = stamp_position
