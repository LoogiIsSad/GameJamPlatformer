extends CanvasLayer

var speed = 0.1
var current_speed = 0.01
var cutscene_running = false

signal cutscene_end

func _process(delta):
	if cutscene_running == false: return
	
	current_speed += speed * delta
	
	$Clock/LongHand.rotation -= current_speed
	$Clock/Shorthand.rotation -= current_speed / 3


func start_cutscene():
	$AnimationPlayer.play("rift")
	$AudClick.play()
	$AudRewind.play()
	cutscene_running = true


func _on_animation_player_animation_finished(anim_name):
	$AudClick.play()
	emit_signal("cutscene_end")
