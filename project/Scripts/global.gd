# Global.gd
extends Node

# Global toggle state
var is_visible = true

# Signal to notify changes in visibility
signal visibility_toggled(new_state: bool)

# Method to update the state and emit signal
func toggle_visibility(new_state: bool) -> void:
	is_visible = new_state
	emit_signal("visibility_toggled", is_visible)
