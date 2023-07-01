class_name Actions
extends Node

var type: String
var additional_actions: Resource

'''
The standard actions in game all Behaviour Nodes reference. These scripts handle the actual implementation of chosen behaviours.

Additional Actions can be optionally loaded from Resources/ActionDefinitions.
'''

func initialize(new_actions):
	self.additional_actions = new_actions

func set_destination(type: String):
	if type:
		match type:
			"Idle":
				self.type = "Idle" 
func set_target():
	return
func attack_target(attacker, defender):
	return
func leave_building(npc, building):
	return
func equip_item(npc, item):
	return
func sell_item(building, item):
	return
func buy_item(building, item):
	return
func use_ability(npc, target_location):
	return
func use_item(npc, item):
	return
func enter_building(npc, building):
	return
func idle():
	return	
