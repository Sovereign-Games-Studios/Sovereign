shader_type spatial;

render_mode unshaded, depth_prepass_alpha;

uniform float fogMaxDepth;
uniform float maxRange = 20;
uniform float defaultAlpha = 0.9;
uniform vec3 fogColor = vec3(0.0, 0.0, 0.0);
uniform float mapWidth = 200;
uniform sampler2D fogMap;

vec2 worldPosToPixel(vec3 worldPos) {
	ivec2 fogMapSize = textureSize(fogMap, 0);
	float bitmapPixelWidth = 1.0 / float(fogMapSize.x);
	

	worldPos += (mapWidth/2.0);
	worldPos *= (float(fogMapSize.x) / mapWidth); 
	
	float indexOnBitmapX = worldPos.x * bitmapPixelWidth;
	float indexOnBitmapY = worldPos.z * bitmapPixelWidth;
	
	return vec2(indexOnBitmapX, indexOnBitmapY);
}

vec4 getPixelColor(vec2 pixelPos) {
	
	ivec2 fogMapSize = textureSize(fogMap, 0);
	float bitmapPixelWidth = 1.0 / float(fogMapSize.x); 
	
	vec4 bitmapPixel = texture(fogMap, vec2(pixelPos.x, pixelPos.y)); 
	
	return bitmapPixel;
}


void vertex() {
	vec3 worldPos = ((MODEL_MATRIX) * vec4(VERTEX, 1.0)).xyz;
	vec2 pixelPos = worldPosToPixel(worldPos);

	vec4 bitmapPixel = getPixelColor(pixelPos);
	
	if (VERTEX.y < 0.0) {
		VERTEX.y = 0.0;
	} 
	
	if (bitmapPixel.r > 0.8) {
		VERTEX.y = - (fogMaxDepth * bitmapPixel.r + 10.0);
	}
		
	
	VERTEX.x = VERTEX.x + (bitmapPixel.r) ;
	VERTEX.z = VERTEX.z + (bitmapPixel.r) ;
}

void fragment() {
	vec3 worldPos = (inverse(VIEW_MATRIX) * vec4(VERTEX, 1.0)).xyz;  
	vec2 pixelPos = worldPosToPixel(worldPos);
	vec4 pixelColor = getPixelColor(pixelPos);

	ALBEDO = pixelColor.rgb * 0.0000001;
	ALPHA = defaultAlpha;

}

