class_name SelectedBuildingUi
extends Control

var attached_building: Building

func initialize(building: Building):
	$Control2/AspectRatioContainer/Node2D/BuildingSprite2.texture = building.sprite
	$Control2/AspectRatioContainer/Node2D.position = (Vector2($Control2.size.x/2, $Control2.size.y/2))
	attached_building = building
	var text = ("Building Name: " + building.definition.name + "\nTeam: " + building.team + "\nCurrently Housed NPCs: %s").format(building.current_occupants)
	$"Control/AspectRatioContainer/TabContainer/Building Info".text = text
	self.set_global_position(Vector2(0,0))
	if building.services.size() > 0:
		for service in building.services:
			if service == "Guild":
				print("This building has a guild service!")
				var new_node = handle_guild_service()
				$Control/AspectRatioContainer/TabContainer.add_child(new_node)
				
				
func handle_guild_service():
	var new_node = Panel.new()
	new_node.name = "Recruit Heroes"
	for npc in attached_building.definition.recruitable_npcs:
		var new_button = Button.new()
		new_button.text = "Recruit " + npc
		new_button.pressed.connect(attached_building.services["Guild"].recruit_npc.bind(npc, attached_building))
		new_node.add_child(new_button)
	print("Our new Panel's location: ", new_node.global_position)
	return new_node
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var text = ("Building Name: " + attached_building.definition.name + "\n Team: " + attached_building.team + "\n Currently Housed NPCs: %").format(attached_building.current_occupants)
	$"Control/AspectRatioContainer/TabContainer/Building Info".text = text
	pass
