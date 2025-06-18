extends GutTest
class_name trader

var traderScene = preload("res://Game/Characters/Player/trader.tscn")
var npc

func before_each():
	npc = traderScene.instantiate()
	add_child(npc)
	await get_tree().process_frame

func after_each():
	npc.queue_free()

func test_player_enters_area():
	var area = Area2D.new()
	area.add_to_group("player")
	var player_node = Node2D.new()
	player_node.add_child(area)
	add_child(player_node)

	npc._on_detect_dialogue_area_entered(area)

	assert_true(npc.player_in_area, "Гравець має бути в зоні")
	assert_eq(npc.player, player_node, "NPC має зберегти посилання на гравця")

func test_player_exits_area():
	var area = Area2D.new()
	area.add_to_group("player")
	var player_node = Node2D.new()
	player_node.add_child(area)
	add_child(player_node)

	npc._on_detect_dialogue_area_entered(area)
	npc._on_detect_dialogue_area_exited(area)

	assert_false(npc.player_in_area, "Гравець має бути поза зоною")
	assert_eq(npc.player, null, "NPC має очистити посилання на гравця")
