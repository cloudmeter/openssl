IF [%DEBUG_SUFFIX%] == [d] (
SET OUT_DIR=out32.dbg
SET TMP_DIR=tmp32.dbg
) ELSE (
SET OUT_DIR=out32
SET TMP_DIR=tmp32
)

IF [%1] == [rebuild] (
@echo rebuild option specified, cleaning previous build output
rmdir /S /Q %OUT_DIR%
rmdir /S /Q %TMP_DIR%
) ELSE (
@echo no rebuild option specified
)

nmake -f ms\nt.mak
if %errorlevel% neq 0 goto fail

nmake -f ms\nt.mak test
if %errorlevel% neq 0 goto fail

nmake -f ms\nt.mak install
if %errorlevel% neq 0 goto fail

REM create output directories, if needed
IF EXIST %INC_DIR% GOTO copy
mkdir %INC_DIR%

IF EXIST %LIB_DIR% GOTO copy
mkdir %LIB_DIR%

:copy
xcopy /s /y %OUTPUT_PREFIX%\include %INC_DIR%\
xcopy /y %OUT_DIR%\libeay32.* %LIB_DIR%\libeay32%DEBUG_SUFFIX%.*
xcopy /y %OUT_DIR%\ssleay32.* %LIB_DIR%\ssleay32%DEBUG_SUFFIX%.*

goto end

:fail
echo Build FAILED
:end
