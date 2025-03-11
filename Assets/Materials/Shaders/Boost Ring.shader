Shader "Unlit/Boost Ring"
{
    Properties
    {
        [HDR] _StandardColor ("Standard Color", Color) = (1, 1, 1, 1)
        _EmissionMap ("Emission Map", 2D) = "white" {}
        [HDR] _EmissionColor ("Emission Color", Color) = (1, 1, 1, 1)
        _EmissionCutoff ("Emission Cutoff", Range(0, 1)) = .9
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4 _StandardColor;
            sampler2D _EmissionMap;
            float4 _EmissionColor;
            float _EmissionCutoff;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 col = _StandardColor;

                float4 emissionValue = tex2D(_EmissionMap, i.uv);

                if(emissionValue.r > _EmissionCutoff) col = _EmissionColor;

                return col;
            }
            ENDCG
        }
    }
}
