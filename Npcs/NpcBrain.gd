class_name NpcBrain
extends Node


''' 
List of variables that store the NPC's knowledge of it's current state. This is often a subset of the Kingdom Knowledge. 
'''

# Dictionary of known enemies and their last seen location
var known_enemies: Dictionary
# Array of enemies in vision range
var enemies_in_range: Array
# Array of enemies attacking kingdom
var enemies_attacking_kingdom: Array
# Dictionary of known monster lairs and their last seen location
var known_lairs: Dictionary
# Personality of the NPC
var personality: Personality
# Party leader if any. This should be null if they are leading a party. 
var party_leader: NPC
# If the NPC is the party leader, indicate it. This should be false if the party_leader variable has a valid npc.
var leading_party: bool
# How long the npc has been idle
var idle_ticks
var mutex

func initialize(npc_personality: Personality, mutex: Mutex):
	self.personality = npc_personality
	self.known_enemies = {}
	self.known_lairs = {}
	self.mutex = mutex
	
func _physics_process(delta):
	var npc = self.get_parent()
	var vision = npc.find_child("Vision")
	var i = 0
	# Cleanup
	for enemy in enemies_in_range:
		if not enemy in vision.get_overlapping_bodies():
			self.mutex.lock
			enemies_in_range.remove_at(i)
			self.mutex.unlock()
		i += 1
