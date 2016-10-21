

uniform mat4 transform;
uniform mat4 texMatrix;

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D texture;
uniform float pscale;

void main() {

  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);

  vec4 dv = texture2D( texture, vertTexCoord.st ); 
  vec4 newVertexPos = vec4((dv.x-0.5)*pscale,(dv.y-0.5)*pscale,(dv.z-0.5)*pscale,1.0);
  
  gl_Position = transform * newVertexPos;
    
  vertColor = color;
  vertTexCoord = vertTexCoord;
}