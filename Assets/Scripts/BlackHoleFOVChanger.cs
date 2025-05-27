using UnityEngine;

public class BlackHoleFOVChanger : MonoBehaviour
{
    Transform camera;

    private void Start()
    {
        camera = Camera.main.transform;
    }

    public float maxDistance;

    private void Update()
    {
        float distance = Vector3.Distance(camera.position, transform.position);
        if (distance <= maxDistance)
        {
            float strenght = Vector3.Dot(camera.forward, transform.position - camera.position);
            float fov = Mathf.Log(distance / maxDistance) * 180 * (strenght/2);
            Debug.Log(fov);
            Camera.main.fieldOfView = Mathf.Clamp(fov, 10, 170);
        }
    }
}
