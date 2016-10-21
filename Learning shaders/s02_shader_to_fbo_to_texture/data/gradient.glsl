#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

void main(void)

{    

 vec2 c = vec2 (-1.0 + 2.0 * gl_FragCoord.x / resolution.x, 1.0 - 2.0 * gl_FragCoord.y / resolution.y); 

 gl_FragColor = vec4(c.x*abs(sin(time)), c.y* abs(cos(time)), abs(sin(time/2)), 1.0);

}