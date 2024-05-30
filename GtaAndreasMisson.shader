Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _ColorA("Color A",Color) = (0,0,0,1)
        _ColorB("Color B",Color) = (0,1,0,1)
        _ColorStart("Color start",Range(0,1)) = 0
        _ColorEnd("Color end",Range(0,1)) = 1

    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue" = "Transparent"
        }
        LOD 100

        Pass
        {
            Blend One One
            ZWrite Off
            Cull Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #define TAU 6.28318550178

            #include "UnityCG.cginc"

            float4 _ColorA;
            float4 _ColorB;

            float _ColorStart;
            float _ColorEnd;


            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal: NORMAL;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float3 normal:TEXCOORD0;
                float2 uv:TEXTCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float InverseLerp(float a, float b, float v)
            {
                return (v - a) / (b - a);
            }

            Interpolators vert(MeshData v)
            {
                Interpolators o;
                o.normal = v.normal;
                o.uv = v.uv;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(Interpolators i) : SV_Target
            {
                //  float t = abs(frac(i.uv.x * 5) * 2 - 1);
                float offset = cos(i.uv.x * TAU * 8) * 0.1;
                float t = cos((i.uv.y + 0 - _Time.y / 2) * TAU * 5) * 0.5 + 0.5;
                t *= 1 - i.uv.y;

                float topBottomRemover = (abs(i.normal.y) < 0.999);
                float waves =t *  topBottomRemover;

                float4 gradiant = lerp(_ColorA,_ColorB,i.uv.y);

                return gradiant * waves;
                
                //return t * (abs(i.normal.y) < 0.999);
            }
            ENDCG
        }
    }
}