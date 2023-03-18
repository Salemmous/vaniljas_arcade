class_name CharacterJumpState
extends CharacterState

@export var pawn: CharacterPawn

@onready var animation_tree := pawn.animation_tree
@onready var animation_playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

func enter(previous: CharacterState) -> void:
	animation_playback.travel("Jump Up")


func process_actions(delta: float, actions: CharacterActions, parent: CharacterState) -> CharacterActions:
	if animation_playback.get_current_node() == "Falling":
		parent.change_state("Fall")
	return actions
