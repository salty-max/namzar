class_name Game
extends Control

const HistoryRow := preload("res://scenes/history_row/history_row.tscn")

@export var text_animation_speed: float = 1.0

@onready var history: VBoxContainer = %History
@onready var scroll: ScrollContainer = %Scroll
@onready var scroll_bar: VScrollBar = %Scroll.get_v_scroll_bar()

var max_scroll_length := 0


func _ready() -> void:
	scroll_bar.changed.connect(_on_scroll_bar_changed)
	max_scroll_length = scroll_bar.max_value

func _on_text_input_text_submitted(new_text: String) -> void:
	var row := HistoryRow.instantiate()
	row.animation_speed = text_animation_speed
	row.set_text(new_text, "Wtf man?")
	history.add_child(row)


func _on_scroll_bar_changed() -> void:
	if max_scroll_length != scroll_bar.max_value:
		max_scroll_length = scroll_bar.max_value
		scroll.scroll_vertical = scroll_bar.max_value
