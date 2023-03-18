class_name CharacterGravityController
extends CharacterActionController

@export var gravity_multiplier: float = 1

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func process_actions(delta: float, actions: CharacterActions) -> CharacterActions:
	if not actions.is_on_ground:
		actions.velocity.y -= gravity * gravity_multiplier * delta
	return actions
