extends RigidBody2D

var default_linear = Vector2(150,-300)
var default_angular = 10.0

func _ready():
	pass

func _process(delta):
	pass
	
func set_velocity(linearv,angular):
	if linearv == null :
		linearv = default_linear
	if angular == null:
		angular = default_angular
		
	linear_velocity = linearv
	angular_velocity = angular
	
	
func _on_hitbox_body_entered(body):
	body.ricochet()
