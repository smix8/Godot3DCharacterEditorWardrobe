extends Spatial

#############################################
### Keeps track of the actors current visible equipment meshes and slots
###	Handles equipment changes by replacing the slot's MeshInstance.mesh with a new loaded mesh resource
###	Copies all found and matching Blendshape values from the main Skin MeshInstance to new equiped MeshInstances



var skin : MeshInstance
var hair : MeshInstance
var torso : MeshInstance
var legs : MeshInstance
var feet : MeshInstance
var hands : MeshInstance
var skeleton : Skeleton


### dictionary that holds all found and matching MeshInstance Nodes / equipment slots
var armature : Dictionary = {
	"skin" : null,
	"hair" : null,
	"torso" : null,
	"legs" : null,
	"feet" : null,
	"hands" : null
}



func _ready():
	
	### find the skeleton and all available, matching mesh nodes
	if has_node("Skeleton"):
		skeleton = get_node("Skeleton")
		
		if skeleton.has_node("Skin"):
			skin = skeleton.get_node("Skin")
			armature["skin"] = skin
			
		if skeleton.has_node("Hair"):
			hair = skeleton.get_node("Hair")
			armature["hair"] = hair
			
		if skeleton.has_node("Torso"):
			torso = skeleton.get_node("Torso")
			armature["torso"] = torso
			
		if skeleton.has_node("Legs"):
			legs = skeleton.get_node("Legs")
			armature["legs"] = legs
			
		if skeleton.has_node("Feets"):
			feet = skeleton.get_node("Feets")
			armature["feet"] = feet
			
		if skeleton.has_node("Hands"):
			hands = skeleton.get_node("Hands")
			armature["hands"] = hands



func change_slot_mesh( slot_name : String , new_mesh : ArrayMesh ):

	if skeleton:
		
		match slot_name:
			"skin":
				if skin:
					### if we replace the main skin we need to temp save the current blendshape values or things break
					var saved_blendshapes = skin.get("blend_shapes")
					skin.mesh = new_mesh
					skin.mesh.set("blend_shapes", saved_blendshapes)
			"hair":
				if hair and skin:
					hair.mesh = new_mesh
					copy_blendshape_values_from_skin_to_equipment(hair)
			"torso":
				if torso and skin:
					torso.mesh = new_mesh
					copy_blendshape_values_from_skin_to_equipment(torso)
			"legs":
				if legs and skin:
					legs.mesh = new_mesh
					copy_blendshape_values_from_skin_to_equipment(legs)
			"feet":
				if feet and skin:
					feet.mesh = new_mesh
					copy_blendshape_values_from_skin_to_equipment(feet)
			"hands":
				if hands and skin:
					hands.mesh = new_mesh
					copy_blendshape_values_from_skin_to_equipment(hands)
					
					
					
func _on_changed_mesh_color(new_color, equipment):
	
	### add a material override for a new color on the mesh
	
	if not equipment:
		print("equipment slot missing for color change")
		return
		
	### if our material override is empty we create a new one and than apply the new color override
	if not armature.get(equipment).material_override:
		armature.get(equipment).material_override = SpatialMaterial.new()
	armature.get(equipment).material_override.albedo_color = new_color
	
	
	
func _on_changed_blendshape_value(blendshape_name, value):
	change_character_blendshape(blendshape_name, value)
	


func change_character_blendshape(blendshape_name : String, new_blendshape_value : float):
	
	### applies a new blendshape value to the main skin, than to all current equipment with matching blendshapes
	
	
	### limit the incoming slider values for safety as our blendshapes range between 0 and 1
	new_blendshape_value = clamp(new_blendshape_value, 0.0, 1.0)
	
	### if we can't find a main skin mesh no point in proceeding
	if skin:

		### create the string path to the blendshape value
		var blendshape_path_to_value = "blend_shapes/%s" % blendshape_name
		
		### if we find the blendshape we can start applying the new value
		if skin.get(blendshape_path_to_value) != null:
			
			### apply the new blendshape value to our skin mesh
			skin.set(blendshape_path_to_value, new_blendshape_value)

			### also apply the value to all equiped items with matching blendshape names to prevent clipping
			for key in armature.keys():
				
				### skip the skin mesh
				if key == "skin":
					continue
				
				### if we get a value other than null it means that the mesh has this blendshape
				if armature[key].get(blendshape_path_to_value) != null:
						
					### apply the new blendshape value to our euqipment mesh
					armature[key].set(blendshape_path_to_value, new_blendshape_value)



func copy_blendshape_values_from_skin_to_equipment(equipment):
	
	### copies all matching blendshape values from the main actor skin to new equipment
	
	for blendshape_inx in skin.mesh.get_blend_shape_count():
		var blendshape_name = skin.mesh.get_blend_shape_name( blendshape_inx )
		var blendshape_path_to_value = "blend_shapes/%s" % blendshape_name
		if equipment.get(blendshape_path_to_value) != null:
			equipment.set(blendshape_path_to_value, skin.get(blendshape_path_to_value))
			


func _on_changed_asset(asset_id):
			
	### get the asset loadpath from our mesh libary
	var asset_dict : Dictionary = get_parent().get_parent().get_parent().get_parent().mesh_libary.get(asset_id)
	
	if asset_dict:
		var slot_name = asset_dict.get("slot")
		var new_mesh_path = asset_dict.get("path")
					
		if slot_name and new_mesh_path:
			if new_mesh_path == "none":
				change_slot_mesh( slot_name , null)
			else:
				var new_mesh = load(new_mesh_path)
				change_slot_mesh( slot_name , new_mesh )
