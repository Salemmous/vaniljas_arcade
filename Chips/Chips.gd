class_name Chips
extends Node3D

signal collected(Chips)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not (body is CharacterController):
		return
	collected.emit(self)
	queue_free()
