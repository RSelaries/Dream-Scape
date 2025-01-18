extends Scene


func _ready() -> void:
	super()
	_open_metro_doors()


func _open_metro_doors() -> void:
	get_tree().call_group("rusted_metro_double_doors_right", "open")
	
