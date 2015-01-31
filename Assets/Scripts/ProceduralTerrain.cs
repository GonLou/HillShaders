/// <summary>
/// Procedural terrain with Hill algorithm.
/// </summary>

using UnityEngine;
using System.Collections;

public class ProceduralTerrain : MonoBehaviour {
	
	private float widthLength = 100.0f;
	private int meshSegmentCount = 100;	

	// Hill variables
	public float minRadius = 1.0f;
	public float maxRadius = 50.0f;

	public float minHillSize = 50;
	public float maxHillSize = 100;

	private float[,] finalY;

	public int interactionHill = 100;
	public int interactionHillSmooth = 3;

	private float maxY = 0;
	private float minY = 0;

	protected virtual void Start() {
		MeshBuilder meshBuilder = new MeshBuilder();
		
		float segmentSize = widthLength / meshSegmentCount;

		// Hill
		finalY = new float[(int)widthLength+1, (int)widthLength+1]; // make the grid
		for (int i = 0; i < interactionHill; i++) GenerateHill();
		MidpointDisplacementHill(interactionHillSmooth);
		
		for (int i = 0; i <= meshSegmentCount; i++) {
			float z = segmentSize * i;
			float v = (1.0f / meshSegmentCount) * i;
			
			for (int j = 0; j <= meshSegmentCount; j++) {
				float x = segmentSize * j;
				float u = (1.0f / meshSegmentCount) * j;

				Vector3 offset;

				// Hill
				offset = new Vector3(x, finalY[i, j], z);

				Vector2 uv = new Vector2(u, v);

				bool buildTriangles = i > 0 && j > 0;
				
				BuildQuadForGrid(meshBuilder, offset, uv, buildTriangles, meshSegmentCount + 1);
			}
		}

		Mesh mesh = meshBuilder.CreateMesh(); // Creates the mesh
		mesh.RecalculateNormals(); // Recalculates the normals of the mesh from the triangles and vertices
		mesh.AddComponent<MeshCollider>();
		MeshFilter filter = GetComponent<MeshFilter>(); // Search for a MeshFilter component attached to this GameObject
		if (filter != null)	filter.sharedMesh = mesh; // Render the mesh created

	}

	public void GenerateHill() {
		float radius = Random.Range( minHillSize, maxHillSize * 2);   // estabilishes the minimum and maximum value for the hill
		float x, y;                                                   // coordinates
		float theta = Random.Range( 0.0f, 2 * Mathf.PI );             // circle	
		float distance = Random.Range( 0, widthLength/2.0f - radius); // base distance

		// pick the coordinates for the hill inside the pre-establish circle
		x = (float)(widthLength / 2.0f + Mathf.Cos( theta ) * distance/1.5f);
		y = (float)(widthLength / 2.0f + Mathf.Sin( theta ) * distance/1.5f);

		float squareRadius = radius * radius; // just avoing pow function
		float squareDistance;
		float heigth; // the value of y
		
		// calculates the are of influence by the altitude of the hill
		int xMin = (int)(x - radius - 1);
		int xMax = (int)(x + radius + 1);

		int yMin = (int)(y - radius - 1);
		int yMax = (int)(y + radius + 1);

		// caps the bounds
		if( xMin < 0 ) xMin = 0;
		if( xMax >= widthLength ) xMax = (int)widthLength - 1;

		if( yMin < 0 ) yMin = 0;
		if( yMax >= widthLength ) yMax = (int)widthLength - 1;

		// cycles throug the affected mesh cells
		for( int h = xMin; h <= xMax; ++h ) {
			for( int v = yMin; v <= yMax; ++v ) {
				squareDistance = ( x - h ) * ( x - h ) + ( y - v ) * ( y - v ); // calculate the distance of this particular point
				heigth =  squareDistance-squareRadius; // determine the height of the hill for this point

				if( heigth > 0 ) finalY[h, v] = heigth; // add the height of this hill to the cell
					// keeps the maximum and lower values for later smoothing with normalize
					//if (heigth > maxY) maxY = heigth;
					//if (heigth < minY) minY = heigth;

			} // y
		} // x

	}
	
	/// <summary>
	/// Default normalize (no used)
	/// </summary>
	public void NormalizeHill() {
		// Get grid cell coordinates
		for( int h = 1; h <= widthLength-1; ++h ) {
			for( int v = 1; v <= widthLength-1; ++v ) {
				finalY[h, v] = (finalY[h, v] - minY) / (maxY - minY);
			}
		}
	}

	/// <summary>
	/// Smooths the plane
	/// </summary>
	/// <param name="smooth">number of interactions</param>
	public void MidpointDisplacementHill( int smooth ) {
		for ( int i = 0; i <= smooth; i++ ) {
			for( int h = 1; h <= widthLength-1; ++h ) {
				for( int v = 1; v <= widthLength-1; ++v ) {
					finalY[h, v] = (finalY[h+1, v+1] + 
					                finalY[h+1, v-1] + 
					                finalY[h-1, v+1] + 
					                finalY[h-1, v-1] +
					                finalY[h-1, v] + 
					                finalY[h+1, v] + 
					                finalY[h, v+1] + 
					                finalY[h, v-1]) / 8;
				}
			}
		}
		
	}

	/// <summary>
	/// </summary>
	/// <param name="meshBuilder">Mesh builder.</param>
	/// <param name="position">Position.</param>
	/// <param name="uv">Uv.</param>
	/// <param name="buildTriangles">If set to <c>true</c> build triangles.</param>
	/// <param name="vertsPerRow">Verts per row.</param>
	private void BuildQuadForGrid(MeshBuilder meshBuilder, Vector3 position, Vector2 uv, bool buildTriangles, int vertsPerRow) {
		meshBuilder.Vertices.Add(position);
		meshBuilder.UVs.Add(uv);
		
		if (buildTriangles) {
			int baseIndex = meshBuilder.Vertices.Count - 1;
			
			int index0 = baseIndex;
			int index1 = baseIndex - 1;
			int index2 = baseIndex - vertsPerRow;
			int index3 = baseIndex - vertsPerRow - 1;
			
			meshBuilder.AddTriangle(index0, index2, index1);
			meshBuilder.AddTriangle(index2, index3, index1);
		}
	}
}

