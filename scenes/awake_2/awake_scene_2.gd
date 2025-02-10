extends Scene


func _ready() -> void:
	super()
	
	cinematic_player.play("waking_up")


func _to_main_screen() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
