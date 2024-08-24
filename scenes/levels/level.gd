extends Node
class_name Level

@export var cam_limits = [0, 0, 0, 0]

func _ready():
	#$Player.paused = true
	$Player.set_camera_limits(cam_limits)


func _process(delta):
	$Parallax2D.rotation += 0.00001
