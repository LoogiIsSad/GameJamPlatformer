extends CanvasLayer

@export var text = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = text
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($TextureRect, "modulate:a", 1.0, 1.0)
	tween.tween_property($Label, "modulate:a", 1.0, 1.0)
	tween.set_parallel(false)
	tween.tween_callback($Timer.start)


func _on_timer_timeout():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($TextureRect, "modulate:a", 0.0, 1.0)
	tween.tween_property($Label, "modulate:a", 0.0, 1.0)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)
