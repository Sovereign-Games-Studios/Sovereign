class_name ItemServices

var item_list
var enchantment_list

func instantiate(available_items):
	self.item_list = available_items

func buyItem(item):
	item_list.push(item)
	
func sellItem(npc, itemName, building):
	var sold_item = null
	for item in item_list:
		if item.name == itemName:
			sold_item = item
	if sold_item and npc in building.current_occupants:
		print("Sold ", sold_item.name, " to ", npc.char_class, ". ", sold_item.name, " has been added to their inventory.")
		npc.inventory.append(sold_item)
		# TODO charge npc gold after
		
func enchantItem(desired_enchant, item):
	if desired_enchant in enchantment_list:
		item.enchantment = desired_enchant
