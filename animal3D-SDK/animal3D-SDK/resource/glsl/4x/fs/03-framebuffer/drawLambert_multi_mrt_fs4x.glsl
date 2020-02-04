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
	
	drawLambert_multi_mrt_fs4x.glsl
	Draw Lambert shading model for multiple lights with MRT output.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variable for texture; see demo code for hints
//	2) declare uniform variables for lights; see demo code for hints
//	3) declare inbound varying data
//	4) implement Lambert shading model
//	Note: test all data and inbound values before using them!
//	5) set location of final color render target (location 0)
//	6) declare render targets for each attribute and shading component

layout (location = 0) out vec4 rtFragColor;
layout (location = 4) out vec4 diffuseMap;
layout (location = 1) out vec4 viewPosMap;
layout (location = 2) out vec4 normalMap;
layout (location = 3) out vec4 coordinateMap;

uniform sampler2D uTex_dm;
uniform vec4 uLightPos[4];
uniform vec4 uLightCol[4];
uniform int uLightCt;

in vec4 viewPos;
in vec4 vNorm;
layout (location = 3) in vec4 vCoord;

float lambertCalc(vec4 N, vec4 L)
{
	vec4 normN = normalize(N);
	vec4 normL = normalize(L);
	float dotNL = dot(normN, normL);
	return max(0.0, dotNL);
}

void main()
{
	//rtFragColor = vec4(1.0,0.0,0.0,1.0);
	diffuseMap = vec4(0.0);
	for(int i = 0; i < uLightCt; i++)
	{
		diffuseMap += (uLightCol[i] * lambertCalc(vNorm, vCoord - uLightPos[i]));
	}
	rtFragColor = diffuseMap * texture(uTex_dm, vCoord.xy);
	
	// DEBUGGING:
	//rtFragColor = diffuse;
	//rtFragColor = uLightPos[1];
	//rtFragColor = uLightCol[1];
	//rtFragColor = vCoord;
	//rtFragColor = vNorm;
	//rtFragColor = viewPos;
}
