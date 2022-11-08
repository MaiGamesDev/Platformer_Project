extends RigidBody2D

var default_velocity = 500.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_velocity(speed):
	if speed == null:
		speed = default_velocity
	linear_velocity.x = speed
	
func ricochet():
	queue_free()
