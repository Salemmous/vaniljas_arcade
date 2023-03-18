class_name CharacterActionController
extends Node3D

func process_actions(delta: float, actions: CharacterActions) -> CharacterActions:
	for child in get_children():
		if child is CharacterActionController:
			actions = child.process_actions(delta, actions)
	return actions
