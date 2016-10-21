// frag.glsl
#version 330

uniform mat4 transform;

in vec4 vertColor;

out vec4 fragColor;

void main() {
  if(distance(gl_PointCoord.st, vec2(0.5,0.5)) > 0.5) {
    discard;
  }
  fragColor = vertColor;
}