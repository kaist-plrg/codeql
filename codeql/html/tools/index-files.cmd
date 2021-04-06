@echo off

type NUL && "%CODEQL_JAVA_HOME%\bin\java" ^
    -jar "%CODEQL_EXTRACTOR_HTML_ROOT%\tools\html-extractor.jar" ^
        --fileList="%1" ^
        --sourceArchiveDir="%CODEQL_EXTRACTOR_HTML_SOURCE_ARCHIVE_DIR%" ^
        --outputDir="%CODEQL_EXTRACTOR_HTML_TRAP_DIR%"

exit /b %ERRORLEVEL%
