extends PanelContainer


export(String) var display_text
var display_label
export(String) var blendshape_name
var slider

signal changed_blendshape_value

func _ready():
	display_label = $VBoxContainer/Property_Label
	display_label.text = display_text
	slider = $VBoxContainer/Property_Slider


func _on_Property_Slider_value_changed(new_blendshape_value):
	
	emit_signal("changed_blendshape_value", blendshape_name, new_blendshape_value)
