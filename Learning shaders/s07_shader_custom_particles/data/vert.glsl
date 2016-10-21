#define PROCESSING_POINT_SHADER

uniform mat4 projection;
uniform mat4 modelview;

attribute vec4 vertex;
attribute vec4 color;
attribute vec2 offset;

varying vec4 vertColor;

void main() {
  vec4 pos = modelview * vertex;
  vec4 clip = projection * pos;
  
  gl_Position = clip + projection * vec4(offset, 0, 0);
 
  vertColor = color;
}