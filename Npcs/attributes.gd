class_name Attributes
extends Node

var primary_stat

var agility
var strength
var stamina
var spirit
var intelligence
var wisdom
var charisma

var physical_resistance
var magic_resistance
var fire_resistance 
var air_resistance 
var earth_resistance 
var water_resistance 
var electric_resistance 
var nature_resistance 
var shadow_resistance 
var light_resistance 
var speed
var attribute_dict
var attribute_score: int = 0

func initialize(owner: Node3D, definition: Resource):
	
	if owner is NPC:
		# Handle Statistics
		self.stamina = definition.stamina
		self.agility = definition.agility
		self.strength = definition.strength
		self.spirit = definition.spirit
		self.intelligence = definition.intelligence
		self.wisdom = definition.wisdom
		self.charisma = definition.charisma
		
		self.speed = definition.speed
		
		self.primary_stat = definition.primary_stat
			
		self.attribute_dict = {
			"agility": self.agility,
			"charisma": self.charisma,
			"intelligence": self.intelligence,
			"spirit": self.spirit,
			"stamina": self.stamina,
			"strength": self.strength,
			"wisdom": self.wisdom
		}
			
		for attribute in attribute_dict:
			self.attribute_score += attribute_dict[attribute] 
	# Handle Resists
	self.physical_resistance = definition.physical_resistance 
	self.magic_resistance = definition.magic_resistance 
	self.fire_resistance = definition.fire_resistance  
	self.air_resistance = definition.air_resistance  
	self.earth_resistance = definition.earth_resistance  
	self.water_resistance = definition.water_resistance  
	self.electric_resistance = definition.electric_resistance  
	self.nature_resistance = definition.nature_resistance  
	self.shadow_resistance = definition.shadow_resistance  
	self.light_resistance = definition.light_resistance  

# update function
func _process(delta):
	self.attribute_dict = {
		"agility": self.agility,
		"charisma": self.charisma,
		"intelligence": self.intelligence,
		"spirit": self.spirit,
		"stamina": self.stamina,
		"strength": self.strength,
		"wisdom": self.wisdom
	}
	for attribute in attribute_dict:
		self.attribute_score +=attribute_dict[attribute] 
