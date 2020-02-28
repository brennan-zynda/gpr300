/*
	Copyright 2011-2020 Daniel S. Buckstein

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

/*
	animal3D SDK: Minimal 3D Animation Framework
	By Daniel S. Buckstein
	
	drawTexture_brightPass_fs4x.glsl
	Draw texture sample with brightening.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) implement brightness function (e.g. luminance)
//	2) use brightness to implement tone mapping or just filter out dark areas

uniform sampler2D uImage00;

layout (location = 0) out vec4 rtFragColor;

layout (location = 0) in vec4 vTexCoord;

// (1)
float relativeLuminance(vec3 c)
{
	return (0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b);
}

vec3 lumaToneMap(vec3 color)
{
	float white = 2.0;
	float gamma = 2.2;
	float luma = relativeLuminance(color);
	float toneMap = luma * (1.0 + luma / (white*white)) / (1.0 + luma);
	color *= toneMap/luma;
	color = pow(color, vec3(1.0 / gamma));
	return color;
}

void main()
{
	vec4 tex = texture(uImage00, vTexCoord.xy);
	rtFragColor = vec4(lumaToneMap(tex.rgb),1) * tex;
	
	// DEBUGGING:
	//rtFragColor = vtCoord;
}
