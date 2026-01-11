#version 120

varying vec4 color;
varying vec2 imageCoord;
uniform float time;
uniform sampler2D sampler0;
uniform vec2 resolution;
varying vec2 textureCoord;
uniform vec2 imageSize;
uniform vec2 textureSize;

vec2 img2tex( vec2 v ) { return v / textureSize * imageSize; }

//https://www.shadertoy.com/view/4tG3WR


void main()
{
    
    vec2 uv = imageCoord;
    
        float X = uv.x*25.+time;
        float Y = uv.y*25.+time;
        uv.y += cos(X+Y)*0.005*cos(Y);
        uv.x += sin(X-Y)*0.005*sin(Y);

      vec3 col = texture2D( sampler0, img2tex(uv) ).rgb;

    gl_FragColor = vec4( col, 1.0 ) * color;
}
