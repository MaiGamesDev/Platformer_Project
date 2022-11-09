extends CharacterBody2D

var Bullet = preload("res://SCENE/Bullet.tscn")
var Coin = preload("res://SCENE/Coin.tscn")

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
	if event.is_action_pressed("shoot"):
		shoot()
	if event.is_action_pressed("use_item"):
		use_coin()


func shoot():
	var bullet = Bullet.instantiate()
	bullet.global_position = $Sprite/Gun/ShootPos.global_position
	bullet.set_velocity(null)
	get_tree().root.add_child(bullet)

func use_coin():
	var coin = Coin.instantiate()
	coin.global_position = $Sprite/ItemPos.global_position
	coin.set_velocity(null,null)
	get_tree().root.add_child(coin)
	