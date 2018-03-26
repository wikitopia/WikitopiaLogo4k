//Copyright Yuichiro Takeuchi 2018

varying vec2 texCoordOut;

uniform sampler2D sampler;
uniform float alpha;

void main()
{
    vec4 tex = texture2D(sampler, texCoordOut);
    gl_FragColor = vec4(vec3(tex[0], tex[1], tex[2]), alpha);
}
