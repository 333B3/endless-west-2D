extends GutTest

var BanditScene = preload("res://Game/Characters/enemy/bandit.tscn") 
var bandit

func before_each():
	bandit = BanditScene.instantiate()
	add_child(bandit)
	await get_tree().process_frame

func after_each():
	if is_instance_valid(bandit):
		bandit.queue_free()
	await get_tree().process_frame


func test_bandit_enters_player_area():
	var area = Area2D.new()
	area.add_to_group("player")

	var player = Node2D.new()
	player.add_child(area)
	add_child(player)

	bandit._on_detector_area_entered(area)

	assert_true(bandit.player_in_area, "Bandit повинен вважати, що гравець поруч")
	assert_eq(bandit.player, player, "Bandit має зберігати посилання на гравця")


func test_bandit_exits_player_area():
	var area = Area2D.new()
	area.add_to_group("player")

	var player = Node2D.new()
	player.add_child(area)
	add_child(player)

	bandit._on_detector_area_entered(area)
	bandit._on_detector_area_exited(area)

	assert_false(bandit.player_in_area, "Bandit повинен вважати, що гравець пішов")
	assert_eq(bandit.player, null, "Bandit має очищати посилання на гравця")


func test_bandit_takes_damage_and_dies():
	bandit.health = 50

	bandit.take_damage(50)
	await get_tree().create_timer(0.7).timeout  # чекаємо анімацію пошкодження

	assert_true(bandit.dead, "Bandit повинен бути мертвим при 0 HP")
	assert_eq(bandit.speed, 0, "Швидкість має бути 0 після смерті")


func test_bandit_does_not_die_from_small_damage():
	bandit.health = 100

	bandit.take_damage(30)
	await get_tree().create_timer(0.7).timeout

	assert_false(bandit.dead, "Bandit не повинен померти при HP > 0")
	assert_eq(bandit.health, 70, "HP повинен зменшитися на 30")


func test_bandit_detects_hit_player():
	var area = Area2D.new()
	area.add_to_group("player")

	bandit._on_hit_area_entered(area)
	assert_true(bandit.hit_player, "Bandit повинен активувати атаку")

	bandit._on_hit_area_exited(area)
	assert_false(bandit.hit_player, "Bandit повинен деактивувати атаку після виходу гравця")
