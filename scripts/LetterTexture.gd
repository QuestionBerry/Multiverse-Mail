extends Node2D


func create_letter_texture(origin, destination, has_stamp, has_seal):
	$SubViewport/OriginName2.text = NameList.get_random_name(origin)
	$SubViewport/OriginLocation2.text = NameList.get_random_location(origin)
	
	$SubViewport/DestinationName2.text = NameList.get_random_name(destination)
	$SubViewport/DestinationLocation2.text = NameList.get_random_location(destination)
	
	if has_stamp:
		set_stamp(origin)
	
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
			pass
		NameList.universe.MAGIC:
			#placeholder test until more sprites get added
			$SubViewport/Stamp.frame = randi_range(0,4)
		NameList.universe.CYBER:
			pass
	
	var stamp_position = Vector2(229, 25)
	stamp_position.x += randi_range(-4, 4)
	stamp_position.y += randi_range(-3, 3)
	$SubViewport/Stamp.position = stamp_position
