// vert.glsl

uniform mat4 transform;
uniform sampler2D texture;

in vec4 position;
in vec4 color;
in vec2 uvs;

out vec4 vertColor;
out vec2 txtCoords;

void main() {
  gl_Position = transform * position;
  vertColor = color;
  txtCoords = uvs;
}