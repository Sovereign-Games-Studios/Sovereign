extends Camera2D

# Camera script follwing a target (usually the player)
# This camera is snapped to a grid, therefore only moves when the character exits a screen.

@export var target : NodePath
@export var align_time : float = 0.2
@export var screen_size := Vector2(1920, 1080)

@onready var Target = get_node_or_null(target)

func _physics_process(_delta: float) -> void:
	var desired_pos = self.global_position
	if Input.is_action_pressed("A"):
		desired_pos.x += -500 * _delta
	if Input.is_action_pressed("D"):
		desired_pos.x += 500 * _delta
	if Input.is_action_pressed("W"):
		desired_pos.y += -500 * _delta
	if Input.is_action_pressed("S"):
		desired_pos.y += 500 * _delta
	
	# Actual movement
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "position", desired_pos, align_time).from_current()

# Calculating the gridnapped position
