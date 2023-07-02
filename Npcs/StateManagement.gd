extends Node


func handle_state(npc):
	if npc.state == "Combat" and npc.target != null:
		npc.brain.root_node = list_of_bts["Combat"]
