extends RigidBody3D

@export var weight :float= 0.0

var is_touching_desk := false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.body_entered.connect(on_body_entered)
	self.body_exited.connect(on_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_body_entered(body: Node):
	if body.is_in_group("desk"):
		is_touching_desk = true
		print("touch desk")

func on_body_exited(body:Node):
	if body.is_in_group("desk"):
		is_touching_desk = false
		print("no touch")
