extends Node2D

var box_textures = [
	"res://assets/sprites/packages/box_1.png",
	"res://assets/sprites/packages/box_2.png",
	"res://assets/sprites/packages/box_3.png",
	"res://assets/sprites/packages/box_4.png",
	"res://assets/sprites/packages/box_5.png",
	"res://assets/sprites/packages/box_6.png",
	"res://assets/sprites/packages/box_7.png",
	"res://assets/sprites/packages/box_8.png",
	"res://assets/sprites/packages/box_9.png",
	"res://assets/sprites/packages/box_10.png",
	"res://assets/sprites/packages/box_11.png",
	"res://assets/sprites/packages/box_12.png",
	"res://assets/sprites/packages/box_13.png",
	"res://assets/sprites/packages/box_14.png",
	"res://assets/sprites/packages/box_15.png", 
	"res://assets/sprites/packages/box_16.png",
	"res://assets/sprites/packages/box_17.png",
	"res://assets/sprites/packages/box_18.png",
	"res://assets/sprites/packages/box_19.png",
	"res://assets/sprites/packages/box_20.png",
	"res://assets/sprites/packages/box_21.png",
	"res://assets/sprites/packages/box_22.png",
	"res://assets/sprites/packages/box_23.png",
	"res://assets/sprites/packages/box_24.png"
]

var box_address_locations = [
	[Vector2(0, 0), 0],
	[Vector2(23, 47)*2, 0],
	[Vector2(49, 177)*2, -90],
	[Vector2(51, 367)*2, -90],
	[Vector2(0, 380)*2, -90],
	[Vector2(17, 232)*2, 0],
	[Vector2(211, 45)*2, 0],
	[Vector2(230, 173)*2, -90],
	[Vector2(197, 205)*2, 0],
	[Vector2(223, 270)*2, 0],
	[Vector2(4, 400)*2, 0],
	[Vector2(24, 480)*2, 0],
	[Vector2(185, 401)*2, 90],
	[Vector2(217, 466)*2, 0],
	[Vector2(196, 566)*2, -90],
]

func create_package_texture(origin, destination):
	$SubViewport/Address2/OriginName.text = NameList.get_random_name(origin)
	$SubViewport/Address2/OriginLocation.text = NameList.get_random_location(origin, true)

	$SubViewport/Address2/DestinationName.text = NameList.get_random_name(destination)
	$SubViewport/Address2/DestinationLocation.text = NameList.get_random_location(destination, true)
	
	$SubViewport/PackageTexture.texture = load(box_textures.pick_random())
	var address_transform = box_address_locations.pick_random()
	$SubViewport/Address2.position = address_transform[0]
	$SubViewport/Address2.rotation_degrees = address_transform[1]
	
	#Sets the Subviewport to render once, then waits for frame to draw
	$SubViewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	#Takes image data from viewport and makes a new imageTexture 
	#Otherwise all instance would reference the same dynamic viewport texture
	print(address_transform)
	var img : Image = $SubViewport.get_texture().get_image()
#	img.resize(384*3, 576*3, Image.INTERPOLATE_NEAREST)
	var newTexture := ImageTexture.create_from_image(img)
	return newTexture
