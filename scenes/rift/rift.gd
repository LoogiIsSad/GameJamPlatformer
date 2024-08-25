extends Node2D

signal player_entered_rift
@export var next_scene = ""
@export var active = false

func _ready():
	set_status()


func set_status():
	$Area2D.monitoring = active
	$Pngegg.visible = active
	$Grey.visible = !active


func _process(delta):
	$Pngegg.rotation += 0.3 * delta
	set_status()


func _on_area_2d_area_entered(area):
	$EnterRift.start_cutscene()
	var player = area.get_parent()
	player.get_node("CanvasLayer").visible = true
	emit_signal("player_entered_rift")
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(player, "position", self.position, 2.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(player, "modulate:a", 0.0, 2.5)


func _on_enter_rift_cutscene_end():
	print(get_tree().change_scene_to_file(next_scene))
