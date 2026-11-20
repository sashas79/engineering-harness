@echo off
rem Engineering Harness launcher (BRS Section 69.4). It passes its arguments unchanged to the
rem core, which it looks for in this order: the ENGINEERING_HARNESS_CORE environment variable,
rem harness-core in the parent of this file's directory, harness-core on the search path.
rem With no core it exits 64, or 0 for adapter_guard so that a tool hook never fails.
rem For adapter_guard it exits 0 or 2 only (Section 68.3): status 2 of the core passes through,
rem any other status (a core that crashes or cannot start) becomes 0.
setlocal
set "ENGINEERING_HARNESS_PROJECT_ROOT=%~dp0"
if "%ENGINEERING_HARNESS_PROJECT_ROOT:~-1%"=="\" set "ENGINEERING_HARNESS_PROJECT_ROOT=%ENGINEERING_HARNESS_PROJECT_ROOT:~0,-1%"
set "HARNESS_CORE_FOUND="
if defined ENGINEERING_HARNESS_CORE (
  if exist "%ENGINEERING_HARNESS_CORE%" set "HARNESS_CORE_FOUND=%ENGINEERING_HARNESS_CORE%"
)
if defined HARNESS_CORE_FOUND goto run
if defined ENGINEERING_HARNESS_CORE (
  where /q "%ENGINEERING_HARNESS_CORE%" 2>nul && set "HARNESS_CORE_FOUND=%ENGINEERING_HARNESS_CORE%"
)
if defined HARNESS_CORE_FOUND goto run
if exist "%~dp0..\harness-core.exe" set "HARNESS_CORE_FOUND=%~dp0..\harness-core.exe"
if defined HARNESS_CORE_FOUND goto run
where /q harness-core 2>nul && set "HARNESS_CORE_FOUND=harness-core"
if defined HARNESS_CORE_FOUND goto run
if /i "%~1"=="adapter_guard" exit /b 0
echo harness: no Engineering Harness core found: set ENGINEERING_HARNESS_CORE, or place harness-core.exe beside the project directory or on the search path 1>&2
exit /b 64
:run
"%HARNESS_CORE_FOUND%" %*
if /i "%~1"=="adapter_guard" goto guard
exit /b %ERRORLEVEL%
:guard
if errorlevel 3 exit /b 0
if errorlevel 2 exit /b 2
exit /b 0
