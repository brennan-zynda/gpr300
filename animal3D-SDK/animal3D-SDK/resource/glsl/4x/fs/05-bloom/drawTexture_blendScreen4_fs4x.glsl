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
	
	drawTexture_blendScreen4_fs4x.glsl
	Draw blended sample from multiple textures using screen function.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) declare additional texture uniforms
//	2) implement screen function with 4 inputs
//	3) use screen function to sample input textures

// Inbound Varyings
layout (location = 0) in vec4 vTexCoord;

// Inbound Uniforms
uniform sampler2D uImage00;
uniform sampler2D uImage01;
uniform sampler2D uImage02;
uniform sampler2D uImage03;

// All rendering targets (location values based on demo values)
layout (location = 0) out vec4 rtFragColor;

vec4 screen(vec4 A, vec4 B, vec4 C, vec4 D)
{
	return 1-((1-A)*(1-B)*(1-C)*(1-D));
}

void main()
{
	// DUMMY OUTPUT: all fragments are OPAQUE WHITE
	//rtFragColor = vec4(1.0, 1.0, 1.0, 1.0);
	
	// Lab 2 Texturing Shader
	vec4 blurTex8 = texture(uImage00, vTexCoord.xy);
	vec4 blurTex4 = texture(uImage01, vTexCoord.xy);
	vec4 blurTex2 = texture(uImage02, vTexCoord.xy);
	vec4 brightTex = texture(uImage03, vTexCoord.xy);
	rtFragColor = screen(blurTex8,blurTex4,blurTex2,brightTex);
}
