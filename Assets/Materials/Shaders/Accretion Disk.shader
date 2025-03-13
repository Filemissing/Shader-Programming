Shader "Unlit/Accretion Disk"
{
    Properties
    {
        [HDR] _Color ("Color", Color) = (1, 1, 1, 1)
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _Cutoff ("Cutoff", Range(0, 1)) = .5 
        _Radius ("Radius", float) = 5
        _Speed ("Rotation Speed", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100

        Pass
        {
            Cull off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Properties
            float4 _Color;
            sampler2D _NoiseTex;
            float4 _NoiseTex_ST;
            float _Cutoff;
            float _Radius;
            float _Speed;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1));
                o.uv = TRANSFORM_TEX(v.uv, _NoiseTex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;

                float Cos = cos(_Time.y * _Speed);
                float Sin = sin(_Time.y * _Speed);

                uv -= .5;
                uv = float2(uv.x * Cos - uv.y * Sin, uv.y * Cos + uv.x * Sin);
                uv += .5;

                float4 center = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));
                float distanceFromCenter = distance(center, i.worldPos);
                clip(_Radius - distanceFromCenter);

                float4 col = float4(1, 0, 1, 1);

                float4 texColor = tex2D(_NoiseTex, uv);

                clip(texColor.r - _Cutoff);

                return texColor * _Color;
            }
            ENDCG
        }
    }
}
