extends RigidBody2D

var default_velocity = 350.0
signal _pause_effect

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/Game").pause.connect(_pause_effect)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_velocity(speed):
	if speed == null:
		speed = default_velocity
	linear_velocity.x = speed
	
func ricochet():
	get_tree().paused = true
	await get_tree().create_timer(1, false).timeout
	get_tree().paused = false
	queue_free()
