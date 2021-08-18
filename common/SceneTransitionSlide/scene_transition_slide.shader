shader_type canvas_item;
render_mode unshaded;

uniform float _cutoff : hint_range(0.0, 1.0);
uniform sampler2D mask : hint_albedo;
uniform bool _in;

void fragment() 
{
	float value = texture(mask, UV).r;
	
	if(_in)
	{
		if(value < _cutoff)
		{
			COLOR = vec4(COLOR.rgb, 0.0);
		}
		else 
		{
			COLOR = vec4(COLOR.rgb, 1.0);
		}
	}
	else 
	{
		if(value > _cutoff)
		{
			COLOR = vec4(COLOR.rgb, 0.0);
		}
		else 
		{
			COLOR = vec4(COLOR.rgb, 1.0);
		}
	}
}