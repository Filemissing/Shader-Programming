Shader "Unlit/1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Offset ("Offset", float) = 0
        _DissolveTexture ("Dissolve Texture", 2D) = "Noise" {}
        _DissolveCutoff ("Dissolve Cutoff", float) = 0
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

            //Properties
            sampler2D _MainTex;
            float4 _Color;
            float _Offset;
            sampler2D _DissolveTexture;
            float _DissolveCutoff;

            struct input
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 normal : NORMAL;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(input IN)
            {
                v2f OUT;
                
                OUT.position = UnityObjectToClipPos(IN.vertex + IN.normal * _Offset);
                OUT.uv = IN.uv;

                return OUT;
            }

            fixed4 frag(v2f IN) : SV_TARGET
            {
                float4 texColor = tex2D(_MainTex, IN.uv);

                float4 dissolveColor = tex2D(_DissolveTexture, IN.uv);
                clip(dissolveColor.rgb - _DissolveCutoff);
                
                return texColor * _Color;
            }


            ENDCG
        }
    }
}
