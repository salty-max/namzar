extends Node

enum PaletteColor {
	RED,
	BLUE,
	GREEN,
	ORANGE,
	YELLOW,
	TEAL
}

const HEX_DICT := {
	PaletteColor.RED: "#f38ba8",
	PaletteColor.BLUE: "#89b4fa",
	PaletteColor.GREEN: "#a6e3a1",
	PaletteColor.ORANGE: "#fab387",
	PaletteColor.YELLOW: "#f9e2af",
	PaletteColor.TEAL: "#94e2d5",
}


func colorize(text: String, color: PaletteColor) -> String:
	return '[color="%s"]%s[/color]' % [HEX_DICT[color], text]
