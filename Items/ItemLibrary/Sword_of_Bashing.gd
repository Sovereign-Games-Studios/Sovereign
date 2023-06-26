extends Item
class_name SwordOfBashing

func initialize():
	name = "Sword of Bashing"
	type = "Weapon"
	level = 1
	stats = Statistics.getStats(name)
	class_requirements = "Barbarian"
	value = 1000

