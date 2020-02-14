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
	
	passLightingData_shadowCoord_transform_vs4x.glsl
	Vertex shader that prepares and passes lighting data. Outputs transformed 
		position attribute and all others required for lighting. Also computes 
		and passes shadow coordinate.
*/

#version 410

// ****TO-DO: 
//	0) copy previous lighting data vertex shader
//	1) declare MVPB matrix for light
//	2) declare varying for shadow coordinate
//	3) calculate and pass shadow coordinate

layout (location = 0) in vec4 aPosition;
layout (location = 2) in vec4 aNorm;
layout (location = 8) in vec4 aCoord;

uniform mat4 uMV;
uniform mat4 uP;
uniform mat4 uMV_nrm;
uniform mat4 uAtlas;
uniform mat4 uMVPB;

layout (location = 0) out vec4 viewPos;
layout (location = 1) out vec4 vNorm;
layout (location = 2) out vec4 vTexCoord;
layout (location = 3) out vec4 shadowCoord;

void main()
{
	// Updates pixel position based on Model-View Matrix
	viewPos = uMV * aPosition;
	
	// Updates global position based on projection matrix
	gl_Position = uP * viewPos;
	
	// Updates normal attribute
	vNorm = uMV_nrm * aNorm;
	
	// Updates the texture coordinate based upon the Atlas matrix
	vTexCoord = uAtlas * aCoord;
	
	// Shadow Calculations
	shadowCoord = uMVPB * aPosition;
}

