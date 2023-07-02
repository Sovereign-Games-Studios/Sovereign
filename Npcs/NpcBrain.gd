class_name NpcBrain
extends Node


''' 
List of variables that store the NPC's knowledge of it's current state. This is often a subset of the Kingdom Knowledge. 
'''

# Dictionary of known enemies and their last seen location
var known_enemies: Dictionary
# Array of enemies in range
var enemies_in_range: Array
# Array of enemies attacking kingdom
var enemies_attacking_kingdom: Array
# Dictionary of known monster lairs and their last seen location
var known_lairs: Dictionary
# Action currently being undertaken
var current_action: Action
# Personality of the NPC
var personality: Personality
# Dictionary of NPC Attributes
var current_attributes: Dictionary
# Current Target
var current_target: NPC
# Self
var party_leader: NPC
var leading_party: bool

func initialize(npc_personality):
	self.personality = npc_personality
	self.known_enemies = {}
	self.known_lairs = {}
	self.current_target = null
