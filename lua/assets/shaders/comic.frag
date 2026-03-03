#version 120
 // shader source https://www.shadertoy.com/view/Ds2fRD
 
uniform float time;
uniform vec3 mouse;
uniform vec2 resolution;
uniform vec2 imageSize;
uniform vec2 textureSize;
varying vec2 textureCoord;
varying vec2 imageCoord;
uniform sampler2D sampler0;
uniform sampler2D samplerRandom;


vec2 img2tex( vec2 v ) { return v / textureSize * imageSize; }


///original shadertoy begins here///
// Convert rgb color to cmyk
vec4 cmyk(vec3 c) {
    float k = 1.0 - max(c.r, max(c.g, c.b));
    return vec4(
        (1.0 - c.r - k) / (1.0 - k),
        (1.0 - c.g - k) / (1.0 - k),
        (1.0 - c.b - k) / (1.0 - k),
        k
    );
}

// Grid pattern rotated by 'a' radians with the density 'dens'
vec2 grid(vec2 uv, float a, float dens) {
    vec2 aspect = imageSize.xy / imageSize.y;
    return vec2(
        mod(((uv.x * aspect.x) * cos(a) - uv.y * sin(a)) * dens, 1.0), 
        mod(((uv.x * aspect.x) * sin(a) + uv.y * cos(a)) * dens, 1.0)
    );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (imageCoord*imageSize)/imageSize.xy;

    vec3 col = texture2D(sampler0, img2tex(uv)).rgb;
    
    //Color of the image, converted to cmyk
    vec4 cmyk = cmyk(col);
    
    //Density of the dots
    float dens = 100.0;
    
    //Rotation angles for different ink colors
    //http://the-print-guide.blogspot.com/2009/05/halftone-screen-angles.html
    float ca = 0.261;
    float ma = 1.309;
    float ya = 0.0;
    float ka = 0.785;
    
    vec2 cgrid = grid(uv, ca, dens);
    
    float cb = cmyk.x * 0.8 / length(cgrid - vec2(0.5));
    cb = pow(cb, 5.0);
    cb = max(min(cb, 1.0), 0.0);
    vec3 cv = vec3(cb, 0.0, 0.0);
    
    vec2 mgrid = grid(uv, ma, dens);
    
    float mb = cmyk.y * 0.9 / length(mgrid - vec2(0.5));
    mb = pow(mb, 5.0);
    mb = max(min(mb, 1.0), 0.0);
    vec3 mv = vec3(0.0, mb, 0.0);
    
    vec2 ygrid = grid(uv, ya, dens);
    
    float yb = cmyk.z * 0.8 / length(ygrid - vec2(0.5));
    yb = pow(yb, 5.0);
    yb = max(min(yb, 1.0), 0.0);
    vec3 yv = vec3(0.0, 0.0, yb);
    
    vec2 kgrid = grid(uv, ka, dens);
    
    float kb = cmyk.w * 0.6 / length(kgrid - vec2(0.5));
    kb = pow(kb, 5.0);
    kb = max(min(kb, 1.0), 0.0);
    vec3 kv = vec3(kb);

    // Output to screen
    fragColor = vec4(vec3(1.0) - cv - mv - yv - kv,1.0);
} 
///original shadertoy ends here///

void main()
{
	mainImage(gl_FragColor.rgba, gl_FragCoord.xy);
}