class_name Statistics

# painful godot formatting I apologize but its the only way to get this to be useable outside this file
static func getStats(char_class):
	var generic_npc_block = {
	"Strength": 10,
	"Spirit": 10,
	"Stamina": 10,
	"Agility": 10,
	"Charisma": 10,
	"Wisdom": 10,
	"Intelligence": 10,
	"Physical Resistance": 0,
	"Magic Resistance": 0,
	"Fire Resistance": 0,
	"Air Resistance": 0,
	"Earth Resistance": 0,
	"Water Resistance": 0,
	"Electric Resistance": 0,
	"Nature Resistance": 0,
	"Shadow Resistance": 0,
	"Light Resistance": 0
}

	var barbarian_block = {
		"Strength": 18,
		"Spirit": 10,
		"Stamina": 18,
		"Agility": 10,
		"Charisma": 10,
		"Wisdom": 10,
		"Intelligence": 10,
		"Physical Resistance": 10,
		"Magic Resistance": 0,
		"Fire Resistance": 0,
		"Air Resistance": 0,
		"Earth Resistance": 0,
		"Water Resistance": 0,
		"Electric Resistance": 0,
		"Nature Resistance": 0,
		"Shadow Resistance": 0,
		"Light Resistance": 0
	}


	var stat_lib = {"generic_npc": generic_npc_block, "barbarian": barbarian_block}

	return stat_lib[char_class]
