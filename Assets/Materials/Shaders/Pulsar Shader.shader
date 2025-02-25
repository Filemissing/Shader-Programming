Shader "Unlit/Pulsar Shader"
{
    Properties
    {

    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vertexFunction
            #pragma fragment fragmentFunction

            #include "UnityCG.cginc"


            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            void vertexFunction(appdata IN)
            {
                
            }

            void fragmentFunction()
            {

            }

            ENDCG
        }

    }
}
