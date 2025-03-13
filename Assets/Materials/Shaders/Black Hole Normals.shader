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
            Cull off

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
                OUT.worldPos = mul(unity_ObjectToWorld, IN.vertex); 

                OUT.normal = normalize(mul(unity_ObjectToWorld, float4(IN.normal.xyz,0))); // no translation, but scaling is still applied! (so normalize!)

                // w=1: apply translation (use for position vectors)
                // w=0: don't apply translation (use for direction vectors)

                return OUT;
            }

            fixed4 frag (v2f IN) : SV_Target
            {
                float3 viewDirection = normalize(_WorldSpaceCameraPos - IN.worldPos);

                float dt = dot(viewDirection, IN.normal.xyz); // from 0 to 1: 1 if pointed at cam, 0 at "grazing angle"

                float angle = acos(dt / (length(IN.normal) * length(viewDirection)));

                float distanceFromEventHorizon = angle - _EventHorizon;

                if(distanceFromEventHorizon <= 0) return float4 (0, 0, 0, 1);

                float distortion = pow(1 - distanceFromEventHorizon, _DistortionStrength);

                float2 distortedUV = frac(IN.uv - distortion);

                return tex2D(_CameraOpaqueTexture, distortedUV);
            }
            ENDCG
        }
    }
}
