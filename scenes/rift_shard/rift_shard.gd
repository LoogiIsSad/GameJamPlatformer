extends Node2D

signal collected
signal shard_ready
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("shard_ready", Callable(get_parent(), "on_rift_shard_ready"))
	emit_signal("shard_ready")
	connect("collected", Callable(get_parent(), "on_rift_shard_collected"))


func _on_area_2d_area_entered(area):
	var player
	if area.get_parent().name == "Player":
		player = area.get_parent()
	else:
		return
	
	emit_signal("collected")
	queue_free()
