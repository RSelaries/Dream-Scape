extends Node3D


@onready var animation_player: AnimationPlayer = %AnimationPlayer

var open := false


func interact() -> void:
	if open:
		animation_player.play("open", -1, -1, true)
	else:
		animation_player.play("open")
	open = !open
