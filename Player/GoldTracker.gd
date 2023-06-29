extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var kingdom_stats = get_node("../../../../World")
	text = "Gold: " + str(kingdom_stats.gold)
	pass
