extends CharacterBody2D

var Bullet = preload("res://SCENE/Bullet.tscn")
var Coin = preload("res://SCENE/Coin.tscn")

const SPEED = 4
const JUMP_VELOCITY = -200.0
const MAX_SPEED = 100
const DECEL_SPEED = 6
const MAX_FALL_SPEED = 200
const WALL_JUMP_SPEED = 200

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var gun_collision_point = Vector2(0,0)

var STATE = "idle"
var stateOld = STATE

var dir = 1


func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()
	if event.is_action_pressed("use_item"):
		use_coin()
	if event.is_action_pressed("dash"):
		dash()

func _physics_process(delta):
	move(delta)
	
func _process(delta):
	initialize_variable()
	
	manage_STATE()
	
	# AFTER
	if STATE != stateOld:
		print(STATE)
		set_animation()	
	
func initialize_variable():
	dir = sign($Sprite.scale.x)
	stateOld = STATE	
	
func move(delta):
	# Add the gravity.
	if not is_on_floor() and not is_on_wall() and is_gravitable():
		velocity.y += gravity * delta
	if not is_on_floor() and is_on_wall() and is_gravitable():
		velocity.y += gravity * delta
		
	# Set max y velocity.
	velocity.y = clamp(velocity.y, -10000 , MAX_FALL_SPEED)
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and is_controllable():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("ui_accept") and is_on_wall() and is_controllable():
		velocity.y = JUMP_VELOCITY
		velocity.x = -dir * WALL_JUMP_SPEED
		


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = 0
	if is_controllable():
		direction = Input.get_axis("move_left", "move_right")
		
	if direction:
		var decel = (int((sign(velocity.x) != sign(direction))) * DECEL_SPEED * direction) 
		var velocity_fm = velocity.x + direction * SPEED + decel
		velocity.x = clamp(velocity_fm,-MAX_SPEED,MAX_SPEED)
		$Sprite.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, DECEL_SPEED)
		
	move_and_slide()
	
func dash():
	STATE = "dash"
	set_animation()
	
	velocity.x = MAX_SPEED * 2 * dir
	velocity.y = 0
	

func shoot():
	var bullet = Bullet.instantiate()
	bullet.global_position = $Sprite/Gun/ShootPos.global_position
	bullet.set_velocity(null, dir)
	get_tree().root.add_child(bullet)

func use_coin():
	var coin = Coin.instantiate()
	coin.global_position = $Sprite/ItemPos.global_position
	coin.set_velocity(null,null,dir)
	get_tree().root.add_child(coin)
	
func manage_STATE():
	
	# Gravity STATE
	if not is_on_floor() and is_gravitable():
		if velocity.y > 0:
			# fall
			STATE = "fall"
		elif velocity.y < 0:
			# jump
			STATE = "jump"
			
	# Velocity STATE
	if is_on_floor() and is_controllable():
		if velocity.x == 0:
			# idle
			STATE = "idle"
		else:
			# walk
			STATE = "walk"
	
	# wall STATE
	if not is_on_floor() and is_on_wall():
		# wall_grab
		STATE = "wall_grab"
		
	
	if not is_controllable():
		if STATE == "dash" and abs(velocity.x) < 30:
			STATE = "" 
		
func set_animation():
	$Sprite.animation = STATE
	
func is_controllable():
	var uncontrollable_state = ["dash"]
	for i in uncontrollable_state.size():
		if STATE == uncontrollable_state[i]:
			return false
	return true
	
func is_gravitable():
	var ungravitable_state = ["dash"]
	for i in ungravitable_state.size():
		if STATE == ungravitable_state[i]:
			return false
	return true
	
