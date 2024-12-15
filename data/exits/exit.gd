class_name Exit
extends Resource

var room_1: Room
var room_1_locked: bool = false

var room_2: Room
var room_2_locked: bool = false


func get_next_room(room: Room) -> Room:
	return room_1 if room == room_2 else room_2
