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
			elif service == "Item Seller":
				print("This building has a item seller service!")
				var new_node = handle_item_seller_service()
				$Control/AspectRatioContainer/TabContainer.add_child(new_node)
				
	if building.definition.upgrades.size() > 0:	
		var new_node = Panel.new()	
		new_node.name = "Upgrades"		
		for upgrade in building.definition.upgrades:
			var new_button = Button.new()
			new_button.name = upgrade
			new_button.text = upgrade + " {upgrade} ".format({"upgrade": attached_building.definition.upgrades[upgrade]}) 
			new_node.add_child(new_button)
		$Control/AspectRatioContainer/TabContainer.add_child(new_node)
		

func handle_item_seller_service():
	var new_node = Panel.new()
	new_node.name = "Available Items"
	var text = "---Available Items--- \n"
	for item in attached_building.services["Item Seller"].inventory:
		item.get_script()
		text += "\n - {item}: {cost}".format({"item": item.name,"cost": item.cost})
	var text_node = Button.new()
	text_node.name = "ServiceText"
	text_node.text = text
	new_node.add_child(text_node)
	return new_node
				
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
	var text = ("Building Name: " + attached_building.definition.name +
	 "\n Team: " + attached_building.team +
	 "\n Currently Housed NPCs: {npcs}" +
	 "\n Recruited NPCs: {recruited_npcs}").format({"npcs": attached_building.current_occupants, 
	"recruited_npcs": attached_building.recruited_npcs})
	$"Control/AspectRatioContainer/TabContainer/Building Info".text = text
	pass
