extends Control

signal building_selected(building_data: BuildingData)

@export var buildings: Array[BuildingData]

func _ready():
	for data in buildings:
		var btn = Button.new()
		btn.text = data.name
		btn.pressed.connect(func(): emit_signal("building_selected", data))
		$VBoxContainer.add_child(btn)
