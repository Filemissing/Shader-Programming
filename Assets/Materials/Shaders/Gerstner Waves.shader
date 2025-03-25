Shader "Custom/Gerstner Waves"
{
    Properties
    {
        _Color ("Color", Color) = (0.0, 0.5, 0.8, 1.0)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Wavelength ("Wavelength", Float) = 10.0
        _Steepness ("Steepness", Range(0, 1)) = 0.5
        _Speed ("Speed", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        CGPROGRAM
        // Use the standard surface shader with lighting and a custom vertex function.
        #pragma surface surf Standard fullforwardshadows vertex:vert
        
        #include "UnityCG.cginc"
        
        sampler2D _MainTex;
        fixed4 _Color;
        float _Wavelength;
        float _Steepness;
        float _Speed;
        float _Gravity = 9.8;
        
        struct Input
        {
            float2 uv_MainTex;
        };
        
        // Vertex function that applies Gerstner wave displacement in world space.
        void vert (inout appdata_full v)
        {
            float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
    
            float k = 2.0 * UNITY_PI / _Wavelength;
            float c = sqrt(_Gravity / k);
            float a = _Steepness / k;

            // Compute phase at current vertex position
            float phase = k * (worldPos.x - c * _Time.y * _Speed);
    
            // Apply Gerstner displacement
            float3 displacedPos = worldPos;
            displacedPos.x += a * cos(phase);
            displacedPos.y += a * sin(phase);

            // Transform back to object space
            v.vertex = mul(unity_WorldToObject, float4(displacedPos, 1.0));
        }

        
        // Surface function to sample texture and apply lighting.
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Metallic = 0.0;
            o.Smoothness = 0.8;
            o.Alpha = c.a;
        }
        ENDCG
    }
}
