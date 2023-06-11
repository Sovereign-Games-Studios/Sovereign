class_name Behaviours

# Class for our basic behaviours, getBehaviour returns a weighted list of actions 
# We should randomly determine what action the character does next based on previous actions and weighted available actions
# This might get complicated so brainstorm this as a group
static func getBehaviour(char_class):
	var generic_behaviour = {
	"Explore": 10,
	"Defend" : 5,
	"Form Party": 0,
	"Flee": 0,
	"Support Ally": 0,
	"Purchase Item": 0,
	"Purchase Spell": 0,
	"Train": 0,
	"Relax": 0,
	"Hunt": 0,
	"Follow Party Leader": 0,
	"Loot": 0,
	"Special Action": 0	
}

	var barbarian_behaviour = {
	"Explore": 0,
	"Defend" : 0,
	"Form Party": 0,
	"Flee": 0,
	"Support Ally": 0,
	"Purchase Item": 0,
	"Purchase Spell": 0,
	"Train": 0,
	"Relax": 0,
	"Hunt": 100,
	"Follow Party Leader": 0,
	"Loot": 0,
	"Special Action": 0	
	}

	var behaviour_lib = {"generic_npc": generic_behaviour, "barbarian": barbarian_behaviour}

	return behaviour_lib[char_class]

static func hunt(node):
	var directions = randi() % 5
	if directions == 0:
		node.velocity = Vector2.UP	* node.speed
	if directions == 1:
		node.velocity = Vector2.LEFT * node.speed
	if directions == 2:
		node.velocity = Vector2.RIGHT * node.speed
	if directions == 3:
		node.velocity = Vector2.DOWN * node.speed
