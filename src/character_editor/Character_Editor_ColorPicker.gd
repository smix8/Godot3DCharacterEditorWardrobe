extends ColorPicker

export(String, "hair", "torso", "legs", "feet") var slot = "hair"

signal changed_mesh_color


func _on_Character_Editor_ColorPicker_color_changed(color):
	emit_signal("changed_mesh_color", color, slot)
