#ifdef GL_ES
precision highp float;
#endif

uniform mat4 transform;
uniform mat4 texMatrix;

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D texture;
uniform sampler2D texturex;
uniform sampler2D texturey;
uniform sampler2D texturez;
uniform float pscale;


//Functions to encode and decode values
// 32bit float <----> rgba

vec3 encodeFloatToVec3( const in float f ) {  
   vec3 color;  
   color.b = floor(f / 255.0 / 255.0);  
   color.g = floor( (f - (color.b * 255.0 * 255.0) ) / 255.0 );  
   color.r = floor( f - (color.b * 255.0 * 255.0) - (color.g * 255.0) );  
   
     
   // color.rgb are in range 0:255, but GLSL  
   // buffer needs values in 0:1 range.   
   // Divide through by 255.  
   return (color/255.0);  
 }  
   
   
 // This function has an extra *255 for RGB compared  
 // to the processing sketch because GLSL operates RGB  
 // in the 0:1 range, processing in 0:255  
 float decodeVec3ToFloat( vec3 color) {  
   float result;  
   result = float(color.r * 255.0);  
   result += float(color.g * 255.0 * 255.0 );  
   result += float(color.b * 255.0 * 255.0 * 255.0);  
   return result;  
 }  
   

void main() {

  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);

  vec4 dv = texture2D( texture, vertTexCoord.st ); 
  vec4 dvx = texture2D( texturex, vertTexCoord.st ); 
  vec4 dvy = texture2D( texturey, vertTexCoord.st ); 
  vec4 dvz = texture2D( texturez, vertTexCoord.st ); 

  float valuex = decodeVec3ToFloat(dvx.xyz)/16777216.0;
  float valuey = decodeVec3ToFloat(dvy.xyz)/16777216.0;
  float valuez = decodeVec3ToFloat(dvz.xyz)/16777216.0;

  vec4 newVertexPos = vec4((valuex-0.5)*pscale,(valuey-0.5)*pscale,(valuez-0.5)*pscale,1.0);
  //vec4 newVertexPos = vec4(vertex.x,vertex.y,(valuez-0.5)*pscale,1.0);
  
  gl_Position = transform * newVertexPos;
  vertColor = color;
  
}