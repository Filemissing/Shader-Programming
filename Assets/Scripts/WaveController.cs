using UnityEngine;

public class WaveController : MonoBehaviour
{
    [SerializeField] MeshRenderer MeshRenderer;

    public Vector4[] waveData = new Vector4[]
    {
        new Vector4(1, 0, 10, 0.5f),   // Right-moving wave
        new Vector4(0, 1, 15, 0.3f),   // Forward-moving wave
        new Vector4(-1, 0, 20, 0.4f),  // Left-moving wave
        new Vector4(0, -1, 25, 0.2f)   // Backward-moving wave
    };
    void Awake()
    {
        Material mat = MeshRenderer.material;
        mat.SetFloat("_WavesNum", waveData.Length);
        mat.SetVectorArray("_WaveData", waveData);
    }
}
