extends CharacterBody2D


var speed = 20
var speed_limit = 300
var air_jumps = 1
var max_air_jumps = 1


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if is_on_floor():
		air_jumps = max_air_jumps
	velocity = calculate_velocity()
	velocity * delta
	move_and_slide()


func calculate_velocity():
	if !is_on_floor():
		velocity.y += Global.gravity
	else:
		velocity.y = 0
	if Input.is_action_pressed("ui_right"): 
		if velocity.x < speed_limit: velocity.x += speed
	elif Input.is_action_pressed("ui_left"): 
		if velocity.x > -speed_limit: velocity.x += -speed
	else:
		if velocity.x > 0: velocity.x -= speed
		elif velocity.x < 0: velocity.x += speed
	
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = -700
		elif air_jumps > 0:
			air_jumps -= 1
			velocity.y = -500
	
	return velocity


func set_camera_limits(x = [0, 0, 0, 0]):
	$Camera2D.limit_left = x[0]
	$Camera2D.limit_top = x[1]
	$Camera2D.limit_right = x[2]
	$Camera2D.limit_bottom = x[3]
