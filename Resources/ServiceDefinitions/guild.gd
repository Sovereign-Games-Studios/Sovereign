extends Node

func recruit_npc(npc_name, building):
	var npc_scene = load("res://NpcScripts/guard_scene.tscn")
	var maximum_npcs = building.building_definition.recruitable_npcs
	for npc_type in maximum_npcs:
		if self.recruited_npcs[npc_type].size() < maximum_npcs[npc_type]:
			var npc = npc_scene.instantiate()
			var spawn_location = self.get_node("SpawnPath/SpawnLocation").position
			npc.initialize(spawn_location)
			if npc.team == "player":
				npc.add_to_group("Player Entities")
			self.recruited_npcs[npc_type].append(npc)
			add_child(npc)
			print("Spawned NPC of type: ", npc_type, " using entity: ", npc.char_class, " at ", spawn_location)
			# We only want to spawn once a tick. 
			return
	
func cast_guild_spell(spell_name):
	pass
