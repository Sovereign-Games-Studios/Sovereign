class_name  BehaviourNode
extends Node

# Type of node this is
var type: String
# List of considerations to be taken before node is selected
var considerations: Array
# Node definition
var definition: Resource
# Array of child nodes if any
var child_nodes: Array

var current_node: BehaviourNode
var should_exit = false

var status: String

func initialize(new_definition: Resource):
	definition = new_definition
	considerations = new_definition.considerations
	child_nodes = new_definition.child_nodes
	type = new_definition.type

func think(npc: NPC, kingdom_state: KingdomState, mutex: Mutex):
	if self.child_nodes.size() > 0:
		var best_option = self.child_nodes[0]
		var best_value = 0
		# exits thought process early
		if should_exit:
			should_exit = false
			return "FAILURE"
		for option_name in self.options:
			var option = kingdom_state.list_of_bts[option_name]
			var option_value = option.definition.consider(npc, GameStateInit)
			if option_value > best_value:
				best_value = option_value
				best_option = option
			if best_option.type == "ActionQueue":
				# all action node definitions have the queue_actions function defined within that must be overriden. 
				status = best_option.definition.queue_actions(npc, kingdom_state, mutex)
			else:
				current_node = best_option
				status = best_option.think(npc, kingdom_state, mutex)
			return status
	return "FAILURE"
	
func interrupt(npc: NPC):
	if current_node:
		current_node.interrupt(npc)
		current_node = null
	should_exit = true
	return
