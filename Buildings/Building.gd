extends CharacterBody3D
class_name Building

var team: String
var definition: Resource
# Array of NPCs inside the building
var current_occupants: Array
# Dictionary where NPC Type is the Key and the value an array of NPCs recruited by the building of that type
var recruited_npcs: Dictionary
# Image
var sprite
var npc_node = preload("res://Characters/npc_node.tscn")
# Array of instantiated Services
var services = {}

func initialize(building_name, start_position, team):
	self.team = team
	set_global_position(start_position)
	self.definition = ResourceLoader.load("res://Resources/Buildings/BuildingDefinitions/"+building_name+".tres")
	self.definition.get_script()
	self.current_occupants = []
	self.add_to_group("Player Entities")
	# Handle NPCs	
	self.recruited_npcs = self.definition.recruitable_npcs.duplicate()
	for npctype in self.recruited_npcs:
		self.recruited_npcs[npctype] = []
		
	# Handle Building Sprite
	if(self.definition.sprite_override):
		self.sprite = load("res://Resources/Buildings/Images/"+self.definition.sprite_override+".png")
	else:
		self.sprite = load("res://Resources/Buildings/Images/"+building_name+".png")		
	$Sprite3D.texture = self.sprite	
	
	if definition.building_type == "Support" or definition.building_type == "Lair":
		$Timer.wait_time = 10
		$Timer.timeout.connect(_recruit_on_timer_timeout)
	attach_services(definition.services)
	
# TODO Services in general.
func attach_services(services):
	for service in services:
		var new_service = load("res://Resources/ServiceDefinitions/"+service.to_lower()+".tres")
		self.services[service] = new_service
		return
	

func _recruit_on_timer_timeout():
	var maximum_npcs = self.definition.recruitable_npcs
	for npc_type in maximum_npcs:
		if self.recruited_npcs[npc_type].size() < maximum_npcs[npc_type]:
			var npc = npc_node.instantiate()
			var spawn_location = self.get_node("SpawnPath/SpawnLocation").position
			npc.initialize(spawn_location, npc_type, team)
			if npc.team == "player":
				npc.add_to_group("Player Entities")
			self.recruited_npcs[npc_type].append(npc)
			add_child(npc)
			print("Spawned NPC of type: ", npc_type, " using entity: ", npc.char_class, " at ", spawn_location)
			# We only want to spawn once a tick. 
			return
