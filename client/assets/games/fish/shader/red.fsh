#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

void main()
{
    vec4 color1 = texture2D(CC_Texture0, v_texCoord) * v_fragmentColor;
	float gray = (color1.r + color1.g + color1.b) * (1. / 3.);
	color1 = color1*vec4(2.4,0.4,0.4,1);
    gl_FragColor =color1;
}
