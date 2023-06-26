class_name SelectedBuildingUi
extends Control

var attached_building: Building

func initialize(building: Building):
	$Control2/AspectRatioContainer/Node2D/BuildingSprite2.texture = building.sprite
	$Control2/AspectRatioContainer/Node2D.position = (Vector2($Control2.size.x/2, $Control2.size.y/2))
	attached_building = building
	var text = ("Building Name: " + building.building_definition.name + "\nTeam: " + building.team + "\nCurrently Housed NPCs: %s").format(building.current_occupants)
	$"Control/AspectRatioContainer/TabContainer/Building Info".text = text
	self.set_global_position(Vector2(0,0))
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var text = ("Building Name: " + attached_building.building_definition.name + "\n Team: " + attached_building.team + "\n Currently Housed NPCs: %").format(attached_building.current_occupants)
	$"Control/AspectRatioContainer/TabContainer/Building Info".text = text
	pass
