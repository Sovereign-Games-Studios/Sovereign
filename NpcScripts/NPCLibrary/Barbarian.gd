extends NPC
class_name Barbarian

# Get the gravity from the project settings to be synced with RigidBody nodes.

func _ready():
	char_class = "barbarian"
	level = 1
	exp = 0

	inventory = []
	gold = 20
	equipped_items = []
	behaviour = "TODO implement behaviour"
	spells = "TODO implement spells"
	stats = Statistics.getStats(char_class)
	attack = Attacks.getAttack(char_class)
	max_health = 10 + stats["Stamina"]
	current_health = 10 + stats["Stamina"]
	pass # Replace with function body.

func _physics_process(_delta):
	var overlapping = self.get_node("Area2D").get_overlapping_bodies()
	for node in overlapping:
		if node.get_meta("Team") == "enemy":
			var target_pos = node.global_position
			var fullv = target_pos - self.global_position
			var unitv = fullv.normalized()
			velocity = unitv * 20
			var distance = target_pos - self.global_position
			if distance[0] <= self.attack["Range"] and distance[1] <= self.attack["Range"]:
				Attacks.attackTarget(self, node) 
	move_and_slide()


func initialize(start_position, team, char_class, level, behaviour, stats, spells, equipped_items):
	set_global_position(start_position)
	char_class = "barbarian"
	team = team
	level = 1
	exp = 0

	inventory = []
	gold = 20
	equipped_items = []
	behaviour = "TODO implement behaviour"
	spells = "TODO implement spells"
	stats = Statistics.getStats(char_class)
	attack = Attacks.getAttack(char_class)
	max_health = 10 + stats["Stamina"]
	current_health = 10 + stats["Stamina"]
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
