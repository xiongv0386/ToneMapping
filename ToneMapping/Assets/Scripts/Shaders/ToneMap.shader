Shader "Unlit/ToneMap.shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass     //first pass
        {
            CGPROGRAM
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct appdata members exposure)
#pragma exclude_renderers d3d11
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata  //uniforms/pass ins to the vertex shader
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                //float3 normal : NORMAL;   //may need to change this
                float exposure = 1;
            };

            struct v2f     //pass from vertex to fragment shader  "outs" in openGL
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION; //like GL_POSTION

            };

            ////declare uniforms and needed ins before shaders
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)    //vertex shader
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //float3 normal =  UnityObjectToWorldNormal(/*multiplies by normal matrix*/)
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target     //fragment shader
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
