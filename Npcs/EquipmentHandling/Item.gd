class_name Item
extends Node3D
var gear_score = 0
# Attribute Mods
var strength
var spirit
var stamina
var agility
var charisma
var wisdom
var intelligence

var range
var attack_speed
var physical_damage
var magic
var fire
var air
var earth
var water
var light
var shadow
var nature
var electric
	
var physical_resistance
var magic_resistance
var fire_resistance
var earth_resistance
var water_resistance
var electric_resistance
var nature_resistance
var shadow_resistance
var light_resistance

var level
var slot
var has_defensives
var has_offensives
var cost
# only weapons
var enchantment

func initialize(name: String):
	var definition = ResourceLoader.load("res://Resources/ItemDefinitions/"+name+".tres")
	definition.get_script()
	self.level = definition.level
	self.slot = definition.slot
	self.has_defensives = definition.has_defensives
	self.has_offensives = definition.has_offensives
	self.cost = definition.cost
	# only weapons and armor can be enchanted to grant a bonus to hit and damage
	self.enchantment = 0

	### Stats Modified by the item, these are added directly to owner stats ###
	
	# Attribute Mods
	self.strength = definition.strength
	self.spirit = definition.spirit
	self.stamina = definition.stamina
	self.agility = definition.agility
	self.charisma = definition.charisma
	self.wisdom = definition.wisdom
	self.intelligence = definition.intelligence
	
	self.gear_score += strength + spirit + stamina + agility + charisma + wisdom + intelligence
	# Attack Mods. Note that since they are additive if you wish to increase attack speed make this number negative.
	if(definition.has_offensives):
		self.range = definition.range
		self.attack_speed = definition.attack_speed
		self.physical_damage = definition.physical_damage
		self.magic = definition.magic
		self.fire = definition.fire
		self.air = definition.air
		self.earth = definition.earth
		self.water = definition.water
		self.light = definition.light
		self.shadow = definition.shadow
		self.nature = definition.nature
		self.electric = definition.electric
		
		self.gear_score = range + attack_speed + physical_damage + magic + fire + air + earth + water + light + shadow + electric

	if(definition.has_defensives):
		# Resistance Mods
		self.physical_resistance = definition.physical_resistance
		self.magic_resistance = definition.magic_resistance
		self.fire_resistance = definition.air_resistance
		self.earth_resistance = definition.earth_resistance
		self.water_resistance = definition.water_resistance
		self.electric_resistance = definition.electric_resistance
		self.nature_resistance = definition.nature_resistance
		self.shadow_resistance = definition.shadow_resistance
		self.light_resistance = definition.light_resistance
		# Bring the percentile up to an easier number to work with.
		self.gear_score = 100 * (physical_resistance+magic_resistance+fire_resistance+earth_resistance+water_resistance+electric_resistance+nature_resistance+shadow_resistance+light_resistance)
		
