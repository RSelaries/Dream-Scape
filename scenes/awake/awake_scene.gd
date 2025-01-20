extends Scene


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	super()


func _open_metro_doors() -> void:
	get_tree().call_group("rusted_metro_double_doors_right", "open")


func _on_inside_metro_body_entered(body: Node3D) -> void:
	if body is FpsPlayer:
		cinematic_player.play("player_in_metro")
