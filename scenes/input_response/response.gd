class_name Output
extends RichTextLabel

const TEXT_SCROLL_SOUND := preload("res://assets/audio/text_scroll.wav")

@export var text_scroll_speed: float
@export var is_text_animated: bool

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if is_text_animated:
		animation_player.animation_finished.connect(_on_animation_finished)


func display(output: String) -> void:
	if not is_node_ready():
		await ready

	text = output

	if not is_text_animated:
		visible_ratio = 1
		return

	# Remove bbcode from text
	var regex = RegEx.new()
	regex.compile(r"\[\/?[a-zA-Z0-9_=#:; ]+\]")
	var raw_text = regex.sub(text, "", true)

	var duration: float = raw_text.length() * text_scroll_speed
	var animation := animation_player.get_animation("text_scroll")

	animation.length = duration
	animation.track_set_key_time(0, 1, duration)
	EventBus.text_scroll_started.emit()
	SFXPlayer.play(TEXT_SCROLL_SOUND)
	animation_player.play("text_scroll")


func _on_animation_finished(_animation_name: String) -> void:
	SFXPlayer.stop()
	EventBus.text_scroll_finished.emit()
