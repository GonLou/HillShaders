using UnityEngine;
using System.Collections;

public class SphereAdd : MonoBehaviour {

	// Use this for initialization
	void Start () {
		MeshBuilder meshBuilder;

		int x = 0;
		int y = 0;
		int z = 0;

		float r = Mathf.Sqrt(x*x + y*y + z*z );
		float theta = Mathf.Atan2(Mathf.Sqrt(x*x + y*y) , z);
		float phi = Mathf.Atan2(y,x);

		int segmentCount = 10;
		float radius = 10;
		int n = 8;
				
		float newx = Mathf.Pow (r, n) * Mathf.Sin(theta*n) * Mathf.Cos(phi*n);
		float newy = Mathf.Pow (r, n) * Mathf.Sin(theta*n) * Mathf.Sin(phi*n);
		float newz = Mathf.Pow (r, n) * Mathf.Cos(theta*n);

		newx = 0;
		newy = 0;
		newz = 0;

		//BuildRingForSphere(meshBuilder, segmentCount, Vector3 (newx, newy, newz), radius, 1, true);
					
	}



//	float4 frag(v2f_img i) : COLOR {
//		float2 mcoord;
//		float2 coord = float2(0.0,0.0);
//		mcoord.x = ((1.0-i.uv.x)*3.5)-2.5;
//		mcoord.y = (i.uv.y*2.0)-1.0;
//		float iteration = 0.0;
//		const float _MaxIter = 29.0;
//		const float PI = 3.14159;
//		float xtemp;
//		for ( iteration = 0.0; iteration < _MaxIter; iteration += 1.0) {
//			if ( coord.x*coord.x + coord.y*coord.y > 2.0*(cos(fmod(_Time.y,2.0*PI))+1.0) )
//				break;
//			xtemp = coord.x*coord.x - coord.y*coord.y + mcoord.x;
//			coord.y = 2.0*coord.x*coord.y + mcoord.y;
//			coord.x = xtemp;
//		}
//		float val = fmod((iteration/_MaxIter)+_Time.x,1.0);
//		float4 color;
//		
//		color.r = clamp((3.0*abs(fmod(2.0*val,1.0)-0.5)),0.0,1.0);
//		color.g = clamp((3.0*abs(fmod(2.0*val+(1.0/3.0),1.0)-0.5)),0.0,1.0);
//		color.b = clamp((3.0*abs(fmod(2.0*val-(1.0/3.0),1.0)-0.5)),0.0,1.0);
//		color.a = 1.0;
//		
//		return color;
//	}
//	ENDCG
//}


// Update is called once per frame
void Update () {
	
}

//void BuildRingForSphere(MeshBuilder meshBuilder, int segmentCount, Vector3 centre, float radius, 
//                        float v, bool buildTriangles)
//{
//	float angleInc = (Mathf.PI * 2.0f) / segmentCount;
//	
//	for (int i = 0; i <= segmentCount; i++)
//	{
//		float angle = angleInc * i;
//		
//		Vector3 unitPosition = Vector3.zero;
//			unitPosition.x = Mathf.Cos(angle);
//			unitPosition.z = Mathf.Sin(angle);
//			
//			Vector3 vertexPosition = centre + unitPosition * radius;
//			
//			meshBuilder.Vertices.Add(vertexPosition);
//			meshBuilder.Normals.Add(vertexPosition.normalized);
//			meshBuilder.UVs.Add(new Vector2((float)i / segmentCount, v));
//			
//			if (i > 0 && buildTriangles)
//			{
//				int baseIndex = meshBuilder.Vertices.Count - 1;
//				
//				int vertsPerRow = segmentCount + 1;
//				
//				int index0 = baseIndex;
//				int index1 = baseIndex - 1;
//				int index2 = baseIndex - vertsPerRow;
//				int index3 = baseIndex - vertsPerRow - 1;
//				
//				meshBuilder.AddTriangle(index0, index2, index1);
//				meshBuilder.AddTriangle(index2, index3, index1);
//			}
//		}
//	}
}
