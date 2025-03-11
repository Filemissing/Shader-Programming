Shader "Unlit/Black Hole Normals"
{
    Properties
    {
        _EventHorizon ("Event Horizon", float) = 1.0
        _DistortionStrength ("Distortion Strength", float) = 0.1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Properties
            sampler2D _CameraOpaqueTexture;
            float _EventHorizon;
            float _DistortionStrength;

            float PI = 3.14159265358979323846264338327950288419716939937510;

            struct input
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float4 normal : NORMAL;
            };

            v2f vert (input IN)
            {
                v2f OUT;

                OUT.pos = UnityObjectToClipPos(IN.vertex);
                OUT.uv = IN.uv;
                OUT.worldPos = mul(unity_ObjectToWorld, IN.vertex).xyz; 

                OUT.normal = mul(unity_ObjectToWorld, IN.normal); 

                return OUT;
            }

            fixed4 frag (v2f IN) : SV_Target
            {   
                fixed4 color = fixed4(1, 1, 1, 1);

                float3 viewDirection = normalize(IN.worldPos - _WorldSpaceCameraPos);

                float angle = acos(dot(IN.normal, viewDirection) / (length(IN.normal) * length(viewDirection)));
                
                return float4(angle, angle, angle, 1);
            }
            ENDCG
        }
    }
}
