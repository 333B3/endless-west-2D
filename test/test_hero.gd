extends GutTest

var Hero = preload("res://unit_testing/hero.gd")
var hero = Hero

func before_each():
	hero = Hero.new()
	add_child(hero)
	await get_tree().process_frame

func after_each():
	hero.queue_free()
	
func test_starting_health():
	assert_eq(hero.health, hero.max_health, "player start with full health")
