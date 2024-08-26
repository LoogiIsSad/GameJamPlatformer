extends CharacterBody2D


var speed = 20
var speed_limit = 300
var air_jumps = 1
var max_air_jumps = 1
var air_dashes = 1
var max_air_dashes = 1
var dash_active = false
var dash_off_cooldown = true
var rewinding = false
var recording = false
var rewind_positions = []
var ground_positions = []
var death_limit = 800
var spawning = true
var coyote_time = false

func _ready():
	$CanvasLayer.visible = true
	var tween = create_tween()
	tween.tween_property($CanvasLayer/CanvasModulate, "color:a", 0.0, 2.0)
	tween.tween_callback(func():
		spawning = false
		$CanvasLayer.visible = false
		$CanvasLayer/ColorRect.visible = false
		$CanvasLayer/CanvasModulate.color.a = 1.0
		$SpriteCanvasLayer/SprPause.visible = false
		$SpriteCanvasLayer/SprPlay.visible = true
		$SpriteCanvasLayer/Timer.start())


var record_count = 0
var was_on_floor = true
func _physics_process(delta):
	if spawning == true: return
	
	if was_on_floor and !rewinding and (!is_on_floor() or get_floor_angle() != 0):
		recording = true
		rewind_positions = ground_positions
		was_on_floor = false
		$CoyoteTimer.stop()
		$CoyoteTimer.wait_time = 0.15
		$CoyoteTimer.start()
		coyote_time = true
	if recording:
		rewind_positions.append(position)
	
	if position.y > death_limit and !rewinding: rewind("start")
	
	
	if rewinding and !rewind_positions.is_empty():
		position = rewind_positions[record_count]
		record_count -= 1
		if record_count == 0:
			rewind("stop")
			record_count = 0
		return
	
	if is_on_floor():
		ground_positions.append(position)
		if ground_positions.size() > 10:
			ground_positions.reverse()
			ground_positions.resize(10)
			ground_positions.reverse()
		air_jumps = max_air_jumps
		air_dashes = max_air_dashes
		was_on_floor = true
		
		if get_floor_angle() == 0:
			recording = false
			rewind_positions = []
	
	velocity = calculate_velocity()
	play_animation()
	$Camera2D.offset = $Camera2D.offset.lerp(Vector2(velocity.x / 6, 0), delta * 1)
	velocity * delta
	move_and_slide()


func play_animation():
	if !is_on_floor():
		$AnimationPlayer.stop()
		$Sprite2D.frame = 5
		return
	
	if Input.is_action_pressed("ui_right"):
		$AnimationPlayer.play("run")
		$Sprite2D.scale.x = 1
	elif Input.is_action_pressed("ui_left"):
		$AnimationPlayer.play("run")
		$Sprite2D.scale.x = -1
	else:
		$AnimationPlayer.stop()
		$Sprite2D.frame = 0
	
func rewind(x = "start"):
	if x == "start":
		rewinding = true
		recording = false
		$CanvasLayer.visible = true
		record_count = rewind_positions.size() - 1
		$SpriteCanvasLayer/SprRewind.visible = true
	
	if x == "stop":
		rewinding = false
		recording = false
		$CanvasLayer.visible = false
		if get_floor_angle() == 0: rewind_positions = []
		velocity = Vector2.ZERO
		$SpriteCanvasLayer/SprRewind.visible = false


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
		if is_on_floor() or coyote_time == true:
			velocity.y = -700
		elif air_jumps > 0:
			air_jumps -= 1
			velocity.y = -500
	
	if Input.is_action_just_pressed("dash") and dash_off_cooldown:
		var x = 0
		if Input.is_action_pressed("ui_right"): x = 1
		if Input.is_action_pressed("ui_left"): x = -1
		
		if is_on_floor() and x != 0:
			velocity.y = 0
			velocity.x = x * 500
			dash()
		elif air_dashes > 0 and x != 0:
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
	death_limit = x[3] + 160
	$Camera2D.limit_left = x[0]
	$Camera2D.limit_top = x[1]
	$Camera2D.limit_right = x[2]
	$Camera2D.limit_bottom = x[3]


func _on_dash_duration_timeout(): dash_active = false


func _on_dash_cooldown_timeout(): dash_off_cooldown = true


func _on_timer_timeout():
	$SpriteCanvasLayer/SprPlay.visible = false


func _on_coyote_timer_timeout():
	coyote_time = false
