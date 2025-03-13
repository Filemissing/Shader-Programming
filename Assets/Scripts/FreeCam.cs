using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class FreeCam : MonoBehaviour
{
    Rigidbody rb;
    private void Awake()
    {
        rb = GetComponent<Rigidbody>();
        Cursor.lockState = CursorLockMode.Locked;
    }

    public float baseSpeed;
    public float fastSpeed;
    float speed;
    public float mouseSensitivity;

    void Update()
    {
        speed = Input.GetKey(KeyCode.LeftShift) ? fastSpeed : baseSpeed;

        float forward = Input.GetAxisRaw("Forward-Backward");
        float right = Input.GetAxisRaw("Left-Right");
        float up = Input.GetAxisRaw("Up-Down");

        rb.linearVelocity = speed * (transform.right * right + transform.up * up + transform.forward * forward);

        float mouseX = Input.GetAxisRaw("Mouse X");
        float mouseY = Input.GetAxisRaw("Mouse Y");

        transform.rotation = Quaternion.Euler(transform.eulerAngles.x + (-mouseY * mouseSensitivity), transform.eulerAngles.y + (mouseX * mouseSensitivity), transform.eulerAngles.z);
    }
}
