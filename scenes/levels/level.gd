extends Node
class_name Level

@export var cam_limits = [0, 0, 0, 0] # left, top, right, bottom
@export var time_limit = 1.0
@export var phrase = 0
var rift_shards_total = 0
var rift_shards_collected = 0
var rift_label
var timer

func _init():
	rift_label = load("res://scenes/rift_counter/rift_counter.tscn").instantiate()
	add_child(rift_label)


func _ready():
	Global.phrase = phrase
	Global.low_time = false
	#$Player.paused = true
	$Player.set_camera_limits(cam_limits)
	start_timer()


func connect_rift(): 
	$Rift.connect("player_entered_rift", on_player_entered_rift)

func start_timer():
	
	if time_limit <= 0:
		return
	
	var effect_timer = Timer.new()
	timer = Timer.new()
	var x = time_limit - 20.0
	if x < 0.0: x = 0.0
	
	effect_timer.wait_time = x
	timer.wait_time = time_limit
	add_child(timer)
	add_child(effect_timer)
	effect_timer.connect("timeout", _on_effect_timer_timeout)
	effect_timer.start()
	timer.connect("timeout", _on_timer_timeout)
	timer.start()


func _on_effect_timer_timeout():
	var x = load("res://scenes/out_of_time/out_of_time.tscn").instantiate()
	Global.low_time = true
	add_child(x)
	x.start()


func _on_timer_timeout():
	if Global.finished:
		get_tree().change_scene_to_file("res://scenes/levels/new_beginning/new_beginning.tscn")
		return
	
	get_tree().change_scene_to_file("res://scenes/surface/Surface.tscn")


func on_rift_shard_ready():
	rift_shards_total += 1
	rift_label.get_node("Label").text = str(rift_shards_collected) + " / " + str(rift_shards_total)
	print(rift_shards_total)


func on_rift_shard_collected():
	rift_shards_collected += 1
	print(str(rift_shards_collected) + "/" + str(rift_shards_total))
	rift_label.get_node("Label").text  = str(rift_shards_collected) + " / " + str(rift_shards_total)
	check_rift_shards()


func check_rift_shards():
	if rift_shards_collected < rift_shards_total: return
	
	activate()
	$Rift.active = true


func activate():
	$Rift.active = true

func on_player_entered_rift():
	timer.stop()
	var time_taken = time_limit - timer.time_left()
	print(time_taken)
