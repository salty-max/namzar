class_name CommandParser
extends Node

const COMMAND_DEFS := {
	"go": 2,
	"look": 1,
	"back": 1,
	"attack": 4,
	"help": 1
}

var current_room: Room


func init(starting_room: Room) -> String:
	return _change_room(starting_room)


func parse_command(input: String) -> String:
	var words = input.to_lower().split(" ", false)
	if words.is_empty():
		return Palette.to_error("Empty command...")

	var cmd: String = words[0]
	if not COMMAND_DEFS.has(cmd):
		return Palette.to_error("Unknown command: %s" % [cmd])

	var expected_args_count = COMMAND_DEFS[cmd] - 1
	var args = words.slice(1)

	match cmd:
		"go":
			return _go(args)
		"look":
			return _look()
		"help":
			return _help()

	return Palette.to_error("Wololo!")


func _go(args: Array) -> String:
	if args.is_empty():
		return "Go where?"

	var dir = args[0]

	if current_room.exits.keys().has(dir):
		var exit = current_room.exits[dir]
		var room_change_string = _change_room(exit.get_next_room(current_room))
		return "\n\n".join([
			"You go %s" % Palette.to_direction(dir),
			room_change_string
		])

	return Palette.to_error("No exit in that direction.")


func _look() -> String:
	return current_room.get_description()


func _help() -> String:
	return "\n".join([
		"Available commands:",
		"\t%s <location>" % Palette.to_command("go"),
		"\t%s" % Palette.to_command("look"),
		"\t%s" % Palette.to_command("help")
	])


func _change_room(new_room: Room) -> String:
	current_room = new_room
	return current_room.get_location()
