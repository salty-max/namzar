class_name CommandParser
extends Node

const COMMAND_DEFS := {
	"go": 2,
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
		return "Empty command..."

	var cmd: String = words[0]
	if not COMMAND_DEFS.has(cmd):
		return "Unknown command: %s" % [cmd]

	var expected_args_count = COMMAND_DEFS[cmd] - 1
	var args = words.slice(1)

	match cmd:
		"go":
			return _go(args)
		"help":
			return _help()

	return Palette.colorize("Wololo!", Palette.PaletteColor.RED)


func _go(args: Array) -> String:
	if args.is_empty():
		return "Go where?"

	var dir = args[0]

	if current_room.exits.keys().has(dir):
		var room_change_string = _change_room(current_room.exits[dir])
		return "\n\n".join([
			"You go %s" % Palette.colorize(dir, Palette.PaletteColor.YELLOW),
			room_change_string
		])

	return "No exit in that direction"


func _help() -> String:
	return "\n".join([
		"Available commands:",
		"\t%s <location>" % Palette.colorize("go", Palette.PaletteColor.BLUE),
		"\t%s" % Palette.colorize("help", Palette.PaletteColor.BLUE)
	])


func _change_room(new_room: Room) -> String:
	current_room = new_room
	var exits_string = " ".join(new_room.exits.keys())
	var strings = "\n\n".join([
		"You are now in %s." % Palette.colorize(new_room.room_name, Palette.PaletteColor.GREEN),
		new_room.room_description,
		"Exits: %s" % Palette.colorize(exits_string, Palette.PaletteColor.YELLOW)
	])
	return strings
