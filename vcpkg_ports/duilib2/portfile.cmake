include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO winsoft666/duilib2
    REF 6b967ccba728ff579c0d9d0e0189ab69d0984794
    SHA512 b751dabfba34e9ed08ca06149c37774e704129df9dbff04a1e5efdfdc50e66db6c3a12c3e7ff0c42d417ee73180b29b3ad7cccbe82cd3ae3cd768f8dba1a66ca 
    HEAD_REF master
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" UILIB_STATIC)

set(UILIB_WITH_CEF OFF)
if("cef" IN_LIST FEATURES)
    set(UILIB_WITH_CEF ON)
	message(STATUS "UILIB_WITH_CEF=ON")
endif()


vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DBUILD_TESTS=OFF
		-DUILIB_STATIC=${UILIB_STATIC}
		-DUILIB_WITH_CEF=${UILIB_WITH_CEF}
)

vcpkg_install_cmake()

if(EXISTS ${CURRENT_PACKAGES_DIR}/lib/cmake/duilib2)
    vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/duilib2)
elseif(EXISTS ${CURRENT_PACKAGES_DIR}/share/duilib2)
    vcpkg_fixup_cmake_targets(CONFIG_PATH share/duilib2)
endif()

file(READ ${CURRENT_PACKAGES_DIR}/include/duilib2/UIlibExport.h UILIB_H)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    string(REPLACE "#ifdef UILIB_STATIC" "#if 1" UILIB_H "${UILIB_H}")
else()
    string(REPLACE "#ifdef UILIB_STATIC" "#if 0" UILIB_H "${UILIB_H}")
endif()
file(WRITE ${CURRENT_PACKAGES_DIR}/include/duilib2/UIlibExport.h "${UILIB_H}")

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/duilib2 RENAME copyright)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

vcpkg_copy_pdbs()