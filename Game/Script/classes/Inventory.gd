extends Node

@export var Item :Array[Item]

func add_Item(item :Item):
	Item.append(Item)
	
func remove_item(item :Item):
	Item.erase(item)
	
func hus_item(item :Item):
	return Item.has(item)
