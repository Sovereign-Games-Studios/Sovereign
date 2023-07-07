class_name BehaviourTree
extends Node
'''
This is the basic interface used by NPCs to build their behaviour trees.
'''

# This should be an array of Modular Behaviours
var should_exit = false
# currently processing node
var current_node: BehaviourNode
# Lock for behaviour tree
var mutex = Mutex.new
# current status
var status: String

var root_node: BehaviourNode
var team_state: KingdomState
var parent_npc: NPC
signal interrupt_success

func _process(_delta):
	var npc = self.get_parent()
	if npc.action_queue.size() < 4 and status != "RUNNING":
		process_tree(root_node)
	else:
		await process_action()
	pass

func process_action():
	pass

func initialize(new_root: BehaviourNode, new_state: KingdomState, npc: NPC):
	root_node = new_root
	team_state = new_state
	parent_npc = npc

func process_tree(starting_node: BehaviourNode):
	if should_exit:
		if is_instance_valid(current_node):
			current_node.interrupt(parent_npc)
			current_node = null
		mutex.lock()
		parent_npc.action_queue = []
		mutex.unlock()
		should_exit = false
		interrupt_success.emit()
	else:
		current_node = starting_node
		status = starting_node.think(parent_npc, team_state, mutex)
	
	
func interrupt(priorityNode: BehaviourNode):
	should_exit = true
	interrupt_success.connect(_interrupt_success.bind(priorityNode))
	
func _interrupt_success(priorityNode: BehaviourNode):
	process_tree(npc, priorityNode, team_state)
