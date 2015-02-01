Shader "Custom/Terrain Mixer Texture" {
	Properties {
		_MainTex ("Main Texture", 2D) = "white" {}
		_SecondTex ("Second Texture", 2D) = "white" {}
		//_ThirdTex ("Third Texture", 2D) = "white" {}
		//_TextureMix ("Texture Mix", Range(0.0, 1.0)) = 0.5 
		//_Color("Diffuse Material Color", Color) = (1.0, 0.5, 0.2, 1.0)
		//_BumpMap ("Bumpmap", 2D) = "bump"  {}

	}
	SubShader {
		Tags { "Queue"="Geometry" }
		
		//Tags {"LightMode" = "ForwardBase"}
	
//		Tags { "Queue"="Transparent" }
//		ZWrite Off
//		Blend SrcAlpha OneMinusSrcAlpha
//		LOD 200
		
		Pass
		{
		CGPROGRAM
		#pragma exclude_renderers ps3 xbox360 flash
		#pragma fragmentoption ARB_precision_hint_fatest
		#pragma vertex vert
		#pragma fragment frag
		
		#include "UnityCG.cginc"

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		
		uniform sampler2D _SecondTex;
		uniform float4 _SecondTex_ST;
		
//		uniform sampler2D _ThirdTex;
//		uniform float4 _ThirdTex_ST;
		
		//uniform fixed _TextureMix;
		uniform fixed4 _Color;
		uniform fixed4 _LightColor0;

		struct vertexInput {
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
		};
		
//		struct Input
//	    {
//		    float2 uv_MainTex;
//		    float2 uv_BumpMap;
//		    //INTERNAL_DATA
//	    };
//
//	    sampler2D _BumpMap;
//	    samplerCUBE _Cube;
		
		struct fragmentInput {
			float4 pos : SV_POSITION;
			half2 uv : TEXCOORD0;
			half2 uv2 : TEXCOORD1;
			//half2 uv3 : TEXCOORD2;
			fixed2 localPos : TEXCOORD3;
		};

		fragmentInput vert(vertexInput i)
		{
			fragmentInput o;
			o.localPos = i.vertex.xy + fixed2(0.5, 0.5);
			o.pos = mul(UNITY_MATRIX_MVP, i.vertex);
			o.uv  = TRANSFORM_TEX(i.texcoord, _MainTex);
			o.uv2 = TRANSFORM_TEX(i.texcoord, _SecondTex);
			//o.uv3 = TRANSFORM_TEX(i.texcoord, _ThirdTex);
			
//			float3 normalDirection = normalize(mul(float4(i.normal, 1.0), _World2Object).xyz); // normalize related to world
//			
//			float3 lightDirection = normalize( _WorldSpaceLightPos0.xyz);
//			
//			float3 diffuse = _LightColor0.xyz * _Color.rgb * max(0.0, (dot(normalDirection, lightDirection)));
//			
//			o.color = half4(diffuse, 1.0);

//			float4 tex = tex2D (_MainTex, IN.uv_MainTex);
//			clip (tex.a - 0.5);
//			o.Albedo = tex.rgb;
//			o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
			
			return o;
		}
		
		half4 frag(fragmentInput i) : COLOR {
			fixed midpointDistance = 1 - i.localPos.y;
			float pointChange = 2.0f;
			float percentageChange = 1.5f;
			
			fixed4 mainTexColor   = tex2D(_MainTex, i.uv);
			fixed4 secondTexColor = tex2D(_SecondTex, i.uv2);
			//fixed4 thirdTexColor  = tex2D(_ThirdTex, i.uv3);
			
			return lerp(mainTexColor, 
						secondTexColor,
						1 - (midpointDistance+pointChange)/pointChange*percentageChange); 
			
		}
		
//		void surf (Input IN, inout SurfaceOutput o)
//	    {
//			float4 tex = tex2D (_MainTex, IN.uv_MainTex);
//			clip (tex.a - 0.5);
//			o.Albedo = tex.rgb;
//			o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
//	    }
			
		ENDCG
		}
	} 
	FallBack "Diffuse"
}
