shader_type spatial;
render_mode blend_mix;

uniform float speed : hint_range(-1,1) = 0.01;

uniform sampler2D noise1;
uniform sampler2D noise2;

uniform sampler2D depth : hint_depth_texture;

uniform vec4 color : source_color;
uniform vec4 color_light : source_color;
uniform vec4 foam_color : source_color;

uniform float wave_height = 0.1;
uniform float wave_speed = 0.005;

uniform float edge_scale = 0.25;
uniform float near = 0.1;
uniform float far = 100.0;

varying vec3 world_position;

float rim(float to_rim){
	to_rim = 2.0 * to_rim - 1.0;
	return near * far / (far + to_rim * (near - far));
}

void fragment() {
	float time = TIME * speed;
	//vec2 uv = vec2(world_position.x, world_position.z) * 0.001;
	//uv = UV;
	vec3 n1 = texture(noise1, UV + time).rgb;
	vec3 n2 = texture(noise2, UV - time * 0.2).rgb;
	
	float light = (n1.r + n2.r) / 2.0;
	float mix_light = floor(light * 10.0) / 10.0;
	vec3 water_color = mix(color.rgb, color_light.rgb, mix_light);
	
	float z_depth = rim(texture(depth, SCREEN_UV).x);
	float z_pos = rim(FRAGCOORD.z);
	float diff = z_depth - z_pos;
	
	ALBEDO = mix(foam_color.rgb, water_color, step(edge_scale, diff));
	//ALBEDO = VERTEX.rgb;
	
	ROUGHNESS = 0.1;
	SPECULAR = 0.0;
}

void vertex() {
	VERTEX.y += wave_height * sin(VERTEX.x + TIME * wave_speed);
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}
