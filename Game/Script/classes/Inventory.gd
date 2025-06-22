extends Node
class_name Inventory

signal item_added(item)

@export var Item: Dictionary = {}
@export var slotcount: int = 20

func add_item(item: Item):
	for i in Item.keys():
		if Item[i]["item"].item_name == item.item_name:  # Порівнюємо за назвою
			Item[i]["count"] += 1
			emit_signal("item_added", item)
			print("Після додавання (існуючий): ", Item)
			return

	for i in range(slotcount):
		if not Item.has(i):
			Item[i] = {"item": item, "count": 1}
			emit_signal("item_added", item)
			print("Після додавання (новий): ", Item)
			return

func remove_item(item: Item):
	for key in Item.keys():
		if Item[key]["item"].item_name == item.item_name:
			Item[key]["count"] -= 1
			if Item[key]["count"] <= 0:
				Item.erase(key)
			print("Після видалення: ", Item)
			break

func has_item(item: Item) -> bool:
	for key in Item.keys():
		if Item[key]["item"].item_name == item.item_name:
			return true
	return false

func get_items():
	var unique_items = []
	for key in Item.keys():
		if not unique_items.has(Item[key]["item"]):
			unique_items.append(Item[key]["item"])
	return unique_items

func equip_item(item, weapon_slot_node):
	if has_item(item):
		weapon_slot_node.item = item
		print("Екіпіровано зброю: ", item.item_name)
	else:
		print("Предмет не в інвентарі, екіпірування скасовано")

func remove_item_by_name(name: String, count_to_remove: int) -> void:
	for key in Item.keys():
		var entry = Item[key]
		if entry["item"].item_name == name:
			var count = entry["count"]
			if count >= count_to_remove:
				entry["count"] -= count_to_remove
				var item_ref = entry["item"]
				if entry["count"] <= 0:
					Item.erase(key)
				else:
					Item[key] = entry
				emit_signal("item_added", item_ref)
				print("Видалено ", count_to_remove, " одиниць ", name)
				return
			else:
				print("Недостатньо кількості для видалення: ", count, " < ", count_to_remove)
