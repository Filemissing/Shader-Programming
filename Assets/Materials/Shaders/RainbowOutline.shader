Shader "Unlit/RainbowOutline"
{
    Properties
    {
        _Active ("Active", int) = 0
    }
    SubShader
    {
        Tags { "RenderPipeline"="UniversalRenderPipeline" }
        Pass
        {
            Name "FullscreenPass"
            ZTest Always 
            Cull Off 
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            int _Active;
            sampler2D _BlitTexture;
            sampler2D _CameraNormalsTexture;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_BlitTexture, i.uv);

                float greyScale = (0.299 * col.r) + (0.587 * col.g) + (0.114 * col.b);

                float3 normal = tex2D(_CameraNormalsTexture, i.uv).rgb;

                return col;
            }
            ENDCG
        }
    }
}
