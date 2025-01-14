class_name SceneHandler
extends Node3D


@export var awake_scene: PackedScene
@export var asleep_scene: PackedScene

@onready var transition_color: ColorRect = %TransitionColor
@onready var current_scene_parent: Node3D = %CurrentSceneParent
@onready var transition_half_timer: Timer = %TransitionHalfTimer
@onready var transition_cooldown: Timer = %TransitionCooldown
@onready var transition_animation: AnimationPlayer = %TransitionAnimation


var current_scene: Scene
var scenes_infos := {}

var changing_scene := false
var changing_scene_to: Scene


func _ready() -> void:
	change_scene(awake_scene, false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("switch_scene") and !changing_scene:
		if current_scene.name == "AwakeScene":
			change_scene(asleep_scene)
		else:
			change_scene(awake_scene)


## Changes current scene to [code]scene[/code].[br]
## If transition is set to false, the scene will change immediately without transition.
func change_scene(scene: PackedScene, transition: bool = true, transition_time: float = 1.5) -> void:
	var new_scene: Scene = scene.instantiate()
	
	transition_half_timer.wait_time = transition_time / 2.0
	transition_cooldown.wait_time = transition_time
	transition_cooldown.start()
	changing_scene = true
	
	changing_scene_to = new_scene
	
	if transition:
		transition_half_timer.start()
		transition_animation.play("fade_in_out", -1, 1 / transition_time)
	else:
		_add_scene_node()
		_on_transition_cooldown_timeout()
	
	current_scene = new_scene


func _add_scene_node() -> void:
	var clear_scene_parents_childs: Callable = func() -> void:
		if current_scene_parent.get_children():
			for child in current_scene_parent.get_children():
				child.queue_free()
	
	clear_scene_parents_childs.call()
	current_scene_parent.add_child(changing_scene_to)


func _on_transition_cooldown_timeout() -> void:
	changing_scene = false
