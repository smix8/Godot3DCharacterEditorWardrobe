extends Control

var character_name : String#

onready var animate = $AnimationPlayer

signal character_name_changed

func _on_Name_Button_pressed():
	if visible == false:
		animate.play("show")
		yield(animate, "animation_finished")



func _on_LineEdit_text_entered(new_text):
	character_name = new_text
	emit_signal("character_name_changed", character_name)
	animate.play("hide")
	yield(animate, "animation_finished")
