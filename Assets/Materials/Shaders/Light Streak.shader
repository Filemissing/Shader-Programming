Shader "Unlit/Light Streak"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Thickness ("Line Thickness", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        Cull Off
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            float4 _Color;
            float _Thickness;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv  = v.uv;
                return o;
            }

            float formula(float x)
            {
                return sin(x) + 1;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float distance = abs(formula(i.uv.y) - frac(i.uv.x)) - _Thickness;
                distance = saturate(distance);

                float4 col = smoothstep(float4(1, 1, 1, 1), float4(0, 0, 0, 0), distance);

                return col;
            }
            ENDCG
        }
    }
}
