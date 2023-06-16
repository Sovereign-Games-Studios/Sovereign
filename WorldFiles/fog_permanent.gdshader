//
//    This file is part of Critically Entangled.
//    Copyright (c) 2018 Lukas Sägesser, ScyDev GmbH, Switzerland.
//
//    Critically Entangled is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//    Critically Entangled is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Critically Entangled.  If not, see <http://www.gnu.org/licenses/>.
//

shader_type spatial;

// player pos will be a world pos so we need our
// fragment position reported as world coordinate as well, using world_vertex_coords
//
// skip_vertex_transform: skip the conversion from model to view space
// world_vertex_coords: VERTEX/NORMAL/etc are modified in world coordinates instead of local. 
// 		+- fragment(): doesn't seem to change anything in this shader. with inverse(INV_CAMERA_MATRIX) below.
// 		+- vertex(): deforms the mesh in a circle, but moves with the camera. with inverse(INV_CAMERA_MATRIX) below.
render_mode unshaded, depth_prepass_alpha;
// 		+- no render_mode specified (or unshaded): makes the mesh deform in a long wave but moves with the cam. with inverse(INV_CAMERA_MATRIX) below.

uniform float fogMaxDepth;
uniform float maxRange = 20;
uniform float defaultAlpha = 0.9;
uniform vec3 fogColor = vec3(0.0, 0.0, 0.0);
uniform float mapWidth = 145;
uniform sampler2D fogMap;

vec2 worldPosToPixel(vec3 worldPos) {
	ivec2 fogMapSize = textureSize(fogMap, 0);
	float bitmapPixelWidth = 1.0 / float(fogMapSize.x); // offset used to read color from center of pixel, important to get the pixel, not an uncertain value from pixel border
	
	// this order is important! first shift, then scale!
	worldPos += (mapWidth/2.0); // shift to positive values for reading from bitmap
	worldPos *= (float(fogMapSize.x) / mapWidth); // map worldPos from world units to pixels of the fogMap
	
	float indexOnBitmapX = worldPos.x * bitmapPixelWidth; // the pixel that holds current units position info
	float indexOnBitmapY = worldPos.z * bitmapPixelWidth;
	
	return vec2(indexOnBitmapX, indexOnBitmapY);
}

vec4 getPixelColor(vec2 pixelPos) {
	
	ivec2 fogMapSize = textureSize(fogMap, 0);
	float bitmapPixelWidth = 1.0 / float(fogMapSize.x); // offset used to read color from center of pixel, important to get the pixel, not an uncertain value from pixel border
	
	// vec2 pixelPos = worldPosToPixel(worldPos);
	vec4 bitmapPixel = texture(fogMap, vec2(pixelPos.x, pixelPos.y)); // texture() reads positions on a bitmap between 0.0 and 1.0, not int pixels
	
//	indexOnBitmapX = 0.25;
//	indexOnBitmapY = 0.25;
//	bitmapPixel.r = 0.2;
//	bitmapPixel.g = 0.0;
//	bitmapPixel.b = 0.0;
	
	return bitmapPixel;
}


void vertex() {
	// world pos of currect fog vertex
	vec3 worldPos = ((MODEL_MATRIX) * vec4(VERTEX, 1.0)).xyz;  // transform from view to world space
	vec2 pixelPos = worldPosToPixel(worldPos);

	vec4 bitmapPixel = getPixelColor(pixelPos);

	// we expect grayscale, so we need check only r component. ignore black pixels, they are full fog
	// apparently, when overdrawing the fogMap image with a 0.1 alpha black rect, we will never ever reach full black again. 
	// so let's have some tolerance here as for what counts as black.
	if (bitmapPixel.r > 0.8) {
		VERTEX.y = - (fogMaxDepth * bitmapPixel.r + 10.0);
	}
		
	
	VERTEX.x = VERTEX.x + (bitmapPixel.r) ;
	VERTEX.z = VERTEX.z + (bitmapPixel.r) ;
	
}

void fragment() {
	vec3 worldPos = (inverse(VIEW_MATRIX) * vec4(VERTEX, 1.0)).xyz;  // transform from view to world space
	vec2 pixelPos = worldPosToPixel(worldPos);
	vec4 pixelColor = getPixelColor(pixelPos);

	ALBEDO = pixelColor.rgb * 0.0000001;
	ALPHA = defaultAlpha;

}

