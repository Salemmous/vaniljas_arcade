class_name Chips
extends Node3D

const ZERO_SCALE = Vector3(0.01, 0.01, 0.01) # Not using zero as it produces an error

@export var fly_away_height: float = 4.0
@export var rotation_acceleration: float = 4.0
@export var animation_time: float = 0.7

@onready var floater: Floater = $Floater
@onready var sound_effect: AudioStreamPlayer3D = $SoundEffect
@onready var bag: MeshInstance3D = $Bag
@onready var area: Area3D = $Area
@onready var particles: GPUParticles3D = $Bag/Particles

var collected = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not (body is CharacterController) or collected:
		return
	collect()
	
func collect() -> void:
	collected = true
	sound_effect.play()
	particles.emitting = true
	floater.floating = false
	var tween := create_tween()
	tween.tween_property(floater, "speed", 0, animation_time)
	tween.parallel().tween_property(floater, "start_offset", fly_away_height, animation_time)
	tween.parallel().tween_property(floater, "rotation_speed", rotation_acceleration, animation_time)
	tween.tween_interval(animation_time)
	tween.tween_property(bag, "scale", ZERO_SCALE, animation_time)
	await tween.finished
	queue_free()
	
