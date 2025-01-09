extends Node3D


@export var player_starting_position: Vector3

@onready var player: CharacterBody3D = $Player


func _ready() -> void:
	if player:
		player.position = player_starting_position
