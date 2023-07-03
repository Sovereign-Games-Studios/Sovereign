extends Sprite2D

var MAIN
var FOG
var fogMapImg = null
# Called when the node enters the scene tree for the first time.
func _ready():
	MAIN = get_node("../../../../../World")
	FOG = get_node("../../../../Terrain/Fog/Fog")
	get_viewport().size = FOG.fog_map_size
	print("viewport size: ", get_viewport().size)
	draw_rect(Rect2(Vector2(0, 0), FOG.fog_map_size), Color(0.0, 0.0, 0.0))
	$Timer.wait_time = 0.2
	$Timer.timeout.connect(_on_Timer_timeout)
	pass # Replace with function body.
	
	
var oldImg = null
var backgroundDrawn = false
func _draw():
	oldImg = Image.new()
	oldImg.copy_from(get_viewport().get_texture().get_image())
	if !self.backgroundDrawn:
		draw_rect(Rect2(Vector2(0, 0), FOG.fog_map_size), Color(0.0, 0.0, 0.0))
		self.backgroundDrawn = true	
	else:
		var tex = ImageTexture.new()
		tex.create_from_image(self.oldImg)
		draw_texture(tex, Vector2(0, 0))
		
	var scene_tree = self.get_tree()
	
	for node in scene_tree.get_nodes_in_group("Player Entities"):	 
		var pixel = FOG.getFogMapPixelForUnit(node)
		var r = 200  # tier of the unit to multiply its viewing distance
		
		var blurSteps = 10.0
		var blurMultRadius = 0.05
			
		draw_circle(Vector2(pixel.x, pixel.y), r, Color(1.0, 1.0, 1.0))


func _on_Timer_timeout():
	self.queue_redraw() # force redraw of Sprite, which draws fog reveal circles on itself
	
	fogMapImg = get_viewport().get_texture().get_image()
	var tex = ImageTexture.create_from_image(fogMapImg)
	FOG.material_override.set_shader_parameter("fogMap", tex)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
