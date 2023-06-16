class_name Npc_Scenes

func get_npc_scene(npc_name):
	match npc_name:
		"Tax Collector":
			return preload("res://NpcScripts/guard_scene.tscn")
		"Guard":
			return preload("res://NpcScripts/guard_scene.tscn")
		"Peasant":
			return preload("res://NpcScripts/guard_scene.tscn")
		"Enemy":
			return preload("res://NpcScripts/guard_scene.tscn")
