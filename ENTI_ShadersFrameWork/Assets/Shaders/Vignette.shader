Shader "Hidden/Custom/Vignette"
{
	HLSLINCLUDE
	// StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
	#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
	
	TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
	
	float _intensity;
	float _innerRadius;
	float _outerRadius;
	float3 _color;
	float4 Vignette(VaryingsDefault i) : SV_Target
	{
		
		float4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
		float2 uvfix = (i.texcoord - float2(0.5, 0.5));
		float shade = smoothstep(_innerRadius, _outerRadius, length(uvfix));

		return float4(lerp(col.rgb, lerp(col.rgb, _color, shade), _intensity.xxx), shade * _intensity);
	}
	ENDHLSL
	
	SubShader
	{
		Cull Off ZWrite Off ZTest Always
			Pass
		{
			HLSLPROGRAM
				#pragma vertex VertDefault
				#pragma fragment Vignette
			ENDHLSL
		}
	}
}
