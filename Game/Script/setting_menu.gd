extends Control

func _ready():
	$CanvasLayer/AnimationPlayer.play("fade")
	await get_tree().create_timer(0.3).timeout
	$CanvasLayer.visible = false
	pass

func _process(delta):
	
	volume_update()
	
func volume_update():
	var MusicVolume = $Music
	var FXvolume = $FX
	$"../Background".volume_db = MusicVolume.value

func _on_back_pressed():
	$".".visible = false
