class_name CharacterLandState
extends CharacterState

@export var pawn: CharacterPawn

@onready var animation_tree := pawn.animation_tree
@onready var animation_playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

func enter(previous: CharacterState) -> void:
	animation_playback.travel("Jump Down")


func process_actions(delta: float, actions: CharacterActions, parent: CharacterState) -> CharacterActions:
	if animation_playback.get_current_node() == "Movement":
		parent.change_state("Movement")
	return actions
