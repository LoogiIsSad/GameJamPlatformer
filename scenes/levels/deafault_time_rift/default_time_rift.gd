extends Level


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Parallax2D.rotation += 0.005 * delta
