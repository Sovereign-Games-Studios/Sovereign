extends CharacterBody2D
class_name Building

var building_type
var team
# We'll see if we use this attribute
var level
var max_health
var current_health
var stats
var recruitable_npc_type
var number_of_npcs
var maximum_npcs

# Must check to see if these are on the map before construction is allowed
var prerequisites

# only relevant to pc buildings
var cost 
var services
var upgrades
