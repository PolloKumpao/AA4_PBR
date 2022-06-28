#ifndef UNITY_BRDF
#define UNITY_BRDF

static const float PI = 3.14159265;

// - FRESNEL

float FresnelSchlick(float q, float3 lightDir, float3 halfDir){
	return (q + pow((1.0 - q)*1.0 - dot(lightDir, halfDir),5.0));
}


// - DISTRIBUTION

float Distribution_GGX(float alpha, float3 normalDir, float3 halfDir){
	return (alpha * alpha) / (PI * pow(pow(dot(halfDir, normalDir), 2.0) * (alpha * alpha - 1.0) + 1.0, 2.0));
}


// - GEOMETRY

float Geometric_Kelemen(float3 viewDir, float3 normalDir, float3 lightDir, float3 halfDir){
	return (dot(normalDir, lightDir) * dot(normalDir, viewDir)) / pow(dot(viewDir, halfDir), 2);
}


// - BRDF

float BRDF(float alpha, float q, float3 viewDir, float3 normalDir, float3 lightDir){
	float3 halfDir = normalize(viewDir + lightDir);
	return	max((
			FresnelSchlick(q, lightDir, halfDir)
			* Geometric_Kelemen(viewDir, normalDir, lightDir, halfDir)
			* Distribution_GGX(alpha, normalDir, halfDir)
			), 0)
			/ (4.0 * dot(normalDir, lightDir) * dot(normalDir, viewDir));
}

#endif