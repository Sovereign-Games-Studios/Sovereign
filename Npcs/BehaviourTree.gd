class_name BehaviourTree
extends Node
'''
This is the basic interface used by NPCs to build their behaviour trees.
'''

# Interrupt flag
var should_exit = false
# currently processing node
var current_node: BehaviourNode
# Lock for behaviour tree
var mutex = Mutex.new()
# current tree status
var tree_status: String
# current activity
var current_action = null
# current action status
var action_status
# Root Node of the Behaviour Tree, only used at init or in fail states
var root_node: BehaviourNode
# World State visible to this behaviour tree, usually dependent on attached npc
var team_state: TeamState
# Owner of the Behaviour Tree
var parent_npc: NPC
# Signal for tracking if our interrupt went through
signal interrupt_success

var ticks_since_last_action = 0

func _process(_delta):
	if parent_npc.state == "idle":
		process_tree(self.root_node)
	if 	(parent_npc.action_queue.size() < 4 and tree_status != "RUNNING"):
		process_tree(self.root_node)
	if current_action == null and not should_exit:
		ticks_since_last_action = 0
		# On success or no current action, we process a new one
		mutex.lock()
		current_action = parent_npc.action_queue.pop_front()
		mutex.unlock()
		action_status = process_action(current_action)
	elif parent_npc.action_queue.size() > 0 and not should_exit:
		if action_status == "RUNNING" and current_action != null and ticks_since_last_action < 500:
			ticks_since_last_action += 1
			action_status = process_action(current_action)
			return
		elif action_status == "FAILURE":
			parent_npc.state = "idle"
			# If we failed, reset our queue
			# print("ERROR: Action {action} failed!".format({"action": current_action}))
			ticks_since_last_action = 0
			current_action = null
			should_exit = true
			interrupt(root_node)
			return		
		else: 
			ticks_since_last_action = 0
			# On success or no current action, we process a new one
			mutex.lock()
			current_action = parent_npc.action_queue.pop_front()
			mutex.unlock()
			action_status = process_action(current_action)
	elif should_exit:
			# Immediately halt actions and clear queue
			mutex.lock()
			current_action = null
			parent_npc.action_queue = []		
			mutex.unlock()
			action_status = "FAILURE"
			
			# Process new behaviour
			process_tree(self.root_node)			
	pass

func process_action(action: Callable):
	# call the action and get its current status
	current_action = action
	return(action.call(parent_npc, team_state))

	
func initialize(new_root: BehaviourNode, new_state: TeamState, npc: NPC):
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
