extends RigidBody3D

@onready var weigh_area := $"Weigh Area"
@onready var scale_readout := $Label3D
@onready var desk := get_tree().get_first_node_in_group("desk")

var bodies_on_scale = []
var current_total_weight : float = 0
var current_visual_weight : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	weigh_area.body_entered.connect(scale_body_entered)
	weigh_area.body_exited.connect(scale_body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_scale()
	var new_scale_weight = lerpf(current_visual_weight, current_total_weight, 0.1)
	print(new_scale_weight)
	update_scale_readout(new_scale_weight)


func check_scale():
	var new_total_weight := 0.0
	for body in bodies_on_scale:
		if "is_touching_desk" in body and not body.is_touching_desk:
			if "weight" in body:
				new_total_weight += body.weight
	current_total_weight = new_total_weight

func scale_body_entered(body: Node3D):
	bodies_on_scale.append(body)
	print(str(body, " entered scale."))

func scale_body_exited(body:Node3D):
	bodies_on_scale.remove_at(bodies_on_scale.find(body))
	print(str(body, " removed from scale."))

func update_scale_readout(new_weight) -> void:
	current_visual_weight = new_weight
	new_weight = snappedf(new_weight, 0.01)
	scale_readout.text = str(new_weight, " lbs")
