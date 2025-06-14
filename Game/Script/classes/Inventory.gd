extends Node
class_name Inventory

signal item_added(item)

@export var Item: Dictionary = {}
@export var slotcount: int = 20

# Додаємо предмет до інвентарю
func add_item(item: Item):
	for i in Item.keys():
		if Item[i]["item"] == item:  
			Item[i]["count"] += 1
			emit_signal("item_added", item)
			return

	for i in range(slotcount):
		if not Item.has(i):
			Item[i] = {"item": item, "count": 1}
			emit_signal("item_added", item)
			return

# Видаляємо предмет з інвентарю
func remove_item(item: Item):
	for key in Item.keys():
		if Item[key]["item"] == item:
			Item[key]["count"] -= 1
			if Item[key]["count"] <= 0:
				Item.erase(key)
			break

# Перевіряємо, чи є предмет в інвентарі
func has_item(item: Item) -> bool:
	for key in Item.keys():
		if Item[key]["item"] == item:
			return true
	return false

# Повертаємо список усіх унікальних предметів
func get_items():
	var unique_items = []
	for key in Item.keys():
		if not unique_items.has(Item[key]["item"]):
			unique_items.append(Item[key]["item"])
	return unique_items

# Екіпіруємо предмет у збройний слот
func equip_item(item, weapon_slot_node):
	if has_item(item):
		weapon_slot_node.item = item
		print("Екіпіровано зброю: ", item.ItemName)
	else:
		print("Предмет не в інвентарі, екіпірування скасовано")
