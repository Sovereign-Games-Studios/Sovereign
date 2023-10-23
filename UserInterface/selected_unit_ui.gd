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
	$"Control/AspectRatioContainer/TabContainer/UnitInfo".text = text
	self.set_global_position(Vector2(0,0))
	
	var new_node = Panel.new()	
	new_node.name = "Equipment"		
	text = ""
	# var new_text_box = ItemList.new()
	# for equipment_type in unit.current_equipment:
		# new_text_box.add_item("{equipment_type}: {equipment} \n".format({"equipment_type": equipment_type, "equipment": unit.current_equipment[equipment_type]}), null, false)
	# new_node.add_child(new_text_box)
	# new_text_box.show()
	# $Control/AspectRatioContainer/TabContainer.add_child(new_node)
		
	if is_instance_valid(unit.target):	
		new_node = Panel.new()	
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
		$"Control/AspectRatioContainer/TabContainer/UnitInfo".text = text
	else:
		queue_free()
	pass
