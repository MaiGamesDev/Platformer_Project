extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pause(time):
	get_tree().paused = true
	await get_tree().create_timer(time, true).timeout
	get_tree().paused = false
