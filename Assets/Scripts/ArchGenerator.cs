using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class ArchGenerator : MonoBehaviour
{
    public Vector2 thickness;
    public float width;
    public float baseHeight;
    public float archHeight;
    public float archDetail;

    public int archCount;
    public float distance;

    MeshFilter meshFilter;
    void Start()
    {
        meshFilter = GetComponent<MeshFilter>();

        MeshBuilder meshBuilder = new();

        Vector3 right = transform.right * thickness.x;
        Vector3 up = transform.right * thickness.x;
        Vector3 forward = transform.right * thickness.x;

        Vector3 width = transform.right * this.width;

        for (int i = 0; i < archCount; i++)
        {
            Vector3 archOrigin = (thickness.y + distance) * i * Vector3.forward;

            // left base bottom - [0,3]
            meshBuilder.AddVertex(archOrigin);
            meshBuilder.AddVertex(archOrigin + right);
            meshBuilder.AddVertex(archOrigin + forward);
            meshBuilder.AddVertex(archOrigin + right + forward);

            meshBuilder.AddTriangle(0, 1, 2);
            meshBuilder.AddTriangle(1, 3, 2);

            // left base front - [4, 7]
            meshBuilder.AddVertex(archOrigin);
            meshBuilder.AddVertex(archOrigin + right);
            meshBuilder.AddVertex(archOrigin + up);
            meshBuilder.AddVertex(archOrigin + right + up);

            meshBuilder.AddTriangle(4, 6, 5);
            meshBuilder.AddTriangle(7, 5, 6);

            // left base back - [8, 11]
            meshBuilder.AddVertex(archOrigin + forward);
            meshBuilder.AddVertex(archOrigin + forward + right);
            meshBuilder.AddVertex(archOrigin + forward + up);
            meshBuilder.AddVertex(archOrigin + forward + right + up);

            meshBuilder.AddTriangle(8, 11, 10);
            meshBuilder.AddTriangle(8, 9, 11);

            //// left base top
            //meshBuilder.AddVertex(archOrigin + transform.up * baseHeight);
            //meshBuilder.AddVertex(archOrigin + right + transform.up * baseHeight);
            //meshBuilder.AddVertex(archOrigin + forward + transform.up * baseHeight);
            //meshBuilder.AddVertex(archOrigin + right + forward + transform.up * baseHeight);


            //// right base bottom
            //meshBuilder.AddVertex(archOrigin + width);
            //meshBuilder.AddVertex(archOrigin + width + right);
            //meshBuilder.AddVertex(archOrigin + width + forward);
            //meshBuilder.AddVertex(archOrigin + width + right + forward);

            //// right base top
            //meshBuilder.AddVertex(archOrigin + width + transform.up * baseHeight);
            //meshBuilder.AddVertex(archOrigin + width + right + transform.up * baseHeight);
            //meshBuilder.AddVertex(archOrigin + width + forward + transform.up * baseHeight);
            //meshBuilder.AddVertex(archOrigin + width + right + forward + transform.up * baseHeight);
        }

        meshFilter.mesh = meshBuilder.CreateMesh();
    }
}
