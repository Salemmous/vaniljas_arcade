class_name CharacterMovementState
extends CharacterState

@export var pawn: CharacterPawn

@onready var animation_tree := pawn.animation_tree
@onready var animation_playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@export var warm_up_speed := 2.0
@export var deceleration_speed := 2.5

const THRESHOLD = -0.15

const VELOCITY_TO_ANIMATION = 180

var anim_speed = null

func enter(previous: CharacterState) -> void:
	animation_playback.travel("Movement")
	
func exit(next: CharacterState) -> void:
	anim_speed = null

func process_actions(delta: float, actions: CharacterActions, parent: CharacterState) -> CharacterActions:
	if actions.started_jump:
		parent.change_state("Jump")
		return actions
	if not actions.is_on_ground:
		parent.change_state("Fall")
		return actions
	var velocity = Vector3(actions.velocity.x, 0, actions.velocity.z)
	var target_speed := velocity.length() / delta / VELOCITY_TO_ANIMATION
	if anim_speed == null:
		anim_speed =  target_speed
	var warm_up = warm_up_speed if target_speed > anim_speed else warm_up_speed * deceleration_speed
	var diff: float = target_speed - anim_speed
	anim_speed = lerp(anim_speed, target_speed, delta * warm_up_speed) if diff < THRESHOLD or diff > 0 else target_speed
	animation_tree.set("parameters/Movement/blend_position", anim_speed)
	return actions
