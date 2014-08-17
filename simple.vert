#version 150

in vec2 position;
uniform vec2 location;

void
main()
{
    gl_Position = vec4(location + position, 0.0, 1.0);
}
