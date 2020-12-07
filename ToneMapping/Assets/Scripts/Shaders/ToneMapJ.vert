#version 330 core

/** vertex shader for tone map by Justin 

fragment shader has reference link
*/

layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoords;

uniform mat4 mvp; ///need model, view, projection matrix passed in.
uniform mat3 normalMatrix;  //meed normal matrix passed in.
uniform mat4 model; //need model patrix passed in. might be identity

out vec2 texCoords;
out vec3 fragPos;
out vec3 normal;

uniform bool inverseNormals;

void main()
{
    //texture coords for hdr calculation
    texCoords = aTexCoords;
    fragPos = vec3(model * vec4(pos, 1.0));

    vec3 n = inverseNormals ? -aNormal : aNormal;
    normal = normalize(normalMatrix * n);

    gl_Position = mvp * vec4(pos, 1.0);


}