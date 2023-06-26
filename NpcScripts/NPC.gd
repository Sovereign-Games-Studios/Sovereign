extends CharacterBody3D
class_name NPC

var char_class
var team
var level
var exp
var max_health
var current_health
var stats
var speed

var inventory
var gold
var equipped_items
var behaviour
var spells
var attack
var status

static func leaveBuilding(npc, target_building):
	var found = target_building.current_occupants.find(npc)
	if found >= 0:
		target_building.current_occupants.remove_at(found) 
		npc.show()

static func enterBuilding(npc, target_building:Building):
	if npc.global_position.distance_to(target_building.global_position) < 10:
		target_building.current_occupants.append(npc)
		npc.hide()
		npc.status = "Inside Building"
