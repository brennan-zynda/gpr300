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

// All rendering targets (location values based on demo values)
layout (location = 0) out vec4 rtFragColor;
layout (location = 6) out vec4 diffuseTotal;
layout (location = 1) out vec4 viewPosMap;
layout (location = 2) out vec4 normalMap;
layout (location = 3) out vec4 coordinateMap;
layout (location = 4) out vec4 diffuseMap;

// Inbound Uniforms
uniform sampler2D uTex_dm;
uniform vec4 uLightPos[4];
uniform vec4 uLightCol[4];
uniform int uLightCt;

// Inbound Varyings
layout (location = 0) in vec4 viewPos;
layout (location = 1) in vec4 vNorm;
layout (location = 2) in vec4 vCoord;

// Function to calculate lambertian product
float lambertCalc(vec4 N, vec4 L)
{
	float dotNL = dot(N, L);
	return max(0.0, dotNL);
}

void main()
{
	// Defaulting values
	diffuseTotal = vec4(0.0);
	
	// Normalizing values for future calculations
	vec4 vNormNorm = normalize(vNorm);
	
	// Calculating diffuse total for each light
	for(int i = 0; i < uLightCt; i++)
	{
		diffuseTotal += (uLightCol[i] * lambertCalc(vNormNorm, normalize(vCoord - uLightPos[i])));
	}
	
	// Assigning each display target variable
	diffuseMap = texture(uTex_dm, vCoord.xy);
	rtFragColor = diffuseTotal * diffuseMap;
	viewPosMap = viewPos;
	normalMap = vec4(vNorm.xyz,1.0);
	coordinateMap = vCoord;
	
	// DEBUGGING:
	//rtFragColor = diffuse;
	//rtFragColor = uLightPos[1];
	//rtFragColor = uLightCol[1];
	//rtFragColor = vCoord;
	//rtFragColor = vNorm;
	//rtFragColor = viewPos;
}
