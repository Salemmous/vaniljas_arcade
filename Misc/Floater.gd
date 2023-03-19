extends Node3D


@export var target: Node3D
@export var start_offset: float = 0
@export var amplitude: float = 1.0
@export var speed: float = 1.0
@export var rotation_speed: float = 1.0

@onready var offset := randf()
var start_y := 0.0

func _physics_process(delta: float) -> void:
	if not target:
		return
	var time_now := Time.get_unix_time_from_system()
	var offset_y = start_offset + sin(time_now * speed + offset) * amplitude
	target.transform.origin.y = offset_y
	target.rotate_y(delta * rotation_speed)


func _on_area_3d_body_entered(body):
	pass # Replace with function body.
