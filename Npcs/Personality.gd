class_name Personality
extends Node


var greed: int
var valor: int
var bravery: int
var cowardice: int
var wanderlust: int

var personality_type: String

func initialize(npc_definition: Resource):
	self.greed = npc_definition.greed
	self.valor = npc_definition.valor
	self.bravery = npc_definition.bravery
	self.cowardice = npc_definition.cowardice
	self.wanderlust = 5
	generate_personality_type(npc_definition)

func generate_personality_type(npc_definition: Resource):
	self.personality_type = "Heroic Champion"
