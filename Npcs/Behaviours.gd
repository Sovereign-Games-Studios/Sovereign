class_name BehaviourTree

'''
This is the basic interface used by NPCs to build their behaviour trees.
'''
var interrupt = false
var current_node: BehaviourNode
func think(npc: NPC, node: BehaviourNode):
	print("NPC in thread: ", npc)
	if interrupt:
		interrupt = false
		current_node.interrupt()
		current_node = null
		return "Failure"
	var best_option: BehaviourNode
	var best_value = 0
	# exits thought process early
	for option_name in node.options:
		var option = GameStateInit.list_of_bts[option_name]
		var option_value = option.definition.consider(npc, GameStateInit)
		if option_value > best_value:
			best_value = option_value
			best_option = option
	if best_option.options.size() > 0:
		think(npc, best_option)
	else:
		npc.action_queue.push_back(best_option.action_list) 
	return "Success"
	
func _adapt(npc: NPC, priorityNode: BehaviourNode):
	interrupt = true
	think(npc, priorityNode)
