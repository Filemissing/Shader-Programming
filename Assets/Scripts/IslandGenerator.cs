using Unity.Mathematics;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class IslandGenerator : MonoBehaviour
{
    public Vector2Int size;
    [Tooltip("vertices per unit")] public int detail;
    public float baseHeight;
    public float heightMultiplier;

    public Texture2D falloffMap;

    MeshFilter meshFilter;
    private void Start()
    {
        meshFilter = GetComponent<MeshFilter>();
        GenerateIsland();
    }
    public void GenerateIsland()
    {
        MeshBuilder meshBuilder = new();
        
        float2 center = new float2(size.x / 2f, size.y / 2f);
        
        for (int x = 0; x < size.x * detail; x++)
        {
            for (int z = 0; z < size.y * detail; z++)
            {
                float realX = x / (float)detail;
                float realZ = z / (float)detail;

                float u = realX / size.x;
                float v = realZ / size.y;

                float falloff = falloffMap.GetPixelBilinear(u, v).r;

                float noiseValue = noise.pnoise(new float2(realX, realZ), new float2(size.x, size.y));

                float y = (noiseValue + 1f) * .5f; // remap from [-1, 1] to [0, 1]

                y += baseHeight;

                y *= falloff;

                meshBuilder.AddVertex(new Vector3(realX, y * heightMultiplier, realZ), new Vector2(realX / size.x, realZ / size.y));
            }
        }

        int width = size.x * detail;
        int height = size.y * detail;
        for (int x = 0; x < width - 1; x++)
        {
            for (int z = 0; z < height - 1; z++)
            {
                int i = x * height + z;

                meshBuilder.AddTriangle(i, i + 1, i + height + 1);
                meshBuilder.AddTriangle(i + height + 1, i + height, i);
            }
        }

        meshFilter.mesh = meshBuilder.CreateMesh(true, true);
    }
}
