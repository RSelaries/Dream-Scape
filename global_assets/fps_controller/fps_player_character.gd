class_name FpsPlayer
extends CharacterBody3D


@export_group("Inputs")
@export var input_enabled := {
	"movement": true,
	"camera": true,
}

@export_group("Nodes")
@export var neck : Node3D
@export var camera : PlayerCamera
@export var interaction_ray_cast: RayCast3D
@export var reticle: Reticle
@export var inspect_position_node: Node3D

@export_group("Camera Settings")
@export var mouse_sensitivity : float = 0.003
@export_subgroup("Shaking")
@export var shake_intensity: float = 1:
	set(value): camera.shake_intensity = value
@export var shake_noise_scale : float = 0.94:
	set(value): camera.shake_noise_scale = value
@export_subgroup("Oscilation")
@export var shake_oscillation_speed: float = 2:
	set(value): camera.shake_oscillation_speed = value
@export var shake_oscillation_amplitude: float = 0.3:
	set(value): camera.shake_oscillation_amplitude = value
@export_subgroup("Viewbobbing")
@export var viewbobbing_frequency: float:
	set(value): camera.viewbobbing_frequency = value
@export var viewbobbing_force: float:
	set(value): camera.viewbobbing_force = value

@export_group("Movement Settings")
@export var use_jump : bool = true
@export var speed : float = 5.0
@export var jump_velocity : float = 4.5
@export var action_names := {
	"frw" : "movement_forward",
	"lft" : "movement_left",
	"bck" : "movement_backward",
	"rgt" : "movement_right",
}


var inspect_original_distance: float


func _ready() -> void:
	Global.game_state_changed.connect(_on_game_state_changed)
	Global.player = self
	inspect_original_distance = inspect_position_node.position.z


func _process(_delta: float) -> void:
	_reticle_based_on_interact()


func _unhandled_input(event: InputEvent) -> void:
	# Capture mouse on left click, release on 'escape' pressed
	if event is InputEventMouseButton and input_enabled.camera:
		var mouse_button_event: InputEventMouseButton = event
		if mouse_button_event.button_index == 1:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Handling Camera
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and input_enabled.camera:
		var event_mouse_motion : InputEventMouseMotion = event
		
		neck.rotate_y( -event_mouse_motion.relative.x * mouse_sensitivity * 0.01)
		camera.rotate_x( -event_mouse_motion.relative.y * mouse_sensitivity * 0.01)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(85) )
	
	# Handling Inspect zoom
	if Global.current_game_state == Global.GameStates.OBJECT_INSPECTING:
		if event.is_action_pressed("mouse_wheel_up"):
			inspect_position_node.position.z += 0.05
			inspect_position_node.position.z = clamp(inspect_position_node.position.z, -0.759, -0.384)
		elif event.is_action_pressed("mouse_wheel_down"):
			inspect_position_node.position.z -= 0.05
			inspect_position_node.position.z = clamp(inspect_position_node.position.z, -0.759, -0.384)


func _physics_process(delta: float) -> void:
	if input_enabled.movement:
		# Add the gravity
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump
		if use_jump:
			if Input.is_action_just_pressed("ui_accept") and is_on_floor():
				velocity.y = jump_velocity

		# Get the input direction and handle the movement/deceleration
		@warning_ignore("unsafe_call_argument")
		var input_dir := Input.get_vector(action_names["lft"],action_names["rgt"], action_names["frw"], action_names["bck"])
		var direction := (neck.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func _input(event: InputEvent) -> void:
	if !input_enabled.movement:
		return
	
	if event.is_action_pressed("interact"):
		_interact_with()


func _on_game_state_changed(current_game_state: Global.GameStates) -> void:
	match current_game_state:
		Global.GameStates.PLAYING:
			input_enabled.movement = true
			input_enabled.camera = true
			reticle.reticle_type = reticle.ReticleTypes.CIRCLE
			inspect_position_node.position.z = inspect_original_distance
		
		Global.GameStates.CINEMATIC:
			pass
		
		Global.GameStates.OBJECT_INSPECTING:
			input_enabled.movement = false
			input_enabled.camera = false
			reticle.reticle_type = reticle.ReticleTypes.NONE


func _interact_with() -> void:
	var what := interaction_ray_cast.get_collider()
	
	if what:
		if what.has_method("interact"):
			@warning_ignore("unsafe_method_access")
			what.interact()


func _reticle_based_on_interact() -> void:
	if Global.current_game_state != Global.GameStates.PLAYING:
		return
	
	if interaction_ray_cast.get_collider() is not InteractibleObject3D:
		reticle.reticle_type = reticle.ReticleTypes.CIRCLE
		return
	
	var ray_cast_collider: InteractibleObject3D = interaction_ray_cast.get_collider()
	
	var interaction_type: InteractibleObject3D.InteractionTypes = InteractibleObject3D.InteractionTypes.DEFAULT
	interaction_type = ray_cast_collider.interaction_type
	
	
	match interaction_type:
		InteractibleObject3D.InteractionTypes.DEFAULT:
			reticle.reticle_type = reticle.ReticleTypes.HAND
		
		InteractibleObject3D.InteractionTypes.OWNER_DEFAULT:
			reticle.reticle_type = reticle.ReticleTypes.HAND
		
		InteractibleObject3D.InteractionTypes.INSPECT:
			reticle.reticle_type = reticle.ReticleTypes.HAND
		
		InteractibleObject3D.InteractionTypes.SLEEP:
			reticle.reticle_type = reticle.ReticleTypes.SLEEP
