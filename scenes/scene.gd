class_name Scene
extends Node3D


@export var player: FpsPlayer
@export var player_position: Vector3
@export var cinematic_player: AnimationPlayer

var input_enabled := false


func _ready() -> void:
	if !player and %Player:
		player = %Player
