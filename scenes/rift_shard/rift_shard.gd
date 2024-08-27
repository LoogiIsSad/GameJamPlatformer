extends Node2D

signal collected
signal shard_ready
var rng = RandomNumberGenerator.new()
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
	rng.randomize()
	$AudioStreamPlayer2D.pitch_scale = rng.randf_range(1.0, 1.3)
	$AudioStreamPlayer2D.play()
	$Area2D.queue_free()
	$RiftShard.visible = false
	$CPUParticles2D.emitting = true
	$CPUParticles2D2.emitting = true
	$CPUParticles2D3.emitting = true
	$Timer.start()


func _on_timer_timeout():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.5)
	tween.tween_callback(queue_free)
