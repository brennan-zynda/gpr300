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
	
	drawPhong_multi_shadow_mrt_fs4x.glsl
	Draw Phong shading model for multiple lights with MRT output and 
		shadow mapping.
*/

#version 410

// ****TO-DO: 
//	0) copy existing Phong shader -
//	1) receive shadow coordinate -
//	2) perform perspective divide
//	3) declare shadow map texture
//	4) perform shadow test

// All rendering targets (location values based on demo values)
layout (location = 0) out vec4 rtFragColor;
layout (location = 4) out vec4 diffuseMap;
layout (location = 5) out vec4 specularMap;
layout (location = 1) out vec4 viewPosMap;
layout (location = 2) out vec4 normalMap;
layout (location = 3) out vec4 coordinateMap;
layout (location = 6) out vec4 diffuseTotal;
layout (location = 7) out vec4 specularTotal;

// Inbound Uniforms
uniform sampler2D uTex_dm;
uniform sampler2D uTex_sm;
uniform vec4 uLightPos[4];
uniform vec4 uLightCol[4];
uniform int uLightCt;
uniform sampler2D uTex_proj;
uniform sampler2D uTex_shadow;

// Inbound Varyings
layout (location = 0) in vec4 viewPos;
layout (location = 1) in vec4 vNorm;
layout (location = 2) in vec4 vTexCoord;
layout (location = 3) in vec4 shadowCoord;

// Function to calculate lambertian product
float lambertCalc(vec4 N, vec4 L)
{
	float dotNL = dot(N, L);
	return max(0.0, dotNL);
}

// Function to calculate specular product
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
	// Defaulting values
	diffuseTotal = vec4(0.0);
	vec4 reflectBoi = vec4(0.0);
	specularTotal = vec4(0.0);
	
	// Normalizing values for future calculations
	vec4 view = normalize(viewPos - vTexCoord);
	vec4 vNormNorm = normalize(vNorm);
	
	// Calculating totals with each light
	for(int i = 0; i < uLightCt; i++)
	{
		diffuseTotal += (uLightCol[i] * lambertCalc(vNormNorm, normalize(uLightPos[i] - viewPos)));
		reflectBoi = normalize(reflect(viewPos - uLightPos[i], vNormNorm));
		specularTotal += specCalc(view, reflectBoi);
	}
	 
	// Perspective Divide
	vec4 postPerDiv = shadowCoord / shadowCoord.w;
	
	// Shadows :D
	float shadowSample = texture2D(uTex_shadow, postPerDiv.xy).r;
	
	bool fragIsShadowed = (postPerDiv.z > (shadowSample));
	
	if(fragIsShadowed)
	{
		// Scale diffuse
		diffuseTotal *= 0.2;
	}
	// Assigning each display target variable
	viewPosMap = viewPos;
	coordinateMap = vTexCoord;
	normalMap = vec4(vNorm.xyz,1.0);
	specularTotal = vec4(specularTotal.xyz,1.0);
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
