# MIT License
#
# Copyright (c) 2019 Vladimir Berlev

set(DD_CMAKELIST "${CMAKE_CURRENT_LIST_DIR}/Dependency-CMakeLists.txt.in")

function(download_dependency DD_NAME)
    set(DD_PROJECT_NAME "${DD_NAME}-download")
    set(DD_PROJECT_DIR "${CMAKE_CURRENT_BINARY_DIR}/${DD_PROJECT_NAME}")

    cmake_parse_arguments(DD "" "URL;HASH;BUILD_SCRIPT" "" ${ARGN})
    if (NOT DEFINED DD_URL)
        message(FATAL_ERROR "URL is required")
    endif()
    if (NOT DEFINED DD_HASH)
        message(FATAL_ERROR "Hash is required")
    endif()

    # Prepare download project CMakeLists.txt file
    configure_file("${DD_CMAKELIST}" "${DD_PROJECT_DIR}/CMakeLists.txt" @ONLY)

    # Download project generate step
    execute_process(
        COMMAND "${CMAKE_COMMAND}" -G "${CMAKE_GENERATOR}" .
        WORKING_DIRECTORY "${DD_PROJECT_DIR}"
        RESULT_VARIABLE RESULT
    )
    if (RESULT)
        message(FATAL_ERROR "Generate step for ${DD_PROJECT_DIR} failed")
    endif()

    # Download project build step
    execute_process(
        COMMAND "${CMAKE_COMMAND}" --build .
        WORKING_DIRECTORY "${DD_PROJECT_DIR}"
        RESULT_VARIABLE RESULT
    )
    if (RESULT)
        message(FATAL_ERROR "Build step for ${DD_PROJECT_DIR} failed")
    endif()

    if (DEFINED DD_BUILD_SCRIPT)
        file(COPY "${DD_BUILD_SCRIPT}" DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/${DD_NAME}")
    endif()

    add_subdirectory("${CMAKE_CURRENT_BINARY_DIR}/${DD_NAME}")
endfunction()
