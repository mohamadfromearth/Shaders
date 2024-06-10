Shader "Unlit/Lighting"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float3 normal:NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal:TEXTCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            Interpolators vert(MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag(Interpolators i) : SV_Target
            {
                float3 N = i.normal;
                float3 L = _WorldSpaceLightPos0.xyz;


                float3 diffuseLight = saturate(dot(N, L)) * _LightColor0.xyz;

                return float4(diffuseLight, 1);
            }
            ENDCG
        }
    }
}