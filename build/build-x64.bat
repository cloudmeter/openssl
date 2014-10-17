@echo off
REM Builds DLL and static lib versions of OpenSSL for 64 bit Windows
REM Usage: <openssl_root_dir>\>build\build-win32.bat [output-dir] [rebuild]
REM i.e. c:\openssl>build\build-x64.bat c:\openssl-1.0.1g
REM if no <output-dir> supplied, puts the build artefacts under c:\openssl-build directory

IF [%1] == [] (
ECHO command line argument missing, using c:\openssl-build as an output location
SET OPENSSL_DIR="c:\openssl-build"
) ELSE (
SET OPENSSL_DIR="%1"
ECHO Building OpenSSL in %OPENSSL_DIR%
)

SET OUTPUT_PREFIX=_win64
REM TODO: openlssl build script doesn't handle no-ssl2 and no-ssl3 defined simultaneously
REM so we just disable SSL3
SET OPENSSL_OPTIONS=no-ssl3
SET INC_DIR=%OPENSSL_DIR%\inc64
SET BIN_DIR=%OPENSSL_DIR%\bin\x64
SET LIB_DIR=%OPENSSL_DIR%\lib\x64

rmdir /S /Q %OUTPUT_PREFIX%
REM x64 Debug builds
perl Configure debug-VC-WIN64A %OPENSSL_OPTIONS% --prefix=%OUTPUT_PREFIX%
if %errorlevel% neq 0 goto fail

call ms\do_win64a.bat
if %errorlevel% neq 0 goto fail

SET DEBUG_SUFFIX=d
@echo Building x64 Debug DLLs
call build\build-dll.bat %2
if %errorlevel% neq 0 goto fail

@echo Building x64 Debug static lib
call build\build-lib.bat %2
if %errorlevel% neq 0 goto fail

REM x64 Release builds
perl Configure VC-WIN64A %OPENSSL_OPTIONS% --prefix=%OUTPUT_PREFIX%
if %errorlevel% neq 0 goto fail

call ms\do_win64a.bat
if %errorlevel% neq 0 goto fail

SET DEBUG_SUFFIX=
@echo Building x64 Release DLLs
call build\build-dll.bat %2
if %errorlevel% neq 0 goto fail

@echo Building x64 Release static lib
call build\build-lib.bat %2
if %errorlevel% neq 0 goto fail

echo Build finished
goto end

:fail
echo Build FAILED
:end
