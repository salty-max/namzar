class_name Player
extends Node

@export var data: PlayerData


func _ready() -> void:
	data.changed.connect(_on_data_changed)


func get_player_name() -> StringName:
	return data.name


func get_gold() -> int:
	return data.gold


func get_items() -> Array[Item]:
	return data.items


func take_item(item: Item) -> void:
	data.add_item(item)


func drop_item(item: Item) -> void:
	data.remove_item(item)


func _on_data_changed() -> void:
	print(data)
