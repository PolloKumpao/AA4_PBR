Shader "Hidden/Custom/Pixelate"
{
	HLSLINCLUDE
	// StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
	#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
	
	TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
	
	float _pixelSize;
	float4 Pixelate(VaryingsDefault i) : SV_Target
	{
		//float2 N = _ScreenParams / _pixelSize;
		float2 UV = floor(i.texcoord * _pixelSize) / _pixelSize;
		float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, UV);
		
		// Return the result
		return color;
	}
	ENDHLSL
	
	SubShader
	{
		Cull Off ZWrite Off ZTest Always
			Pass
		{
			HLSLPROGRAM
				#pragma vertex VertDefault
				#pragma fragment Pixelate
			ENDHLSL
		}
	}
}
