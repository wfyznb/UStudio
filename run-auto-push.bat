@echo off
cd /d "c:\Users\jijijijhi\Desktop\AnimeStudio-master"
set GIT_EXE=C:\Program Files\Git\bin\git.exe

REM Check git status
"%GIT_EXE%" status --porcelain > git-status.tmp 2>&1
if %errorlevel% neq 0 (
    echo Git status failed
    type git-status.tmp
    del git-status.tmp
    exit /b 1
)

for %%A in (git-status.tmp) do if %%~zA equ 0 (
    echo [%date% %time%] No changes detected, skipping.
    del git-status.tmp
    exit /b 0
)

REM Git add
"%GIT_EXE%" add -A
if %errorlevel% neq 0 (
    echo Git add failed
    del git-status.tmp
    exit /b 1
)

REM Git commit
set TIMESTAMP=%date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,8%
"%GIT_EXE%" commit -m "auto: sync changes at %TIMESTAMP%"
if %errorlevel% neq 0 (
    echo Git commit failed
    del git-status.tmp
    exit /b 1
)

REM Git push
"%GIT_EXE%" push origin master
if %errorlevel% neq 0 (
    echo Git push failed
    del git-status.tmp
    exit /b 1
)

echo Changes pushed successfully
del git-status.tmp
exit /b 0
