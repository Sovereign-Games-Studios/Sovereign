class_name Behaviour

'''
This is the basic interface used by NPCs to build their behaviour trees.

'''
# This should be an array of Modular Behaviours
var root_node: BehaviourNode

func think(npc: NPC, node: BehaviourNode):
	var best_option: BehaviourNode
	var best_value = 0
	print("Node is ", node.name)
	print("Options are ", node.options)
	for option_name in node.options:
		var option = GameStateInit.list_of_bts[option_name]
		var option_value = option.definition.consider(npc, GameStateInit)
		if option_value > best_value:
			best_value = option_value
			best_option = option
	print("We have chosen: ", best_option.name)
	if best_option.type == "Option":
		think(npc, best_option)
	elif best_option.type == "Action":
		# Final computation before return.
		best_option.definition.take_action(npc)
	return

	
