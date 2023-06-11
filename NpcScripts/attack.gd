class_name Attacks
@export_group("Attack")

# Class for our basic attacks, all special attacks are considered spells

static func getAttack(char_class):
	var generic_attack = {
	"Range": 10,
	"Physical" : 5,
	"Magic": 0,
	"Fire": 0,
	"Air": 0,
	"Earth": 0,
	"Water": 0,
	"Light": 0,
	"Shadow": 0,
	"Nature": 0,
	"Electric": 0
}

	var barbarian_attack = {
		"Range": 25,
		"Physical" : 15,
		"Magic": 0,
		"Fire": 0,
		"Air": 0,
		"Earth": 0,
		"Water": 0,
		"Light": 0,
		"Shadow": 0,
		"Nature": 0,
		"Electric": 0
	}

	var attack_lib = {"generic_npc": generic_attack, "barbarian": barbarian_attack}

	return attack_lib[char_class]

static func attackTarget(attacking_node, target_node):
	var physical_damage = attacking_node.attack["Physical"] - target_node.stats["Physical Resistance"]
	var magic_damage = attacking_node.attack["Magic"] - target_node.stats["Magic Resistance"]
	var fire_damage = attacking_node.attack["Fire"] - target_node.stats["Fire Resistance"]
	var air_damage = attacking_node.attack["Air"] - target_node.stats["Air Resistance"]
	var earth_damage = attacking_node.attack["Earth"] - target_node.stats["Earth Resistance"]
	var water_damage = attacking_node.attack["Water"] - target_node.stats["Water Resistance"]
	var light_damage = attacking_node.attack["Light"] - target_node.stats["Light Resistance"]
	var shadow_damage = attacking_node.attack["Shadow"] - target_node.stats["Shadow Resistance"]
	var nature_damage = attacking_node.attack["Nature"] - target_node.stats["Nature Resistance"]
	var electric_damage = attacking_node.attack["Electric"] - target_node.stats["Electric Resistance"]
	var damage_dealt = physical_damage + magic_damage + fire_damage + air_damage + earth_damage + water_damage + light_damage + shadow_damage + nature_damage + electric_damage
	
	print(attacking_node.char_class, " is attacking ", target_node.char_class, "! They deal ", damage_dealt)
	
	target_node.current_health = target_node.current_health - damage_dealt
	
