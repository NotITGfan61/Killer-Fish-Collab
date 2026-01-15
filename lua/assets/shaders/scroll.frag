#version 120
varying vec2 imageCoord;

uniform vec2 textureSize;
uniform vec2 imageSize;
uniform sampler2D sampler0;
uniform float beat;

uniform float scrolly = 0.0;
uniform float scrollx = 0.0;

varying vec4 color;

vec2 img2tex(vec2 uv){
	return uv / textureSize * imageSize;
}

void main()
{
	
	
	vec2 uv = imageCoord;
	
	vec4 col = vec4(0.0,0.0,0.0,0.0);
	
	
	col = texture2D(sampler0, img2tex(uv-vec2(fract(scrollx),fract(scrolly))) );
	
	if (uv.y <= fract(scrolly)){
	col = texture2D(sampler0, img2tex(vec2(uv.x,uv.y+1.0-fract(scrolly))) );
	}
	
	if (uv.x <= fract(scrollx)){
	col = texture2D(sampler0, img2tex(vec2(uv.x+1.0-fract(scrollx),uv.y)) );
	}
	
	if (uv.y <= fract(scrolly) && uv.x <= fract(scrollx)){
	col = texture2D(sampler0, img2tex(vec2(uv.x+1.0-fract(scrollx),uv.y+1.0-fract(scrolly))) );
	}
	
	
	gl_FragColor = col * color;
}