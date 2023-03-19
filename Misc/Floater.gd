class_name Floater
extends Node3D


@export var target: Node3D
@export var floating: bool = true
@export var rotating: bool = true
@export var start_offset: float = 0
@export var amplitude: float = 1.0
@export var speed: float = 1.0
@export var rotation_speed: float = 1.0

@onready var offset := randf()

var last_offset_y := 0.0

func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:
	if not target:
		return
	var time_now := Time.get_unix_time_from_system()
	var new_offset_y := sin(time_now * speed + offset) * amplitude if floating else last_offset_y
	var offset_y := start_offset + new_offset_y
	target.transform.origin.y = offset_y
	last_offset_y = new_offset_y
	if rotating:
		target.rotate_y(delta * rotation_speed)
