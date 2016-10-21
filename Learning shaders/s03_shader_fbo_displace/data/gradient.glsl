#ifdef GL_ES
precision highp float;
#endif
#define M_PI 3.1415926535897932384626433832795

uniform float time;
uniform vec2 resolution;

void main(void)

{    

 vec2 st = gl_FragCoord.xy/resolution.xy;
 
 gl_FragColor = vec4(st.x,st.y,0.5*abs(cos(st.x*M_PI+time)*sin(st.y*M_PI+time)),1.0);

}