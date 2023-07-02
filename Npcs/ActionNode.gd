class_name ActionNode
extends BehaviourNode


# Called when the node enters the scene tree for the first time.
func initialize(action_def):
	action_def.get_script()	
	self.definition = action_def
	self.name = action_def.name
	self.considerations = action_def.considerations
	self.type = "Action"
