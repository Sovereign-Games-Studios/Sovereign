class_name Attacks
@export_group("Attack")

# Class for our basic attacks, all special attacks are considered spells

static func getAttack(char_class):
	var generic_attack = {
	"Range": 10,
	"Speed": 3,
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
		"Speed": 3,
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
	var physical_damage = attacking_node.attack["Physical"] * (1 - target_node.stats["Physical Resistance"])
	if physical_damage < 0:
		physical_damage = 0
	var magic_damage = attacking_node.attack["Magic"] * (1 - target_node.stats["Magic Resistance"])
	if magic_damage < 0:
		magic_damage = 0
	var fire_damage = attacking_node.attack["Fire"] * (1 - target_node.stats["Fire Resistance"])
	if fire_damage < 0:
		fire_damage = 0
	var air_damage = attacking_node.attack["Air"] * (1 - target_node.stats["Air Resistance"])
	if air_damage < 0:
		air_damage = 0
	var earth_damage = attacking_node.attack["Earth"] * (1 - target_node.stats["Earth Resistance"])
	if earth_damage < 0:
		earth_damage = 0
	var water_damage = attacking_node.attack["Water"] * (1 - target_node.stats["Water Resistance"])
	if water_damage < 0:
		water_damage = 0
	var light_damage = attacking_node.attack["Light"] * (1 - target_node.stats["Light Resistance"])
	if light_damage < 0:
		light_damage = 0
	var shadow_damage = attacking_node.attack["Shadow"] * (1 - target_node.stats["Shadow Resistance"])
	if shadow_damage < 0:
		shadow_damage = 0
	var nature_damage = attacking_node.attack["Nature"] * (1 - target_node.stats["Nature Resistance"])
	if nature_damage < 0:
		nature_damage = 0
	var electric_damage = attacking_node.attack["Electric"] * (1 - target_node.stats["Electric Resistance"])
	if electric_damage < 0:
		electric_damage = 0
	var damage_dealt = physical_damage + magic_damage + fire_damage + air_damage + earth_damage + water_damage + light_damage + shadow_damage + nature_damage + electric_damage
	if damage_dealt < 0:
		damage_dealt = 0
	print(attacking_node.char_class, " is attacking ", target_node.char_class, "! They deal ", damage_dealt)
	
	target_node.current_health = target_node.current_health - damage_dealt
	
