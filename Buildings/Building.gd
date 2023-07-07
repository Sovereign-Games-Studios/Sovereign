extends StaticBody3D
class_name Building

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var team: String
var definition: Resource
# Array of NPCs inside the building
var current_occupants: Array
# Dictionary where NPC Type is the Key and the value an array of NPCs recruited by the building of that type
var recruited_npcs: Dictionary
# Image
var sprite
var current_health
var npc_node = preload("res://Npcs/npc_node.tscn")
# Array of instantiated Services
var services = {}
signal death_signal

var fall_speed = 50;

func initialize(start_position, building_name, team):
	self.team = team
	set_global_position(start_position)
	self.definition = ResourceLoader.load("res://Resources/Buildings/BuildingDefinitions/"+building_name.to_lower()+".tres")
	self.definition.get_script()
	current_health = self.definition.max_health
	self.current_occupants = []
	if(team == "player"):
		self.add_to_group("Player Entities")
	# Handle NPCs	
	self.recruited_npcs = self.definition.recruitable_npcs.duplicate()
	for npctype in self.recruited_npcs:
		self.recruited_npcs[npctype] = []
		
	# Handle Building Sprite
	if(self.definition.sprite_override):
		self.sprite = load("res://Resources/Buildings/Images/"+self.definition.sprite_override+".png")
	else:
		self.sprite = load("res://Resources/Buildings/Images/"+building_name.to_lower()+".png")		
	$Sprite3D.texture = self.sprite	
	
	if definition.building_type == "Support" or definition.building_type == "Lair" or definition.building_type == "Merchant":
		$RecruitTimer.wait_time = 10
		$RecruitTimer.timeout.connect(_recruit_on_timer_timeout)
	attach_services(definition.services)

func _process(delta):
	if current_health < 0:
		print(self.name, " has been destroyed!")		
		self.death_signal.emit()
		self.queue_free()
		
# TODO Services in general.
func attach_services(services):
	for service in services:
		var service_name = service.replace(" ", "_").to_lower()
		var new_service = load("res://Resources/ServiceDefinitions/"+service_name+".tres")
		new_service.get_script()
		# Some services require instantiation.
		if services[service].size() > 0:
			new_service.initialize(services[service])
		if new_service.requires_timer:
			var new_timer = Timer.new()
			new_timer.name = service
			new_timer.wait_time = new_service.service_timer
			new_timer.autostart = true
			new_timer.timeout.connect(new_service._on_service_timeout)
			add_child(new_timer)
		self.services[service] = new_service		
		return
	

func _recruit_on_timer_timeout():
	var maximum_npcs = self.definition.recruitable_npcs
	if self.definition.name == "Frontier Market":
		print("Frontier Market npcs: ", maximum_npcs)
	for npc_type in maximum_npcs:
		if self.recruited_npcs[npc_type].size() < maximum_npcs[npc_type]:
			var npc = npc_node.instantiate()
			var spawn_location = self.get_node("SpawnPath/SpawnLocation").get_global_position()
			npc.initialize(spawn_location, npc_type, team)
			if npc.team == "player":
				npc.add_to_group("Player Entities")
			self.recruited_npcs[npc_type].append(npc)
			#add_child(npc)
			get_tree().get_root().add_child(npc)
			print("The ", self.definition.name, " Spawned NPC of type: ", npc_type, " using entity: ", npc.definition.name, " at ", spawn_location)
			# We only want to spawn once a tick. 
			return

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func _physics_process(delta):
	if not $RayCast3D.is_colliding():
		position.y -= fall_speed * delta
	else:
		# Get the normal right below us 
		var n = $RayCast3D.get_collision_normal()
		# Transform and interpolate with current orientation
		var xform = align_with_y(global_transform, n)
		global_transform = global_transform.interpolate_with(xform, 0.2)
