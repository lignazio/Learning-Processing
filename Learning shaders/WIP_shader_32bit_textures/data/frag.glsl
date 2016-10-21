#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D texture;
varying vec4 vertColor;
varying vec2 txtCoords;

void main(void)

{    

 gl_FragColor = texture(texture,txtCoords)*vertColor;

}