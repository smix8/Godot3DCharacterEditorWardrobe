tool
extends Button

export(String) var asset_id
export(String, "skin", "hair", "torso", "legs", "feet", "arms") var asset_slot
export(bool) var unlocked = false setget _set_unlocked
export(String) var display_name
export(Texture) var image

signal character_asset_clicked

func _ready():	
	$TextureRect.texture = image

func _set_unlocked(value):
	unlocked = value	
	$Unlocked_Image.visible = !unlocked
	if unlocked:
		get("custom_styles/normal").set("bg_color", "dadada")
	else:
		get("custom_styles/normal").set("bg_color", "2b2b2b")
	return unlocked


func _on_Button_pressed():
	if unlocked:
		emit_signal("character_asset_clicked", asset_id)
