extends RigidBody2D

var default_velocity = 250.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var effect = AnimatedSprite2D.new()
	effect.frames = load("res://BulletEffect.tres")
	effect.global_position = global_position
	effect.playing = true
	effect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	get_tree().root.call_deferred("add_child",effect)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_velocity(speed,dir):
	if speed == null:
		speed = default_velocity
	linear_velocity.x = speed * dir
	
	
func ricochet():
	Global.pause(0.1)
