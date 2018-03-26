//Copyright Yuichiro Takeuchi 2018

attribute vec4 position;
attribute vec2 texCoord;

varying vec2 texCoordOut;

void main()
{
    gl_Position = position;
    texCoordOut = texCoord;
}
