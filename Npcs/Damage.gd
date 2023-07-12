class_name Damage


static func calculateDamage(attacker, defender):
	var attacking_node = attacker.basic_attack
	var target_node = defender.attributes
	var physical_damage = (attacking_node.physical + attacker.definition.strength) * (1 - target_node.physical_resistance)
	if physical_damage < 0:
		physical_damage = 0
	var magic_damage = attacking_node.magic * (1 - target_node.magic_resistance)
	if magic_damage < 0:
		magic_damage = 0
	var fire_damage = attacking_node.fire * (1 - target_node.fire_resistance)
	if fire_damage < 0:
		fire_damage = 0
	var air_damage = attacking_node.air * (1 - target_node.air_resistance)
	if air_damage < 0:
		air_damage = 0
	var earth_damage = attacking_node.earth * (1 - target_node.earth_resistance)
	if earth_damage < 0:
		earth_damage = 0
	var water_damage = attacking_node.water * (1 - target_node.water_resistance)
	if water_damage < 0:
		water_damage = 0
	var light_damage = attacking_node.light * (1 - target_node.light_resistance)
	if light_damage < 0:
		light_damage = 0
	var shadow_damage = attacking_node.shadow * (1 - target_node.shadow_resistance)
	if shadow_damage < 0:
		shadow_damage = 0
	var nature_damage = attacking_node.nature * (1 - target_node.nature_resistance)
	if nature_damage < 0:
		nature_damage = 0
	var electric_damage = attacking_node.electric * (1 - target_node.electric_resistance)
	if electric_damage < 0:
		electric_damage = 0
	var damage_dealt = physical_damage + magic_damage + fire_damage + air_damage + earth_damage + water_damage + light_damage + shadow_damage + nature_damage + electric_damage
	if damage_dealt < 0:
		damage_dealt = 0
	print(attacker.definition.name, " is attacking ", target_node.name, "! They deal ", damage_dealt)
	
	return damage_dealt
	
