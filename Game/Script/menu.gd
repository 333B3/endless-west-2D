extends Control

func _ready():
	var mainLoc = load("res://Game/Main_Map/main_loc.tscn")
	var Setting_menu = load("res://Game/Scene/Setting_menu.tscn")
	music_fx_start()
	
func _process(delta):
	pass

func music_fx_start():
	$background_music.play()
	
func music_fx_stop():
	$background_music.stop()
func _on_new_pressed():
	var mainLoc = load("res://Game/Main_Map/main_loc.tscn")
	get_tree().change_scene_to_packed(mainLoc)


func _on_setting_pressed():
	var Setting_menu = load("res://Game/Scene/Setting_menu.tscn")
	get_tree().change_scene_to_packed(Setting_menu)


func _on_exit_pressed():
	get_tree().quit()
