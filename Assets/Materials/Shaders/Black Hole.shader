Shader "Unlit/Black Hole"
{
    Properties
    {
        _EventHorizon ("Event Horizon", float) = 1.0
        _DistortionStrength ("Distortion Strength", float) = 0.1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        GrabPass { }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Properties
            sampler2D _GrabTexture;
            float _EventHorizon;
            float _DistortionStrength;

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
                float2 screenUV : TEXCOORD2;
                float4 normal : NORMAL;
            };

            v2f vert (input IN)
            {
                v2f OUT;

                OUT.pos = UnityObjectToClipPos(IN.vertex);
                OUT.uv = IN.uv;
                OUT.worldPos = mul(unity_ObjectToWorld, IN.vertex).xyz; 
                
                float4 screenPos = ComputeScreenPos(OUT.pos);
                OUT.screenUV = screenPos.xy / screenPos.w;

                OUT.normal = IN.normal;

                return OUT;
            }

            fixed4 frag (v2f IN) : SV_Target
            {   
                fixed4 color = fixed4(1, 1, 1, 1);

                float3 center = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));
                float distanceToCenter = distance(center, IN.worldPos.xyz);

                // Normalize distance
                float normalizedDist = saturate((distanceToCenter - _EventHorizon) / _EventHorizon);

                // Calculate distortion amount
                float2 distortion = (IN.screenUV - 0.5) * (_DistortionStrength * (1.0 - normalizedDist));

                // Apply distortion to screen UVs
                float2 distortedUV = IN.screenUV + distortion;

                // Sample the background texture
                fixed4 col = tex2D(_GrabTexture, distortedUV);

                if(distanceToCenter < _EventHorizon) col = fixed4(0, 0, 0, 1);

                
                return col;
            }
            ENDCG
        }
    }
}
