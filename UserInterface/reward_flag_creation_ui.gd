class_name RewardFlagCreationUI
extends Control

var attached_entity: Node3D
var reward_flag: RewardFlag

func initialize(target: Node3D):
	$Control2/AspectRatioContainer/Node2D/BuildingSprite2.texture = target.sprite
	$Control2/AspectRatioContainer/Node2D.position = (Vector2($Control2.size.x/2, $Control2.size.y/2))
	attached_entity = target
	var text = ("Unit Name: " + attached_entity.definition.name +
	 "\nTeam: " + attached_entity.team + "\n")
	$"Control/AspectRatioContainer/TabContainer/Target".text = text
	self.set_global_position(Vector2(0,0))
	var current_reward = 0
	if target.get_node("RewardFlag") != null:
		reward_flag = target.get_node("RewardFlag")		
		current_reward = reward_flag.value
		reward_flag.show()
	
	$Control/AspectRatioContainer/TabContainer/Target/IncreaseReward.pressed.connect(_handle_reward_up)
	$"Control/AspectRatioContainer/TabContainer/Target/DecreaseReward".pressed.connect(_handle_reward_down)
	
	$Control/AspectRatioContainer/TabContainer/Target/Reward.text = str(current_reward)
	
func _handle_reward_up():
	reward_flag = attached_entity.get_node("RewardFlag")
	reward_flag.value += 100
	$Control/AspectRatioContainer/TabContainer/Target/Reward.text = str(reward_flag.value)

func _handle_reward_down():
	reward_flag = attached_entity.get_node("RewardFlag")
	reward_flag.value -= 100
	$Control/AspectRatioContainer/TabContainer/Target/Reward.text = str(reward_flag.value)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(attached_entity):
		var text = ("Unit Name: " + attached_entity.definition.name +
		 "\nTeam: " + attached_entity.team)
		$"Control/AspectRatioContainer/TabContainer/Target".text = text
		if attached_entity.reward_flag != null:
			$Control/AspectRatioContainer/TabContainer/Target/Reward.text = attached_entity.reward_flag.value	
	else:
		queue_free()
	pass
