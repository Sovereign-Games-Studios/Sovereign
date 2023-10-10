class_name Item
extends Node3D

func initialize(name: String):
	var definition = ResourceLoader.load("res://Resources/ItemDefinitions/"+name.to_lower()+".tres")
	var level = definition.level
	var slot = definition.equipment_slot
	var has_defensives = definition.has_defensives
	var has_offensives = definition.has_offensives
	var class_requirements = definition.class_requirements
	
	var cost = definition.cost
	
	# only weapons and armor can be enchanted to grant a bonus to hit and damage
	var enchantment = definition.enchantment

	### Stats Modified by the item, these are added directly to owner stats ###

	# Attribute Mods
	var strength = definition.strength
	var spirit = definition.spirit
	var stamina = definition.stamina
	var agility = definition.agility
	var charisma = definition.charisma
	var wisdom = definition.wisdom
	var intelligence = definition.intelligence
	
	# Attack Mods. Note that since they are additive if you wish to increase attack speed make this number negative.
	if(self.definition.has_offensives):
		var range = definition.range
		var attack_speed = definition.attack_speed
		var physical_damage = definition.physical_damage
		var magic = definition.magic
		var fire = definition.fire
		var air = definition.air
		var earth = definition.earth
		var water = definition.water
		var light = definition.light
		var shadow = definition.shadow
		var nature = definition.nature
		var electric = definition.electric

	if(self.definition.has_defensives):
		# Resistance Mods
		var physical_resistance = definition.physical_resistance
		var magic_resistance = definition.magic_resistance
		var fire_resistance = definition.air_resistance
		var earth_resistance = definition.earth_resistance
		var water_resistance = definition.water_resistance
		var electric_resistance = definition.electric_resistance
		var nature_resistance = definition.nature_resistance
		var shadow_resistance = definition.shadow_resistance
		var light_resistance = definition.light_resistance
