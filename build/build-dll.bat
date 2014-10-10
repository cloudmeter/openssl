IF [%DEBUG_SUFFIX%] == [d] (
SET OUT_DIR=out32dll.dbg
SET TMP_DIR=tmp32dll.dbg
) ELSE (
SET OUT_DIR=out32dll
SET TMP_DIR=tmp32dll
)

IF [%1] == [rebuild] (
@echo rebuild option specified, cleaning previous build output
rmdir /S /Q %OUT_DIR%
rmdir /S /Q %TMP_DIR%
) ELSE (
@echo no rebuild option specified
)

nmake -f ms\ntdll.mak
if %errorlevel% neq 0 goto fail

nmake -f ms\ntdll.mak test
if %errorlevel% neq 0 goto fail

nmake -f ms\ntdll.mak install
if %errorlevel% neq 0 goto fail

REM create output directories, if needed
IF EXIST %INC_DIR% GOTO copy
mkdir %INC_DIR%

IF EXIST %BIN_DIR% GOTO copy
mkdir %BIN_DIR%

:copy
xcopy /s /y %OUTPUT_PREFIX%\include %INC_DIR%\
xcopy /y %OUT_DIR%\libeay32.* %BIN_DIR%\libeay32%DEBUG_SUFFIX%.*
xcopy /y %OUT_DIR%\ssleay32.* %BIN_DIR%\ssleay32%DEBUG_SUFFIX%.*

goto end

:fail
echo Build FAILED
:end
