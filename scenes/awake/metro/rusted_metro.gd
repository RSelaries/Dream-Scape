extends Node3D


@export var door_sound_players: Array[AudioStreamPlayer3D]
@export var ambiant_sound_players: Array[AudioStreamPlayer3D]

const volume_max: float = -31.35


func play_ambiant_sounds() -> void:
	var tween := create_tween()
	
	for audio_stream in ambiant_sound_players:
		audio_stream.volume_db = -80.0
		audio_stream.play()
		tween.parallel().tween_property(audio_stream, "volume_db", volume_max, 2.0)


func play_departure_sound() -> void:
	pass


func play_door_sound() -> void:
	for audio_stream in door_sound_players:
		audio_stream.play()
