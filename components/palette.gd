extends Node

enum PaletteColor {
	RED,
	BLUE,
	GREEN,
	ORANGE,
	YELLOW,
	TEAL,
	MAUVE
}

const HEX_DICT := {
	PaletteColor.RED: "#f38ba8",
	PaletteColor.BLUE: "#89b4fa",
	PaletteColor.GREEN: "#a6e3a1",
	PaletteColor.ORANGE: "#fab387",
	PaletteColor.YELLOW: "#f9e2af",
	PaletteColor.TEAL: "#94e2d5",
	PaletteColor.MAUVE: "#cba6f7"
}


func colorize(text: String, color: PaletteColor) -> String:
	return '[color="%s"]%s[/color]' % [HEX_DICT[color], text]


func to_error(text: String) -> String:
	return colorize(text, PaletteColor.RED)


func to_command(text: String) -> String:
	return colorize(text, PaletteColor.BLUE)


func to_direction(text: String) -> String:
	return colorize(text, PaletteColor.YELLOW)


func to_room(text: String) -> String:
	return colorize(text, PaletteColor.GREEN)


func to_item(text: String) -> String:
	return colorize(text, PaletteColor.MAUVE)


func to_character(text: String) -> String:
	return colorize(text, PaletteColor.ORANGE)
