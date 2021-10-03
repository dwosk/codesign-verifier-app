cmake_minimum_required(VERSION 3.21)

include(CheckLanguage)

set(CMAKE_XCODE_GENERATE_TOP_LEVEL_PROJECT_ONLY ON)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

project(codesign-verifier
    VERSION 0.1.0
    LANGUAGES Swift)

check_language(Swift)
if (CMAKE_Swift_COMPILER AND CMAKE_GENERATOR STREQUAL Xcode)
    set(CMAKE_Swift_LANGUAGE_VERSION 5.0)
    add_subdirectory(src)
else ()
    message(FATAL_ERROR "Must use Xcode generator")
endif ()
