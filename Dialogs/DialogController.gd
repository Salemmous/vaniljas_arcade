class_name DialogController
extends NinePatchRect

var current_dialog: Dialog

signal closed

const BLOCKER_ID = "DIALOG"

@onready var label := $DialogBackground/DialogText
@onready var timer := $ControlBlockerTimer

func _ready() -> void:
	visible = false
	
	
func show_dialog(new_dialog: Dialog) -> DialogController:
	timer.stop()
	visible = true
	ControlBlocker.add_blocker(BLOCKER_ID)
	current_dialog = new_dialog
	label.clear()
	label.add_text(current_dialog.text)
	return self
	
func _input(event) -> void:
	if not visible:
		return
	if not current_dialog:
		return
	if event.is_action_pressed("dialog_next"):
		if current_dialog.next:
			current_dialog.next.call(self)
			return
		close()
		
func close() -> void:
	visible = false
	current_dialog = null
	closed.emit()
	timer.start()

func _on_release_controls() -> void:
	ControlBlocker.remove_blocker(BLOCKER_ID)
