Shader "Custom/Crystal"
{
    Properties
    {
        [HDR] _Color ("Color", Color) = (1,1,1,1)
        _SubtractionModifier ("Subtraction Modifier", float) = 1.0
        _MultiplicationModifier ("Multiplication Modifier", float) = 3.0
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
            float4 _Color;
            float _SubtractionModifier;
            float _MultiplicationModifier;
    
            struct appdata
            {
                float3 position : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
    
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata IN)
            {
                v2f OUT;

                OUT.vertex = UnityObjectToClipPos(IN.position);
                OUT.worldPos = mul(unity_ObjectToWorld, IN.position);
                OUT.normal = IN.normal;
                OUT.uv = IN.uv;

                return OUT;
            }

            float4 frag(v2f IN) : SV_TARGET
            {
                // Get world space view direction (camera to fragment)
                float3 viewDir = normalize(IN.worldPos - _WorldSpaceCameraPos);

                // Compute cross product
                float3 crossProduct = dot(IN.normal, viewDir);

                // Compute length of cross product
                float intensity = pow(2, (length(crossProduct) - _SubtractionModifier) * _MultiplicationModifier);

                float4 c = float4(_Color.rgb * intensity, _Color.a);

                return c;
            }

            ENDCG
        }
    }
}
