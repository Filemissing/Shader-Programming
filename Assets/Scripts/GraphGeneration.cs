using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;

[RequireComponent (typeof(MeshRenderer))]
public class GraphGeneration : MonoBehaviour
{
    MeshRenderer meshRenderer;
    Material material;
    private void Awake()
    {
        meshRenderer = GetComponent<MeshRenderer>();
        material = meshRenderer.material;
    }

    //public int Steps;
    //public float Thickness;

    public Vector2Int size;
    public Color baseColor;
    public Color lineColor;
    public float lineThickness;
    public float animationValue;
    private void Start()
    {
        Texture2D texture = GenerateTexture(size);

        material.mainTexture = texture;
    }

    Texture2D GenerateTexture(Vector2Int size)
    {
        Texture2D texture = new Texture2D(size.x, size.y);

        Color[,] pixels = new Color[size.x, size.y];
        //texture.GetPixels().CopyTo(pixels, 0);

        for (int x = 0; x < size.x; x++)
        {
            for (int y = 0; y < size.y; y++)
            {
                Vector2 uv = new Vector2((float)x / (float)size.x, (float)y / (float)size.y);

                Vector2 trange = new Vector2(0, 2);

                //bool isOnLine = false;
                //float stepSize = (trange.y - trange.x) / Steps;
                //for (int j = 0; j < Steps; j++)
                //{
                //    float t = trange.x + j * stepSize;
                //    float2 result = Formula(t, animationValue);

                //    float dist = Vector2.Distance(uv, result);
                //    if (dist < Thickness)
                //    {
                //        isOnLine = true;
                //        break;
                //    }
                //}

                //if (isOnLine) pixels[x, y] = lineColor;

                float s = 2 * uv.x - 1;
                float angle1 = Mathf.Asin(s);
                float angle2 = Mathf.PI - angle1;

                float minDist = 1;

                for (int k = -5; k < 5; k++)
                {
                    // calculate theta
                    float theta1 = angle1 + 2 * Mathf.PI * k;
                    float theta2 = angle2 + 2 * Mathf.PI * k;

                    // calculate t
                    float t1 = theta1 / 20;
                    float t2 = theta2 / 20;

                    // if t1 is in range
                    if (t1 >= 0 && t1 <= 2)
                    {
                        Vector2 pt = Formula(t1, animationValue);
                        float d = Vector2.Distance(uv, pt);
                        minDist = Mathf.Min(minDist, d);
                    }

                    // if t2 is in range
                    if (t2 >= 0 && t2 <= 2)
                    {
                        Vector2 pt = Formula(t2, animationValue);
                        float d = Vector2.Distance(uv, pt);
                        minDist = Mathf.Min(minDist, d);
                    }
                }

                float alpha = SmoothStep(lineThickness, 0, minDist); // faloff alpha based on distance
                pixels[x, y] = Color.Lerp(baseColor, lineColor, alpha);
            }
        }

        //flatten list
        Color[] finalPixles = new Color[size.x * size.y];
        int i = 0;
        foreach(Color pixel in pixels)
        {
            finalPixles[i] = pixel;
            i++;
        }

        texture.SetPixels(finalPixles);

        texture.Apply();

        return texture;
    }

    public static float SmoothStep(float edge0, float edge1, float x)
    {
        // Scale, bias and saturate x to 0..1 range
        x = Mathf.Clamp01((x - edge0) / (edge1 - edge0));
        // Evaluate polynomial
        return x * x * (3 - 2 * x);
    }

    Vector2 Formula(float t, float v)
    {
        return new Vector2((Mathf.Sin(20 * t) + 1) / 2, (Mathf.Sin(25 * t + v) + 1) / 2);
    }
}
