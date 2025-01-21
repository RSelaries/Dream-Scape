extends InteractibleObject3D


@export var scene_owner: Scene


func interact() -> void:
	scene_owner.cinematic_player.play("sleeping")
