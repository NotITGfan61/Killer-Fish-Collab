#version 120

varying vec2 textureCoord;
varying vec3 normal;

uniform sampler2D matcapTexture;
uniform float beat;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
varying vec3 position;

uniform float fNoteBeat = 100;

void main() {
  vec3 modelspace_normal = normalize((vec4(normal, 1.0) * modelMatrix).xyz);
  vec2 muv = vec2(viewMatrix * vec4(normalize(modelspace_normal.xyz), 0))*0.49+vec2(0.5,0.5);
  float quant = fract(fNoteBeat);
  //colors

  vec4 col;
  vec4 tint = vec4(1,1,1,1);
  vec4 mcap = texture2D(matcapTexture, vec2(muv.x, 1.0-muv.y));
  col = 1-(1-mcap)/tint;
  gl_FragColor = col;
}
