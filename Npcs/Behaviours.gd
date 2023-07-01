class_name Behaviour

'''
This is the basic interface used by NPCs to build their behaviour trees.

'''
# This should be an array of Modular Behaviours
var root_node: BehaviourNode

func get_next_behaviour(npc_brain: NpcBrain):
	return root_node.think(npc_brain)

func construct_behaviour_tree(npc_type: Resource):
	# Behaviour Tree defined in NPC Definition
	return root_node
	
static func hunt():
	var radius = 2
	var random_position = Vector3(randi_range(-radius, radius), 0, randi_range(-radius, radius))
	return random_position
		
