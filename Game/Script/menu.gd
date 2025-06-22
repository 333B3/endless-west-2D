extends Control

func _ready():
	var mainLoc = load("res://Game/Main_Map/main_loc.tscn")
	var Setting_menu = load("res://Game/Scene/Setting_menu.tscn")
	$FadeScreen.visible = false

func _on_new_pressed():
	$FadeScreen.visible = true
	$FadeScreen/AnimationPlayer.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	$FadeScreen.visible = false
	var mainLoc = load("res://Game/Main_Map/main_loc.tscn")
	get_tree().change_scene_to_packed(mainLoc)


func _on_setting_pressed():
	$FadeScreen.visible = true
	$FadeScreen/AnimationPlayer.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	$FadeScreen.visible = false
	$Control.visible = true


func _on_exit_pressed():
	get_tree().quit()


func _on_button_pressed():
	$ColorRect.visible = false
	$CanvasLayer11.visible = false


func _on_about_pressed():
	$ColorRect.visible = true


func _on_help_pressed():
	$CanvasLayer11.visible = true
