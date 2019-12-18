extends Spatial

##################################################
### Character Editor node
### Uses a Viewport for the 3d character to allow for additonal independent scene elements
### e.g. lightchanges, other characters, animated scene backgrounds, ...
###
###	Place your own character 'Skeleton' node as a child of the 'Actor' node
### Add MeshInstance nodes to the skeleton and match the names for the equipmentslots



###############
###  SETUP  ###
###############
###
### dictionary that holds all asset_id's and their resource loading paths
### in a real game should be replaced with an autoload accessable by all other nodes that need to load meshes
### dummy placeholders to give you an idea, replace with your own image filenames / asset_id's and mesh resource paths
var mesh_libary : Dictionary = {
	"dummy_item_name_01" : "res://assets/meshes/dummy_item_name_01.mesh",
	"dummy_item_name_02" : "res://assets/meshes/dummy_item_name_02.mesh",
	"dummy_item_name_03" : "res://assets/meshes/dummy_item_name_03.mesh",
	"dummy_item_name_04" : "res://assets/meshes/dummy_item_name_04.mesh",
	"dummy_item_name_05" : "res://assets/meshes/dummy_item_name_05.mesh"
}

### renames the sometimes ugly blendshape names to more userfriendly names before displaying them
var blendshape_renames : Dictionary = {
	"BlendShape1" : "First Blendshape",
	"BlendShape2" : "Second Blendshape",
	"BlendShape3" : "Third Blendshape",
}

### links the blendshape names to an appropriated category to later add them to the right menu
var blendshape_to_category : Dictionary = {
	"BlendShape1" : "torso",
	"BlendShape2" : "legs",
	"BlendShape3" : "feet"
}





### holds access to the container nodes by category key
### gets 'category:node' pairs on _ready() from the export nodepaths
var category_to_node : Dictionary = {}

export(PackedScene) onready var animated_background_scene

var actor : Spatial
var character_property_template : PackedScene = preload("res://gui/character_editor/Character_Editor_Property.tscn")

onready var mannequin = $ViewportContainer/Viewport/Character_Mannequin
onready var camera = $ViewportContainer/Viewport/Character_Mannequin/Character_Mannequin_Camera
onready var namechange_popup = $Namechange_Popup



func _ready():
	
	### if we have an animated background add it to the scene
	if animated_background_scene:
		add_child(animated_background_scene.instance())
		
	
	### check if we have a skeleton and actor at the right position before we explode in a thousand error messages
	if has_node("ViewportContainer/Viewport/Character_Mannequin/Actor/Skeleton"):
		actor = get_node("ViewportContainer/Viewport/Character_Mannequin/Actor")
		
		### assigning and connect all the nodes from the export nodepaths
		assign_nodepaths()
		
		
		### loop through all available blendshapes on the main actor skin
		if actor.skin.mesh:
			for blendshape_inx in actor.skin.mesh.get_blend_shape_count():
				
				### find the blendshape name
				var blendshape_name = actor.skin.mesh.get_blend_shape_name( blendshape_inx )
				
				### find the right category for this blendshape
				var blendshape_category = blendshape_to_category.get(blendshape_name)
				
				### if we have no category setup for this blendshape ignore it
				if not blendshape_category:
					continue
				
				var new_blendshape_slider : HSlider = character_property_template.instance()
				
				### rename our blendshape name to something more user friendly for the label
				new_blendshape_slider.display_text = blendshape_renames.get(blendshape_name, blendshape_name)
				new_blendshape_slider.blendshape_name = blendshape_name
				
				### find the right container node with the help of our dict and add the new slider
				category_to_node[blendshape_category].add_child(new_blendshape_slider)
				
				### connect the slider with our actor node so everytime the value changes the blendshapes get updated
				new_blendshape_slider.connect("changed_blendshape_value", actor, "_on_changed_blendshape_value")

		### connect the colorpicker with our actor node so the colorcode for the material_overwrite gets updated
		hair_colorpicker.connect("changed_mesh_color", actor, "_on_changed_mesh_color")
		

	### connect with our camera so we know when the current camera spin has ended
	camera.connect("camera_spin_finished", self , "_on_camera_spin_finished")
	
	
	
	### connect the namechange box, so we can update the displays and maybe save the name somewhere else
	namechange_popup.connect("character_name_changed", self, "_on_character_name_changed")



func _on_character_name_changed(new_name):
	
	### update displays with the new name and maybe save somewhere else as well to be persistent
	
	$Character_Editor_Menu/MarginContainer/HBoxContainer/Properties_ScrollContainer/VBoxContainer/Name_VBox/Name_Button.text = new_name
	
	
	
func _on_camera_spin_finished():
	
	### code that should execute when the camera has finished spinning to a new bodypart
	
	pass
	


func _on_category_button_pressed(category_name):
	
	### when we press a category button start the right cameraspin and show the right dropdown menu
	
	print("category_name %s" % category_name)
		
	### hide all dropdowns
	head_properties_container.visible = false
	torso_properties_container.visible = false
	legs_properties_container.visible = false
	feet_properties_container.visible = false
	
	### match with the category, show the dropdown and start the camera spin to the bodypart
	match category_name:
		"head":	
			head_properties_container.visible = true
			camera.move_closeup_to(category_name)
		"torso":
			torso_properties_container.visible = true
			camera.move_closeup_to(category_name)
		"legs":
			legs_properties_container.visible = true
			camera.move_closeup_to(category_name)
		"feet":
			feet_properties_container.visible = true
			camera.move_closeup_to(category_name)



func _on_Confirm_Button_pressed():
	pass
	### start your game or whatever happens after the character editor
	


func _on_Cancel_Button_pressed():
	get_tree().quit()
	### return to the scene before the character editor opened
	
	
	
func assign_nodepaths() -> void:
	
	### assigns and connects all the nodes from the export nodepaths
	
	hair_colorpicker = get_node(hair_colorpicker_path)	
	head_properties_container = get_node(head_properties_path)
	torso_properties_container = get_node(torso_properties_path)
	legs_properties_container = get_node(legs_properties_path)
	feet_properties_container = get_node(feet_properties_path)
	head_category_button = get_node(head_category_button_path)
	torso_category_button = get_node(torso_category_button_path)
	legs_category_button = get_node(legs_category_button_path)
	feet_category_button = get_node(feet_category_button_path)
	category_to_node["head"] = head_properties_container
	category_to_node["torso"] = torso_properties_container
	category_to_node["legs"] = legs_properties_container
	category_to_node["feet"] = feet_properties_container
	
	head_category_button.connect("pressed", self, "_on_category_button_pressed", ["head"])
	torso_category_button.connect("pressed", self, "_on_category_button_pressed", ["torso"])
	legs_category_button.connect("pressed", self, "_on_category_button_pressed", ["legs"])
	feet_category_button.connect("pressed", self, "_on_category_button_pressed", ["feet"])
	
	hair_assets_gridcontainer = get_node(hair_assets_gridcontainer_path)
	torso_assets_gridcontainer = get_node(torso_assets_gridcontainer_path)
	legs_assets_gridcontainer = get_node(legs_assets_gridcontainer_path)
	feet_assets_gridcontainer = get_node(feet_assets_gridcontainer_path)
	for asset in hair_assets_gridcontainer.get_children():
		asset.connect("character_asset_clicked", actor, "_on_changed_asset")
	for asset in torso_assets_gridcontainer.get_children():
		asset.connect("character_asset_clicked", actor, "_on_changed_asset")
	for asset in legs_assets_gridcontainer.get_children():
		asset.connect("character_asset_clicked", actor, "_on_changed_asset")
	for asset in feet_assets_gridcontainer.get_children():
		asset.connect("character_asset_clicked", actor, "_on_changed_asset")


### nodepath picker for all script relevant nodes for comfort
### rearranging the node structure for the ui and then retyping all the paths is no fun afterall
### placed at the bottom because you guys take up way to much space at the top!
export(NodePath) onready var hair_colorpicker_path
var hair_colorpicker : ColorPicker
export(NodePath) onready var head_properties_path
export(NodePath) onready var torso_properties_path
export(NodePath) onready var legs_properties_path
export(NodePath) onready var feet_properties_path
var head_properties_container : VBoxContainer
var torso_properties_container : VBoxContainer
var legs_properties_container : VBoxContainer
var feet_properties_container : VBoxContainer
export(NodePath) onready var head_category_button_path
export(NodePath) onready var torso_category_button_path
export(NodePath) onready var legs_category_button_path
export(NodePath) onready var feet_category_button_path
var head_category_button : Button
var torso_category_button : Button
var legs_category_button : Button
var feet_category_button : Button
export(NodePath) onready var hair_assets_gridcontainer_path
export(NodePath) onready var torso_assets_gridcontainer_path
export(NodePath) onready var legs_assets_gridcontainer_path
export(NodePath) onready var feet_assets_gridcontainer_path
var hair_assets_gridcontainer : GridContainer
var torso_assets_gridcontainer : GridContainer
var legs_assets_gridcontainer : GridContainer
var feet_assets_gridcontainer : GridContainer
