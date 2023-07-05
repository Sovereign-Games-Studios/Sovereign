class_name Behaviour

'''
This is the basic interface used by NPCs to build their behaviour trees.

'''
# This should be an array of Modular Behaviours
var should_exit = false
var thinking = false
var main_thought = Thread.new()
var mutex = Mutex.new()

func think(npc: NPC, node: BehaviourNode):
	thinking = true
	var best_option: BehaviourNode
	var best_value = 0
	# exits thought process early
	if should_exit:
		mutex.lock()
		should_exit = false
		thinking = false
		mutex.unlock()
		return
	for option_name in node.options:
		var option = GameStateInit.list_of_bts[option_name]
		var option_value = option.definition.consider(npc, GameStateInit)
		if option_value > best_value:
			best_value = option_value
			best_option = option
	if best_option.type == "Option":
		think(npc, best_option)
	elif best_option.type == "Action":
		thinking = false
		# Finalg computation before return.
		npc.state = best_option.definition.take_action(npc, GameStateInit)
	return
	
func start_thinking(npc: NPC, node: BehaviourNode):
	main_thought.start(think.bind(npc, node), 1)
	main_thought.wait_to_finish()
	
func _adapt(npc: NPC, priorityNode: BehaviourNode):
	mutex.lock()
	should_exit = true # Protect with Mutex.
	mutex.unlock()
	main_thought.wait_to_finish()
	start_thinking(npc, priorityNode)
