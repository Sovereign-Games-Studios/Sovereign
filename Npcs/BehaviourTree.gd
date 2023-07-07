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
var mutex = Mutex.new()
# current tree status
var tree_status: String
# current activity
var current_action
# current action status
var action_status
# Root Node of the Behaviour Tree, only used at init or in fail states
var root_node: BehaviourNode
# World State visible to this behaviour tree, usually dependent on attached npc
var team_state: KingdomState
# Owner of the Behaviour Tree
var parent_npc: NPC
# Signal for tracking if our interrupt went through
signal interrupt_success

func _process(_delta):
	if 	parent_npc.action_queue.size() < 4 and tree_status != "RUNNING" and not should_exit:
		process_tree(self.root_node)
	if parent_npc.action_queue.size() > 0 and not should_exit:
		if action_status == "FAILURE":
			print("ERROR: Action {action} failed!".format({"action": current_action}))
			current_action = null
			await process_action()
		elif action_status == "SUCCESS":
			await process_action()		
		elif action_status == "RUNNING":
			pass	
		# Just send it if we fall through.
		else:
			await process_action()		
	pass

func process_action():
	# If we manage to catch it here first
	if should_exit:
		# Might be necessary to force us back into the tree
		mutex.lock()		
		current_action = parent_npc.action_queue.pop_front()
		mutex.unlock()				
		current_action = null
		action_status = "FAILURE"
		return
	else:
		action_status = "RUNNING"		
		mutex.lock()		
		current_action = parent_npc.action_queue.pop_front()
		mutex.unlock()		
		if current_action != null:
			action_status = await current_action.call(parent_npc, team_state)
			return
		else:
			action_status = "FAILURE"
			return 

func initialize(new_root: BehaviourNode, new_state: KingdomState, npc: NPC):
	print("INITIALIZED BEHAVIOUR TREE WITH: {root}, {new_state}, {npc}".format({"root": new_root, "new_state": new_state, "npc": npc}))
	self.root_node = new_root
	self.team_state = new_state
	self.parent_npc = npc

func process_tree(starting_node: BehaviourNode):
	tree_status = "RUNNING"
	if should_exit:
		if is_instance_valid(current_node):
			current_node.interrupt(parent_npc)
			current_node = null
		mutex.lock()
		parent_npc.action_queue = []
		mutex.unlock()
		should_exit = false
		interrupt_success.emit()
		tree_status == "SUCCESS"
		return
	else:
		current_node = starting_node
		tree_status = starting_node.think(parent_npc, team_state, mutex)
	if tree_status == "RUNNING":
		process_tree(current_node)
	elif tree_status == "FAILED":
		print("ERROR: Behaviour Tree Failed.")
		process_tree(root_node)
	elif tree_status == "SUCCESS":
		return 
		
func interrupt(priorityNode: BehaviourNode):
	should_exit = true
	interrupt_success.connect(_interrupt_success.bind(priorityNode))
	
func _interrupt_success(priorityNode: BehaviourNode):
	process_tree(priorityNode)
	interrupt_success.disconnect(_interrupt_success)
