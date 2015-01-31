Shader "Custom/Terrain Mixer Texture" {
	Properties {
		_MainTex ("Main Texture", 2D) = "white" {}
		_SecondTex ("Second Texture", 2D) = "white" {}
		_TextureMix ("Texture Mix", Range(0.0, 1.0)) = 0.5 
	}
	SubShader {
		Tags { "Queue"="Geometry" }
	
		//Tags { "Queue"="Transparent" }
		//ZWrite Off
		//Blend SrcAlpha OneMinusSrcAlpha
		//LOD 200
		
		Pass
		{
		CGPROGRAM
		#pragma exclusde_renderers ps3 xbox360 flash
		#pragma fragmentoption ARB_precision_hint_fatest
		#pragma vertex vert
		#pragma fragment frag
		
		#include "UnityCG.cginc"

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _SecondTex;
		uniform float4 _SecondTex_ST;
		uniform fixed _TextureMix;

		struct vertexInput {
			float4 vertex : POSITION;
			float4 texcoord : TEXCOORD0;
		};
		
		struct fragmentInput {
			float4 pos : SV_POSITION;
			half2 uv : TEXCOORD0;
			half2 uv2 : TEXCOORD1;
			fixed2 localPos : TEXCOORD2;
		};

		fragmentInput vert(vertexInput i)
		{
			fragmentInput o;
			o.localPos = i.vertex.xy + fixed2(0.5, 0.5);
			o.pos = mul(UNITY_MATRIX_MVP, i.vertex);
			o.uv = TRANSFORM_TEX(i.texcoord, _MainTex);
			o.uv2 = TRANSFORM_TEX(i.texcoord, _SecondTex);
			
			return o;
		}
		
		half4 frag(fragmentInput i) : COLOR {
			fixed midpointDistance = _TextureMix - i.localPos.x;
			fixed4 mainTexColor = tex2D(_MainTex, i.uv);
			fixed4 secondTexColor = tex2D(_SecondTex, i.uv2);
			float pointChange = 3.0f;
			float percentageChange = 0.25f;
			
			if (i.localPos.y > pointChange-(pointChange*percentageChange) &&
				i.localPos.y < pointChange+(pointChange*percentageChange)) {
				fixed mixFactor = 1 - (midpointDistance+pointChange)/pointChange*2;
				return lerp(mainTexColor, secondTexColor, pointChange-(pointChange*percentageChange));
			}
			
			if (i.localPos.y <= pointChange-(pointChange*percentageChange)) 
				return mainTexColor;
			else
				return secondTexColor;
		}
			
		ENDCG
		}
	} 
	FallBack "Diffuse"
}
