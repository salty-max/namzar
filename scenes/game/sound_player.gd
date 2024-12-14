extends Node

func play(source: AudioStream, single = false) -> void:
	if not source:
		return

	if single:
		stop()

	for player: AudioStreamPlayer in get_children():
		if not player.playing:
			player.stream = source
			player.play()
			break


func stop() -> void:
	for player: AudioStreamPlayer in get_children():
		player.stop()
