class_name Fader
extends Panel


func fade_in(time: float = 1) -> void:
	var tween := create_tween()
	await tween.tween_property(self, "modulate", Color.WHITE, time).finished
	
func fade_out(time: float = 1) -> void:
	var tween := create_tween()
	await tween.tween_property(self, "modulate", Color.TRANSPARENT, time).finished
	
