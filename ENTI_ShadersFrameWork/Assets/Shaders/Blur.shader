Shader "Hidden/Custom/Blur"
	{
	HLSLINCLUDE
		// StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"


#define PI 3.14159265359
#define E 2.71828182846
#define SAMPLES 100

		sampler2D _MainTex;
		float _BlurSize;
		float _SD;
		float sum = SAMPLES;
		float4 col;



		float4 HorizontalBlur(VaryingsDefault i) : SV_Target
		{
			if (_SD == 0)
			return tex2D(_MainTex, i.texcoord);

			float invAspect = _ScreenParams.y / _ScreenParams.x;

			for (float index = 0; index < SAMPLES; index++)
			{
				float offset = (index / (SAMPLES - 1) - 0.5) * _BlurSize * invAspect;
				//get uv coordinate of sample
				float2 uv = i.texcoord + float2(offset,0 );
				//calculate the result of the gaussian function
				float stDevSquared = _SD * _SD;
				float gauss = (1 / sqrt(2 * PI*stDevSquared)) * pow(E, -((offset*offset) / (2 * stDevSquared)));
				//add result to sum
				sum += gauss;
				//multiply color with influence from gaussian function and add it to sum color
				col += tex2D(_MainTex, uv) * gauss;
			}
			col = col / sum;
			float4 col2;
			for (float index = 0; index < SAMPLES; index++)
			{
				float offset = (index / (SAMPLES - 1) - 0.5) * _BlurSize;
				//get uv coordinate of sample
				float2 uv = i.texcoord + float2(0, offset);
				//calculate the result of the gaussian function
				float stDevSquared = _SD * _SD;
				float gauss = (1 / sqrt(2 * PI*stDevSquared)) * pow(E, -((offset*offset) / (2 * stDevSquared)));
				//add result to sum
				sum += gauss;
				//multiply color with influence from gaussian function and add it to sum color
				col2 += tex2D(_MainTex, uv) * gauss;
			}
			col2 = col2 / sum;
			col = (col + col2) / 2;

			return col;
		}
			
		float4 VerticalBlur(VaryingsDefault i) : SV_Target
		{
			  if (_SD == 0)
				return tex2D(_MainTex, i.texcoord);

			for (float index = 0; index < SAMPLES; index++)
			{
				float offset = (index / (SAMPLES - 1) - 0.5) * _BlurSize;
				//get uv coordinate of sample
				float2 uv = i.texcoord + float2(0, offset);
				//calculate the result of the gaussian function
				float stDevSquared = _SD * _SD;
				float gauss = (1 / sqrt(2 * PI*stDevSquared)) * pow(E, -((offset*offset) / (2 * stDevSquared)));
				//add result to sum
				sum += gauss;
				//multiply color with influence from gaussian function and add it to sum color
				col += tex2D(_MainTex, uv) * gauss;
			}
			col = col / sum;
			return col;
		}
			
			ENDHLSL

		SubShader
		{
			Cull Off ZWrite Off ZTest Always


				Pass
			{
				HLSLPROGRAM
					#pragma vertex VertDefault
					#pragma fragment HorizontalBlur
				ENDHLSL
			}

		
				Pass
			{
				HLSLPROGRAM
					#pragma vertex VertDefault
					#pragma fragment VerticalBlur
				ENDHLSL
			}
		
		

		
		}
	}
