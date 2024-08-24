extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_rift_player_entered_rift():
	var cutscene = load("res://scenes/surface/enter_rift/enter_rift.tscn").instantiate()
	cutscene.position = Vector2(320, 320)
	cutscene.cutscene_end.connect(_on_enter_rift_cutscene_end)
	add_child(cutscene)


func _on_enter_rift_cutscene_end():
	get_tree().change_scene_to_file("res://scenes/levels/tutorial_rift/tutorial_rift.tscn")
