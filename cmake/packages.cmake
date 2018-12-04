if( MINGW )
    hunter_config(
        OpenCV
        VERSION ${HUNTER_OpenCV_VERSION}
        CMAKE_ARGS 
            BUILD_SHARED_LIBS=OFF
            ENABLE_PRECOMPILED_HEADERS=OFF
    )
else()
    hunter_config(
        OpenCV
        VERSION ${HUNTER_OpenCV_VERSION}
        CMAKE_ARGS BUILD_SHARED_LIBS=OFF
    )
endif()