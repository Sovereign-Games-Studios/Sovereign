class_name EquippedItems

var armor
var weapon
var trinkets

func initialize():
	pass

static func equipItem(npc, itemName):
	var item = null
	for object in npc.inventory:
		if object.name == itemName:
			item = object
	if item:
		print(npc.char_class, " is equipping ", item.name, ".")			
		if item.type == "Armor":
			# store old item away
			if npc.equipped_items.armor:
				npc.inventory = npc.equipped_items.armor
			# equip new item
			npc.equipped_items.armor = item	
			npc.stats += item.stats				
		elif item.type == "Weapon":
			# store old item away
			if npc.equipped_items.weapon:
				npc.inventory.append(npc.equipped_items.weapon)
			# equip new item
			npc.inventory.remove_at(npc.inventory.find(item))
			npc.equipped_items.weapon = item
			print("stats before equipped: ", npc.stats)
			for key in npc.stats:
				npc.stats[key] += item.stats[key]
			print("stats after equipped: ", npc.stats)
		# No limit to trinkets currently
		elif item.type == "Trinket":
			npc.equipped_items.trinkets.append(item)
			npc.stats += item.stats	
			
	

