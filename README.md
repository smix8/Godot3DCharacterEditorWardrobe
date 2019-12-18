
# Godot 3D Character Editor with Blendshapes and Wardrobe
Example project made with Godot 3.2 beta2

![char_edit](https://user-images.githubusercontent.com/52464204/71067042-24782d00-2174-11ea-8abb-94a12e33e434.gif)

## Features | Examples:

- Prepared asset slots for skin, hair, torso, legs, and feet but additonal slots can be created
- Example for changing a characters clothes by replacing meshes with a button menu
- Export variables to lock or unlock assets in the button menu
- Example for loading blendshape values on both character skin and clothing with a slider
- Example for changing mesh colors with a color picker e.g. haircolor
- Example for creating camera spins to switch and focus between different body parts
- Example for a character naming popup that saves and displays the input
- Ruby colors!

## NOT included:
- 3d character from the demo, bring your own actor skeleton with meshes.

## Setup | Usage

### Step 1
Place your asset images in the '\assets\images\wardrobes' subfolder and give them a unique name to use as an id
( not mandatory for this version but an automatic import for the assets is on the way and this will be the intended folder structure to function )

![asset_images_setup](https://user-images.githubusercontent.com/52464204/71061545-921e5c00-2168-11ea-896e-4270e87f576f.jpg)

### Step 2
Prepare your mesh assets by loading them on your skeleton actor with the blendshapes and then save them as mesh resources in the '\assets\meshes' subfolder

![mesh_saving](https://user-images.githubusercontent.com/52464204/71061779-18d33900-2169-11ea-860e-a0a5fcf07c4b.jpg)

### Step 3
On the begin of the 'Character_Editor' script find the 'mesh_libary' dictionary add key:value pairs of your image_name as key, and your mesh resource path as value

![meshlibary_setup](https://user-images.githubusercontent.com/52464204/71075879-167ed800-2185-11ea-9df2-009d9cb6db4e.jpg)

(Optional) I would advice moving the dictionary to an autoload for your full game project to not break paths easily in the future. I did on my own project but couldn't add it to this example and make it stand-alone without breaking a million things. Change the current way of getting the path on around codeline 182 in the 'Actor_Mesh_Equipment' script that needs the 'mesh_libary' to load the new meshes.

### Step 4
Add key:value pairs to the 'blendshape_to_category' dictionary with the blendshape name as key and the intended equipmentslot as value

![blendshape_setup](https://user-images.githubusercontent.com/52464204/71061559-977ba680-2168-11ea-8f93-9c924daa1178.jpg)

(Optional) Replace the sometimes very ugly blendshape names by using the 'blendshape_renames' dictionary

### Step 5
For the interface add as many 'Character_Asset_Button' instances as needed in the named gridcontainers for the bodyparts

![asset_button_setup](https://user-images.githubusercontent.com/52464204/71061535-8cc11180-2168-11ea-8845-5f46cd045b52.jpg)

### Step 6
Fill in the export variables, your key from the mesh_libary as the 'asset_id', choose a slot, a display name and drag in your image manually or do everything by code

![asset_export_vars](https://user-images.githubusercontent.com/52464204/71061670-de699c00-2168-11ea-8915-5241aee989c7.jpg)

### Step 7
Open the 'Actor' Scene and replace the 'Skeleton' node with your own character skeleton. If you have to delete the placeholder children for this just add new MeshInstances again and name them the same or leave those out that you don't want to use (skin is mandatory).

![actor_setup](https://user-images.githubusercontent.com/52464204/71070014-3066ed80-217a-11ea-9dec-eefacbe79d5c.jpg)


## License
MIT or my personal 'Don't care' license, do whatever you want with this example and create something fun in 3d to overcome the 2d curse in godot god-dang it.
## Known Issues
I created the editor fast and dirty in a few hours and while it works there might be some ugly parts. Moved it from a larger project of mine to share and make it stand-alone but didn't test it for long, so might have missed a dependency. Added some quick code documentation full of typos and stupidity in the end, enjoy!

On rare occasion pre-equipped clothing meshes on the actor bug out on first scene load for no apparent reason. The code doesn't touch them so might be some hidden issue elsewhere.
