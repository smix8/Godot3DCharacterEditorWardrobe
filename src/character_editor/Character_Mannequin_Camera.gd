extends Camera

########################################
### Camera responsible for the spin animations that focuses a bodypart in the character editor
###


onready var animate : AnimationPlayer = $AnimationPlayer

var current_bodypart : String = "default"
var in_transition : bool = false

signal camera_spin_finished



func move_closeup_to(bodypart) -> void:
	
	### handles camera spinning to the selected bodypart
	### animations follow the naming pattern
	### CURRENTBODYPART_to_NEWBODYPART
	
	
	### if the camera is currently spinning don't accept to act on new movement clicks
	if in_transition:
		return
	
	in_transition = true
	
	var next_animation_name : String

	if ( current_bodypart == bodypart ):
		### if we clicked the same category button again we move the camera back to the default position
		next_animation_name = "%s_to_%s" % [current_bodypart, "default"]
		current_bodypart = "default"
		
	else:
		### if we clicked a new category we spin the camera from the current to the new bodypart
		next_animation_name = "%s_to_%s" % [current_bodypart, bodypart]
		current_bodypart = bodypart		

	### play the animation and wait until it has finished
	animate.play(next_animation_name)
	yield(animate, "animation_finished")
	
	### camera spinning is finished, allow for new camera spins and tell everyone interested that we are dizzy now
	in_transition = false
	emit_signal("camera_spin_finished")
