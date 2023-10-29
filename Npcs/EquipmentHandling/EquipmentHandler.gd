class_name EquipmentHandler
extends Node3D
var weapon: Item = null
var head: Item = null
var neck: Item = null
var shoulders: Item = null
var chest: Item = null
var hands: Item = null
var legs: Item = null
var feet: Item = null
var rings: Array = []
var trinkets: Array = []
var gear_score = 0
var current_equipment = {
	"weapon": weapon,
	"head": head,
	"neck": neck,
	"shoulders": shoulders,
	"chest": chest,
	"hands": hands,
	"legs": legs,
	"feet": feet
}

var desired_equipment = current_equipment.duplicate()



func initialize(starting_equipment: Dictionary):
	
	for item in starting_equipment:
		var item_name = starting_equipment[item].replace(" ", "_").to_lower()
		var starting_item = Item.new()
		starting_item.initialize(item_name)
		self.current_equipment[item] = starting_item
		
	calc_gear_score()

func equip_item(new_item: Item):
	current_equipment[new_item.slot] = new_item
	desired_equipment[new_item.slot] = null
	calc_gear_score()

	
func calc_gear_score():
	var current_gear_score = 0
	for item in self.current_equipment:
		current_gear_score += self.current_equipment[item].gear_score
	self.gear_score = current_equipment
