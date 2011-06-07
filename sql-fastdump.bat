@echo off
title sql-fastdump
for /f "tokens=1* delims=:" %%a in ('findstr /b /c:"*::" "%~f0"') do set "%%b"

:profilecreate
if defined profile call :main
echo create profile for sql-fastdump:
echo.
set /p "host= MySQL server adress (Default = localhost): "
>>"%~f0" call echo *::host=%%host%%
set /p "user= MySQL user (Default = root): "
>>"%~f0" call echo *::user=%%user%%
set /p "pass= MySQL password: "
>>"%~f0" call echo *::pass=%%pass%%
set /p "mangos= db - mangos (Default = mangos): "
>>"%~f0" call echo *::mangos=%%mangos%%
set /p "char= db - characters (Default = characters): "
>>"%~f0" call echo *::char=%%char%%
set /p "realm= db - realmd (Default = realmd): "
>>"%~f0" call echo *::realm=%%realm%%
set /p "sd2= db - sd2 (Default = scriptdev2): "
>>"%~f0" call echo *::sd2=%%sd2%%
>>"%~f0" call echo *::profile=isdefined
start sql-fastdump.bat
exit

:main
cls
echo choose option:
echo   1 - dump all
echo   2 - dump db - %mangos%
echo   3 - dump db - %char%
echo   4 - dump db - %realm%
echo   5 - dump db - %sd2%
set /p "main=choice?: "
if %main%==1 call :dumpall
if %main%==2 call :dumpmangos
if %main%==3 call :dumpchar
if %main%==4 call :dumprealm
if %main%==5 call :dumpsd2
exit
