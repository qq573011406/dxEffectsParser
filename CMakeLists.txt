cmake_minimum_required(VERSION 3.1)

project(DxEffectsParser)


if(WIN32)

    #$(YACC) -o parser.cc --defines=parser.h parser.yy
    add_custom_command(OUTPUT ${PROJECT_SOURCE_DIR}/src/parser.cc
    COMMAND ${PROJECT_SOURCE_DIR}/tools/bison.exe -o parser.cc --defines=parser.h ${PROJECT_SOURCE_DIR}/src/parser.yy
    COMMAND move /y parser.cc ${PROJECT_SOURCE_DIR}/src/parser.cc
    COMMAND move /y parser.h ${PROJECT_SOURCE_DIR}/src/parser.h
    MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/src/parser.yy
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/tools/
    COMMENT "Executing Bison on /parser.yy"
    )
    #$(LEX) -o scanner.cc scanner.ll
    add_custom_command(OUTPUT ${PROJECT_SOURCE_DIR}/src/scanner.cc
    COMMAND ${PROJECT_SOURCE_DIR}/tools/flex.exe -o scanner.cc ${PROJECT_SOURCE_DIR}/src/scanner.l
    COMMAND move /y scanner.cc ${PROJECT_SOURCE_DIR}/src/scanner.cc
    COMMAND move /y location.hh ${PROJECT_SOURCE_DIR}/src/location.hh
    COMMAND move /y position.hh ${PROJECT_SOURCE_DIR}/src/position.hh
    COMMAND move /y stack.hh ${PROJECT_SOURCE_DIR}/src/stack.hh
    MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/src/scanner.l
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/tools/
    COMMENT "Executing flex on scanner.l"
    )
    

    
    add_custom_target(flexAndBison ALL
    DEPENDS ${PROJECT_SOURCE_DIR}/src/parser.cc
    DEPENDS ${PROJECT_SOURCE_DIR}/src/scanner.cc
    )
    
    set_source_files_properties(${PROJECT_SOURCE_DIR}/src/scanner.cc PROPERTIES GENERATED 1)
    set_source_files_properties(${PROJECT_SOURCE_DIR}/src/parser.cc PROPERTIES GENERATED 1)
endif(WIN32)


add_library(fxParser
${PROJECT_SOURCE_DIR}/src/dxeffects.h
${PROJECT_SOURCE_DIR}/src/parser.cc
${PROJECT_SOURCE_DIR}/src/scanner.cc
${PROJECT_SOURCE_DIR}/src/driver.h
${PROJECT_SOURCE_DIR}/src/driver.cc
)
target_include_directories(fxParser PUBLIC ${PROJECT_SOURCE_DIR}/src/)

add_executable(fxParserTest ${PROJECT_SOURCE_DIR}/src/exprtest.cc)

target_link_libraries(fxParserTest fxParser)

