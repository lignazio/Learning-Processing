#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform sampler2D texture1;

void main(void)

{    

 vec2 xy = vec2(gl_FragCoord.x / resolution.x, 1.0-gl_FragCoord.y / resolution.y);
 gl_FragColor = texture2D(texture1,xy);;

}