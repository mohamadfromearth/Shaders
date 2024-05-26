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
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

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
                float t = abs(frac(i.uv.x * 5) * 2 - 1);

                float4 outColor = lerp(_ColorA, _ColorB, t);
                return outColor;
            }
            ENDCG
        }
    }
}