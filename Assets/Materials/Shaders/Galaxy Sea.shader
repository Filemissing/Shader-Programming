Shader "Unlit/Galaxy Sea"
{
    Properties
    {
        _Color ("Color", Color) = (0.0, 0.5, 0.8, 1.0)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Speed ("Speed", Float) = 1.0
        _WavesNum ("Number of Waves", float) = 4.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Properties
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float _Speed;
            float _Gravity = 9.8;
            float _WavesNum;

            // Wave settings (adjust NUM_WAVES for more detail)
            float4 _WaveData[16]; // (dirX, dirZ, wavelength, steepness)

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            // Gerstner Wave Function
            float3 GerstnerWave(float3 worldPos, float2 direction, float wavelength, float steepness, float time)
            {
                float k = 2.0 * UNITY_PI / wavelength;  // Wave number
                float c = sqrt(_Gravity / k);           // Wave speed
                float a = steepness / k;                // Amplitude

                // Compute phase, moving in wave direction over time
                float phase = k * (dot(worldPos.xz, direction) - time * _Speed);

                // Apply displacement
                float3 displacedPos = worldPos;
                displacedPos.x += direction.x * a * cos(phase);
                displacedPos.z += direction.y * a * cos(phase);
                displacedPos.y += a * sin(phase);

                return displacedPos;
            }

            // Vertex Shader
            v2f vert (appdata v)
            {
                v2f o;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                // Apply multiple waves
                for (int i = 0; i < _WavesNum; i++)
                {
                    float2 dir = normalize(_WaveData[i].xy);
                    float wavelength = _WaveData[i].z;
                    float steepness = _WaveData[i].w;

                    worldPos = GerstnerWave(worldPos, dir, wavelength, steepness, _Time.y);
                }

                // Transform back to object space
                float3 newObjectPos = mul(unity_WorldToObject, float4(worldPos, 1.0));
                o.vertex = UnityObjectToClipPos(newObjectPos);

                return o;
            }

            // Fragment Shader
            float4 frag (v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv);
            }
            ENDCG
        }
    }
}
