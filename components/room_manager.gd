class_name RoomManager
extends Node2D


func _ready() -> void:
	$ShackRoom.connect_exit("east", $OutsideShackRoom)
