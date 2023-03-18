extends Camera3D

@export var look_at_target: Node
@export var camera_speed := 4.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if look_at_target:
		var target_rotation = global_transform.looking_at(look_at_target.global_transform.origin)
		global_transform.basis.y=lerp(global_transform.basis.y, target_rotation.basis.y, delta*camera_speed)
		global_transform.basis.x=lerp(global_transform.basis.x, target_rotation.basis.x, delta*camera_speed)
		#global_transform.basis.z=lerp(global_transform.basis.z, target_rotation.basis.z, delta*camera_speed)
