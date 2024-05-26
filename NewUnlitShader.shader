Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _Color("Color",Color) = (0,0,0,1)
        _Scale("UV Scale",Float) = 1
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

            float4 _Color;
            float _Scale;

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

            Interpolators vert(MeshData v)
            {
                Interpolators o;
                o.normal = v.normal;
                o.uv = v.uv * _Scale;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(Interpolators i) : SV_Target
            {
                return float4(i.uv,0, 1);
            }
            ENDCG
        }
    }
}