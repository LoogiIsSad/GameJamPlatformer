extends Node2D

var speed = 0.0005
var current_speed = 0.01

signal cutscene_end

func _ready():
	$AnimationPlayer.play("rift")


func _process(delta):
	current_speed += speed
	
	$Clock/LongHand.rotation -= current_speed
	$Clock/Shorthand.rotation -= current_speed / 3


func _on_animation_player_animation_finished(anim_name):
	emit_signal("cutscene_end")
