extends CharacterBody2D

var Bullet = preload("res://SCENE/Bullet.tscn")
var Coin = preload("res://SCENE/Coin.tscn")

const SPEED = 4
const JUMP_VELOCITY = -200.0
const MAX_SPEED = 100
const DECEL_SPEED = 6


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var gun_collision_point = Vector2(0,0)

var STATE = "idle"
var stateOld = STATE


func _physics_process(delta):
	if STATE != "dash":
		move(delta)
	
func _process(delta):
	
	stateOld = STATE
	
	manage_STATE()
	
	#AFTER
	if STATE != stateOld:
		print(STATE)
		set_animation()	
	
	
func move(delta):
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
		var velocity_fm = velocity.x + direction * SPEED + (int((sign(velocity.x) != sign(direction))) * DECEL_SPEED * direction) 
		velocity.x = clamp(velocity_fm,-MAX_SPEED,MAX_SPEED)
		$Sprite.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, DECEL_SPEED)
		
	move_and_slide()
	
func dash():
	STATE = "dash"
	var dir = sign($Sprite.scale.x) 
	velocity.x = MAX_SPEED * 2 * dir
	move_and_slide()
	
func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()
	if event.is_action_pressed("use_item"):
		use_coin()
	if event.is_action_pressed("dash"):
		dash()

func shoot():
	var dir = sign($Sprite.scale.x)
	var bullet = Bullet.instantiate()
	bullet.global_position = $Sprite/Gun/ShootPos.global_position
	bullet.set_velocity(null, dir)
	get_tree().root.add_child(bullet)

func use_coin():
	var dir = sign($Sprite.scale.x)
	var coin = Coin.instantiate()
	coin.global_position = $Sprite/ItemPos.global_position
	coin.set_velocity(null,null,dir)
	get_tree().root.add_child(coin)
	
func manage_STATE():
	# velocity animation
	if not is_on_floor():
		if velocity.y > 0:
			#fall
			STATE = "fall"
		elif velocity.y < 0:
			#jump
			STATE = "jump"
	else:
		if velocity.x == 0:
			#idle
			STATE = "idle"
		else:
			#walk
			STATE = "walk"
		
func set_animation():
	$Sprite.animation = STATE
