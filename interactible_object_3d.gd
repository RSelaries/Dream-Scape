extends CollisionObject3D
class_name InteractibleObject3D


enum InteractionTypes {DEFAULT, INSPECT, OWNER_DEFAULT}
@export var interaction_type: InteractionTypes = InteractionTypes.DEFAULT


var inspected := false
var moving := false
var can_move := false


@onready var original_position := position
@onready var original_rotation := rotation


func _process(_delta: float) -> void:
	match interaction_type:
		InteractionTypes.INSPECT:
			if can_move and Global.current_game_state == Global.GameStates.OBJECT_INSPECTING:
				_inspect_update_position()
		
		_:
			pass


func interact() -> void:
	match interaction_type:
		InteractionTypes.INSPECT:
			_inspect_interact()
		
		InteractionTypes.OWNER_DEFAULT:
			if owner.has_method("interact"):
				@warning_ignore("unsafe_method_access")
				owner.interact()
		
		_:
			pass


func _unhandled_input(event: InputEvent) -> void:
	match interaction_type:
		InteractionTypes.DEFAULT:
			pass
		
		InteractionTypes.INSPECT:
			if can_move == true:
				_inspect_handle_input(event)


func _on_return() -> void:
	pass


## ========= Inspect functions =========
func _inspect_update_position() -> void:
	global_position = Global.player.inspect_position_node.global_position

func _inspect_interact() -> void:
	Global.current_game_state = Global.GameStates.OBJECT_INSPECTING
	
	var tween := create_tween()
	
	var inspect_rotation := Global.player.inspect_position_node.global_rotation
	tween.tween_property(self, "global_position", Global.player.inspect_position_node.global_position, 0.5)
	tween.parallel()
	tween.tween_property(self, "global_rotation", Vector3(inspect_rotation.x + PI * 0.5, inspect_rotation.y, inspect_rotation.z), 0.5)
	
	inspected = true
	
	await get_tree().create_timer(0.5).timeout
	
	can_move = true

func _inspect_handle_input(event: InputEvent) -> void:
	if !inspected:
		return
	
	# Handle rotation
	if event is InputEventMouseMotion and moving:
		var event_mouse_motion : InputEventMouseMotion = event
		
		rotation.z += -event_mouse_motion.relative.x * 0.008
		rotation.x += event_mouse_motion.relative.y * 0.008
	
	if event.is_action_pressed("interact"):
		moving = true
	elif event.is_action_released("interact"):
		moving = false
	
	# Handle inspect return
	if event.is_action_pressed("return"):
		var tween := create_tween()
		
		inspected = false
		can_move = false
		moving = false
		Global.current_game_state = Global.GameStates.PLAYING
		
		
		rotation_degrees.x = fmod(rotation_degrees.x, 360)
		rotation_degrees.y = fmod(rotation_degrees.y, 360)
		rotation_degrees.z = fmod(rotation_degrees.z, 360)
		
		tween.tween_property(self, "position", original_position, 0.2)
		tween.parallel()
		tween.tween_property(self, "rotation", original_rotation, 0.2)
		
		_on_return()
	
	# Handle second interaction
	if event.is_action_pressed("interact_2"):
		_inspect_interact_2()

func _inspect_interact_2() -> void:
	pass
## =====================================
