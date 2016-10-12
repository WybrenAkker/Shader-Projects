Shader "Custom/NormalShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_Glossiness ("Smoothness", 2D) = "black" {}
		_Metallic ("Metallic", 2D) = "black" {}
		_NormalMap ("Normal", 2D) = "bump" {}
		_DetailMap("DetailNormal", 2D) = "bump" {}
		_DetailIntensity ("Detail", Range(0,1)) = 0.0
		_EmissionTex("EmissionTexture" , 2D) = "white" {}
		_Emission("Emission", Color) = (1,0,0,1)
		_EmissionIntensity("EmissionIntensity", Range(0,1)) = 0.0
		}
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model(, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _Glossiness;
		sampler2D _Metallic;
		sampler2D _NormalMap;
		sampler2D _DetailMap;
		sampler2D _EmissionTex;

		struct Input {
			float2 uv_EmissionTex;
			float2 uv_Glossiness;
			float2 uv_Metallic;
		};

		half _DetailIntensity;
		fixed4 _Color;
		fixed4 _Emission;
		half _EmissionIntensity;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			o.Albedo = _Color;
				// Metallic and smoothness come from slider variables
			fixed4 m = tex2D(_Metallic, IN.uv_Metallic);
			o.Metallic = m.rgb;

			fixed4 g = tex2D(_Glossiness, IN.uv_Glossiness);
			o.Smoothness = g.rgb;


			fixed3 n = UnpackNormal(tex2D(_NormalMap, IN.uv_Metallic));
			fixed3 d = UnpackNormal(tex2D(_DetailMap, IN.uv_Metallic)) * _DetailIntensity;
			o.Normal = n + d;

			fixed4 e = tex2D(_EmissionTex, IN.uv_EmissionTex) * _Emission;
			o.Emission = e.rgb * _EmissionIntensity;

			o.Alpha = _Color.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
