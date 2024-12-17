class_name Exit
extends Resource

var room_a: Room
var room_b: Room
var locked: bool = false
var locked_msg: String
var key: Item


func _init(_room_a: Room, _room_b: Room, _locked: bool = false, _key: Item = null, _locked_msg: String = "") -> void:
	self.room_a = _room_a
	self.room_b = _room_b
	self.locked = _locked
	self.locked_msg = _locked_msg
	self.key = _key


func get_next_room(current_room: Room) -> Room:
	return room_a if current_room == room_b else room_b


func is_locked() -> bool:
	return locked


func lock() -> void:
	locked = true


func unlock() -> void:
	locked = false


func get_key() -> Item:
	return key


func get_locked_message() -> String:
	return locked_msg
