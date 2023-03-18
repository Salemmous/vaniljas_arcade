class_name CharacterCamera
extends Camera3D

@export var look_at_target: Node
@export var camera_speed := 4.0
@export var target_reached_threshold := 0.02

var target_reached_threshold_squared = target_reached_threshold * target_reached_threshold

signal target_reached

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if look_at_target:
		var target_rotation := global_transform.looking_at(look_at_target.global_transform.origin)
		var new_basis: Basis = global_transform.basis.slerp(target_rotation.basis, delta * camera_speed)
		var difference = new_basis.get_euler().distance_squared_to(global_transform.basis.get_euler())
		if difference < target_reached_threshold_squared:
			target_reached.emit()
		global_transform.basis = new_basis
		
