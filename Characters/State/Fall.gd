class_name CharacterFallState
extends CharacterState

@export var pawn: CharacterPawn

@onready var animation_tree := pawn.animation_tree
@onready var animation_playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

func enter(previous: CharacterState) -> void:
	if animation_playback.get_current_node() != "Falling":
		animation_playback.travel("Falling")


func process_actions(delta: float, actions: CharacterActions, parent: CharacterState) -> CharacterActions:
	if actions.is_on_ground:
		parent.change_state("Land")
	return actions
