extends Area3D

@onready var respawn: Node3D = $Respawn
@onready var fader: Fader = $Fader

signal player_respawned

const BLOCKER_ID = "PIT_RESPAWN"

func _on_body_entered(body: Node3D) -> void:
	if not respawn:
		return
	ControlBlocker.add_blocker(BLOCKER_ID)
	await fader.fade_in()
	body.global_transform = respawn.global_transform
	await fader.fade_out()
	player_respawned.emit()
	ControlBlocker.remove_blocker(BLOCKER_ID)
