#version 410
/** Fragment shader for tone mapping by Justin Chipman 

good reference code link: https://learnopengl.com/code_viewer_gh.php?code=src/5.advanced_lighting/6.hdr/hdr.cpp
look for links to shaders

*/

in vec2 texCoords; 

out vec4 fragColor;

uniform sampler2D hdrBuffer;
uniform bool hdr;
uniform float exposure;

void main()
{      
    //use high dynamic range to calculate color exposure/brightness
    const float gamma = 2.2;
    vec3 hdrColor = texture(hdrBuffer, texCoords).rgb;
    if(hdr)
    {
        // reinhard tone map calculation
        vec3 result = hdrColor / (hdrColor + vec3(1.0));
        // exposure tone map calculation
        //vec3 result = vec3(1.0) - exp(-hdrColor * exposure);
        // also gamma correct while we're at it       
        result = pow(result, vec3(1.0 / gamma));
        fragColor = vec4(result, 1.0);
    }
    else
    {
        vec3 result = pow(hdrColor, vec3(1.0 / gamma));
        fragColor = vec4(result, 1.0);
    }
}