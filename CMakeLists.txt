cmake_minimum_required(VERSION 3.1)

project(DxEffectsParser)


if(WIN32)

    add_custom_command(OUTPUT ${PROJECT_SOURCE_DIR}/src/Gen_dxEffect.c
    COMMAND ${PROJECT_SOURCE_DIR}/tools/flex.exe ${PROJECT_SOURCE_DIR}/src/dxeffect.l
    MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/src/dxeffect.l
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/src/
    COMMENT "Executing flex on dxeffect.l"
    )
    
    add_custom_command(OUTPUT ${PROJECT_SOURCE_DIR}/src/Gen_dxeffect_tab.c
    COMMAND bison.exe -d -t -v ${PROJECT_SOURCE_DIR}/src/dxeffect.y
    COMMAND move /y dxeffect.tab.h ${PROJECT_SOURCE_DIR}/src/dxeffect_tab.h
    COMMAND move /y dxeffect.tab.c ${PROJECT_SOURCE_DIR}/src/Gen_dxeffect_tab.c
    MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/src/dxeffect.y
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/tools/bin/
    COMMENT "Executing Bison on dxeffect.y"
    )
    
    add_custom_target(parser ALL
    DEPENDS ${PROJECT_SOURCE_DIR}/src/Gen_dxEffect.c ${PROJECT_SOURCE_DIR}/src/Gen_dxeffect_tab.c
    )
    
    set_source_files_properties(${PROJECT_SOURCE_DIR}/src/Gen_dxEffect.cpp PROPERTIES GENERATED 1)
    set_source_files_properties(${PROJECT_SOURCE_DIR}/src/Gen_dxeffect_tab.cpp PROPERTIES GENERATED 1)
endif(WIN32)


add_executable(parsertest
${PROJECT_SOURCE_DIR}/src/Gen_dxEffect.c
${PROJECT_SOURCE_DIR}/src/Gen_dxeffect_tab.c
)