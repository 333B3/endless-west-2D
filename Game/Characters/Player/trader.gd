extends CharacterBody2D

var player_in_area = false
var player: Node2D
var is_chatting = false
var is_roaming = true

#func _process(delta):
	#if player_in_area:
		#if Input.is_action_just_pressed("action"):
			#run_dialogue("timeline")

func _on_speak_area_entered(area):
	if area.is_in_group("player"):
		player_in_area = true
		player = area.get_parent()



func _on_speak_area_exited(area):
	if area.is_in_group("player"):
		player_in_area = false
		player = null
		
#func run_dialogue(dialogue_string):
	#is_chatting = true
	#is_roaming = false
	##Dialogic.start(dialogue_string)
