class_name Dialog
extends Resource

@export var text: String
@export var next: Callable

static func end(dialog_text: String) -> Dialog:
	var dialog := Dialog.new()
	dialog.text = dialog_text
	return dialog
	
static func following(dialog_text: String, next_dialog: Dialog) -> Dialog:
	var dialog := Dialog.new()
	dialog.text = dialog_text
	dialog.next = func (controller: DialogController): controller.show_dialog(next_dialog)
	return dialog
	
static func action(dialog_text: String, callable_action: Callable) -> Dialog:
	var dialog := Dialog.new()
	dialog.text = dialog_text
	dialog.next = callable_action
	return dialog
