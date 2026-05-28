{
	"type": "fx",
	"cullingRadius": 50,
	"children": [
		{
			"type": "object",
			"name": "FXRoot",
			"scaleX": 0.8,
			"scaleY": 0.8,
			"scaleZ": 0.8,
			"children": [
				{
					"type": "object",
					"name": "WaterFallTest",
					"z": 22.4,
					"children": [
						{
							"type": "model",
							"name": "M_Waterfall_lake",
							"source": "Fx/_Resources/Meshes_Common/M_Waterfall.fbx",
							"x": 0.02,
							"y": 2.08,
							"z": 29.01,
							"scaleX": 5,
							"scaleY": 5,
							"scaleZ": 5,
							"children": [
								{
									"type": "material",
									"name": "material",
									"props": {
										"PBR": {
											"mode": "BeforeTonemapping",
											"blend": "Alpha",
											"shadows": false,
											"culling": "None",
											"colorMask": 255
										}
									},
									"diffuseMap": "Fx/_Resources/Gradients/z_FillWhite.jpg",
									"refMatLib": ""
								},
								{
									"type": "shader",
									"name": "SHADER_LakeTest",
									"source": "Fx/Environment/SHADER_Lake.shgraph",
									"props": {
										"ColorDistance": 6,
										"WaterColor1": [
											0.11764705882352941,
											0.6901960784313725,
											0.6039215686274509,
											1
										],
										"WaterColor2": [
											0.03529411764705882,
											0.34901960784313724,
											0.42745098039215684,
											1
										],
										"Opacity": 0.35,
										"Opacity2": 0.9,
										"PerlinDisto": "Fx/_Resources/Noise/perlin4.jpg",
										"PerlinDisto_Tiling": 0.1,
										"PerlinDisto_Speed": 0.2,
										"BorderColor": [
											0.803921568627451,
											1,
											0.9215686274509803,
											1
										],
										"BorderDistance": 3.5,
										"BorderWigglyScale": 0.1,
										"BorderScale": 0.24,
										"BorderOpacity": 0.25
									}
								},
								{
									"type": "shader",
									"name": "VertexDisplacement",
									"source": "shaders/VertexDisplacement.hx",
									"props": {
										"X": true,
										"Y": true,
										"Z": true,
										"useNormal": true,
										"texScaleX": 8,
										"texScaleY": 0.1,
										"tex": "Fx/_Resources/Noise/T_FireSharp.png",
										"intensity": 0.5,
										"scrollSpeed": [
											0.1,
											-0.5
										],
										"useWorld": false,
										"centered": false
									}
								},
								{
									"type": "shader",
									"name": "DissolveMap",
									"source": "shaders/DissolveMap.hx",
									"props": {
										"useSourceUVs": true,
										"useScale": false,
										"wrap": true,
										"progress": 0.25,
										"saturation": 1,
										"width": 1,
										"uvScaleX": 1,
										"uvScaleY": 1,
										"texture": {
											"type": "gradient",
											"data": {
												"stops": [
													{
														"position": 0,
														"color": -16777216
													},
													{
														"position": 0.3359375,
														"color": -1
													}
												],
												"resolution": 64,
												"isVertical": true,
												"interpolation": "Linear",
												"colorMode": 0
											}
										},
										"uvShift": [
											0,
											0
										],
										"uvShiftSpeed": [
											0,
											0
										]
									}
								},
								{
									"type": "shader",
									"name": "AlphaKill",
									"source": "shaders/AlphaKill.hx",
									"props": {
										"threshold": 0.1,
										"useRGB": false
									}
								}
							]
						},
						{
							"type": "object",
							"name": "WaterFall",
							"y": 1.9,
							"z": 27.75,
							"children": [
								{
									"type": "sound",
									"name": "event:/Ambiance/Amb_3D/Waterfall/Waterfall_Lake",
									"y": 10
								},
								{
									"type": "model",
									"name": "M_Waterfall",
									"source": "Fx/_Resources/Meshes_Common/M_Waterfall.fbx",
									"x": 0.0167,
									"y": 0.08,
									"z": 1.55,
									"scaleX": 5,
									"scaleY": 5,
									"scaleZ": 5,
									"children": [
										{
											"type": "material",
											"name": "material",
											"props": {
												"PBR": {
													"mode": "BeforeTonemapping",
													"blend": "Alpha",
													"shadows": false,
													"culling": "None",
													"colorMask": 255,
													"depthTest": "LessEqual",
													"alphaKill": true
												}
											}
										},
										{
											"type": "shader",
											"name": "SHADER_WaterFall",
											"source": "Fx/Environment/SHADER_WaterFall.shgraph",
											"props": {
												"ReflectionEmissiveIntensity": 1,
												"ReflectionDissolve": "Fx/_Resources/Noise/FlareNoise01_Sharper.png",
												"ReflectionDissolveScale": [
													5,
													0.5
												],
												"ReflectionDissolve_ScrollSpeed": [
													0.2,
													-1
												],
												"ReflectionMask": "Fx/_Resources/Alphas/TEX_WaterSpec02.png",
												"ReflectionMask_Offset": [
													0,
													-0.035
												],
												"ReflectionMask_Scale": [
													3,
													1.77
												],
												"ReflectionDisto": "Fx/_Resources/Noise/T_FireSharp.png",
												"ReflectionDisto_Scale": [
													2,
													1
												],
												"ReflectionDisto_Speed": [
													0,
													-1
												],
												"ReflectionDisto_Intensity": 0.01,
												"TrailsTexture": "Fx/_Resources/Alphas/TEX_WaterSpec04.png",
												"Trails_Scale01": [
													3,
													2
												],
												"Trails_Speed01": [
													-0.1,
													-1.2
												],
												"Trails_Scale02": [
													1,
													1
												],
												"Trails_Speed02": [
													0,
													-1.3
												],
												"CouleTexture": "Fx/_Resources/Noise/T_WaterNoise.png",
												"CouleOpacity": 0.2,
												"CouleScale01": [
													1,
													0.5
												],
												"CouleSpeed01": [
													-0.05,
													-0.5
												],
												"CouleScale02": [
													0.5,
													0.25
												],
												"CouleSpeed02": [
													0.05,
													-0.25
												]
											}
										},
										{
											"type": "shader",
											"name": "ColorSet",
											"source": "shaders/ColorSet.hx",
											"props": {
												"amount": 1,
												"color": [
													1,
													1,
													1
												]
											}
										},
										{
											"type": "shader",
											"name": "GradientMap",
											"source": "shaders/GradientMap.hx",
											"props": {
												"USE_ALPHA": true,
												"gradient": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0,
																"color": -8674654
															},
															{
																"position": 1,
																"color": -1903886
															}
														],
														"resolution": 64,
														"isVertical": false,
														"interpolation": "Linear",
														"colorMode": 0
													}
												}
											}
										},
										{
											"type": "shader",
											"name": "SHADER_UVDistortion_OnMask",
											"source": "Fx/Shaders/SHADER_UVDistortion_OnMask.shgraph",
											"props": {
												"1": 1,
												"TEX_Distortion": "Fx/_Resources/Noise/FlareNoise03.png",
												"Scale": [
													2,
													1
												],
												"Speed": [
													0,
													-1
												],
												"Power": 0.88,
												"Mask": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0.10546875,
																"color": -16777216
															},
															{
																"position": 0.33984375,
																"color": -1
															}
														],
														"resolution": 64,
														"isVertical": true,
														"interpolation": "Linear",
														"colorMode": 0
													}
												},
												"Progress": 0.23,
												"Saturation": 1,
												"Width": 1,
												"SourceUV": 0,
												"IF_AlphaInput": 1
											}
										},
										{
											"type": "shader",
											"name": "VertexDisplacement",
											"source": "shaders/VertexDisplacement.hx",
											"props": {
												"X": true,
												"Y": true,
												"Z": true,
												"useNormal": true,
												"texScaleX": 8,
												"texScaleY": 0.1,
												"tex": "Fx/_Resources/Noise/T_FireSharp.png",
												"intensity": 0.5,
												"scrollSpeed": [
													0.1,
													-0.5
												],
												"useWorld": false,
												"centered": false
											}
										},
										{
											"type": "shader",
											"name": "AlphaKill",
											"source": "shaders/AlphaKill.hx",
											"props": {
												"threshold": 0.1,
												"useRGB": false
											}
										}
									]
								},
								{
									"type": "model",
									"name": "M_BottomTrail",
									"source": "Fx/_Resources/Meshes_Common/M_Waterfall.fbx",
									"x": 0.0167,
									"y": 0.08,
									"z": -3.1,
									"scaleX": 5,
									"scaleY": 5,
									"scaleZ": 5,
									"children": [
										{
											"type": "material",
											"name": "material",
											"props": {
												"PBR": {
													"mode": "BeforeTonemapping",
													"blend": "Alpha",
													"shadows": false,
													"culling": "None",
													"colorMask": 255,
													"depthTest": "LessEqual",
													"alphaKill": true,
													"textureWrap": true
												}
											},
											"diffuseMap": "Fx/_Resources/Gradients/z_FillWhite.jpg"
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": false,
												"useScale": true,
												"wrap": false,
												"progress": 0.27,
												"saturation": 1,
												"width": 0.29,
												"uvScaleX": 0.5,
												"uvScaleY": 2,
												"texture": "Fx/_Resources/Alphas/TEX_WaterWave_Left.png",
												"uvShift": [
													0,
													-0.2
												],
												"uvShiftSpeed": [
													-1,
													0
												]
											}
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": false,
												"progress": 0.78,
												"saturation": 1,
												"width": 0.29,
												"uvScaleX": 1,
												"uvScaleY": 0.5,
												"texture": "Fx/_Resources/Noise/FlareNoise01_Sharper.png",
												"uvShift": [
													0,
													-0.2
												],
												"uvShiftSpeed": [
													0,
													-1
												]
											}
										},
										{
											"type": "shader",
											"name": "UVDistortion",
											"source": "shaders/UVDistortion.hx",
											"props": {
												"noiseTexture": "Fx/_Resources/Noise/T_Noise_Water_04.png",
												"directionalNoise": true,
												"intensity": 0.33,
												"scrollSpeed": [
													0,
													-1
												],
												"scale": [
													4,
													1
												],
												"useSourceUV": true
											}
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": true,
												"useScale": false,
												"wrap": true,
												"progress": 0.61,
												"saturation": 1,
												"width": 0.76,
												"uvScaleX": 1,
												"uvScaleY": 1,
												"texture": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0.15625,
																"color": -1
															},
															{
																"position": 0.609375,
																"color": -16777216
															},
															{
																"position": 0.94140625,
																"color": -1
															}
														],
														"resolution": 64,
														"isVertical": true,
														"interpolation": "Constant",
														"colorMode": 0
													}
												},
												"uvShift": [
													0,
													0
												],
												"uvShiftSpeed": [
													0,
													0
												]
											}
										},
										{
											"type": "shader",
											"name": "ColorSet",
											"source": "shaders/ColorSet.hx",
											"props": {
												"amount": 1,
												"color": [
													0.8862745098039215,
													0.9490196078431372,
													0.9490196078431372
												]
											}
										},
										{
											"type": "shader",
											"name": "AlphaMult",
											"source": "shaders/AlphaMult.hx",
											"props": {
												"alpha": 0.27
											}
										},
										{
											"type": "shader",
											"name": "VertexDisplacement",
											"source": "shaders/VertexDisplacement.hx",
											"props": {
												"X": true,
												"Y": true,
												"Z": true,
												"useNormal": true,
												"texScaleX": 8,
												"texScaleY": 0.1,
												"tex": "Fx/_Resources/Noise/T_FireSharp.png",
												"intensity": 0.5,
												"scrollSpeed": [
													0.1,
													-0.5
												],
												"useWorld": false,
												"centered": false
											}
										},
										{
											"type": "shader",
											"name": "AlphaKill",
											"source": "shaders/AlphaKill.hx",
											"props": {
												"threshold": 0.1,
												"useRGB": false
											}
										}
									]
								},
								{
									"type": "model",
									"name": "M_Waterfall_Sides02",
									"source": "Fx/_Resources/Meshes_Common/M_Waterfall_Sides02.fbx",
									"x": -0.0333,
									"y": -0.16,
									"z": 1.55,
									"scaleX": 5,
									"scaleY": 5,
									"scaleZ": 5,
									"children": [
										{
											"type": "material",
											"name": "material",
											"props": {
												"PBR": {
													"mode": "BeforeTonemapping",
													"blend": "Alpha",
													"shadows": false,
													"culling": "None",
													"colorMask": 255,
													"depthTest": "LessEqual",
													"alphaKill": true
												}
											},
											"diffuseMap": "Fx/_Resources/Gradients/z_FillWhite.jpg"
										},
										{
											"type": "shader",
											"name": "DissolveMap_base",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.3,
												"saturation": 1,
												"width": 1,
												"uvScaleX": 1,
												"uvScaleY": 6,
												"texture": "Fx/_Resources/Alphas/T_WaterFall_07.png",
												"uvShift": [
													0.35,
													0
												],
												"uvShiftSpeed": [
													0,
													-4
												]
											}
										},
										{
											"type": "shader",
											"name": "DissolveMap_noise",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.25,
												"saturation": 1,
												"width": 1,
												"uvScaleX": 1,
												"uvScaleY": 4,
												"texture": "Fx/_Resources/Noise/FlareNoise01_Sharper_midmask01.png",
												"uvShift": [
													0.4,
													0
												],
												"uvShiftSpeed": [
													0,
													-4
												]
											}
										},
										{
											"type": "shader",
											"name": "DissolveMap_Side",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.3,
												"saturation": 1,
												"width": 1,
												"uvScaleX": 1,
												"uvScaleY": 1,
												"texture": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0,
																"color": -16777216
															},
															{
																"position": 0.00390625,
																"color": -1
															},
															{
																"position": 0.7265625,
																"color": -1
															},
															{
																"position": 0.84375,
																"color": -16777216
															}
														],
														"resolution": 64,
														"isVertical": false,
														"interpolation": "Linear",
														"colorMode": 0
													}
												},
												"uvShift": [
													0,
													0
												],
												"uvShiftSpeed": [
													0,
													0
												]
											}
										},
										{
											"type": "shader",
											"name": "AlphaKill",
											"source": "shaders/AlphaKill.hx",
											"props": {
												"threshold": 0.5,
												"useRGB": false
											}
										},
										{
											"type": "shader",
											"name": "ColorSet",
											"source": "shaders/ColorSet.hx",
											"props": {
												"amount": 1,
												"color": [
													0.8862745098039215,
													0.9490196078431372,
													0.9490196078431372
												]
											}
										},
										{
											"type": "shader",
											"name": "SHADER_UVDistortion_OnMask",
											"source": "Fx/Shaders/SHADER_UVDistortion_OnMask.shgraph",
											"props": {
												"1": 1,
												"TEX_Distortion": "Fx/_Resources/Noise/FlareNoise03.png",
												"Scale": [
													0.5,
													1
												],
												"Speed": [
													0,
													-1
												],
												"Power": 0.88,
												"Mask": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0,
																"color": -16777216
															},
															{
																"position": 0.17578125,
																"color": -1
															}
														],
														"resolution": 64,
														"isVertical": true,
														"interpolation": "Linear",
														"colorMode": 0
													}
												},
												"Progress": 0.23,
												"Saturation": 1,
												"Width": 1,
												"SourceUV": 0,
												"IF_AlphaInput": 1
											}
										},
										{
											"type": "shader",
											"name": "AlphaKill",
											"source": "shaders/AlphaKill.hx",
											"props": {
												"threshold": 0.1,
												"useRGB": false
											}
										}
									]
								}
							]
						},
						{
							"type": "object",
							"name": "Bottom",
							"x": 0.0295,
							"y": -5.8717,
							"z": -17,
							"scaleX": 0.9,
							"scaleY": 0.9,
							"scaleZ": 0.9,
							"children": [
								{
									"type": "polygon",
									"name": "TEST LAKE",
									"enabled": false,
									"editorOnly": true,
									"scaleX": 222.2222,
									"scaleY": 222.2222,
									"scaleZ": 222.2222,
									"kind": 0,
									"args": [
										41
									],
									"children": [
										{
											"type": "material",
											"name": "material",
											"props": {
												"PBR": {
													"mode": "BeforeTonemapping",
													"blend": "Alpha",
													"shadows": false,
													"culling": "Back",
													"colorMask": 255
												}
											},
											"diffuseMap": "Fx/_Resources/Gradients/z_FillWhite.jpg",
											"refMatLib": ""
										},
										{
											"type": "shader",
											"name": "SHADER_LakeTest",
											"source": "Fx/Environment/SHADER_Lake.shgraph",
											"props": {
												"ColorDistance": 6,
												"WaterColor1": [
													0.11764705882352941,
													0.6901960784313725,
													0.6039215686274509,
													1
												],
												"WaterColor2": [
													0.03529411764705882,
													0.34901960784313724,
													0.42745098039215684,
													1
												],
												"Opacity": 0.35,
												"Opacity2": 0.9,
												"PerlinDisto": "Fx/_Resources/Noise/perlin4.jpg",
												"PerlinDisto_Tiling": 0.1,
												"PerlinDisto_Speed": 0.2,
												"BorderColor": [
													0.803921568627451,
													1,
													0.9215686274509803,
													1
												],
												"BorderDistance": 3.5,
												"BorderWigglyScale": 0.1,
												"BorderScale": 0.24,
												"BorderOpacity": 0.25
											}
										}
									]
								},
								{
									"type": "model",
									"name": "M_Waterfall_Ripples01",
									"source": "Fx/_Resources/Meshes_Common/M_Waterfall_Ripples01.fbx",
									"scaleX": 5,
									"scaleY": 5,
									"scaleZ": 3,
									"children": [
										{
											"type": "material",
											"name": "material",
											"props": {
												"PBR": {
													"mode": "BeforeTonemapping",
													"blend": "Alpha",
													"shadows": false,
													"culling": "Back",
													"colorMask": 255,
													"drawOrder": "100"
												}
											},
											"diffuseMap": "Fx/_Resources/Gradients/z_FillWhite.jpg"
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.32,
												"saturation": 0,
												"width": 1,
												"uvScaleX": 2,
												"uvScaleY": 1,
												"texture": "Fx/_Resources/Alphas/T_WaterFall01_noise.png",
												"uvShift": [
													0,
													0
												],
												"uvShiftSpeed": [
													0,
													-0.75
												]
											}
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.28,
												"saturation": 1,
												"width": 1,
												"uvScaleX": 1,
												"uvScaleY": 1,
												"texture": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0,
																"color": -16777216
															},
															{
																"position": 0.359375,
																"color": -1
															},
															{
																"position": 1,
																"color": -16777216
															}
														],
														"resolution": 64,
														"isVertical": true,
														"interpolation": "Linear",
														"colorMode": 0
													}
												},
												"uvShift": [
													0,
													0
												],
												"uvShiftSpeed": [
													0,
													0
												]
											}
										},
										{
											"type": "shader",
											"name": "ColorSet",
											"source": "shaders/ColorSet.hx",
											"props": {
												"amount": 1,
												"color": [
													0.4823529411764706,
													0.6352941176470588,
													0.6352941176470588
												]
											}
										},
										{
											"type": "shader",
											"name": "ColorSet",
											"source": "shaders/ColorSet.hx",
											"enabled": false,
											"props": {
												"amount": 1,
												"color": [
													1,
													0,
													0
												]
											}
										},
										{
											"type": "shader",
											"name": "AlphaMult",
											"source": "shaders/AlphaMult.hx",
											"props": {
												"alpha": 0.29
											}
										},
										{
											"type": "shader",
											"name": "AlphaKill",
											"source": "shaders/AlphaKill.hx",
											"props": {
												"threshold": 0.2,
												"useRGB": false
											}
										}
									]
								},
								{
									"type": "model",
									"name": "M_Waterfall_Ripples01",
									"source": "Fx/_Resources/Meshes_Common/M_Waterfall_Ripples01.fbx",
									"scaleX": 6,
									"scaleY": 6,
									"scaleZ": 3,
									"children": [
										{
											"type": "material",
											"name": "material",
											"props": {
												"PBR": {
													"mode": "BeforeTonemapping",
													"blend": "Alpha",
													"shadows": false,
													"culling": "Back",
													"colorMask": 255,
													"drawOrder": "100"
												}
											},
											"diffuseMap": "Fx/_Resources/Gradients/z_FillWhite.jpg"
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.28,
												"saturation": 1,
												"width": 1,
												"uvScaleX": 2,
												"uvScaleY": 1.5,
												"texture": "Fx/_Resources/Alphas/TEX_WaterSpec05_rot90.png",
												"uvShift": [
													0,
													0
												],
												"uvShiftSpeed": [
													-0.1,
													-1.5
												]
											}
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.28,
												"saturation": 1,
												"width": 1,
												"uvScaleX": 1,
												"uvScaleY": 1,
												"texture": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0.49609375,
																"color": -1
															},
															{
																"position": 1,
																"color": -16777216
															}
														],
														"resolution": 64,
														"isVertical": true,
														"interpolation": "Linear",
														"colorMode": 0
													}
												},
												"uvShift": [
													0,
													0
												],
												"uvShiftSpeed": [
													0,
													0
												]
											}
										},
										{
											"type": "shader",
											"name": "ColorSet",
											"source": "shaders/ColorSet.hx",
											"props": {
												"amount": 1,
												"color": [
													0.12156862745098039,
													0.26666666666666666,
													0.2784313725490196
												]
											}
										},
										{
											"type": "shader",
											"name": "AlphaKill",
											"source": "shaders/AlphaKill.hx",
											"props": {
												"threshold": 0.2,
												"useRGB": false
											}
										}
									]
								},
								{
									"type": "model",
									"name": "M_Waterfall_Ripples01",
									"source": "Fx/_Resources/Meshes_Common/M_Waterfall_Ripples01.fbx",
									"scaleX": 6,
									"scaleY": 6,
									"scaleZ": 3,
									"children": [
										{
											"type": "material",
											"name": "material",
											"props": {
												"PBR": {
													"mode": "BeforeTonemapping",
													"blend": "Alpha",
													"shadows": false,
													"culling": "Back",
													"colorMask": 255,
													"drawOrder": "100"
												}
											},
											"diffuseMap": "Fx/_Resources/Gradients/z_FillWhite.jpg"
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.28,
												"saturation": 1,
												"width": 1,
												"uvScaleX": 2,
												"uvScaleY": 2,
												"texture": "Fx/_Resources/Alphas/TEX_WaterSpec05_rot90.png",
												"uvShift": [
													0,
													0
												],
												"uvShiftSpeed": [
													-0.1,
													-1.5
												]
											}
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.28,
												"saturation": 1,
												"width": 1,
												"uvScaleX": 1,
												"uvScaleY": 1,
												"texture": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0.49609375,
																"color": -1
															},
															{
																"position": 1,
																"color": -16777216
															}
														],
														"resolution": 64,
														"isVertical": true,
														"interpolation": "Linear",
														"colorMode": 0
													}
												},
												"uvShift": [
													0,
													0
												],
												"uvShiftSpeed": [
													0,
													0
												]
											}
										},
										{
											"type": "shader",
											"name": "GradientMap",
											"source": "shaders/GradientMap.hx",
											"props": {
												"USE_ALPHA": true,
												"gradient": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0,
																"color": -8674654
															},
															{
																"position": 1,
																"color": -1903886
															}
														],
														"resolution": 64,
														"isVertical": false,
														"interpolation": "Linear",
														"colorMode": 0
													}
												}
											}
										},
										{
											"type": "shader",
											"name": "AlphaKill",
											"source": "shaders/AlphaKill.hx",
											"props": {
												"threshold": 0.2,
												"useRGB": false
											}
										}
									]
								},
								{
									"type": "lookAt",
									"name": "lookAt_reflectionTest",
									"rotationZ": -158.5631,
									"lockAxis": [
										0,
										0,
										1
									],
									"children": [
										{
											"type": "model",
											"name": "Ripples01_reflection",
											"source": "Fx/_Resources/Meshes_Common/M_Waterfall_Ripples01.fbx",
											"scaleX": 4,
											"scaleY": 6,
											"scaleZ": 3,
											"rotationZ": 40,
											"children": [
												{
													"type": "material",
													"name": "material",
													"props": {
														"PBR": {
															"mode": "BeforeTonemapping",
															"blend": "Alpha",
															"shadows": false,
															"culling": "Back",
															"colorMask": 255,
															"depthWrite": "On"
														}
													},
													"diffuseMap": "Fx/_Resources/Gradients/z_FillWhite.jpg"
												},
												{
													"type": "shader",
													"name": "SHADER_FakeReflection",
													"source": "Fx/Environment/SHADER_FakeReflection.shgraph",
													"props": {
														"ReflectionEmissiveIntensity": 0.5,
														"ReflectionDissolve": "Fx/_Resources/Noise/FlareNoise01_Sharper.png",
														"ReflectionDissolveScale": [
															0.25,
															4
														],
														"ReflectionDissolve_ScrollSpeed": [
															0.2,
															-1.5
														],
														"ReflectionMask": "Fx/_Resources/Alphas/TEX_WaterSpec02_90.png",
														"ReflectionMask_Offset": [
															0,
															0.03
														],
														"ReflectionMask_Scale": [
															6,
															1.3
														],
														"ReflectionDisto": "Fx/_Resources/Noise/T_FireSharp.png",
														"ReflectionDisto_Scale": [
															2,
															1
														],
														"ReflectionDisto_Speed": [
															0.5,
															1
														],
														"ReflectionDisto_Intensity": 0.01
													}
												},
												{
													"type": "shader",
													"name": "AlphaKill",
													"source": "shaders/AlphaKill.hx",
													"props": {
														"threshold": 0.1,
														"useRGB": false
													}
												},
												{
													"type": "shader",
													"name": "DissolveMap",
													"source": "shaders/DissolveMap.hx",
													"enabled": false,
													"props": {
														"useSourceUVs": true,
														"useScale": true,
														"wrap": true,
														"progress": 0.28,
														"saturation": 1,
														"width": 1,
														"uvScaleX": 1,
														"uvScaleY": 1,
														"texture": {
															"type": "gradient",
															"data": {
																"stops": [
																	{
																		"position": 0,
																		"color": -15527149
																	},
																	{
																		"position": 0.37890625,
																		"color": -1
																	},
																	{
																		"position": 0.5390625,
																		"color": -16777216
																	},
																	{
																		"position": 0.84375,
																		"color": -1
																	}
																],
																"resolution": 64,
																"isVertical": false,
																"interpolation": "Constant",
																"colorMode": 0
															}
														},
														"uvShift": [
															0,
															0
														],
														"uvShiftSpeed": [
															0,
															0
														]
													}
												},
												{
													"type": "shader",
													"name": "DissolveMap",
													"source": "shaders/DissolveMap.hx",
													"props": {
														"useSourceUVs": true,
														"useScale": true,
														"wrap": true,
														"progress": 0.28,
														"saturation": 1,
														"width": 1,
														"uvScaleX": 1,
														"uvScaleY": 1,
														"texture": {
															"type": "gradient",
															"data": {
																"stops": [
																	{
																		"position": 0,
																		"color": -15527149
																	},
																	{
																		"position": 0.37890625,
																		"color": -1
																	},
																	{
																		"position": 0.5390625,
																		"color": -16777216
																	}
																],
																"resolution": 64,
																"isVertical": false,
																"interpolation": "Constant",
																"colorMode": 0
															}
														},
														"uvShift": [
															0,
															0
														],
														"uvShiftSpeed": [
															0,
															0
														]
													}
												},
												{
													"type": "shader",
													"name": "DissolveMap",
													"source": "shaders/DissolveMap.hx",
													"props": {
														"useSourceUVs": true,
														"useScale": true,
														"wrap": true,
														"progress": 0.28,
														"saturation": 1,
														"width": 1,
														"uvScaleX": 1,
														"uvScaleY": 1,
														"texture": {
															"type": "gradient",
															"data": {
																"stops": [
																	{
																		"position": 0,
																		"color": -15527149
																	},
																	{
																		"position": 0.265625,
																		"color": -1
																	},
																	{
																		"position": 0.75390625,
																		"color": -16777216
																	}
																],
																"resolution": 64,
																"isVertical": true,
																"interpolation": "Constant",
																"colorMode": 0
															}
														},
														"uvShift": [
															0,
															0
														],
														"uvShiftSpeed": [
															0,
															0
														]
													}
												},
												{
													"type": "shader",
													"name": "ColorSet",
													"source": "shaders/ColorSet.hx",
													"props": {
														"amount": 1,
														"color": [
															0.8862745098039215,
															0.9490196078431372,
															0.9490196078431372
														]
													}
												}
											]
										}
									]
								},
								{
									"type": "emitter",
									"name": "SplashBottom",
									"props": {
										"alignMode": "Screen",
										"frameCount": 4,
										"frameDivisionX": 2,
										"frameDivisionY": 2,
										"animationSpeed": 0,
										"spriteSheet": "Fx/_Resources/Alphas/T_Sparks_water_2x2_04.png",
										"randomGradient": {
											"stops": [
												{
													"position": 0,
													"color": -4925990
												},
												{
													"position": 1,
													"color": -1511950
												}
											],
											"resolution": 64,
											"isVertical": false,
											"interpolation": "Linear",
											"colorMode": 0
										},
										"instScale": 10,
										"instScale_rand": 1,
										"instOrbitSpeed_rand": [
											0,
											0,
											0
										],
										"emitRate": 300,
										"maxCount": 30,
										"burstParticleCount": 35,
										"useRandomGradient": true,
										"instStretch_rand": [
											0,
											0,
											0
										],
										"lifeTimeRand": 0.15,
										"emitAngle": 360,
										"instWorldAcceleration_rand": [
											0,
											0,
											0
										],
										"emitOrientation": "Normal",
										"emitShape": "Cylinder",
										"instDampen": 10,
										"instStartSpeed": [
											10,
											0,
											0
										],
										"emitRad1": 0.86,
										"emitRad2": 0.88,
										"enableSort": false,
										"seedGroup": 14,
										"emitSurface": true,
										"instStartSpeed_rand": [
											7,
											0,
											0
										],
										"lifeTime": 0.6,
										"instWorldAcceleration": [
											0,
											0,
											-10
										],
										"instSpeed": [
											15,
											0,
											0
										],
										"instSpeed_rand": [
											5,
											0,
											0
										]
									},
									"z": 0.5,
									"scaleX": 18,
									"scaleY": 2,
									"scaleZ": 0.1,
									"children": [
										{
											"type": "polygon",
											"name": "polygon",
											"kind": 0,
											"args": [
												0
											],
											"children": [
												{
													"type": "material",
													"name": "material",
													"props": {
														"PBR": {
															"mode": "BeforeTonemapping",
															"blend": "Alpha",
															"shadows": false,
															"culling": "Back",
															"colorMask": 255,
															"depthTest": "Less",
															"drawOrder": "100"
														}
													},
													"diffuseMap": "Fx/_Resources/Gradients/z_FillWhite.jpg"
												},
												{
													"type": "shader",
													"name": "AutoAlpha",
													"source": "shaders/AutoAlpha.hx",
													"props": {
														"scale": 1
													}
												},
												{
													"type": "shader",
													"name": "GradientMap",
													"source": "shaders/GradientMap.hx",
													"props": {
														"USE_ALPHA": true,
														"gradient": {
															"type": "gradient",
															"data": {
																"stops": [
																	{
																		"position": 0,
																		"color": -4795421
																	},
																	{
																		"position": 0.2265625,
																		"color": -6565388
																	},
																	{
																		"position": 0.76953125,
																		"color": -6697231
																	},
																	{
																		"position": 1,
																		"color": -4795421
																	}
																],
																"resolution": 64,
																"isVertical": false,
																"interpolation": "Linear",
																"colorMode": 0
															}
														}
													}
												},
												{
													"type": "shader",
													"name": "DissolveMap",
													"source": "shaders/DissolveMap.hx",
													"props": {
														"useSourceUVs": true,
														"useScale": true,
														"wrap": true,
														"progress": 1,
														"saturation": 1,
														"width": 1,
														"uvScaleX": 1,
														"uvScaleY": 1,
														"texture": "Fx/_Resources/Noise/FlareNoise01.png",
														"uvShift": [
															0,
															0
														],
														"uvShiftSpeed": [
															0,
															0
														]
													},
													"children": [
														{
															"type": "curve",
															"name": "progress",
															"enabled": false,
															"keyMode": 0,
															"keys": [
																{
																	"time": 0,
																	"value": 0.5,
																	"prevHandle": {
																		"dv": -0.003643096389234113,
																		"dt": -0.4999874256541785
																	},
																	"nextHandle": {
																		"dv": 0.005503490376929432,
																		"dt": 0.6405839697127383
																	}
																},
																{
																	"time": 1,
																	"value": 0,
																	"mode": 2
																}
															]
														},
														{
															"type": "curve",
															"name": "progress",
															"keyMode": 0,
															"keys": [
																{
																	"time": 0,
																	"value": 0.5,
																	"prevHandle": {
																		"dv": 1.2516989267179447e-16,
																		"dt": -0.4999906017711797
																	},
																	"nextHandle": {
																		"dv": -0.001674196096120406,
																		"dt": 0.5626806398031203
																	}
																},
																{
																	"time": 1,
																	"value": 0,
																	"mode": 2
																}
															]
														}
													]
												},
												{
													"type": "shader",
													"name": "AlphaKill",
													"source": "shaders/AlphaKill.hx",
													"props": {
														"threshold": 0.5,
														"useRGB": false
													}
												},
												{
													"type": "shader",
													"name": "ColorSet",
													"source": "shaders/ColorSet.hx",
													"props": {
														"amount": 1,
														"color": [
															0.8901960784313725,
															0.996078431372549,
															1
														]
													},
													"children": [
														{
															"type": "curve",
															"name": "amount",
															"keyMode": 0,
															"keys": [
																{
																	"time": 0,
																	"value": 0,
																	"prevHandle": {
																		"dv": 6.063702554111547e-16,
																		"dt": -0.5
																	},
																	"nextHandle": {
																		"dv": 0.015033893636428042,
																		"dt": 0.7373144357343735
																	}
																},
																{
																	"time": 1,
																	"value": 1,
																	"mode": 2
																}
															]
														}
													]
												},
												{
													"type": "shader",
													"name": "DepthBlend",
													"source": "shaders/DepthBlend.hx",
													"props": {
														"REVERSE": false,
														"range": 1,
														"power": 0.8
													}
												}
											]
										},
										{
											"type": "curve",
											"name": "instScale",
											"keyMode": 0,
											"keys": [
												{
													"time": 0,
													"value": 0,
													"prevHandle": {
														"dv": -2.5100205154238426,
														"dt": -0.2811550107036396
													},
													"nextHandle": {
														"dv": 1.9264054432515016,
														"dt": 0.21661096777619637
													}
												},
												{
													"time": 0.4100494815804867,
													"value": 1.5948507337858193,
													"mode": 2
												},
												{
													"time": 1,
													"value": 1,
													"prevHandle": {
														"dv": -0.02719038278566205,
														"dt": -0.17609143204622257
													},
													"nextHandle": {
														"dv": 0.08747418720888087,
														"dt": 0.4999739712121431
													}
												}
											]
										},
										{
											"type": "curve",
											"name": "emitRate",
											"enabled": false,
											"keys": [
												{
													"time": 0.0007983038726292928,
													"value": 0,
													"mode": 2
												},
												{
													"time": 0.4035066953243174,
													"value": 0.5,
													"mode": 2
												},
												{
													"time": 0.9720593247419848,
													"value": 0.5,
													"mode": 2
												},
												{
													"time": 1.1566599482978148,
													"value": 0,
													"mode": 2
												}
											]
										}
									]
								},
								{
									"type": "emitter",
									"name": "Smoke_Sharp",
									"props": {
										"instScale_rand": 1,
										"maxCount": 150,
										"simulationSpace": "World",
										"randomColor1": [
											1,
											1,
											1,
											1
										],
										"randomColor2": [
											1,
											0.4392156862745098,
											0.3529411764705882,
											1
										],
										"instRotation_rand": [
											0,
											0,
											360
										],
										"instScale": 7.5,
										"burstDelay": 0.05,
										"instStretch_rand": [
											0.1,
											0.1,
											0.1
										],
										"burstParticleCount": 2,
										"emitRad1": 0.83,
										"emitSurface": true,
										"alignMode": "Screen",
										"emitAngle": 19.09,
										"instWorldAcceleration_rand": [
											0,
											0,
											2
										],
										"instSpeed_rand": [
											0,
											0,
											0
										],
										"instAcceleration_rand": [
											0,
											0,
											0
										],
										"warmUpTime": 1,
										"burstCount": 44,
										"lifeTimeRand": 0.2,
										"emitRateMax": 10,
										"randomGradient": {
											"stops": [
												{
													"position": 0,
													"color": -16777216
												},
												{
													"position": 1,
													"color": -1
												}
											],
											"resolution": 64,
											"isVertical": false,
											"interpolation": "Linear",
											"colorMode": 0
										},
										"lifeTime": 3,
										"instDampen": 1,
										"instWorldAcceleration": [
											0,
											0,
											7
										]
									},
									"y": -2.06,
									"z": -0.2,
									"scaleX": 5,
									"scaleY": 5,
									"scaleZ": 9,
									"rotationY": -90,
									"children": [
										{
											"type": "polygon",
											"name": "polygon",
											"kind": 0,
											"args": [
												0
											],
											"children": [
												{
													"type": "material",
													"name": "material",
													"props": {
														"PBR": {
															"mode": "BeforeTonemapping",
															"blend": "Alpha",
															"shadows": false,
															"culling": "Back",
															"depthTest": "Less",
															"colorMask": 15,
															"enableStencil": false
														}
													},
													"diffuseMap": "Fx/_Resources/Gradients/z_FillWhite.jpg"
												},
												{
													"type": "shader",
													"name": "AlphaMap",
													"source": "shaders/AlphaMap.hx",
													"props": {
														"useSourceUVs": false,
														"onDecal": false,
														"wrap": false,
														"invert": false,
														"replace": false,
														"alpha": 0.4,
														"uScale": 1,
														"vScale": 1,
														"uOffset": 0,
														"vOffset": 0,
														"texture": "Fx/_Resources/Alphas/TEX_Smoke_Smooth_01.png"
													},
													"children": [
														{
															"type": "curve",
															"name": "alpha",
															"keyMode": 0,
															"keys": [
																{
																	"time": 0,
																	"value": 0,
																	"mode": 2
																},
																{
																	"time": 0.1975065399538134,
																	"value": 1,
																	"mode": 2
																},
																{
																	"time": 0.6,
																	"value": 1,
																	"mode": 2
																},
																{
																	"time": 1,
																	"value": 0,
																	"prevHandle": {
																		"dv": 0.005577050185784915,
																		"dt": -0.19386818481441104
																	},
																	"nextHandle": {
																		"dv": -0.022551210105988394,
																		"dt": 0.4999578397064895
																	}
																}
															]
														}
													]
												},
												{
													"type": "shader",
													"name": "DissolveMap",
													"source": "shaders/DissolveMap.hx",
													"props": {
														"useSourceUVs": true,
														"useScale": true,
														"wrap": false,
														"progress": 1,
														"saturation": 0,
														"width": 1,
														"uvScaleX": 0.5,
														"uvScaleY": 0.5,
														"texture": "Fx/_Resources/Noise/TEX_DissolveClouded_Blur.png",
														"uvShift": [
															0,
															0.2
														],
														"uvShiftSpeed": [
															0,
															0
														]
													},
													"children": [
														{
															"type": "curve",
															"name": "progress",
															"keyMode": 0,
															"keys": [
																{
																	"time": 0,
																	"value": 0.34730811743415735,
																	"prevHandle": {
																		"dv": 8.168248107897105e-17,
																		"dt": -0.5655108261164778
																	},
																	"nextHandle": {
																		"dv": -0.0006453543530405836,
																		"dt": 0.18109402884015469
																	}
																},
																{
																	"time": 1,
																	"value": 0,
																	"prevHandle": {
																		"dv": 0.29262186072717955,
																		"dt": -0.27363110233914045
																	},
																	"nextHandle": {
																		"dv": -0.25695239280247634,
																		"dt": 0.24029961682889883
																	}
																}
															]
														}
													]
												},
												{
													"type": "shader",
													"name": "DepthBlend",
													"source": "shaders/DepthBlend.hx",
													"props": {
														"REVERSE": false,
														"range": 1.5,
														"power": 0.8
													}
												},
												{
													"type": "shader",
													"name": "ColorSet",
													"source": "shaders/ColorSet.hx",
													"enabled": false,
													"props": {
														"amount": 1,
														"color": [
															0.5411764705882353,
															0.7490196078431373,
															0.807843137254902
														]
													}
												},
												{
													"type": "shader",
													"name": "ColorSet",
													"source": "shaders/ColorSet.hx",
													"props": {
														"amount": 1,
														"color": [
															0.6784313725490196,
															0.8823529411764706,
															0.9411764705882353
														]
													}
												}
											]
										},
										{
											"type": "curve",
											"name": "instScale",
											"keyMode": 0,
											"keys": [
												{
													"time": 0,
													"value": 0.3,
													"prevHandle": {
														"dv": -2.1419375621163073,
														"dt": -0.45629392206732905
													},
													"nextHandle": {
														"dv": 1.2324572642817766,
														"dt": 0.26142995849490325
													}
												},
												{
													"time": 1,
													"value": 3,
													"prevHandle": {
														"dv": -0.0329032704838621,
														"dt": -0.4437637057872682
													},
													"nextHandle": {
														"dv": 0.016001192712657195,
														"dt": 0.2656251075535815
													}
												}
											]
										},
										{
											"type": "curve",
											"name": "emitRate",
											"enabled": false,
											"keys": [
												{
													"time": 1.5,
													"value": 1,
													"mode": 2
												},
												{
													"time": 1.765248539683609,
													"value": 0,
													"mode": 2
												}
											]
										}
									]
								},
								{
									"type": "emitter",
									"name": "Smoke_Sharp",
									"props": {
										"instScale_rand": 1,
										"maxCount": 150,
										"simulationSpace": "World",
										"randomColor1": [
											1,
											1,
											1,
											1
										],
										"randomColor2": [
											1,
											0.4392156862745098,
											0.3529411764705882,
											1
										],
										"instRotation_rand": [
											0,
											0,
											360
										],
										"instScale": 7.5,
										"burstDelay": 0.05,
										"instStretch_rand": [
											0.1,
											0.1,
											0.1
										],
										"burstParticleCount": 2,
										"emitRad1": 0.83,
										"emitSurface": true,
										"alignMode": "Screen",
										"emitAngle": 19.09,
										"instWorldAcceleration_rand": [
											0,
											0,
											0
										],
										"instSpeed_rand": [
											0,
											0,
											0
										],
										"instAcceleration_rand": [
											0,
											0,
											0
										],
										"warmUpTime": 1,
										"burstCount": 44,
										"lifeTimeRand": 0.2,
										"emitRateMax": 10,
										"randomGradient": {
											"stops": [
												{
													"position": 0,
													"color": -16777216
												},
												{
													"position": 1,
													"color": -1
												}
											],
											"resolution": 64,
											"isVertical": false,
											"interpolation": "Linear",
											"colorMode": 0
										},
										"lifeTime": 3,
										"instDampen": 1,
										"instAcceleration": [
											0,
											-5,
											0
										]
									},
									"y": -2.06,
									"z": -0.2,
									"scaleX": 5,
									"scaleY": 5,
									"scaleZ": 9,
									"rotationY": -90,
									"children": [
										{
											"type": "polygon",
											"name": "polygon",
											"kind": 0,
											"args": [
												0
											],
											"children": [
												{
													"type": "material",
													"name": "material",
													"props": {
														"PBR": {
															"mode": "BeforeTonemapping",
															"blend": "Alpha",
															"shadows": false,
															"culling": "Back",
															"depthTest": "Less",
															"colorMask": 15,
															"enableStencil": false
														}
													},
													"diffuseMap": "Fx/_Resources/Gradients/z_FillWhite.jpg"
												},
												{
													"type": "shader",
													"name": "AlphaMap",
													"source": "shaders/AlphaMap.hx",
													"props": {
														"useSourceUVs": false,
														"onDecal": false,
														"wrap": false,
														"invert": false,
														"replace": false,
														"alpha": 0.4,
														"uScale": 1,
														"vScale": 1,
														"uOffset": 0,
														"vOffset": 0,
														"texture": "Fx/_Resources/Alphas/TEX_Smoke_Smooth_01.png"
													},
													"children": [
														{
															"type": "curve",
															"name": "alpha",
															"keyMode": 0,
															"keys": [
																{
																	"time": 0,
																	"value": 0,
																	"mode": 2
																},
																{
																	"time": 0.1975065399538134,
																	"value": 1,
																	"mode": 2
																},
																{
																	"time": 0.6,
																	"value": 1,
																	"mode": 2
																},
																{
																	"time": 1,
																	"value": 0,
																	"prevHandle": {
																		"dv": 0.005577050185784915,
																		"dt": -0.19386818481441104
																	},
																	"nextHandle": {
																		"dv": -0.022551210105988394,
																		"dt": 0.4999578397064895
																	}
																}
															]
														}
													]
												},
												{
													"type": "shader",
													"name": "DissolveMap",
													"source": "shaders/DissolveMap.hx",
													"props": {
														"useSourceUVs": true,
														"useScale": true,
														"wrap": false,
														"progress": 1,
														"saturation": 0,
														"width": 1,
														"uvScaleX": 0.5,
														"uvScaleY": 0.5,
														"texture": "Fx/_Resources/Noise/TEX_DissolveClouded_Blur.png",
														"uvShift": [
															0,
															0.2
														],
														"uvShiftSpeed": [
															0,
															0
														]
													},
													"children": [
														{
															"type": "curve",
															"name": "progress",
															"keyMode": 0,
															"keys": [
																{
																	"time": 0,
																	"value": 0.34730811743415735,
																	"prevHandle": {
																		"dv": 8.168248107897105e-17,
																		"dt": -0.5655108261164778
																	},
																	"nextHandle": {
																		"dv": -0.0006453543530405836,
																		"dt": 0.18109402884015469
																	}
																},
																{
																	"time": 1,
																	"value": 0,
																	"prevHandle": {
																		"dv": 0.29262186072717955,
																		"dt": -0.27363110233914045
																	},
																	"nextHandle": {
																		"dv": -0.25695239280247634,
																		"dt": 0.24029961682889883
																	}
																}
															]
														}
													]
												},
												{
													"type": "shader",
													"name": "DepthBlend",
													"source": "shaders/DepthBlend.hx",
													"props": {
														"REVERSE": false,
														"range": 1.5,
														"power": 0.8
													}
												},
												{
													"type": "shader",
													"name": "ColorSet",
													"source": "shaders/ColorSet.hx",
													"enabled": false,
													"props": {
														"amount": 1,
														"color": [
															0.5411764705882353,
															0.7490196078431373,
															0.807843137254902
														]
													}
												},
												{
													"type": "shader",
													"name": "ColorSet",
													"source": "shaders/ColorSet.hx",
													"props": {
														"amount": 1,
														"color": [
															0.6784313725490196,
															0.8823529411764706,
															0.9411764705882353
														]
													}
												}
											]
										},
										{
											"type": "curve",
											"name": "instScale",
											"keyMode": 0,
											"keys": [
												{
													"time": 0,
													"value": 0.3,
													"prevHandle": {
														"dv": -2.1419375621163073,
														"dt": -0.45629392206732905
													},
													"nextHandle": {
														"dv": 1.2324572642817766,
														"dt": 0.26142995849490325
													}
												},
												{
													"time": 1,
													"value": 3,
													"prevHandle": {
														"dv": -0.0329032704838621,
														"dt": -0.4437637057872682
													},
													"nextHandle": {
														"dv": 0.016001192712657195,
														"dt": 0.2656251075535815
													}
												}
											]
										},
										{
											"type": "curve",
											"name": "emitRate",
											"enabled": false,
											"keys": [
												{
													"time": 1.5,
													"value": 1,
													"mode": 2
												},
												{
													"time": 1.765248539683609,
													"value": 0,
													"mode": 2
												}
											]
										}
									]
								}
							]
						},
						{
							"type": "object",
							"name": "TestMousse",
							"x": 0.0295,
							"y": -5.6517,
							"z": -20.8317,
							"scaleY": 1.5466,
							"children": [
								{
									"type": "model",
									"name": "m_waterfall_TestMousse",
									"source": "Fx/_Resources/Meshes_Common/m_waterfall_TestMousse01.fbx",
									"x": 7,
									"scaleX": 5,
									"scaleY": 4.7378,
									"scaleZ": 3.89,
									"children": [
										{
											"type": "material",
											"name": "material",
											"props": {
												"PBR": {
													"mode": "BeforeTonemapping",
													"blend": "Alpha",
													"shadows": false,
													"culling": "Back",
													"colorMask": 255,
													"depthPrepass": true
												}
											},
											"diffuseMap": "Fx/_Resources/Gradients/z_FillWhite.jpg"
										},
										{
											"type": "shader",
											"name": "SHADER_VertexDisplacement_Masked",
											"source": "Fx/Shaders/SHADER_VertexDisplacement_Masked.shgraph",
											"props": {
												"TEX_Displacement": "Fx/_Resources/Noise/FlareNoise03_disp_tiling.png",
												"TEX_Mask": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0,
																"color": -16777216
															},
															{
																"position": 1,
																"color": -1
															}
														],
														"resolution": 64,
														"isVertical": true,
														"interpolation": "Linear",
														"colorMode": 0
													}
												},
												"Paning_Speed": [
													0,
													-1
												],
												"Tilling": [
													0.25,
													0.5
												],
												"Power": 0.15,
												"UseSourceUV": 0
											}
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.64,
												"saturation": 1,
												"width": 0.83,
												"uvScaleX": 1.5,
												"uvScaleY": 1,
												"texture": "Fx/_Resources/Noise/FlareNoise02_Sharper.png",
												"uvShift": [
													0,
													0
												],
												"uvShiftSpeed": [
													0.1,
													-2
												]
											}
										},
										{
											"type": "shader",
											"name": "AlphaKill",
											"source": "shaders/AlphaKill.hx",
											"props": {
												"threshold": 0.1,
												"useRGB": false
											}
										}
									]
								},
								{
									"type": "model",
									"name": "m_waterfall_TestMousse",
									"source": "Fx/_Resources/Meshes_Common/m_waterfall_TestMousse01.fbx",
									"x": 0.36,
									"scaleX": 5,
									"scaleY": 5,
									"scaleZ": 5,
									"children": [
										{
											"type": "material",
											"name": "material",
											"props": {
												"PBR": {
													"mode": "BeforeTonemapping",
													"blend": "Alpha",
													"shadows": false,
													"culling": "Back",
													"colorMask": 255,
													"depthPrepass": true
												}
											}
										},
										{
											"type": "shader",
											"name": "VertexDisplacement",
											"source": "shaders/VertexDisplacement.hx",
											"enabled": false,
											"props": {
												"X": false,
												"Y": false,
												"Z": true,
												"useNormal": true,
												"texScaleX": 5,
												"texScaleY": 1,
												"tex": "Fx/_Resources/Noise/causticTexture-2.png",
												"intensity": 10,
												"scrollSpeed": [
													0,
													-0.5
												],
												"useWorld": false,
												"centered": false
											}
										},
										{
											"type": "shader",
											"name": "SHADER_VertexDisplacement_Masked",
											"source": "Fx/Shaders/SHADER_VertexDisplacement_Masked.shgraph",
											"enabled": false,
											"props": {
												"TEX_Displacement": "Fx/_Resources/Gradients/TEX_GradientMirror_H.png",
												"TEX_Mask": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0.125,
																"color": -16777216
															},
															{
																"position": 1,
																"color": -1
															}
														],
														"resolution": 64,
														"isVertical": true,
														"interpolation": "Linear",
														"colorMode": 0
													}
												},
												"Paning_Speed": [
													0,
													-5
												],
												"Tilling": [
													1,
													1
												],
												"Power": 0.2,
												"UseSourceUV": 0
											}
										},
										{
											"type": "shader",
											"name": "SHADER_VertexDisplacement_Masked",
											"source": "Fx/Shaders/SHADER_VertexDisplacement_Masked.shgraph",
											"props": {
												"TEX_Displacement": "Fx/_Resources/Noise/FlareNoise03_disp_tiling.png",
												"TEX_Mask": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0,
																"color": -16777216
															},
															{
																"position": 1,
																"color": -1
															}
														],
														"resolution": 64,
														"isVertical": true,
														"interpolation": "Linear",
														"colorMode": 0
													}
												},
												"Paning_Speed": [
													0,
													-1.5
												],
												"Tilling": [
													0.25,
													0.5
												],
												"Power": 0.1,
												"UseSourceUV": 0
											}
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.64,
												"saturation": 1,
												"width": 0.83,
												"uvScaleX": 1,
												"uvScaleY": 0.5,
												"texture": "Fx/_Resources/Noise/FlareNoise02_Sharper.png",
												"uvShift": [
													0,
													0.3
												],
												"uvShiftSpeed": [
													0.3,
													-1
												]
											}
										},
										{
											"type": "shader",
											"name": "SHADER_DissolveMasked",
											"source": "Fx/Shaders/SHADER_DissolveSmoothMaskedPan.shgraph",
											"enabled": false,
											"props": {
												"SourceUV": 1,
												"Dissolve_TEX": "Fx/_Resources/Noise/FlareNoise02_Sharper.png",
												"Dissolve_Mask": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0.05078125,
																"color": -16777216
															},
															{
																"position": 0.43359375,
																"color": -1
															}
														],
														"resolution": 64,
														"isVertical": true,
														"interpolation": "Linear",
														"colorMode": 0
													}
												},
												"Dissolve_State": 0.02,
												"Dissolve_Scale": [
													1,
													1
												],
												"Dissolve_Speed": [
													0,
													-1
												]
											}
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"enabled": false,
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.62,
												"saturation": 1,
												"width": 0.74,
												"uvScaleX": 0.5,
												"uvScaleY": 0.5,
												"texture": "Fx/_Resources/Gradients/GradientSpice_2.png",
												"uvShift": [
													0,
													0.1
												],
												"uvShiftSpeed": [
													0.1,
													-2
												]
											}
										},
										{
											"type": "curve",
											"name": "scale:z",
											"enabled": false,
											"keys": [
												{
													"time": 0,
													"value": 0.9,
													"mode": 2
												},
												{
													"time": 0.2,
													"value": 1.0628810419100467,
													"mode": 2
												},
												{
													"time": 0.4,
													"value": 0.9,
													"mode": 2
												},
												{
													"time": 0.5,
													"value": 1.1,
													"mode": 2
												},
												{
													"time": 0.5924490314640412,
													"value": 0.9,
													"mode": 2
												},
												{
													"time": 0.8,
													"value": 0.95,
													"mode": 2
												},
												{
													"time": 1,
													"value": 0.9,
													"mode": 2
												}
											],
											"loop": true
										},
										{
											"type": "shader",
											"name": "AlphaKill",
											"source": "shaders/AlphaKill.hx",
											"props": {
												"threshold": 0.1,
												"useRGB": false
											}
										}
									]
								},
								{
									"type": "model",
									"name": "m_waterfall_TestMousse",
									"source": "Fx/_Resources/Meshes_Common/m_waterfall_TestMousse01.fbx",
									"x": -2.5,
									"z": 2.14,
									"scaleX": 5,
									"scaleY": 5,
									"scaleZ": 2.56,
									"children": [
										{
											"type": "material",
											"name": "material",
											"props": {
												"PBR": {
													"mode": "BeforeTonemapping",
													"blend": "Alpha",
													"shadows": false,
													"culling": "Back",
													"colorMask": 255,
													"depthPrepass": true
												}
											}
										},
										{
											"type": "shader",
											"name": "VertexDisplacement",
											"source": "shaders/VertexDisplacement.hx",
											"enabled": false,
											"props": {
												"X": false,
												"Y": false,
												"Z": true,
												"useNormal": true,
												"texScaleX": 5,
												"texScaleY": 1,
												"tex": "Fx/_Resources/Noise/causticTexture-2.png",
												"intensity": 10,
												"scrollSpeed": [
													0,
													-0.5
												],
												"useWorld": false,
												"centered": false
											}
										},
										{
											"type": "shader",
											"name": "SHADER_VertexDisplacement_Masked",
											"source": "Fx/Shaders/SHADER_VertexDisplacement_Masked.shgraph",
											"enabled": false,
											"props": {
												"TEX_Displacement": "Fx/_Resources/Gradients/TEX_GradientMirror_H.png",
												"TEX_Mask": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0.125,
																"color": -16777216
															},
															{
																"position": 1,
																"color": -1
															}
														],
														"resolution": 64,
														"isVertical": true,
														"interpolation": "Linear",
														"colorMode": 0
													}
												},
												"Paning_Speed": [
													0,
													-5
												],
												"Tilling": [
													1,
													1
												],
												"Power": 0.2,
												"UseSourceUV": 0
											}
										},
										{
											"type": "shader",
											"name": "SHADER_VertexDisplacement_Masked",
											"source": "Fx/Shaders/SHADER_VertexDisplacement_Masked.shgraph",
											"props": {
												"TEX_Displacement": "Fx/_Resources/Noise/FlareNoise03_disp_tiling.png",
												"TEX_Mask": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0,
																"color": -16777216
															},
															{
																"position": 1,
																"color": -1
															}
														],
														"resolution": 64,
														"isVertical": true,
														"interpolation": "Linear",
														"colorMode": 0
													}
												},
												"Paning_Speed": [
													0,
													-1.5
												],
												"Tilling": [
													0.25,
													1
												],
												"Power": 0.15,
												"UseSourceUV": 0
											}
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.64,
												"saturation": 1,
												"width": 0.83,
												"uvScaleX": 1,
												"uvScaleY": 0.5,
												"texture": "Fx/_Resources/Noise/FlareNoise02_Sharper.png",
												"uvShift": [
													0,
													0.6
												],
												"uvShiftSpeed": [
													-0.2,
													-1
												]
											}
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"enabled": false,
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.62,
												"saturation": 1,
												"width": 0.74,
												"uvScaleX": 0.5,
												"uvScaleY": 0.5,
												"texture": "Fx/_Resources/Gradients/GradientSpice_2.png",
												"uvShift": [
													0,
													0.8
												],
												"uvShiftSpeed": [
													0.1,
													-2
												]
											}
										},
										{
											"type": "curve",
											"name": "scale:z",
											"enabled": false,
											"keys": [
												{
													"time": 0,
													"value": 0.9,
													"mode": 2
												},
												{
													"time": 0.2,
													"value": 1.0628810419100467,
													"mode": 2
												},
												{
													"time": 0.4,
													"value": 0.9,
													"mode": 2
												},
												{
													"time": 0.5,
													"value": 1.1,
													"mode": 2
												},
												{
													"time": 0.5924490314640412,
													"value": 0.9,
													"mode": 2
												},
												{
													"time": 0.8,
													"value": 0.95,
													"mode": 2
												},
												{
													"time": 1,
													"value": 0.9,
													"mode": 2
												}
											],
											"loop": true
										},
										{
											"type": "shader",
											"name": "AlphaKill",
											"source": "shaders/AlphaKill.hx",
											"props": {
												"threshold": 0.1,
												"useRGB": false
											}
										}
									]
								},
								{
									"type": "model",
									"name": "m_waterfall_TestMousse",
									"source": "Fx/_Resources/Meshes_Common/m_waterfall_TestMousse01.fbx",
									"x": 3.15,
									"scaleX": 2.34,
									"scaleY": 5,
									"scaleZ": 7.9,
									"children": [
										{
											"type": "material",
											"name": "material",
											"props": {
												"PBR": {
													"mode": "BeforeTonemapping",
													"blend": "Alpha",
													"shadows": false,
													"culling": "Back",
													"colorMask": 255,
													"depthPrepass": true
												}
											},
											"diffuseMap": "Fx/_Resources/Gradients/z_FillWhite.jpg"
										},
										{
											"type": "shader",
											"name": "SHADER_VertexDisplacement_Masked",
											"source": "Fx/Shaders/SHADER_VertexDisplacement_Masked.shgraph",
											"props": {
												"TEX_Displacement": "Fx/_Resources/Noise/FlareNoise03_disp_tiling.png",
												"TEX_Mask": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0,
																"color": -16777216
															},
															{
																"position": 1,
																"color": -1
															}
														],
														"resolution": 64,
														"isVertical": true,
														"interpolation": "Linear",
														"colorMode": 0
													}
												},
												"Paning_Speed": [
													0,
													-1.5
												],
												"Tilling": [
													0.25,
													2
												],
												"Power": 0.16,
												"UseSourceUV": 0
											}
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.64,
												"saturation": 1,
												"width": 0.83,
												"uvScaleX": 0.5,
												"uvScaleY": 1,
												"texture": "Fx/_Resources/Noise/FlareNoise02_Sharper.png",
												"uvShift": [
													0,
													0.5
												],
												"uvShiftSpeed": [
													0.1,
													-1
												]
											}
										},
										{
											"type": "shader",
											"name": "AlphaKill",
											"source": "shaders/AlphaKill.hx",
											"props": {
												"threshold": 0.1,
												"useRGB": false
											}
										}
									]
								},
								{
									"type": "model",
									"name": "m_waterfall_TestMousse",
									"source": "Fx/_Resources/Meshes_Common/m_waterfall_TestMousse01.fbx",
									"x": -7.21,
									"z": -2.29,
									"scaleX": 2.34,
									"scaleY": 5,
									"scaleZ": 11.2,
									"children": [
										{
											"type": "material",
											"name": "material",
											"props": {
												"PBR": {
													"mode": "BeforeTonemapping",
													"blend": "Alpha",
													"shadows": false,
													"culling": "Back",
													"colorMask": 255,
													"depthPrepass": true
												}
											}
										},
										{
											"type": "shader",
											"name": "VertexDisplacement",
											"source": "shaders/VertexDisplacement.hx",
											"enabled": false,
											"props": {
												"X": true,
												"Y": true,
												"Z": false,
												"useNormal": true,
												"texScaleX": 5,
												"texScaleY": 1,
												"tex": "Fx/_Resources/Noise/FlareNoise03_disp_tiling.png",
												"intensity": 2.35,
												"scrollSpeed": [
													0,
													-2
												],
												"useWorld": false,
												"centered": false
											}
										},
										{
											"type": "shader",
											"name": "SHADER_VertexDisplacement_Masked",
											"source": "Fx/Shaders/SHADER_VertexDisplacement_Masked.shgraph",
											"enabled": false,
											"props": {
												"TEX_Displacement": "Fx/_Resources/Gradients/TEX_GradientMirror_H.png",
												"TEX_Mask": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0.125,
																"color": -16777216
															},
															{
																"position": 1,
																"color": -1
															}
														],
														"resolution": 64,
														"isVertical": true,
														"interpolation": "Linear",
														"colorMode": 0
													}
												},
												"Paning_Speed": [
													0,
													-5
												],
												"Tilling": [
													1,
													1
												],
												"Power": 0.2,
												"UseSourceUV": 0
											}
										},
										{
											"type": "shader",
											"name": "SHADER_VertexDisplacement_Masked",
											"source": "Fx/Shaders/SHADER_VertexDisplacement_Masked.shgraph",
											"props": {
												"TEX_Displacement": "Fx/_Resources/Noise/FlareNoise03_disp_tiling.png",
												"TEX_Mask": {
													"type": "gradient",
													"data": {
														"stops": [
															{
																"position": 0,
																"color": -16777216
															},
															{
																"position": 1,
																"color": -1
															}
														],
														"resolution": 64,
														"isVertical": true,
														"interpolation": "Linear",
														"colorMode": 0
													}
												},
												"Paning_Speed": [
													0,
													-1
												],
												"Tilling": [
													0.25,
													2
												],
												"Power": 0.25,
												"UseSourceUV": 0
											}
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.64,
												"saturation": 1,
												"width": 0.83,
												"uvScaleX": 0.5,
												"uvScaleY": 1,
												"texture": "Fx/_Resources/Noise/FlareNoise02_Sharper.png",
												"uvShift": [
													0.2,
													0
												],
												"uvShiftSpeed": [
													0.1,
													-1
												]
											}
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"enabled": false,
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.62,
												"saturation": 1,
												"width": 0.74,
												"uvScaleX": 0.5,
												"uvScaleY": 1,
												"texture": "Fx/_Resources/Gradients/Cyl01u_A.jpg",
												"uvShift": [
													0,
													0
												],
												"uvShiftSpeed": [
													0.1,
													-3
												]
											}
										},
										{
											"type": "shader",
											"name": "DissolveMap",
											"source": "shaders/DissolveMap.hx",
											"enabled": false,
											"props": {
												"useSourceUVs": true,
												"useScale": true,
												"wrap": true,
												"progress": 0.62,
												"saturation": 1,
												"width": 0.74,
												"uvScaleX": 0.5,
												"uvScaleY": 0.5,
												"texture": "Fx/_Resources/Gradients/GradientSpice_2.png",
												"uvShift": [
													0,
													0
												],
												"uvShiftSpeed": [
													0.1,
													-2
												]
											}
										},
										{
											"type": "curve",
											"name": "scale:z",
											"enabled": false,
											"keys": [
												{
													"time": 0,
													"value": 1.0183995327102804,
													"mode": 2
												},
												{
													"time": 0.2,
													"value": 0.8652749890478977,
													"mode": 2
												},
												{
													"time": 0.4,
													"value": 1.0037620473130842,
													"mode": 2
												},
												{
													"time": 0.5,
													"value": 0.902393947137851,
													"mode": 2
												},
												{
													"time": 0.5924490314640412,
													"value": 0.9964433046144862,
													"mode": 2
												},
												{
													"time": 0.8,
													"value": 0.7523939471378509,
													"mode": 2
												},
												{
													"time": 1,
													"value": 0.9964433046144862,
													"mode": 2
												}
											],
											"loop": true
										},
										{
											"type": "shader",
											"name": "AlphaKill",
											"source": "shaders/AlphaKill.hx",
											"props": {
												"threshold": 0.1,
												"useRGB": false
											}
										}
									]
								},
								{
									"type": "shader",
									"name": "ColorSet",
									"source": "shaders/ColorSet.hx",
									"enabled": false,
									"props": {
										"amount": 1,
										"color": [
											0.5333333333333333,
											0.615686274509804,
											0.615686274509804
										]
									}
								},
								{
									"type": "shader",
									"name": "ColorSet",
									"source": "shaders/ColorSet.hx",
									"props": {
										"amount": 1,
										"color": [
											0.8235294117647058,
											0.8941176470588235,
											0.8941176470588235
										]
									}
								},
								{
									"type": "shader",
									"name": "MaskColorAlpha",
									"source": "hrt.shader.MaskColorAlpha",
									"props": {
										"UVScale": [
											1,
											1
										],
										"alpha": 1,
										"MULTIPLY": false,
										"color": [
											0.6313725490196078,
											0.803921568627451,
											0.8784313725490196,
											1
										],
										"mask": {
											"type": "gradient",
											"data": {
												"stops": [
													{
														"position": 0.46484375,
														"color": -1
													},
													{
														"position": 1,
														"color": -16777216
													}
												],
												"resolution": 64,
												"isVertical": true,
												"interpolation": "Linear",
												"colorMode": 0
											}
										},
										"UVOffset": [
											0,
											0
										]
									}
								},
								{
									"type": "shader",
									"name": "AlphaKill",
									"source": "shaders/AlphaKill.hx",
									"props": {
										"threshold": 0.1,
										"useRGB": false
									}
								},
								{
									"type": "curve",
									"name": "scale:y",
									"keys": [
										{
											"time": 0,
											"value": 0.4883207232038548,
											"mode": 2
										},
										{
											"time": 0.2,
											"value": 1.0628810419100467,
											"mode": 2
										},
										{
											"time": 0.4,
											"value": 0.4883207232038548,
											"mode": 2
										},
										{
											"time": 0.5,
											"value": 1.1,
											"mode": 2
										},
										{
											"time": 0.5924490314640412,
											"value": 0.4883207232038548,
											"mode": 2
										},
										{
											"time": 0.8,
											"value": 1.06048230322722,
											"mode": 2
										},
										{
											"time": 1,
											"value": 0.4883207232038548,
											"mode": 2
										}
									],
									"loop": true
								}
							]
						},
						{
							"type": "model",
							"name": "Torus_Thin_MousseINT",
							"source": "Fx/_Resources/Meshes_Common/Torus_Thin.fbx",
							"x": 0.0295,
							"y": -5.8717,
							"z": -22.8817,
							"scaleX": 16,
							"scaleY": 3.5,
							"scaleZ": 94.41,
							"children": [
								{
									"type": "material",
									"name": "material",
									"props": {
										"PBR": {
											"mode": "BeforeTonemapping",
											"blend": "Alpha",
											"shadows": false,
											"culling": "None",
											"colorMask": 255,
											"depthTest": "Less",
											"depthWrite": "Off",
											"alphaKill": false,
											"depthPrepass": true
										}
									},
									"diffuseMap": "Fx/_Resources/Gradients/z_FillWhite.jpg"
								},
								{
									"type": "shader",
									"name": "VertexDisplacement",
									"source": "shaders/VertexDisplacement.hx",
									"props": {
										"X": false,
										"Y": false,
										"Z": true,
										"useNormal": true,
										"texScaleX": 1,
										"texScaleY": 10,
										"tex": "Fx/_Resources/Noise/T_Noise_Water_04.png",
										"intensity": 15,
										"scrollSpeed": [
											1,
											-1
										],
										"useWorld": false,
										"centered": false
									}
								},
								{
									"type": "shader",
									"name": "VertexDisplacement",
									"source": "shaders/VertexDisplacement.hx",
									"props": {
										"X": true,
										"Y": true,
										"Z": true,
										"useNormal": true,
										"texScaleX": 1,
										"texScaleY": 7,
										"tex": "Fx/_Resources/Noise/T_Noise_Water_04.png",
										"intensity": 4,
										"scrollSpeed": [
											0.5,
											0.5
										],
										"useWorld": false,
										"centered": false
									}
								},
								{
									"type": "shader",
									"name": "ColorSet",
									"source": "shaders/ColorSet.hx",
									"props": {
										"amount": 1,
										"color": [
											0.6431372549019607,
											0.8862745098039215,
											0.9882352941176471
										]
									}
								},
								{
									"type": "shader",
									"name": "SHADER_WaterWave",
									"source": "Fx/Environment/SHADER_WaterWave.shgraph",
									"props": {
										"ColorGradient": {
											"type": "gradient",
											"data": {
												"stops": [
													{
														"position": 0,
														"color": -4401690
													},
													{
														"position": 0.98046875,
														"color": -4401690
													},
													{
														"position": 1,
														"color": -5124125
													}
												],
												"resolution": 64,
												"isVertical": true,
												"interpolation": "Linear",
												"colorMode": 0
											}
										},
										"noisewhite": "Fx/_Resources/Noise/causticTexture-2.png",
										"Noisewhite_scale": [
											1,
											5
										],
										"Wnoise_ScrollSpeedX": 0.7,
										"Wnoise_ScrollSpeedY": 0,
										"GradientNB": {
											"type": "gradient",
											"data": {
												"stops": [
													{
														"position": 0.1171875,
														"color": -1
													},
													{
														"position": 0.46484375,
														"color": -16777216
													}
												],
												"resolution": 64,
												"isVertical": false,
												"interpolation": "Linear",
												"colorMode": 0
											}
										}
									}
								}
							]
						},
						{
							"type": "sound",
							"name": "event:/Ambiance/Amb_3D/Waterfall/Waterfall_Base",
							"y": -5,
							"z": -10
						}
					]
				}
			]
		}
	]
}