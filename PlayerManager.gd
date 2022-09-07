extends KinematicBody2D

var move_speed = 100
var pulse_power = 100
var knockback_speed = 0
var gravity = 50
var max_fall_speed = 500
var fall_speed = gravity

var move_vec = Vector2(0,0)

var gun_collision_point = Vector2(0,0)

func _physics_process(delta):
	if is_on_floor():
		fall_speed = gravity
		move()
	else:
		fall()

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			shoot()

func move():
	if Input.is_action_pressed("move_left"):
		move_vec.x = -1
		$Sprite.scale.x = -2
	elif Input.is_action_pressed("move_right"):
		move_vec.x = 1
		$Sprite.scale.x = 2
	
	var velocity = move_vec * move_speed
	move_and_slide(velocity,Vector2.UP)
	
	move_vec = Vector2(0,0)

func fall():
	fall_speed = clamp(fall_speed * 1.1, 0, max_fall_speed)
	move_and_slide(Vector2(0,fall_speed),Vector2.UP)
	

	
func shoot():
	pass
