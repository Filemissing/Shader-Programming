using UnityEngine;
using UnityEngine.Rendering.Universal;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class ArchGenerator : MonoBehaviour
{
    public Vector2 thickness;
    public float width;
    public float baseHeight;
    public int archDetail;

    public int archCount;
    public float distanceBetween;

    public bool regenerate;

    MeshFilter meshFilter;
    void Start()
    {
        GenerateArches();
    }

    private void Update()
    {
        if (regenerate)
        {
            GenerateArches(); 
        }
    }

    void GenerateArches()
    {
        meshFilter = GetComponent<MeshFilter>();

        MeshBuilder meshBuilder = new();

        Vector3 right = Vector3.right * thickness.x;
        Vector3 up = Vector3.up * baseHeight;
        Vector3 forward = Vector3.forward * thickness.y;

        Vector3 width = Vector3.right * this.width;

        Vector2 uvBottomLeft = new Vector2(0, 0);
        Vector2 uvBottomRight = new Vector2(1, 0);
        Vector2 uvTopLeft = new Vector2(0, 1) * baseHeight;
        Vector2 uvTopRight = new Vector2(1, 1 * baseHeight);

        for (int i = 0; i < archCount; i++)
        {
            Vector3 archOrigin = (thickness.y + distanceBetween) * i * Vector3.forward;
            int startIndex = meshBuilder._vertices.Count;

            // left base
            // left base bottom - [0,3]
            meshBuilder.AddVertex(archOrigin, uvTopLeft);
            meshBuilder.AddVertex(archOrigin + right, uvTopRight);
            meshBuilder.AddVertex(archOrigin + forward, uvBottomLeft);
            meshBuilder.AddVertex(archOrigin + right + forward, uvBottomRight);

            meshBuilder.AddTriangle(startIndex + 0, startIndex + 1, startIndex + 2);
            meshBuilder.AddTriangle(startIndex + 1, startIndex + 3, startIndex + 2);

            // left base front - [4, 7]
            meshBuilder.AddVertex(archOrigin, uvBottomLeft);
            meshBuilder.AddVertex(archOrigin + right, uvBottomRight);
            meshBuilder.AddVertex(archOrigin + up, uvTopLeft);
            meshBuilder.AddVertex(archOrigin + right + up, uvTopRight);

            meshBuilder.AddTriangle(startIndex + 4, startIndex + 6, startIndex + 5);
            meshBuilder.AddTriangle(startIndex + 7, startIndex + 5, startIndex + 6);

            // left base back - [8, 11]
            meshBuilder.AddVertex(archOrigin + forward, uvBottomRight);
            meshBuilder.AddVertex(archOrigin + forward + right, uvBottomLeft);
            meshBuilder.AddVertex(archOrigin + forward + up, uvTopRight);
            meshBuilder.AddVertex(archOrigin + forward + right + up, uvTopLeft);

            meshBuilder.AddTriangle(startIndex + 8, startIndex + 11, startIndex + 10);
            meshBuilder.AddTriangle(startIndex + 8, startIndex + 9, startIndex + 11);

            // left base right - [12, 15]
            meshBuilder.AddVertex(archOrigin + right, uvBottomLeft);
            meshBuilder.AddVertex(archOrigin + right + forward, uvBottomRight);
            meshBuilder.AddVertex(archOrigin + right + up, uvTopLeft);
            meshBuilder.AddVertex(archOrigin + right + up + forward, uvTopRight);

            meshBuilder.AddTriangle(startIndex + 12, startIndex + 14, startIndex + 15);
            meshBuilder.AddTriangle(startIndex + 12, startIndex + 15, startIndex + 13);

            // left base left - [16, 19]
            meshBuilder.AddVertex(archOrigin, uvBottomRight);
            meshBuilder.AddVertex(archOrigin + forward, uvBottomLeft);
            meshBuilder.AddVertex(archOrigin + up, uvTopRight);
            meshBuilder.AddVertex(archOrigin + up + forward, uvTopLeft);

            meshBuilder.AddTriangle(startIndex + 17, startIndex + 19, startIndex + 18);
            meshBuilder.AddTriangle(startIndex + 17, startIndex + 18, startIndex + 16);

            // right base
            // right base bottom - [20,23]
            meshBuilder.AddVertex(archOrigin + width, uvTopLeft);
            meshBuilder.AddVertex(archOrigin + width + right, uvTopRight);
            meshBuilder.AddVertex(archOrigin + width + forward, uvBottomLeft);
            meshBuilder.AddVertex(archOrigin + width + right + forward, uvBottomRight);

            meshBuilder.AddTriangle(startIndex + 20, startIndex + 21, startIndex + 22);
            meshBuilder.AddTriangle(startIndex + 21, startIndex + 23, startIndex + 22);

            // right base front - [24, 27]
            meshBuilder.AddVertex(archOrigin + width, uvBottomLeft);
            meshBuilder.AddVertex(archOrigin + width + right, uvBottomRight);
            meshBuilder.AddVertex(archOrigin + width + up, uvTopLeft);
            meshBuilder.AddVertex(archOrigin + width + right + up, uvTopRight);

            meshBuilder.AddTriangle(startIndex + 24, startIndex + 26, startIndex + 25);
            meshBuilder.AddTriangle(startIndex + 27, startIndex + 25, startIndex + 26);

            // right base back - [28, 31]
            meshBuilder.AddVertex(archOrigin + width + forward, uvBottomRight);
            meshBuilder.AddVertex(archOrigin + width + forward + right, uvBottomLeft);
            meshBuilder.AddVertex(archOrigin + width + forward + up, uvTopRight);
            meshBuilder.AddVertex(archOrigin + width + forward + right + up, uvTopLeft);

            meshBuilder.AddTriangle(startIndex + 28, startIndex + 31, startIndex + 30);
            meshBuilder.AddTriangle(startIndex + 28, startIndex + 29, startIndex + 31);

            // right base right - [32, 35]
            meshBuilder.AddVertex(archOrigin + width + right, uvBottomLeft);
            meshBuilder.AddVertex(archOrigin + width + right + forward, uvBottomRight);
            meshBuilder.AddVertex(archOrigin + width + right + up, uvTopLeft);
            meshBuilder.AddVertex(archOrigin + width + right + up + forward, uvTopRight);

            meshBuilder.AddTriangle(startIndex + 32, startIndex + 34, startIndex + 35);
            meshBuilder.AddTriangle(startIndex + 32, startIndex + 35, startIndex + 33);

            // right base right - [36, 39]
            meshBuilder.AddVertex(archOrigin + width, uvBottomRight);
            meshBuilder.AddVertex(archOrigin + width + forward, uvBottomLeft);
            meshBuilder.AddVertex(archOrigin + width + up, uvTopRight);
            meshBuilder.AddVertex(archOrigin + width + up + forward, uvTopLeft);

            meshBuilder.AddTriangle(startIndex + 37, startIndex + 39, startIndex + 38);
            meshBuilder.AddTriangle(startIndex + 37, startIndex + 38, startIndex + 36);

            // top arch
            float halfCircleOutside(float x)
            {
                return Mathf.Sqrt(-Mathf.Pow(x - ((this.width - thickness.x) / 2) - thickness.x, 2) + Mathf.Pow(((this.width - thickness.x) / 2) + thickness.x, 2));
            }
            float halfCircleInside(float x)
            {
                return Mathf.Sqrt(-Mathf.Pow(x - ((this.width - thickness.x) / 2) - thickness.x, 2) + Mathf.Pow((this.width - thickness.x) / 2, 2));
            }

            for (int j = 0; j < archDetail + 1; j++)
            {
                float outsideX = (this.width + thickness.x) / archDetail * j;
                float insideX = thickness.x + ((this.width - thickness.x) / archDetail * j);

                float outsideY = halfCircleOutside(outsideX);
                float insideY = halfCircleInside(insideX);

                if (float.IsNaN(outsideY)) outsideY = 0;
                if (float.IsNaN(insideY)) insideY = 0;

                // add vertecies for front and back
                meshBuilder.AddVertex(archOrigin + up + Vector3.right * outsideX + Vector3.up * outsideY, new Vector2(outsideX / thickness.x, outsideY * (this.width / 2)));
                meshBuilder.AddVertex(archOrigin + up + Vector3.right * insideX + Vector3.up * insideY, new Vector2(insideX / thickness.x, insideY * (this.width / 2)));
                meshBuilder.AddVertex(archOrigin + up + Vector3.right * outsideX + Vector3.up * outsideY + forward, new Vector2(-outsideX / thickness.x, outsideY * (this.width / 2)));
                meshBuilder.AddVertex(archOrigin + up + Vector3.right * insideX + Vector3.up * insideY + forward, new Vector2(-insideX / thickness.x, insideY * (this.width / 2)));

                // vertices for inside and outside
                meshBuilder.AddVertex(archOrigin + up + Vector3.right * outsideX + Vector3.up * outsideY, new Vector2(1, outsideY / (3 * Mathf.PI * (this.width + thickness.x))));
                meshBuilder.AddVertex(archOrigin + up + Vector3.right * insideX + Vector3 .up * insideY, new Vector2(0, insideY / (3 * Mathf.PI * (this.width - thickness.x))));
                meshBuilder.AddVertex(archOrigin + up + Vector3.right * outsideX + Vector3.up * outsideY + forward, new Vector2(0, outsideY / (3 * Mathf.PI * (this.width + thickness.x))));
                meshBuilder.AddVertex(archOrigin + up + Vector3.right * insideX + Vector3.up * insideY + forward, new Vector2(1, insideY / (3 * Mathf.PI * (this.width - thickness.x))));

                // add triangles only after first ring
                if (j == 0) continue;

                // modify j to be the index of the first vertex in current ring
                int v = startIndex + 40 + j * 8;

                // front
                meshBuilder.AddTriangle(v - 8, v, v + 1);
                meshBuilder.AddTriangle(v - 8, v + 1, v - 7);

                // back
                meshBuilder.AddTriangle(v + 3, v + 2, v - 6);
                meshBuilder.AddTriangle(v - 5, v + 3, v - 6);

                // inside
                meshBuilder.AddTriangle(v - 3, v + 5, v + 7);
                meshBuilder.AddTriangle(v - 3, v + 7, v - 1);

                // outside
                meshBuilder.AddTriangle(v - 2, v + 6, v + 4);
                meshBuilder.AddTriangle(v - 2, v + 4, v - 4);
            }
        }

        meshFilter.mesh = meshBuilder.CreateMesh();
    }
}
