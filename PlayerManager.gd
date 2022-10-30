extends CharacterBody2D

var Bullet = preload("res://Bullet.tscn")

const SPEED = 100
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var gun_collision_point = Vector2(0,0)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		$Sprite.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
	

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			shoot()


func shoot():
	print("b")
	var bullet = Bullet.instantiate()
	bullet.global_position = $Sprite/Gun/ShootPos.global_position
	get_tree().root.add_child(bullet)
