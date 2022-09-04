extends Line2D
class_name Bullet

var to_point = Vector2(100,0)

func _ready():
	points[0] = Vector2.ZERO
	points[1] = to_point
