cmake_minimum_required(VERSION 3.10)
set(
    HUNTER_CACHE_SERVERS
    "https://github.com/CHChang810716/hunter-binary-cache"
    CACHE
    STRING
    "Default cache server"
)
include(cmake/HunterGate.cmake)
HunterGate(
    URL "ssh://git@gitlab.centrilliontech.com.tw:10022/centrillion/hunter.git"
    SHA1 "2a2b6713b9b38395240c2b1e1ea08d16fff51e76"
    FILEPATH ${CMAKE_CURRENT_LIST_DIR}/cmake/packages.cmake
)
project (cvplot)
set(${PROJECT_NAME}_VERSION 0.0.3)
hunter_add_package(OpenCV)
find_package(OpenCV CONFIG REQUIRED)

# include_directories(include)
# include_directories(${OpenCV_INCLUDE_DIRS})

hunter_add_package(GTest)
find_package(GTest CONFIG REQUIRED)

set(CMAKE_CXX_STANDARD 11)
set(CVPLOT_LIB cvplot)
# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/bin")

if (DEFINED CVPLOT_LIB)
  file(GLOB LIB_SOURCES "${PROJECT_SOURCE_DIR}/src/cvplot/*.cc")
  add_library(${CVPLOT_LIB} ${LIB_SOURCES})
  target_include_directories(${CVPLOT_LIB} PUBLIC 
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
  )
  target_link_libraries(${CVPLOT_LIB} PUBLIC ${OpenCV_LIBS})
endif()

if (${CVPLOT_DEMO})
  file(GLOB BIN_SOURCES "${PROJECT_SOURCE_DIR}/src/demo/*.cc")
  foreach(filename ${BIN_SOURCES})
    get_filename_component(name ${filename} NAME_WE)
    add_executable(${name} ${filename})
    target_link_libraries(${name} ${CVPLOT_LIB} ${OpenCV_LIBS})
  endforeach()
endif()

if (${CVPLOT_TEST})
  file(GLOB TEST_SOURCES "${PROJECT_SOURCE_DIR}/test/cvplot/*_test.cc")
  foreach(filename ${TEST_SOURCES})
    get_filename_component(name ${filename} NAME_WE)
    add_executable(${name} ${filename})
    target_link_libraries(${name} ${CVPLOT_LIB} ${OpenCV_LIBS} GTest::gtest GTest::main)
  endforeach()
endif()

include(CMakePackageConfigHelpers)
set(PROJECT_VERSION     "${${PROJECT_NAME}_VERSION}")
set(generated_dir       "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(config_install_dir  "lib/cmake/${PROJECT_NAME}")
set(version_config      "${generated_dir}/${PROJECT_NAME}ConfigVersion.cmake")
set(project_config      "${generated_dir}/${PROJECT_NAME}Config.cmake")
set(targets_export_name "${PROJECT_NAME}Targets")
set(namespace           "${PROJECT_NAME}::")
include(GNUInstallDirs)
write_basic_package_version_file(
    "${version_config}" COMPATIBILITY SameMajorVersion
)

configure_package_config_file(
    "cmake/Config.cmake.in"
    "${project_config}"
    INSTALL_DESTINATION "${config_install_dir}"
)
install(TARGETS ${CVPLOT_LIB} 
    EXPORT "${targets_export_name}"
    BUNDLE DESTINATION . COMPONENT Runtime
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT Runtime
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT Library
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT Library
)
install(
    DIRECTORY include
    DESTINATION ${CMAKE_INSTALL_PREFIX} COMPONENT Headers
)
install(
    FILES       "${project_config}" "${version_config}"
    DESTINATION "${config_install_dir}"
)

install(
    EXPORT      "${targets_export_name}"
    NAMESPACE   "${namespace}"
    DESTINATION "${config_install_dir}"
)