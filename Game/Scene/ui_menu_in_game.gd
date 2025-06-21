extends Control

@onready var walk_sound = get_tree().get_first_node_in_group("PlayerGroup").get_node("WalkSound")
@onready var run_sound = get_tree().get_first_node_in_group("PlayerGroup").get_node("RunSound")
@onready var shoot_sound = get_tree().get_first_node_in_group("PlayerGroup").get_node("ShootSound")
@onready var music_sound = get_tree().get_first_node_in_group("PlayerGroup").get_node("Music")
@onready var hit_tree_sound = get_tree().get_first_node_in_group("PlayerGroup").get_node("tree_hit")
@onready var crash_tree_sound = get_tree().get_first_node_in_group("TreeGroup").get_node("tree_crash")
#@onready var hit_sound = get_tree().get_first_node_in_group("EnemyGroup").get_node("hit2")


func _process(delta):
	CheckESC()
	update_volume()

func update_volume():
	var Music = $TextureRect/Music
	var Walk = $TextureRect/Walk
	var Shoot = $TextureRect/Shoot
	var FX = $TextureRect/FX
	
	walk_sound.volume_db = Walk.value
	run_sound.volume_db = Walk.value
	shoot_sound.volume_db = Shoot.value
	music_sound.volume_db = Music.value
	hit_tree_sound.volume_db = FX.value
	crash_tree_sound.volume_db = FX.value
	#hit_sound.volume_db = FX.value
	

func resume():
	get_tree().paused = false
	$".".visible = false
	$TextureRect.visible = false

func pause():
	$".".visible = true
	get_tree().paused = true

func CheckESC():
	if Input.is_action_just_pressed("esc"):
		if !get_tree().paused:
			pause()
		else:

			resume()

func _on_resume_pressed():
	resume()

func _on_main_menu_pressed():
	var mainMenu = load("res://Game/Menu_Buttons/menu.tscn")
	get_tree().change_scene_to_packed(mainMenu)

func _on_setting_pressed():
	$TextureRect.visible = true

func _on_save_pressed():
	pass # Replace with function body.

func _on_load_pressed():
	pass # Replace with function body.


func _on_back_in_game_setting_pressed():
	$TextureRect.visible = false
