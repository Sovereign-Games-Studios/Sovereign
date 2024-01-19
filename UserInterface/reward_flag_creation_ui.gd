class_name RewardFlagCreationUI
extends Control

var attached_entity: Node3D
var reward_flag: RewardFlag
var camera

func initialize(target: Node3D, camera: Camera3D):
	self.camera = camera
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
		# TODO debug this
		var kingdom_stats = camera.get_parent().teams["player"]
		kingdom_stats.combat_reward_flags.append(target)
	
	$Control/AspectRatioContainer/TabContainer/Target/IncreaseReward.pressed.connect(_handle_reward_up)
	$"Control/AspectRatioContainer/TabContainer/Target/DecreaseReward".pressed.connect(_handle_reward_down)
	
	$Control/AspectRatioContainer/TabContainer/Target/Reward.text = str(current_reward)
	
func _handle_reward_up():
	var kingdom_stats = camera.get_parent().teams["player"]
	if kingdom_stats.gold > 100:
		reward_flag = attached_entity.get_node("RewardFlag")
		reward_flag.value += 100
		kingdom_stats.gold -= 100
		$Control/AspectRatioContainer/TabContainer/Target/Reward.text = str(reward_flag.value)
	else:
		reward_flag = attached_entity.get_node("RewardFlag")
		reward_flag.value += kingdom_stats.gold
		kingdom_stats.gold -= kingdom_stats.gold
		$Control/AspectRatioContainer/TabContainer/Target/Reward.text = str(reward_flag.value)

func _handle_reward_down():
	var reward_flag = attached_entity.get_node("RewardFlag")
	var kingdom_stats = camera.get_parent().teams["player"]	
	if reward_flag.value > 100:
		reward_flag.value -= 100
		kingdom_stats.gold += 100
		$Control/AspectRatioContainer/TabContainer/Target/Reward.text = str(reward_flag.value)
	else:
		reward_flag.value -= reward_flag.gold
		kingdom_stats.gold += reward_flag.gold
		$Control/AspectRatioContainer/TabContainer/Target/Reward.text = str(reward_flag.value)
		reward_flag.hide()
		var index = kingdom_stats.combat_reward_flags.find(attached_entity)
		kingdom_stats.combat_reward_flags.remove_at(index)
		
			
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(attached_entity):
		var text = ("Unit Name: " + attached_entity.definition.name +
		 "\nTeam: " + attached_entity.team)
		$"Control/AspectRatioContainer/TabContainer/Target".text = text
	else:
		queue_free()
	pass
