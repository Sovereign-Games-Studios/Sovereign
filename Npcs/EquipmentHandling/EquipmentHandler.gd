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

signal equipment_change


func initialize(starting_equipment: Dictionary):
	current_equipment = starting_equipment
