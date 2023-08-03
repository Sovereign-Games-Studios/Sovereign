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

func initialize(new_definition: Resource):
	definition = new_definition
	considerations = new_definition.considerations
	child_nodes = new_definition.child_nodes
	type = new_definition.type

func think(npc: NPC, kingdom_state: TeamState, mutex: Mutex):
	if self.child_nodes.size() > 0:
		var status
		var best_option = kingdom_state.list_of_bts["idle"]
		var best_value = 0
		# exits thought process early
		for option_name in self.child_nodes:
			var option = kingdom_state.list_of_bts[option_name]
			var option_value = option.definition.consider(npc, kingdom_state)
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
	return
	
func reconsider(npc: NPC, kingdom_state: TeamState, mutex: Mutex, option):
	var role = npc.definition.role
	var stat_prio = npc.definition.stat_priority
	var value = 0
	var considerations = 3
	if option.earns_exp:
		value += 10
	if option.earns_gold:
		value += 10
	if option.improves_stat:
		value += 10
	if option.is_combat:
		considerations += 1
		if role == "damage" or role == "tank":
			value += 10
		else:
			value -= 10
	
	
	return
