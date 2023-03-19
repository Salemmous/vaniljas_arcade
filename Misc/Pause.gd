class_name Pause
extends CanvasLayer

const OTHER_AUDIO_BUSES := ["Background"]

const BLOCKER_ID = "PAUSE"

var mouse_mode := Input.mouse_mode
var audio_bus_volume := {}

@onready var music := $PauseMusic

func _ready() -> void:
	visible = false

func _input(event) -> void:
	if not event.is_action_pressed("pause"):
		return
	if visible:
		close()
		return
	open()
	
func open() -> void:
	visible = true
	mouse_mode = Input.mouse_mode
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	ControlBlocker.add_blocker(BLOCKER_ID)
	get_tree().paused = true
	music.play()
	for bus in OTHER_AUDIO_BUSES:
		var bus_index := AudioServer.get_bus_index(bus)
		audio_bus_volume[bus] = AudioServer.get_bus_volume_db(bus_index)
		AudioServer.set_bus_volume_db(bus_index, -1000)
	
func close() -> void:
	visible = false
	Input.set_mouse_mode(mouse_mode)
	ControlBlocker.remove_blocker(BLOCKER_ID)
	get_tree().paused = false
	music.stop()
	for bus in OTHER_AUDIO_BUSES:
		var bus_index := AudioServer.get_bus_index(bus)
		var volume = audio_bus_volume[bus] if audio_bus_volume.has(bus) else 0
		AudioServer.set_bus_volume_db(bus_index, volume)


func _on_continue_button_pressed():
	close()
	

func _on_quit_button_pressed():
	get_tree().quit()
