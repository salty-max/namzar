class_name Game
extends Control

const HistoryRow := preload("res://scenes/history_row/history_row.tscn")

@export var animated_text: bool = true
@export var text_animation_speed: float = 1.0
@export var max_history_length: int = 30

@onready var history: VBoxContainer = %History
@onready var scroll: ScrollContainer = %Scroll
@onready var scroll_bar: VScrollBar = %Scroll.get_v_scroll_bar()
@onready var text_input: TextInput = %TextInput

var max_scroll_length := 0


func _ready() -> void:
	scroll_bar.changed.connect(_on_scroll_bar_changed)
	max_scroll_length = scroll_bar.max_value

func _on_text_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return

	var row := HistoryRow.instantiate()
	row.is_text_animated = animated_text
	row.animation_speed = text_animation_speed
	if animated_text:
		row.animation_started.connect(_on_response_animation_started)
		row.animation_finished.connect(_on_response_animation_finished)
	row.set_text(new_text, '[color="#f38ba8"]Lorem ipsum dolor sit amet[/color], consectetur adipiscing elit. Vestibulum condimentum metus nulla, sit amet facilisis leo egestas ac. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Etiam lacinia eget risus vitae scelerisque. Duis sagittis congue vehicula.')
	history.add_child(row)

	if history.get_child_count() >= max_history_length:
		var rows_to_forget := history.get_child_count() - max_history_length
		for i in range(rows_to_forget):
			history.get_child(i).queue_free()


func _on_scroll_bar_changed() -> void:
	if max_scroll_length != scroll_bar.max_value:
		max_scroll_length = scroll_bar.max_value
		scroll.scroll_vertical = scroll_bar.max_value


func _on_response_animation_started() -> void:
	text_input.editable = false


func _on_response_animation_finished() -> void:
	text_input.editable = true
