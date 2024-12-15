class_name RoomManager
extends Node2D


func _ready() -> void:
	$ShackRoom.connect_exit("east", $OutsideShackRoom)

	var shack_key = Item.new()
	shack_key.init("shack key", Item.ItemType.KEY)
	$ShackRoom.add_item(shack_key)
