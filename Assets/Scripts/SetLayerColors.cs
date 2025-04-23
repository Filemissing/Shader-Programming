using System.Collections.Generic;
using UnityEngine;

public class SetLayerColors : MonoBehaviour
{
    public Mesh mesh;
    public Material material;

    public Color[] colors;
    public bool rainbowScroll;

    List<MeshRenderer> meshRenderers = new();
    private void Start()
    {
        while (transform.childCount < colors.Length)
        {
            GameObject newLayer = new GameObject($"Layer {transform.childCount}");
            newLayer.transform.parent = transform;
            newLayer.transform.position = transform.position;

            newLayer.AddComponent<MeshFilter>().sharedMesh = mesh;
            MeshRenderer renderer = newLayer.AddComponent<MeshRenderer>();
            renderer.sharedMaterial = material;
            meshRenderers.Add(renderer);

            newLayer.transform.localScale = new Vector3(10 + 10 * newLayer.transform.GetSiblingIndex(), 400, 10 + 10 * newLayer.transform.GetSiblingIndex());
        }
    }

    private void Update()
    {
        for (int i = 0; i < colors.Length; i++)
        {
            if (rainbowScroll)
            {
                // convert to hsv
                // increase hue
                // convert back to rgb
            }

            meshRenderers[i].material.color = colors[i];
        }
    }
}
