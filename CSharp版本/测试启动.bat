@echo off
cd /d "%~dp0"
echo Starting FlomoQuickNote...
echo.
echo If the program closes immediately, please check for error messages.
echo.
"bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe"
echo.
echo Program exited with code: %ERRORLEVEL%
echo.
pause

