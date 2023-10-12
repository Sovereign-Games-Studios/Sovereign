class_name ShoppingHandler
extends Node

# Team state exposes all the items available
var team_state
var desired_weapon: Item = null
var desired_head: Item = null
var desired_neck: Item = null
var desired_shoulders: Item = null
var desired_chest: Item = null
var desired_hands: Item = null
var desired_legs: Item = null
var desired_feet: Item = null
var desired_ring: Item = null
var desired_trinket: Item = null

'''
Handler for equipment inventory change signal on team

TODO: Better decision making and weights for this, probably break it out into its own file too.
'''

func _shopper(npc: NPC):
	for item_list in npc.team_state.available_items:
		for new_item in npc.team_state.available_items[item_list]:
			_item_check(npc, new_item)
			
func _item_check(npc: NPC, new_item: Resource):
	print(npc.equipment_handler)
	var equipment = npc.equipment_handler.current_equipment[new_item.equipment_slot]
	if equipment != null:
		var current_item = equipment
		var new_item_stat
		var current_item_stat 
		match npc.definition.primary_stat:
			"strength":
				print("matched")
				new_item_stat = new_item.strength
				if equipment != null:
					current_item_stat = equipment.strength	
				else:														
					current_item_stat = current_item.strength
			"agility":
				new_item_stat = new_item.agility
				if equipment != null:
					current_item_stat = equipment.agility	
				else:														
					current_item_stat = current_item.agility
			"charisma":
				new_item_stat = new_item.charisma
				if equipment != null:
					current_item_stat = equipment.charisma	
				else:														
					current_item_stat = current_item.charisma
			"stamina":
				new_item_stat = new_item.stamina
				if equipment != null:
					current_item_stat = equipment.stamina	
				else:														
					current_item_stat = current_item.stamina
			"wisdom":
				new_item_stat = new_item.wisdom
				if equipment != null:
					current_item_stat = equipment.wisdom	
				else:														
					current_item_stat = current_item.wisdom
			"spirit":
				new_item_stat = new_item.spirit
				if equipment[equipment] != null:
					current_item_stat = equipment.spirit	
				else:														
					current_item_stat = current_item.spirit
				
		if _compare_items(new_item_stat, current_item_stat):
			npc.equipment_handler.desired_equipment[new_item.equipment_slot] = new_item
	else: 
		npc.equipment_handler.desired_equipment[new_item.equipment_slot] = new_item
'''
Compares two items against the NPCs desired roles
'''
func _compare_items(new_item, current_item):
	print("Comparing items.")
	if new_item > current_item:
		return true
	return false
