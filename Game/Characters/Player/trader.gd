extends CharacterBody2D

var player_in_area = false
var player: Node2D
var is_chatting = false
var is_roaming = true

func _process(delta):
	if player_in_area:
		if Input.is_action_just_pressed("action"):
			run_dialogue("First")
		
func run_dialogue(dialogue_string):
	is_chatting = true
	is_roaming = false
	var layout = Dialogic.start(dialogue_string)
	layout.register_character(load("res://Game/dialogic/character/master.dch"), $".")


	
func _on_detect_dialogue_area_entered(area):
	if area.is_in_group("player"):
		player_in_area = true
		player = area.get_parent()

func _on_detect_dialogue_area_exited(area):
	if area.is_in_group("player"):
		player_in_area = false
		player = null
