extends Control

func _on_button_pressed():
		Events.emit_signal("skip_button_pressed")
