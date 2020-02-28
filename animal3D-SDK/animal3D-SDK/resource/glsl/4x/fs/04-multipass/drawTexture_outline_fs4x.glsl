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
	
	drawTexture_outline_fs4x.glsl
	Draw texture sample with outlines.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) implement outline algorithm - see render code for uniform hints

// Algorithm found from https://en.wikipedia.org/wiki/Sobel_operator

uniform sampler2D uTex_dm;

layout (location = 0) out vec4 rtFragColor;

layout (location = 3) in vec4 vTexCoord;

mat3 sx = mat3( 
    1.0, 2.0, 1.0, 
    0.0, 0.0, 0.0, 
   -1.0, -2.0, -1.0 
);

mat3 sy = mat3( 
    1.0, 0.0, -1.0, 
    2.0, 0.0, -2.0, 
    1.0, 0.0, -1.0 
);

void main()
{
	mat3 I;
	vec4 baseTex = texture(uTex_dm, vTexCoord.xy);
	for(int i = 0; i < 3; i++)
	{
		for(int j = 0; j < 3; j++)
		{
			vec3 temp = texelFetch(uTex_dm, ivec2(gl_FragCoord) + ivec2(i-1,j-1),0).rgb;
			I[i][j] = length(temp);
		}
	}
	
	float gx = dot(sx[0], I[0]) + dot(sx[1], I[1]) + dot(sx[2], I[2]);
	float gy = dot(sy[0], I[0]) + dot(sy[1], I[1]) + dot(sy[2], I[2]);
	
	float g = sqrt(gx*gx + gy*gy);
	
	rtFragColor = vec4(baseTex.rgb - vec3(g),1.0);
	
	// DEBUGGING:
	//rtFragColor = vTexCoord;
}