#version 120

varying vec4 color;
varying vec2 imageCoord;
uniform float time;
uniform sampler2D sampler0;
uniform vec2 resolution;
varying vec2 textureCoord;
uniform vec2 imageSize;

uniform float positionx;
uniform float positiony;
uniform float positionz;

//https://www.shadertoy.com/view/7dyXWc

// Created by Yilin Yan aka greenbird10
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0

uniform float fov;
uniform float roty;
uniform float rotx;
uniform float rotz;
uniform float waterheight;

float wavedx(vec2 position, vec2 direction, float time, float freq){
    float x = dot(direction, position) * freq + time;
    return exp(sin(x) - 1.0);
}

float getwaves(vec2 position){
    float iter = 0.0,phase = 6.0,speed = 2.0;
    float weight = 1.0,w = 0.0,ws = 0.0;   
    for(int i=0;i<5;i++){
        vec2 p = vec2(sin(iter), cos(iter));
        float res = wavedx(position,p,speed*time,phase);        
        w += res * weight; ws += weight;
        iter += 12.0; weight *=0.75; phase *= 1.18; speed *= 1.08;
    }
    return w / ws;
}
float sea_octave(vec2 uv,float choppy){
return getwaves(uv*choppy)+getwaves(uv); }

float noise3D(vec3 p){ 
   vec3 s = vec3(7, 157, 113);
   vec3 ip = floor(p); // Unique unit cell ID. 
   vec4 h = vec4(0.0, s.yz, s.y + s.z) + dot(ip, s);
    p -= ip; // Cell's fractional component. 
    p = p*p*(3.0 - 2.0*p); 
    h = mix(fract(sin(h)*43758.5453),fract(sin(h + s.x)*43758.5453),p.x); 
    h.xy = mix(h.xz, h.yw, p.y); 
    return mix(h.x, h.y, p.z);  
}
//borrowed from
//https://www.shadertoy.com/view/Xs33Df
float smaxP(float a, float b, float s){
    float h = clamp(0.5 + 0.5*(a - b)/s,0.0,1.0);
    return mix(b, a, h) + h*(1.0 - h)*s;
}
vec3 Freq=vec3(0.125,0.31,0.128),Amp= vec3(1.0,1.5,2.5);
vec2 path(float z){ return vec2(Amp.x*sin(z * Freq.x),
     Amp.y*cos(z * Freq.y) + Amp.z*(sin(z*Freq.z) - 1.0)); }
float map(vec3 p){
    float n=noise3D(p);
    float tx =n;
    vec3 q = p*0.35;//rock
    float h = dot(sin(q)*cos(q.yzx),vec3(0.222)) 
       + dot(sin(q*1.5)*cos(q.yzx*1.5),vec3(0.111));    
    float d = p.y+h*3.9;//some hills.   
    q = sin(p*0.5 + h);
    h = q.x*q.y*q.z; //tunnel walls.
    p.xy -= path(p.z);//detail wall
    float tnl = 1.5 - length(p.xy*vec2(.33, .66)) + (0.25 - tx*0.35); 
    return smaxP(d, tnl, 2.) - tx*.25 + tnl*.8;
}

#define STEP 12
#define FAR 35.0

float logBisectTrace(vec3 ro, vec3 rd){
    float t = 0., told = 0., mid, dn;
    float d = map(ro);
    float sgn = sign(d);
    for (int i=0; i<STEP; i++){
       if (sign(d) != sgn || d < 0.001 || t > FAR) break; 
        told = t;
        t += step(d,1.0)*(log(abs(d) + 1.1) - d) + d;        
        d = map(rd*t + ro); }
    // If a threshold was crossed without a solution, use the bisection method.
    if (sign(d) != sgn){    
        dn = sign(map(rd*told + ro));        
        vec2 iv = vec2(told, t); // Near, Far
        for (int ii=0; ii<5; ii++){ 
            mid = dot(iv,vec2(0.5));
            float d = map(rd*mid + ro);
            if (abs(d) < 0.001)break;
            iv = mix(vec2(iv.x, mid), vec2(mid, iv.y), step(0.0, d*dn));
        }
        t = mid;       
    }
    return min(t,FAR);
}

vec3 normal(vec3 p,float t){ vec2 e = vec2(-t, t);   
  return normalize(e.yxx*map(p + e.yxx) + e.xxy*map(p + e.xxy) + 
     e.xyx*map(p + e.xyx) + e.y*map(p + e.y));   
} 




vec3 rotY(vec3 v, float th){
  float a = cos(th);
  float b = sin(th);
  return vec3(a*v.x - b*v.z, v.y, b*v.x + a*v.z);
}
//borrowed from 
//https://www.shadertoy.com/view/4ls3zM 
//

vec3 rotX(vec3 v, float th){
  float a = cos(th);
  float b = sin(th);
  return vec3(v.x, a*v.y-b*v.z, b*v.y + a*v.z);
}
//borrowed from 
//mirin
//

vec3 rotZ(vec3 v, float th){
  float a = cos(th);
  float b = sin(th);
  return vec3(a*v.x - b*v.y, b*v.x+a*v.y, v.z);
}
//borrowed from 
//mallow
//

void mainImage( out vec4 fragColor)
{
	//widescreen scale
	float shift = (((resolution.x/resolution.y) / (1.333333)) - 1.0) * 0.5;
	vec2 adjustedImageCoord = vec2(((imageCoord.x) * ((resolution.x/resolution.y) / (1.333333))) - shift, imageCoord.y);
	
	vec2 uv = (( adjustedImageCoord.xy ) * 2.0) - 1.0;
    
    float time = time*0.2;
   
    vec3 pos = vec3(positionx, positiony, positionz);
    vec3 dir = normalize(vec3(uv, fov*-0.005));
    dir = rotY(dir, roty/58);
    dir = rotX(dir, rotx/58);
    dir = rotZ(dir, rotz/58);
    
    //Koenigsegg ft.Daco
    vec3 sun = vec3(-100.6, 0.5,-0.3); 
    float i = max(0.0, 1.2/(length(sun-dir)+1.0));
    vec3 col = vec3(pow(i, 1.9), pow(i, 1.0), pow(i, .8)) * 1.25;
    col = mix(col, vec3(0.0,0.39,0.62),(1.0-dir.y)*0.9);   

     if (dir.y > 0.0){//water suf
        float d = (pos.y-waterheight)/dir.y;  
        vec2 wat = (dir * d).xz-pos.xz;
        d += sin(wat.x + time);
        wat = (dir * d).xz-pos.xz;        
        col += sea_octave(wat,0.5)*0.6 * max(0.7/-d, 0.0);
    }
    else{//rock        
       vec3 ro=pos;ro.y+=12.0;
       
       float t = logBisectTrace(ro,dir);
       vec3 rock=vec3(0.0);
       if (t < FAR){   
        pos=ro+dir*t;
        t/=FAR;
        vec3 sn = normal(pos,0.1/(1.0 + t));
        float fre = clamp(1.0+dot(sun, sn),0.0,1.0); // Fresnel reflection.
        float Schlick = pow(1.0- max(dot(dir, normalize(dir + sun)),0.0), 5.0);
        fre *= mix(0.2, 1.0, Schlick);//Hard clay.
        float dif=dot(sn,sun)*0.2;    
        float y=smoothstep(0.9,1.0,(1.0+dir.y)); 
        if(y>0.0) rock=mix(rock,col, y*t);     
        col=mix(rock,col,t);
      } 
      float f =(-dir.y-0.3+sin(time*0.05)*0.2)*0.3185;
    f = clamp(f, 0.0, 1.0);   
    col = mix(col,rock,f);
    }
    
    col.x += 0.2;
    col.y += 0.0;
    col.z += 0.075;

    fragColor = vec4(col,0.69);
}

void main() {
    mainImage(gl_FragColor.rgba);
}