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
	
	drawPhong_multi_fs4x.glsl
	Draw Phong shading model for multiple lights.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variables for textures; see demo code for hints
//	2) declare uniform variables for lights; see demo code for hints
//	3) declare inbound varying data
//	4) implement Phong shading model
//	Note: test all data and inbound values before using them!

out vec4 rtFragColor;

uniform sampler2D uTex_dm;
uniform sampler2D uTex_sm;
uniform vec4 uLightPos[4];
uniform vec4 uLightCol[4];
uniform int uLightCt;

in vec4 viewPos;
in vec4 vNorm;
in vec4 vCoord;

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
	vec4 view = normalize(viewPos);
	vec4 vNormNorm = normalize(vNorm);
	for(int i = 0; i < uLightCt; i++)
	{
		diffuse += (uLightCol[i] * lambertCalc(vNormNorm, normalize(uLightPos[i] - viewPos)));
		reflectBoi = normalize(reflect(viewPos - uLightPos[i], vNorm));
		spec += specCalc(view, reflectBoi);
	}
	
	rtFragColor = (spec * texture(uTex_sm, vCoord.xy)) + (diffuse * texture(uTex_dm, vCoord.xy));
	
	// DEBUGGING:
	//rtFragColor = diffuse;
	//rtFragColor = spec;
	//rtFragColor = uLightPos[1];
	//rtFragColor = uLightCol[1];
	//rtFragColor = vCoord;
	//rtFragColor = vNorm;
	//rtFragColor = viewPos;
}