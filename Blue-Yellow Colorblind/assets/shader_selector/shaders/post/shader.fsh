#version 330

uniform sampler2D MainSampler;
uniform sampler2D DataSampler;
uniform sampler2D BlurSampler;

uniform vec2 OutSize;

#moj_import <shader_selector:marker_settings.glsl>
#moj_import <shader_selector:utils.glsl>
#moj_import <shader_selector:data_reader.glsl>

in vec2 texCoord;

out vec4 fragColor;

void main() {
    vec4 texColor = texture(MainSampler, texCoord); // Fetch base texture color
    fragColor = texColor; // Initialize fragColor

        vec3 color = fragColor.rgb;
        // New Tritanopia transformation matrix
        mat3 tritanopiaMatrix = mat3(
            0.9502, 0.0505, 0.0,  // Red transformation
           0.0,      0.4331,      0.5670,      // Green transformation
            0.0,      0.4750,      0.5250       // Blue transformation
        );
        color = tritanopiaMatrix * color; // Apply the Tritanopia transformation
        fragColor.rgb = mix(fragColor.rgb, color, 1);

#ifdef DEBUG
    // Show data sampler on screen
    if (texCoord.x < .25 && texCoord.y < .25) {
        vec2 debugUV = texCoord * 4.0;
        vec4 col = texture(DataSampler, debugUV);
        if (debugUV.x > 1. / 5.0)
            col = vec4(vec3(fract(decodeColor(col))), 1.0);
        fragColor = col;
    }
#endif
}
