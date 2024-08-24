extends CharacterBody2D


var speed = 20
var speed_limit = 300
var air_jumps = 1
var max_air_jumps = 1
var air_dashes = 1
var max_air_dashes = 1
var dash_active = false
var dash_off_cooldown = true
var rewind = false
var recording = false
var rewind_positions = []
var death_limit = 100000

func _ready():
	pass # Replace with function body.


var record_count = 0
var was_on_floor = true
func _physics_process(delta):
	if was_on_floor and !is_on_floor():
		recording = true
	
	if recording:
		rewind_positions.append(position)
	
	if position.y > death_limit and !rewind:
		rewind = true
		recording = false
		record_count = rewind_positions.size() - 1
	
	if rewind:
		print("rewinding")
		position = rewind_positions[record_count]
		print(record_count)
		record_count -= 1
		if record_count == 0:
			print("rewind_ended")
			rewind = false
			record_count = 0
		return
	
	if is_on_floor():
		air_jumps = max_air_jumps
		air_dashes = max_air_dashes
		was_on_floor = true
		recording = false
		rewind_positions = []
	velocity = calculate_velocity()
	$Camera2D.offset = $Camera2D.offset.lerp(Vector2(velocity.x / 6, 0), delta * 1)
	velocity * delta
	move_and_slide()


func calculate_velocity():
	if dash_active:
		return velocity
	
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
	
	if velocity.x > speed_limit and is_on_floor(): velocity.x -= speed * 2
	elif velocity.x < -speed_limit and is_on_floor(): velocity.x += speed * 2
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -700
		elif air_jumps > 0:
			air_jumps -= 1
			velocity.y = -500
	
	if Input.is_action_just_pressed("dash") and dash_off_cooldown:
		var x = 0
		if Input.is_action_pressed("ui_right"): x = 1
		if Input.is_action_pressed("ui_left"): x = -1
		
		if is_on_floor():
			velocity.y = 0
			velocity.x = x * 500
			dash()
		elif air_dashes > 0:
			air_dashes -= 1
			velocity.y = 0
			velocity.x = x * 500
			dash()
	
	return velocity


func dash():
	dash_active = true
	dash_off_cooldown = false
	$DashDuration.start()
	$DashCooldown.start()


func set_camera_limits(x = [0, 0, 0, 0]):
	death_limit = x[3]
	$Camera2D.limit_left = x[0]
	$Camera2D.limit_top = x[1]
	$Camera2D.limit_right = x[2]
	$Camera2D.limit_bottom = x[3]


func _on_dash_duration_timeout(): dash_active = false


func _on_dash_cooldown_timeout(): dash_off_cooldown = true
