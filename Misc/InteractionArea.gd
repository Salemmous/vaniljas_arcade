class_name InteractionArea
extends Area3D

signal interacted(area: InteractionArea)

@onready var controls := $InteractionControl

var is_in_area := false

func _on_body_entered(body: Node3D) -> void:
	if not (body is CharacterController):
		return
	is_in_area = true
	controls.visible = true


func _on_body_exited(body: Node3D) -> void:
	if not (body is CharacterController):
		return
	is_in_area = false
	controls.visible = false

func _input(event) -> void:
	if event.is_action_pressed("interact") and is_in_area:
		interacted.emit(self)
