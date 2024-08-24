extends Node2D

signal player_entered_rift

func _process(delta):
	rotation += 0.01


func _on_area_2d_area_entered(area):
	emit_signal("player_entered_rift")
