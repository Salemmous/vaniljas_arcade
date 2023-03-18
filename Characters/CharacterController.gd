class_name CharacterController
extends CharacterBody3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var character_rotation_speed := 5.5

@onready var action_controller: CharacterActionController = $Actions
@onready var state: CharacterState = $State
@onready var camera_spring := $CameraSpring
@onready var camera := $CameraSpring/Camera3D
@onready var pawn: CharacterPawn = $Vanilja
@onready var animation_player := $Vanilja/AnimationPlayer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("pause"):
		get_tree().quit()

func _physics_process(delta: float) -> void:
	var actions :=  CharacterActions.new()
	actions.is_on_ground = is_on_floor()
	actions.velocity = velocity
	actions.camera_rotation = camera_spring.rotation
	actions = action_controller.process_actions(delta, actions)
	actions = state.process_actions(delta, actions, null)
	
	velocity = actions.velocity
	var plane_velocity = Vector3(velocity.x, 0, velocity.z)
	if plane_velocity.length():
		pawn.transform.basis = pawn.transform.basis.slerp(Basis.looking_at(plane_velocity), delta * character_rotation_speed)
	move_and_slide()
	camera_spring.rotation = actions.camera_rotation
