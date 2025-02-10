extends Node3D


@onready var animation_player: AnimationPlayer = %AnimationPlayer


func open_doors() -> void:
	animation_player.play("open")
	
func close_doors() -> void:
	animation_player.play("open", -1, -1, true)
