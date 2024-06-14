Shader "Unlit/Lighting"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Gloss("Gloss",Float) = 1
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
                float3 wPos:TEXTCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _Gloss;

            Interpolators vert(MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag(Interpolators i) : SV_Target
            {
                // float3 diffuseLight = saturate(dot(N, L)) * _LightColor0.xyz;

                // specular lighting

                // float3 R = reflect(-L, N);
                // float H = normalize(L + V);
                //
                // float3 specularLight = saturate(dot(H, N));
                //
                //
                // specularLight = pow(specularLight, _Gloss);

                float3 N = normalize(i.normal);
                float3 V = normalize(_WorldSpaceCameraPos - i.wPos);


                float3 fresnel = (1 - dot(V, N) * cos(_Time.y * 4)) * 0.5f + 0.5f;


                return float4(fresnel.xxx, 1);
            }
            ENDCG
        }
    }
}