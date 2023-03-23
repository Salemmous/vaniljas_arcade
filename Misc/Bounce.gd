extends Area3D

@export var jump_intensity: float = 7.5
@export var only_from_above: bool = false

signal bounced(CharacterController)

func _on_body_entered(body: Node3D) -> void:
	if not (body is CharacterController):
		return
	if only_from_above and body.global_position.y < global_position.y:
		return
	body.bounce(jump_intensity)
	bounced.emit(body)
