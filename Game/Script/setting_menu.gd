extends Control

func _ready():
	pass

func _process(delta):
	volume_update()
	
func volume_update():
	var MusicVolume = $Music
	var FXvolume = $FX
	$"../Background".volume_db = MusicVolume.value

func _on_back_pressed():
	$".".visible = false
