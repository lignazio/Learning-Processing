#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;


vec4 f = vec4(1.,1.,1.,1.); 

void main(void)

{    

 vec2 c = vec2 (-1.0 + 2.0 * gl_FragCoord.x / resolution.x, 1.0 - 2.0 * gl_FragCoord.y / resolution.y) ;
 
 float t = time;
 f = vec4(c.x*abs(sin(t)), c.y* abs(cos(t)), abs(sin(t/2)), 1.0); 

 gl_FragColor = f;

}