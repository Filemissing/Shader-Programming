Shader "Unlit/Galaxy Sea"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Noise ("Noise Heightmap", 2D) = "white" {}
        _ScrollSpeed ("ScrollSpeed", Vector) = (1, 1, 0, 0)
        _HeightIntensity ("Heightmap Intensity", float) = 1
        _ColorIntensity ("Color Intensity", float) = 3
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
            sampler2D _Noise;
            float2 ScrollSpeed;
            float _HeightIntensity;
            float _ColorIntensity;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 scrolledUV : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.scrolledUV = v.uv + float2(.1, .1) * _Time.y;

                float4 noiseSample = tex2Dlod(_Noise, float4(o.scrolledUV, 0, 0));
                float heightOffset = noiseSample.r * _HeightIntensity;

                float4 worldSpacePos = mul(unity_ObjectToWorld, v.vertex);
                worldSpacePos.y += heightOffset;
                float4 newPos = mul(unity_WorldToObject, worldSpacePos);

                o.vertex = UnityObjectToClipPos(newPos);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv) * _ColorIntensity;
                return col;
            }
            ENDCG
        }
    }
}
