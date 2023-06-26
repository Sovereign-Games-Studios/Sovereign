extends Node

func _init():
	var files = []
	var sub_dirs = []
	var directory
	var base_dir
	if (OS.get_executable_path().get_base_dir().contains("Godot Engine")):
		base_dir = "C:/Users/suhlm/Documents/Sovereign"
	else: 
		base_dir = OS.get_executable_path().get_base_dir()
	directory = DirAccess.open(base_dir)		
	if(directory.dir_exists(base_dir+"/Mods")):	
		base_dir = base_dir+"/Mods"
		directory = DirAccess.open(base_dir)
		print("Base Directory: ", base_dir)
		files = directory.get_files()
		for file in files:
			if file.ends_with(".pck"):
				ProjectSettings.load_resource_pack(base_dir + "/" + file)
				print("loading file: ", file)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
