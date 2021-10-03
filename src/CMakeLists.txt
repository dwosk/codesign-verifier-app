set(PRETTY_APP_NAME "Codesign Verifier")

add_executable(codesign-verifier-app MACOSX_BUNDLE)

target_sources(codesign-verifier-app PRIVATE
    Views/ContentView.swift
    Views/MainView.swift)

set_target_properties(codesign-verifier-app PROPERTIES
    OUTPUT_NAME                                         "${PRETTY_APP_NAME}"
    XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_APPICON_NAME  AppIcon
    XCODE_ATTRIBUTE_SWIFT_OPTIMIZATION_LEVEL            "$<IF:$<CONFIG:Debug>,-Onone,-O>")

set(RESOURCE_FILES
    Resources/Assets.xcassets)

target_sources(codesign-verifier-app PRIVATE ${RESOURCE_FILES})
set_source_files_properties(${RESOURCE_FILES} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
