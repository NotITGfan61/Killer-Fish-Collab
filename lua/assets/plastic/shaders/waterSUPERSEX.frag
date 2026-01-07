//from https://www.shadertoy.com/view/4slBWN !!

#version 120

// ------

varying vec4 color;
varying vec2 imageCoord;
uniform float time;
uniform sampler2D sampler0;
uniform vec2 resolution;
varying vec2 textureCoord;
uniform vec2 textureSize;
uniform vec2 imageSize;

// ------

float timeSpeed = 0.5;

float randomVal (float inVal)
{
    return fract(sin(dot(vec2(inVal, 2523.2361) ,vec2(12.9898,78.233))) * 43758.5453)-0.5;
}

vec2 randomVec2 (float inVal)
{
    return normalize(vec2(randomVal(inVal), randomVal(inVal+151.523)));
}

float makeWaves(vec2 uv, float theTime, float offset)
{
    float result = 0.0;
    float direction = 0.0;
    float sineWave = 0.0;
    vec2 randVec = vec2(1.0,0.0);
    float i;
    for(int n = 0; n < 16; n++)
    {
        i = float(n)+offset;
        randVec = randomVec2(float(i));
        direction = (uv.x*randVec.x+uv.y*randVec.y);
        sineWave = sin(direction*randomVal(i+1.6516)+theTime*timeSpeed);
        sineWave = smoothstep(0.0,1.0,sineWave);
        result += randomVal(i+123.0)*sineWave;
    }
    return result;
}

vec2 img2tex( vec2 v ) { return v / textureSize * imageSize; }

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = imageCoord;
    
    vec2 uv2 = uv * 100.0; // scale
    
    uv *= 1.0;
    
    float result = 0.0;
    float result2 = 0.0;
    
    result = makeWaves( uv2+vec2(time*timeSpeed,0.0), time, 0.1);
    result2 = makeWaves( uv2-vec2(time*0.8*timeSpeed,0.0), time*0.8+0.06, 0.26);
    
    result = smoothstep(0.4,1.1,1.0-abs(result));
    result2 = smoothstep(0.4,1.1,1.0-abs(result2));
    
    result = 2.0*smoothstep(0.35,2.8,(result+result2)*0.5);
    
    // thank for this code below Shane!
    vec2 p = vec2(result, result2)*.015 + sin(uv*16. - cos(uv.yx*16. + time*timeSpeed))*.015; // Etc.
    fragColor = vec4(result)*0.7+texture2D( sampler0 , img2tex(uv+ p));
}


void main() {
    mainImage(gl_FragColor.rgba, gl_FragCoord.xy);
}