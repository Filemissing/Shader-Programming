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

                OUT.normal = mul(unity_ObjectToWorld, IN.normal); // probably wrong: I'm pretty sure it should be in world space

                return OUT;
            }

            fixed4 frag (v2f IN) : SV_Target
            {   
                fixed4 color = fixed4(1, 1, 1, 1);

                float2 centerScreenPos = UnityObjectToClipPos(float3(0, 0, 0)); // ?

                //return float4(centerScreenPos.xy,0,1);

                float distanceToEventHorizon = distance(centerScreenPos, IN.uv) - _EventHorizon;

                // Calculate distortion amount
                float2 distortion = (IN.screenUV - 0.5) * (_DistortionStrength * (1.0 - distanceToEventHorizon));

                // Apply distortion to screen UVs
                float2 distortedUV = IN.screenUV + distortion;

                // Sample the background texture
                fixed4 col = tex2D(_CameraOpaqueTexture, distortedUV);

                if(distanceToEventHorizon <= 0) col = fixed4(0, 0, 0, 1);

                
                return col;
            }
            ENDCG
        }
    }
}
