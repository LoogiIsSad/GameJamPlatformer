extends CanvasLayer

func start():
	var tween = create_tween()
	tween.tween_property($Shader, "color:a", 1.0, 10.0)
	tween.tween_property($Shader/ColorRect, "modulate:a", 1.0, 9.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
