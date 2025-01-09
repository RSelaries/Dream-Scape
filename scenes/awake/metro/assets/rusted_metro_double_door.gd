extends Node3D


@onready var animation_player: AnimationPlayer = $AnimationPlayer


var is_open := false


func open() -> void:
	if animation_player.has_animation("Opening") and !is_open: #If already opened, doesn't play opening animation
		animation_player.play("Opening")
		is_open = true


func close() -> void:
	if !is_open: #If already closed, doesn't play closing animation
		return
	
	if animation_player.has_animation("Closing"):
		animation_player.play("Closing")
		is_open = false
	elif animation_player.has_animation("Opening"): #If there aren't anu closing animation, reverses the opening animation
		animation_player.play("Opening", -1, -1, true)
		is_open = false
		
