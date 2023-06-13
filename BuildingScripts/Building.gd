extends CharacterBody3D
class_name Building

var building_type
var team
# We'll see if we use this attribute
var level
var max_health
var current_health
var stats
var recruitable_npc_type
# array of existing npcs tied to this building, the length of which is compared against maximum to determine if more can be recruited/spawned
var npcs
var maximum_npcs
# array of npcs currently occupying this building
var current_occupants

# Must check to see if these are on the map before construction is allowed
var prerequisites

# only relevant to pc buildings
var cost 
var services
var upgrades
