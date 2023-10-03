class_name ShoppingHandler
extends Node

# Team state exposes all the items available
var team_state

'''
Handler for equipment inventory change signal on team

TODO: Better decision making and weights for this, probably break it out into its own file too.
'''

func _shopper(npc: NPC):
	for item_list in npc.team_state.available_items:
		for new_item in npc.team_state.available_items[item_list]:
			_item_check(npc, new_item)
			
func _item_check(npc: NPC, new_item: Resource):
	for equipment sin npc.equipment.current_equipment:
		# If the item we are looking at doesn't match the slot, skip it.
		if equipment != new_item.type:
			continue
		if npc.equipment.current_equipment[equipment] != null:
			var current_item = npc.equipment.current_equipment[equipment]
			var new_item_stat
			var current_item_stat 
			match npc.definition.primary_stat:
				"strength":
					print("matched")
					new_item_stat = new_item.strength
					if npc.equipment.desired_equipment[equipment] != null:
						current_item_stat = npc.equipment.desired_equipment[equipment].strength	
					else:														
						current_item_stat = current_item.strength
				"agility":
					new_item_stat = new_item.agility
					if npc.equipment.desired_equipment[equipment] != null:
						current_item_stat = npc.equipment.desired_equipment[equipment].agility	
					else:														
						current_item_stat = current_item.agility
				"charisma":
					new_item_stat = new_item.charisma
					if npc.equipment.desired_equipment[equipment] != null:
						current_item_stat = npc.equipment.desired_equipment[equipment].charisma	
					else:														
						current_item_stat = current_item.charisma
				"stamina":
					new_item_stat = new_item.stamina
					if npc.equipment.desired_equipment[equipment] != null:
						current_item_stat = npc.equipment.desired_equipment[equipment].stamina	
					else:														
						current_item_stat = current_item.stamina
				"wisdom":
					new_item_stat = new_item.wisdom
					if npc.equipment.desired_equipment[equipment] != null:
						current_item_stat = npc.equipment.desired_equipment[equipment].wisdom	
					else:														
						current_item_stat = current_item.wisdom
				"spirit":
					new_item_stat = new_item.spirit
					if npc.equipment.desired_equipment[equipment] != null:
						current_item_stat = npc.equipment.desired_equipment[equipment].spirit	
					else:														
						current_item_stat = current_item.spirit
					
			if _compare_items(new_item_stat, current_item_stat):
				npc.equipment.desired_equipment[equipment] = new_item
		else: 
			npc.equipment.desired_equipment[equipment] = new_item
'''
Compares two items against the NPCs desired roles
'''
func _compare_items(new_item, current_item):
	print("Comparing items.")
	if new_item > current_item:
		return true
	return false
