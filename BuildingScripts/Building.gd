extends CharacterBody3D
class_name Building

var building_type
var team
# We'll see if we use this attribute
var level
var max_health
var current_health
var stats
var recruitable_npc_type
# array of existing npcs tied to this building, the length of which is compared against maximum to determine if more can be recruited/spawned
var npcs
# Dictionary of NPC types building seeks to generate and maximum it can keep, will generate more npcs until limit is reached. 
var maximum_npcs
# array of npcs currently occupying this building
var current_occupants

# Must check to see if these are on the map before construction is allowed
var prerequisites

# only relevant to pc buildings
var cost 
var services
var upgrades


func _recruit_on_timer_timeout(NpcScenes):
	for npc_type in maximum_npcs:
		if npcs[npc_type].size() < maximum_npcs[npc_type]:
			var npc_scene = NpcScenes.get_npc_scene(npc_type)
			var npc = npc_scene.instantiate()
			var spawn_location = self.get_node("SpawnPath/SpawnLocation").position
			npc.initialize(spawn_location)
			if npc.team == "player":
				npc.add_to_group("Player Entities")
			npcs[npc_type].append(npc)
			add_child(npc)
			print("Spawned NPC of type: ", npc_type, " using entity: ", npc.char_class, " at ", spawn_location)
			# We only want to spawn once a tick. 
			return
