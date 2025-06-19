extends GutTest

var TreeScene = preload("res://Game/Scene/Tree.tscn")
var tree

func before_each():
	tree = TreeScene.instantiate()
	add_child(tree)
	await get_tree().process_frame

func after_each():
	tree.queue_free()

func test_initial_health():
	assert_eq(tree.health, 4, "Дерево має початкове здоров'я 4")

func test_hit_decreases_health():
	tree.hit()
	assert_eq(tree.health, 3, "Здоров’я має зменшитись до 3 після удару")

func test_tree_dies_when_health_zero():
	tree.health = 1
	tree.hit()
	assert_eq(tree.health, 0, "Здоров’я має бути 0 після останнього удару")


func test_drop_items_when_dies():
	tree.item_scene = preload("res://Game/Scene/Tree.tscn") 

	var original_children = get_tree().current_scene.get_child_count()
	tree.die()
	var new_children = get_tree().current_scene.get_child_count()
	assert_true(new_children > original_children, "Після смерті дерево повинно дропати предмет")

func test_player_enters_and_exits_area():
	var player = Area2D.new()
	player.name = "TestPlayer"
	player.add_to_group("player")

	tree._on_destruction_area_entered(player)
	assert_true(tree.player_in_area, "Гравець увійшов у зону — має бути true")

	tree._on_destruction_area_exited(player)
	assert_false(tree.player_in_area, "Гравець покинув зону — має бути false")

func test_no_drop_when_no_item_scene():
	tree.item_scene = null

func test_animation_logic_in_process():
	tree.health = 4
	tree._process(0.016)
	assert_eq(tree.animated_sprite.animation, "idle", "Здоров’я = 4 -> idle")

	tree.health = 3
	tree._process(0.016)
	assert_eq(tree.animated_sprite.animation, "hit", "Здоров’я = 3 -> hit")

	tree.health = 0
	tree.is_animating = false
	tree._process(0.016)
	assert_eq(tree.animated_sprite.animation, "down", "Здоров’я = 0 -> down")
