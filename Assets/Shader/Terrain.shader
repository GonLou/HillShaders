Shader "Custom/Terrain Mixer Texture" {
	Properties {
		_Color ("Main Color", Color) = (0,1,0,1)
		_MainTex ("Main Texture", 2D) = "white" {}
		_SecondTex ("Second Texture", 2D) = "white" {}
		_BumpMap ("Bumpmap", 2D) = "bump"  {}
//		_NormalIntensity("Normal Map Intensity", Range(0, 2)) = 1
//		_RimColor ("Rim Color", Color) = (1,1,1,1)
//		_RimPower("Rim Power", Range(0.1, 10)) = 3.0
	}
	SubShader {
		Tags { "Queue"="Geometry" }
		
		Tags { "LightMode"="ForwardBase" }

//		Blend SrcAlpha OneMinusSrcAlpha
		
		Pass
		{
		CGPROGRAM
		#pragma exclude_renderers ps3 xbox360 flash
		#pragma fragmentoption ARB_precision_hint_fatest
		#pragma vertex vert
		#pragma fragment frag
		
		#include "UnityCG.cginc"
		
		#include "AutoLight.cginc" 

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		
		uniform sampler2D _SecondTex;
		uniform float4 _SecondTex_ST;
			
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;	
			
		uniform fixed4 _Color;
		uniform fixed4 _LightColor0;
		
		float _NormalIntensity;
		
		float4 _RimColor;
		float _RimPower;

		struct vertexInput {
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
		};
		
		struct Input
	    {
		    float2 uv_MainTex;
		    float2 uv_BumpMap;
		    float3 viewDir;
	    };
	    
	    struct SurfaceOutputCustom {
		    fixed3 Albedo;
		    fixed3 Normal;
		    fixed3 Emission;
		    half Specular;
		    fixed Gloss;
		    fixed Alpha;
		    fixed Intensity;
		};
		
		struct fragmentInput {
			float4 pos : SV_POSITION;
			half2 uv : TEXCOORD0;
			half2 uv2 : TEXCOORD1;
			fixed2 localPos : TEXCOORD3;
			
			LIGHTING_COORDS(0, 1)
		};

		fragmentInput vert(vertexInput i)
		{
			fragmentInput o;
			o.localPos = i.vertex.xy + fixed2(0.5, 0.5);
			o.pos = mul(UNITY_MATRIX_MVP, i.vertex);
			o.uv  = TRANSFORM_TEX(i.texcoord, _MainTex);
			o.uv2 = TRANSFORM_TEX(i.texcoord, _SecondTex);
			
			TRANSFER_VERTEX_TO_FRAGMENT(o);
			
			return o;
		}
		
		half4 frag(fragmentInput i) : COLOR {
			fixed midpointDistance = 1 - i.localPos.y;
			float pointChange = 2.0f;
			float percentageChange = 1.5f;
			
			fixed4 mainTexColor   = tex2D(_MainTex, i.uv);
			fixed4 secondTexColor = tex2D(_SecondTex, i.uv2);
			
			float attenuation = LIGHT_ATTENUATION(i);
			
			return lerp(mainTexColor, 
						secondTexColor,
						1 - (midpointDistance+pointChange)/pointChange*percentageChange) * attenuation; 
			
		}
		
//		void surf (Input IN, inout SurfaceOutputCustom o)
//	    {
//			float4 tex = tex2D (_MainTex, IN.uv_MainTex);
//			o.Albedo = tex.rgb;
//			o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_MainTex));
//			half rim = 1 - dot(normalize(IN.viewDir), o.Normal);
//			o.Emission = _RimColor.rgb * pow(rim, _RimPower);
//
//	    }
			
		ENDCG
		}
	} 
	FallBack "Diffuse"
}
