Shader "Unlit/GraphTexture"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1, 1, 1, 1)
        _LineColor ("Line Color", Color) = (1, 0, 0, 1)
        _Steps ("Steps", Range(1, 20000)) = 2000
        _Thickness ("Line thickness", float) = 0.01
        _Speed ("Speed", float) = .8
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
            float4 _BaseColor;
            float4 _LineColor;
            float _Steps;
            float _Thickness;
            float _Speed;

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float2 formula(float t, float v)
            {
                return float2((sin(20 * t) + 1) / 2, (sin(25 * t + v) + 1) / 2);
            }

            float calculateT(float x)
            {
                return 1/20 * asin(2*x - 1);
            }

            float calculateY(float t)
            {

            }

            float4 frag (v2f i) : SV_Target
            {
                float2 trange = float2(0, 2);

                int isOnLine = 0;

                // float stepSize = (trange.y - trange.x) / _Steps;

                // for (int j = 0; j < _Steps; j++) 
                // {
                //     float t = trange.x + j * stepSize;
                //     float2 result = formula(t, _Time.y * _Speed);

                //     float dist = distance(i.uv, result);
                //     if (dist < _Thickness) {
                //         isOnLine = 1;
                //         break;
                //     }
                // }

                float s = 2 * i.uv.x - 1;
                float angle1 = asin(s);
                float angle2 = 3.14159265 - angle1;

                float minDist = 1.0;
                
                for (int k = -5; k < 5; k++) 
                {
                    // calculate theta
                    float theta1 = angle1 + 2 * 3.14159265 * k;
                    float theta2 = angle2 + 2 * 3.14159265 * k;

                    // calculate t
                    float t1 = theta1 / 20;
                    float t2 = theta2 / 20;

                    // if t1 is in range
                    if (t1 >= 0 && t1 <= 2) 
                    {
                        float2 pt = formula(t1, _Time.y * _Speed);
                        float d = distance(i.uv, pt);
                        minDist = min(minDist, d);
                    }

                    // if t2 is in range
                    if (t2 >= 0 && t2 <= 2) 
                    {
                        float2 pt = formula(t2, _Time.y * _Speed);
                        float d = distance(i.uv, pt);
                        minDist = min(minDist, d);
                    }
                }

                float alpha = smoothstep(_Thickness, 0.0, minDist); // faloff alpha based on distance
                return lerp(_BaseColor, _LineColor, alpha);

                float4 col = lerp(_BaseColor, _LineColor, isOnLine);

                return col;
            }
            ENDCG
        }
    }
}
