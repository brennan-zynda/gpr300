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
	
	drawPhong_multi_mrt_fs4x.glsl
	Draw Phong shading model for multiple lights with MRT output.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variables for textures; see demo code for hints
//	2) declare uniform variables for lights; see demo code for hints
//	3) declare inbound varying data
//	4) implement Phong shading model
//	Note: test all data and inbound values before using them!
//	5) set location of final color render target (location 0)
//	6) declare render targets for each attribute and shading component


layout (location = 0) out vec4 rtFragColor;
layout (location = 4) out vec4 diffuseMap;
layout (location = 5) out vec4 specularMap;
layout (location = 1) out vec4 viewPosMap;
layout (location = 2) out vec4 normalMap;
layout (location = 3) out vec4 coordinateMap;
layout (location = 6) out vec4 diffuseTotal;
layout (location = 7) out vec4 specularTotal;

uniform sampler2D uTex_dm;
uniform sampler2D uTex_sm;
uniform vec4 uLightPos[4];
uniform vec4 uLightCol[4];
uniform int uLightCt;

layout (location = 0) in vec4 viewPos;
layout (location = 1) in vec4 vNorm;
layout (location = 2) in vec4 vTexCoord;

float lambertCalc(vec4 N, vec4 L)
{
	float dotNL = dot(N, L);
	return max(0.0, dotNL);
}

float specCalc(vec4 view, vec4 reflectBoi)
{
	float spec = max(dot(view,reflectBoi), 0.0);
	spec *= spec; // ^2
	spec *= spec; // ^4
	spec *= spec; // ^8
	return spec;	
}

void main()
{
	//rtFragColor = vec4(1.0,0.0,0.0,1.0);
	diffuseTotal = vec4(0.0);
	vec4 reflectBoi = vec4(0.0);
	specularTotal = vec4(0.0);
	vec4 view = normalize(viewPos - vTexCoord);
	vec4 vNormNorm = normalize(vNorm);
	for(int i = 0; i < uLightCt; i++)
	{
		diffuseTotal += (uLightCol[i] * lambertCalc(vNormNorm, normalize(uLightPos[i] - viewPos)));
		reflectBoi = normalize(reflect(viewPos - uLightPos[i], vNormNorm));
		specularTotal += specCalc(view, reflectBoi);
	}
	
	// Assigning each display target variable
	viewPosMap = viewPos;
	coordinateMap = vTexCoord;
	normalMap = vNorm;
	diffuseMap = texture(uTex_dm, vTexCoord.xy);
	specularMap = texture(uTex_sm, vTexCoord.xy);
	rtFragColor = (specularTotal * specularMap) + (diffuseTotal * diffuseMap);
	
	// DEBUGGING:
	//rtFragColor = diffuse;
	//rtFragColor = uLightPos[1];
	//rtFragColor = uLightCol[1];
	//rtFragColor = vCoord;
	//rtFragColor = vNorm;
	//rtFragColor = viewPos;
}
