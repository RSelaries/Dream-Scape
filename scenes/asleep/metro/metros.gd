extends Node3D


@onready var animation_player: AnimationPlayer = %AnimationPlayer


func  _ready() -> void:
	animation_player.play("RESET")


func _on_metro_escaped_body_exited(_body: Node3D) -> void:
	get_tree().call_group("dream_left_doors", "close_doors")
	await get_tree().create_timer(1).timeout
	animation_player.play("speed_off")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "speed_off":
		queue_free()
