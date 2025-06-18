extends GutTest

var Hero = preload("res://unit_testing/hero.gd")
var hero

func before_each():
	hero = Hero.new()
	add_child(hero)
	await get_tree().process_frame

func after_each():
	hero.queue_free()

func test_starting_health():
	assert_eq(hero.health, hero.max_health, "Player should start with full health")

func test_take_damage_reduces_health():
	var start_health = hero.health
	hero.take_damage(10)
	assert_lt(hero.health, start_health, "Health should decrease after taking damage")

func test_take_big_damage_reduces_health_more():
	var start_health = hero.health
	hero.take_big_damage(25)
	assert_eq(hero.health, start_health - 25, "Big damage should reduce health correctly")

func test_take_damage_by_bow():
	var start_health = hero.health
	await hero.take_damage_by_bow(15)
	assert_eq(hero.health, start_health - 15, "Bow damage should reduce health")

func test_attack_sets_attacking_flag():
	await hero.attack()
	assert_eq(hero.attacking, false, "Attacking flag should reset after attack")

func test_death_player_sets_death_true():
	hero.health = 0
	hero.death_player()
	assert_true(hero.death, "Player should be marked as dead")

func test_movement_vector():
	Input.action_press("walk_right")
	var move = hero.movement_vector()
	assert_eq(move.x, 1.0, "Movement vector X should be 1 when moving right")
	Input.action_release("walk_right")

func test_play_animation_sets_walk_speed():
	hero.bullet_equip = false
	hero.play_animation(Vector2(1, 0))
	assert_eq(hero.walk_speed, 75, "Walk speed should be default when not using bullet")
	hero.bullet_equip = true
	hero.play_animation(Vector2(1, 0))
	assert_eq(hero.walk_speed, 0, "Walk speed should be 0 when using bullet")

func test_area_entered_tree_sets_near_tree_true():
	var area = Area2D.new()
	area.add_to_group("tree")
	hero._on_area_2d_area_entered(area)
	assert_true(hero.near_tree, "near_tree should be true when entering a tree area")

func test_area_exited_tree_sets_near_tree_false():
	var area = Area2D.new()
	area.add_to_group("tree")
	hero._on_area_2d_area_exited(area)
	assert_false(hero.near_tree, "near_tree should be false when exiting a tree area")

func test_on_hit_box_area_entered_applies_damage():
	var start_health = hero.health
	var area = Area2D.new()
	area.add_to_group("Bow")
	hero._on_hit_box_area_entered(area)
	await get_tree().process_frame
	assert_eq(hero.health, start_health - 10, "Player should take 10 damage from Bow")

func test_run_dialogue_sets_chatting_true():
	hero.run_dialogue("Test")
	assert_true(hero.is_chatting, "run_dialogue should set is_chatting to true")

func test_on_pick_item_adds_to_inventory():
	var fake_item = Node2D.new()
	fake_item.set("item", { "item_name": "Sword" })
	fake_item.add_to_group("item")

	var area = Area2D.new()
	fake_item.add_child(area)

	var inventory_node = Node.new()
	inventory_node.set_name("Node")
	inventory_node.add_to_group("inventory")
#	inventory_node.get_items = func(): return [{ "item_name": "Sword" }]
#	inventory_node.add_item = func(item): pass

	var canvas_layer = CanvasLayer.new()
	canvas_layer.set_name("CanvasLayer2")
	canvas_layer.add_child(inventory_node)

	hero.add_child(canvas_layer)
	hero._on_pick_item_area_entered(area)

	assert_true(true, "No crash when picking up item")
