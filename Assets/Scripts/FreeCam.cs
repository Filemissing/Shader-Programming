using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class FreeCam : MonoBehaviour
{
    Rigidbody rb;
    private void Awake()
    {
        rb = GetComponent<Rigidbody>();
    }

    public float baseSpeed;
    public float fastSpeed;
    float speed;

    void Update()
    {
        speed = (Input.GetKey(KeyCode.LeftShift)) ? fastSpeed : baseSpeed;

        float forward = Input.GetAxisRaw("Forward-Backward");
        float right = Input.GetAxisRaw("Left-Right");
        float up = Input.GetAxisRaw("Up-Down");

        rb.linearVelocity = speed * new Vector3(right, up, forward);
    }
}
