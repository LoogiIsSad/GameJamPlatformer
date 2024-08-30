extends Node2D

var volume = -20.0
var out_of_time_playing = false
var chords = 0


func _ready():
	$BarTimer.start()
	$PhraseTimer.start()
	set_volume()
	_on_phrase_timer_timeout()


func _on_phrase_timer_timeout() -> void:
	if Global.phrase >= 1 and Global.phrase < 5:
		if chords == 0: 
			$Chords1.play()
			chords = 1
		elif chords == 1:
			$Chords1a.play()
			chords == 0
	if Global.phrase >= 2 and Global.phrase < 5:
		$Bass1.play()
	if Global.phrase >= 3:
		$Drums.play()
		$DrumTimer.start()
	if Global.phrase >= 4 and Global.phrase < 5:
		$Lead1.play()
	if Global.phrase >= 5:
		if chords == 0: 
			$Chords2.play()
			chords = 1
		elif chords == 1:
			$Chords2a.play()
			chords == 0
		$Bass2.play()
		$Lead2.play()


func _on_bar_timer_timeout() -> void:
	if Global.low_time == true:
		if out_of_time_playing == false:
			$OutOfTime.play()
			out_of_time_playing = true
	elif Global.low_time == false:
		$OutOfTime.stop()
		out_of_time_playing = false


func _on_drum_timer_timeout() -> void:
	$Drums.play()


func set_volume():
	$Chords1.volume_db = volume
	$Chords1a.volume_db = volume
	$Chords2.volume_db = volume
	$Chords2a.volume_db = volume
	$Bass1.volume_db = volume
	$Bass2.volume_db = volume
	$Drums.volume_db = volume
	$Lead1.volume_db = volume
	$Lead2.volume_db = volume
	$OutOfTime.volume_db = volume
