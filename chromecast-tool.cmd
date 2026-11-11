@echo off
rem Windows launcher for chromecast-tool (PowerShell / Command Prompt).
rem It runs the script with the sh.exe that comes with Git for Windows.
setlocal
set "CCT_SH="
if exist "%ProgramFiles%\Git\bin\sh.exe" set "CCT_SH=%ProgramFiles%\Git\bin\sh.exe"
if not defined CCT_SH if exist "%LocalAppData%\Programs\Git\bin\sh.exe" set "CCT_SH=%LocalAppData%\Programs\Git\bin\sh.exe"
if not defined CCT_SH for %%G in (git.exe) do if not "%%~$PATH:G"=="" if exist "%%~dp$PATH:G..\bin\sh.exe" set "CCT_SH=%%~dp$PATH:G..\bin\sh.exe"
if not defined CCT_SH (
    echo ERROR: Git for Windows not found. Install it with: winget install Git.Git 1>&2
    exit /b 1
)
"%CCT_SH%" "%~dp0chromecast-tool" %*
