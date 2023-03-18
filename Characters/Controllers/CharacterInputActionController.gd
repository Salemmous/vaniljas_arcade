class_name CharacterInputActionController
extends CharacterActionController

@export var speed: float = 7
@export var jump_velocity: float = 7.5
@export var camera_speed: float = 5
@export var min_clamp_camera = -60
@export var max_clamp_camera = 25

const CAMERA_MOUSE_TWEAK_SPEED = 0.0003

@export var camera_input_name := "mouse"
@export var jump_input_name := "jump"
@export var left_input_name := "left"
@export var right_input_name := "right"
@export var up_input_name := "up"
@export var down_input_name := "down"

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func process_actions(delta: float, actions: CharacterActions) -> CharacterActions:
	if ControlBlocker.are_controls_blocked():
		return actions
	
	# Camera rotation
	var camera_velocity = Input.get_last_mouse_velocity() * CAMERA_MOUSE_TWEAK_SPEED if camera_input_name == "mouse" else Vector2.ZERO
	camera_velocity *= delta
	camera_velocity = -camera_velocity
	
	actions.camera_rotation += Vector3(camera_velocity.y, camera_velocity.x, 0) * camera_speed
	actions.camera_rotation.x = clampf(actions.camera_rotation.x, deg_to_rad(min_clamp_camera), deg_to_rad(max_clamp_camera))
	
	
	# Handle Jump.
	if Input.is_action_pressed(jump_input_name) and actions.is_on_ground:
		actions.started_jump = true
		actions.velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector(left_input_name, right_input_name, up_input_name, down_input_name)
	var camera_basis = Basis(Vector3.UP, actions.camera_rotation.y)
	var direction = (camera_basis * (transform.basis * Vector3(input_dir.x, 0, input_dir.y))).normalized()
	
	var movement_speed = speed
	
	if direction:
		actions.velocity.x = direction.x * movement_speed
		actions.velocity.z = direction.z * movement_speed
	else:
		actions.velocity.x = move_toward(actions.velocity.x, 0, movement_speed)
		actions.velocity.z = move_toward(actions.velocity.z, 0, movement_speed)
	
	return actions
