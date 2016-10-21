// vert.glsl
#version 330

uniform mat4 transform;

in vec4 position;
in vec4 color;
in float size;

out vec4 vertColor;

void main() {
	
  gl_Position = transform * position;
  gl_PointSize =  100.0*size / gl_Position.w;
  vertColor = color;
}