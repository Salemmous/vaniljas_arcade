class_name CharacterFallState
extends CharacterState

@export var pawn: CharacterPawn

@onready var animation_tree := pawn.animation_tree
@onready var animation_playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

func enter(_previous: CharacterState) -> void:
	if animation_playback.get_current_node() != "Falling":
		animation_playback.travel("Falling")


func process_actions(_delta: float, actions: CharacterActions, parent: CharacterState) -> CharacterActions:
	if actions.started_jump:
		parent.change_state("Jump")
	if actions.is_on_ground:
		parent.change_state("Land")
	return actions
