extends Scene


@export var sound_effect_volume_db: float = 1.0:
	set(value):
		_set_sound_effect_audio_bus_volume(value)


@onready var controls_animation_player: AnimationPlayer = %ControlsAnimationPlayer


var metro_departed := false


func _ready() -> void:
	super()
	
	if get_parent().name != "Game":
		_set_sound_effect_audio_bus_volume(sound_effect_volume_db)
		_open_metro_doors()


func _open_metro_doors() -> void:
	get_tree().call_group("rusted_metro_double_doors_right", "open")


func _close_metro_doors() -> void:
	get_tree().call_group("rusted_metro_double_doors_right", "close")


func _on_inside_metro_body_entered(body: Node3D) -> void:
	if body is FpsPlayer and !metro_departed:
		metro_departed = true
		cinematic_player.play("player_in_metro")


func _fade_in_out_controls() -> void:
	controls_animation_player.play("fade_in_out")


func _set_sound_effect_audio_bus_volume(volume: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), linear_to_db(volume))
