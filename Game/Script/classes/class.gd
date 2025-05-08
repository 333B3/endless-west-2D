extends Resource

class_name Item

@export var ItemName :String

@export_enum("Tools", "Material", "Food", "Gun")
var type = "Material"

@export var texture :Texture2D
