extends Sprite2D

var MAIN
var FOG
var fogMapImg = null
# Called when the node enters the scene tree for the first time.
func _ready():
	MAIN = get_node("../../../../../World")
	FOG = get_node("../../../../Fog")
	get_viewport().size = FOG.fog_map_size
	draw_rect(Rect2(Vector2(0, 0), FOG.fog_map_size), Color(0.0, 0.0, 0.0))
	$Timer.wait_time = 0.2
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
		self.oldImg.flip_y() # flip it back. due to the way OpenGL works, the resulting ViewportTexture is flipped vertically.
		var tex = ImageTexture.new()
		tex.create_from_image(self.oldImg)
		draw_texture(tex, Vector2(0, 0))
	
	# WTF? this next line is necessary to make sure the draw_texture() calls works as intended. 
	# even though it's only another sprite for debugging purposes... is this about causing some small delay?
	# without it, we get crazy pink blinking background... 0_o

	var unit = self.get_my_units()
	# transform world pos into pixels on the fogMap
#		var x = (unit.translation.x + (MAIN.mapWidth / 2)) / MAIN.mapWidth * FOG.fogMapSize.x
#		var z = (unit.translation.z + (MAIN.mapWidth / 2)) / MAIN.mapWidth * FOG.fogMapSize.y
	var pixel = FOG.getFogMapPixelForUnit(unit)
	var r = (1 * 60) / 150 * FOG.fog_map_size.y # tier of the unit to multiply its viewing distance
#		print("fog unit at: ",x,"/",z," radius ",y)
	
	var blurSteps = 10.0
	var blurMultRadius = 0.05
		
		# units visible range, full white
	draw_circle(Vector2(pixel.x, pixel.y), r, Color(1.0, 1.0, 1.0))

func get_my_units():
	# TODO make this grab all player entities, probably need to get something
	# good working in the guilds recruit button to make sure it adds the new nodes
	# (aka new heroes) to a parent node that houses ALL player entities. 
	return MAIN.get_node("../../../../Barbarian")
# update texture on shader only when necessary, it's expensive

func _on_Timer_timeout():
	# animate the noise. unfortunately, animating has an entropic effect on the fogMap. bad.
#	var noiseSprite = get_node("../NoiseSprite")
#	if (noiseSprite != null):
#		noiseSprite.texture.noise.seed += 1
	self.queue_redraw() # force redraw of Sprite, which draws fog reveal circles on itself
	
	fogMapImg = get_viewport().get_texture().get_image()
	fogMapImg.flip_y() # flip it back. due to the way OpenGL works, the resulting ViewportTexture is flipped vertically.
#	print("fog map size: ",img.get_size())
	
	# update fogMap image on shaders
	var tex = ImageTexture.new()
	tex.create_from_image(fogMapImg)
	print(tex)
	FOG.mesh.material.set_shader_parameter("fogMap", tex)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.queue_redraw() # force redraw of Sprite, which draws fog reveal circles on itself
	
	fogMapImg = get_viewport().get_texture().get_image()
	fogMapImg.flip_y() # flip it back. due to the way OpenGL works, the resulting ViewportTexture is flipped vertically.
#	print("fog map size: ",img.get_size())
	
	# update fogMap image on shaders
	var tex = ImageTexture.new()
	tex.create_from_image(fogMapImg)
	FOG.mesh.material.set_shader_parameter("fogMap", tex)
	pass
