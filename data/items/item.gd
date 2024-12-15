class_name Item
extends Resource

enum ItemType {
	KEY,
}

@export var name: StringName
@export var type: ItemType


func init(name: StringName, type: ItemType) -> void:
	self.name = name
	self.type = type
