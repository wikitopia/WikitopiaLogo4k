//Copyright Yuichiro Takeuchi 2018

attribute vec4 position;
uniform mat4 matrix;
uniform vec4 color;
uniform float alpha;

void main()
{
    gl_Position = matrix * position;
    gl_FrontColor = vec4(color[0], color[1], color[2], alpha);
}
