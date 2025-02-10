extends Node3D


func open_metro_left_doors() -> void:
	get_tree().call_group("dream_left_doors", "open_doors")


func close_metro_left_doors() -> void:
	get_tree().call_group("dream_left_doors", "close_doors")
