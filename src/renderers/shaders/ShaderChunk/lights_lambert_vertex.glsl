vec3 diffuse = vec3( 1.0 );

GeometricContext geometry = GeometricContext( mvPosition.xyz, normalize( transformedNormal ), normalize( -mvPosition.xyz ) );
GeometricContext backGeometry = GeometricContext( geometry.position, -geometry.normal, geometry.viewDir );

vLightFront = vec3( 0.0 );

#ifdef DOUBLE_SIDED
	vLightBack = vec3( 0.0 );
#endif

#if POINT_LIGHTS > 0

	for ( int i = 0; i < POINT_LIGHTS; i ++ ) {

		IncidentLight directLight = getPointDirectLight( pointLights[ i ], geometry );

		float dotNL = dot( geometry.normal, directLight.direction );
		vec3 directLightColor_Diffuse = PI * directLight.color;

		vLightFront += saturate( dotNL ) * directLightColor_Diffuse;

		#ifdef DOUBLE_SIDED

			vLightBack += saturate( -dotNL ) * directLightColor_Diffuse;

		#endif

	}

#endif

#if SPOT_LIGHTS > 0

	for ( int i = 0; i < SPOT_LIGHTS; i ++ ) {

		IncidentLight directLight = getSpotDirectLight( spotLights[ i ], geometry );

		float dotNL = dot( geometry.normal, directLight.direction );
		vec3 directLightColor_Diffuse = PI * directLight.color;

		vLightFront += saturate( dotNL ) * directLightColor_Diffuse;

		#ifdef DOUBLE_SIDED

			vLightBack += saturate( -dotNL ) * directLightColor_Diffuse;

		#endif
	}

#endif

#if DIR_LIGHTS > 0

	for ( int i = 0; i < DIR_LIGHTS; i ++ ) {

		IncidentLight directLight = getDirectionalDirectLight( directionalLights[ i ], geometry );

		float dotNL = dot( geometry.normal, directLight.direction );
		vec3 directLightColor_Diffuse = PI * directLight.color;

		vLightFront += saturate( dotNL ) * directLightColor_Diffuse;

		#ifdef DOUBLE_SIDED

			vLightBack += saturate( -dotNL ) * directLightColor_Diffuse;

		#endif

	}

#endif

	{

		vLightFront += PI * ambientLightColor;

		#ifdef DOUBLE_SIDED

			vLightBack += PI * ambientLightColor;

		#endif

		#if HEMI_LIGHTS > 0

			for ( int i = 0; i < HEMI_LIGHTS; i ++ ) {

				vLightFront += getHemisphereLightIrradiance( hemisphereLights[ i ], geometry );

				#ifdef DOUBLE_SIDED

					vLightBack += getHemisphereLightIrradiance( hemisphereLights[ i ], backGeometry );

				#endif

			}

		#endif

	}
