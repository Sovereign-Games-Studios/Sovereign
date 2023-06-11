extends Button

@export var building_scene: PackedScene
var buttonPressed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.hide()	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	buttonPressed = true
	$Sprite2D.show()	

func _input(event):
	if buttonPressed:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			# Place Building
			buttonPressed = false
			var building = building_scene.instantiate()
			building.initialize($Sprite2D.position, "enemy", "grue den")
			add_child(building)
			$Sprite2D.hide()
			
			
		if event is InputEventMouseMotion:
			# Move sprite to show where building will be on click
			$Sprite2D.position = get_global_mouse_position()

			
