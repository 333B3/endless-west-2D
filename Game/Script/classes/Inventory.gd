extends Node

class_name Inventory

signal item_added(item)  # Сигнал, який викликається при додаванні предмета

@export var Item: Dictionary = {}
@export var slotcount: int = 20

func add_item(item: Item):
	for i in Item.keys():
		if Item[i]["item"].ItemName == item.ItemName:
			Item[i]["count"] += 1
			emit_signal("item_added", item)  # Викликаємо сигнал
			return
	
	for i in range(slotcount):
		if not Item.has(i):
			Item[i] = {"item": item, "count": 1}
			emit_signal("item_added", item)  # Викликаємо сигнал
			return

func remove_item(item: Item):
	for key in Item.keys():
		if Item[key]["item"] == item:
			Item[key]["count"] -= 1
			if Item[key]["count"] <= 0:
				Item.erase(key)
			break

func has_item(item: Item) -> bool:
	for key in Item.keys():
		if Item[key]["item"] == item:
			return true
	return false
