class_name EquipmentHandler
extends Node
var armor
var weapon
var trinkets

var current_equipment = {
	"weapon": null,
	"head": null,
	"neck": null,
	"shoulders": null,
	"chest": null,
	"hands": null,
	"legs": null,
	"feet": null,
	"ring1": null,
	"ring2": null,
	"trinket": null
}

var desired_equipment = current_equipment.duplicate()

signal equipment_change


func initialize():
	pass

func _process(delta):
	pass
