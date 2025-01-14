class_name Scene
extends Node3D


@export var player: FpsPlayer
@export var player_position: Vector3

var input_enabled := false


func _ready() -> void:
	if %Player:
		player = %Player
		player.position = player_position
