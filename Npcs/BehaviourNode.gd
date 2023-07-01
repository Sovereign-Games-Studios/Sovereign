class_name BehaviourNode
extends Node

# Type of reasoner this is. Should either be an Action or another Reasoner
var type: String
# List of considerations for choosing this specific reasoner
var considerations: Array
# List of child reasoners, if any
var options: Array

func initialize(behaviour_definition):
	# Defined in Resources/BehaviourNodeDefinitions
	self.name = behaviour_definition.name
	self.type = behaviour_definition.type
	self.considerations = behaviour_definition.considerations
	self.options = behaviour_definition.options

func think(npc_brain: NpcBrain):
	var best_option = {"Idle": 0}
	for option in options:
		var option_val = consider(option, npc_brain)
		if option_val > best_option[0]:
			best_option = {option: option_val}
	best_option = best_option.keys()[0]
	
		

	
