class_name OptionNode
extends BehaviourNode

# array of further options to be chosen from when this option is selected
var options: Array 
		
func initialize(option_def):
	option_def.get_script()	
	self.definition = option_def
	self.name = option_def.name
	self.options = option_def.options
	self.considerations = option_def.considerations
	self.type = "Option"
	
