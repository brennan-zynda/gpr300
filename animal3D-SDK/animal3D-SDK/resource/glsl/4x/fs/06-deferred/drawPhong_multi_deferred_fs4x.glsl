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
	
	drawPhong_multi_deferred_fs4x.glsl
	Draw Phong shading model by sampling from input textures instead of 
		data received from vertex shader.
*/

#version 410

#define MAX_LIGHTS 4

// ****TO-DO: 
//	0) copy original forward Phong shader
//	1) declare g-buffer textures as uniform samplers
//	2) declare light data as uniform block <- Don't, use same lighting data as original Phong shader
//	3) replace geometric information normally received from fragment shader 
//		with samples from respective g-buffer textures; use to compute lighting
//			-> position calculated using reverse perspective divide; requires 
//				inverse projection-bias matrix and the depth map
//			-> normal calculated by expanding range of normal sample
//			-> surface texture coordinate is used as-is once sampled
uniform sampler2D uImage00;
in vec4 vTexcoord;
in vbLightingData {
	vec4 vViewPosition;
	vec4 vViewNormal;
	vec4 vTexcoord;
	vec4 vBiasedClipCoord;
};

layout (location = 0) out vec4 rtFragColor;
layout (location = 4) out vec4 rtDiffuseMapSample;
layout (location = 5) out vec4 rtSpecularMapSample;
layout (location = 6) out vec4 rtDiffuseLightTotal;
layout (location = 7) out vec4 rtSpecularLightTotal;

float lambertCalc(vec4 N, vec4 L)
{
	float dotNL = dot(N, L);
	return max(0.0, dotNL);
}

float specCalc(vec4 view, vec4 reflectBoi)
{
	float spec = pow(max(dot(view,reflectBoi), 0.0),32);
	return spec;	
}

void main()
{
	//rtFragColor = vec4(1.0,0.0,0.0,1.0);
	vec4 diffuse = vec4(0.0);
	vec4 reflectBoi = vec4(0.0);
	vec4 spec = vec4(0.0);
	vec4 view = normalize(vViewPosition);
	vec4 vNormNorm = normalize(vViewNormal);
	for(int i = 0; i < uLightCt; i++)
	{
		diffuse += (uLightCol[i] * lambertCalc(vNormNorm, normalize(uLightPos[i] - vViewPosition)));
		reflectBoi = normalize(reflect(vViewPosition - uLightPos[i], vViewNormal));
		spec += specCalc(view, reflectBoi);
	}
	
	rtFragColor = (spec * texture(uTex_sm, vTexcoord.xy)) + (diffuse * texture(uTex_dm, vTexcoord.xy));
	
	// DEBUGGING:
	//rtFragColor = diffuse;
	//rtFragColor = spec;
	//rtFragColor = uLightPos[1];
	//rtFragColor = uLightCol[1];
	//rtFragColor = vTexcoord;
	//rtFragColor = vViewNormal;
	//rtFragColor = vViewPosition;
}
