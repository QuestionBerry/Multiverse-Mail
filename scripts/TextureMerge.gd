class_name PackageTexture
extends Node2D


func get_package_texture():
#	$SubViewport.get_texture().get_image().save_png("user://TEST_TEXTURE.png")
	return $SubViewport.get_texture()
