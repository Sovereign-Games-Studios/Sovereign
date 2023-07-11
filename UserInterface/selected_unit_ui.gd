class_name SelectedUnitUi
extends Control

var attached_unit: NPC

func initialize(unit: NPC):
	$Control2/AspectRatioContainer/Node2D/BuildingSprite2.texture = unit.sprite
	$Control2/AspectRatioContainer/Node2D.position = (Vector2($Control2.size.x/2, $Control2.size.y/2))
	attached_unit = unit
	var text = ("Unit Name: " + attached_unit.definition.name +
	 "\nTeam: " + attached_unit.team +
	 "\ncurrent_state: ") + attached_unit.state
	$"Control/AspectRatioContainer/TabContainer/Building Info".text = text
	self.set_global_position(Vector2(0,0))
	
	if is_instance_valid(unit.target):	
		var new_node = Panel.new()	
		new_node.name = "Target"		
		var new_button = Button.new()
		new_button.name = unit.target.definition.name
		new_button.text = unit.target.definition.name
		new_node.add_child(new_button)
		$Control/AspectRatioContainer/TabContainer.add_child(new_node)
		
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(attached_unit):
		var text = ("Unit Name: " + attached_unit.definition.name +
		 "\nTeam: " + attached_unit.team +
		 "\ncurrent_state: ") + attached_unit.state
		$"Control/AspectRatioContainer/TabContainer/Building Info".text = text
	else:
		queue_free()
	pass
