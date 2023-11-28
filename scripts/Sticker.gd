extends Area3D
class_name Sticker

const RAY_LENGTH = 100

@onready var camera : Camera3D = get_tree().get_first_node_in_group("camera")

enum types {WEIGHT, DESTINATION, FRAGILE, EXPEDITED}
var type = types.WEIGHT

var is_dragging := false
var target = null
var label_text = "0.0lbs"
var weight : float
var destination : NameList.universe

var previous_position : Vector3
var previous_rotation

var sounds = [
	"res://assets/audio/SFX/sticker slap 1.wav",
	"res://assets/audio/SFX/sticker slap 2.wav",
	"res://assets/audio/SFX/sticker slap 3.wav",
	"res://assets/audio/SFX/sticker slap 4.wav"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	input_event.connect(on_input_event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_released("move_object") and is_dragging:
		is_dragging = false
		if target: #Sticker is stuck to surface
			var prev_transform = self.global_transform
			get_parent().has_sticker = false
			
			if type != types.WEIGHT:
				get_parent().create_sticker()
			
			get_parent().remove_child(self)
			target.add_child(self)
			self.global_transform = prev_transform
			$AudioStreamPlayer3D.stream = load(sounds.pick_random())
			$AudioStreamPlayer3D.play()
			#Add layering so new sticker renders in front of old
			if "sticker_offset" in target:
				$CollisionShape3D2/Sticker2.sorting_offset = target.sticker_offset + 1
				if type == types.WEIGHT:
					$CollisionShape3D2/Label3D.sorting_offset = target.sticker_offset + 2
				target.sticker_offset += 2
			#Disable Input
			input_ray_pickable = false
			set_process(false)
		else:
			self.position = previous_position
			self.rotation = previous_rotation
	
	if is_dragging:
		var mouse_position = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_position)
		var to = from + camera.project_ray_normal(mouse_position) * RAY_LENGTH
		
		var result = ObjectInteractor.raycast(from, to, [self])
		if result:
			if result.collider.is_in_group("package") or result.collider.is_in_group("desk"):
				target = result.collider
			else:
				target = null
			
			if result.normal.y > 0.99999 or result.normal == Vector3.UP:
				self.rotation_degrees = Vector3(90,0, 180)
				self.global_position = result.position
			else:
				self.look_at_from_position(result.position, result.position+result.normal)
		else:
			target = null

func on_input_event(_camera, event: InputEvent, _position, _normal, _shape_idx):
	if event.is_action_pressed("move_object"):
		is_dragging = true
		previous_position = self.position
		previous_rotation = self.rotation
		#Rendering offset so sticker renders in front of others on surface
		$CollisionShape3D2/Sticker2.sorting_offset = 99
		if type == types.WEIGHT:
			$CollisionShape3D2/Label3D.sorting_offset = 100

func print_out(scale_weight: float)->void:
	$CollisionShape3D2/Label3D.text = str(scale_weight, "lbs")
	self.weight = scale_weight
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector3.BACK * 0.5, 0.5).as_relative()
	tween.tween_property(self, "position", Vector3.FORWARD * 0.2, 0.2).as_relative()
	await tween.tween_property(self,"position", Vector3.BACK * 0.5 , 0.5).as_relative().finished
	self.input_ray_pickable = true
