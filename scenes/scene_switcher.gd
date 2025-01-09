extends Node


@export var awake_scene: PackedScene
@export var asleep_scene: PackedScene

var player_parameters := {
	"rotation": {"neck_y": 0, "camera_x": 0},
	"awake_scene": {
		"position": Vector3.ZERO,
		},
	"asleep_scene": {
		"position": Vector3.ZERO,
		
		},
}
var current_scene := "awake_scene"

@onready var transition_color: ColorRect = %TransitionColor


func _ready() -> void:
	change_scene(current_scene, false)


func change_scene(scene_name: String, transition := true, transition_duration := 1.2) -> void:
	var clear_children: Callable = func() -> void:
		for child in get_children():
			if child.name != "Transition":
				child.queue_free()
	
	# Scene
	var packed_scene: PackedScene = get(scene_name)
	var scene: Node3D = packed_scene.instantiate()
	
	# Handle transition and timing
	if transition:
		_change_scene_transition(transition_duration)
		await get_tree().create_timer(transition_duration / 2).timeout
	
	# Save player position
	var current_player_position: Vector3
	var current_player_rotation: Vector2
	for child in get_children():
		var properties := child.get_property_list()
		for property in properties:
			if property.name == "player":
				@warning_ignore("unsafe_property_access")
				current_player_position = child.player.position
				@warning_ignore("unsafe_property_access")
				@warning_ignore("unsafe_call_argument")
				current_player_rotation = Vector2(child.player.camera.rotation.x, child.player.neck.rotation.y)
	player_parameters[current_scene].position = current_player_position
	player_parameters["rotation"].neck_y = current_player_rotation.y
	player_parameters["rotation"].camera_x = current_player_rotation.x
	
	clear_children.call()
	add_child(scene)
	
	current_scene = scene_name
	
	# Set player position
	for child in get_children():
		var properties := child.get_property_list()
		for property in properties:
			if property.name == "player":
				@warning_ignore("unsafe_property_access")
				child.player.position = player_parameters[current_scene].position
				@warning_ignore("unsafe_property_access")
				child.player.neck.rotation.y = player_parameters["rotation"].neck_y
				@warning_ignore("unsafe_property_access")
				child.player.camera.rotation.x = player_parameters["rotation"].camera_x


func _add_scene_as_child(scene: Node3D) -> void:
	add_child(scene)


func _change_scene_transition(transition_duration: float) -> void:
	var tween := create_tween()
	tween.set_ease(tween.EASE_IN_OUT)
	
	var transition_in_out := transition_duration * (0.5 * (1 - 0.26))
	var transition_wait := transition_duration * 0.26
	
	tween.tween_property(transition_color, "color", Color(0, 0, 0, 1), transition_in_out)
	tween.tween_property(transition_color, "color", Color(0, 0, 0, 1), transition_wait)
	tween.tween_property(transition_color, "color", Color(0, 0, 0, 0), transition_in_out)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("switch_scene"):
		if current_scene == "awake_scene":
			change_scene("asleep_scene")
		else:
			change_scene("awake_scene")
