@echo off
title sql-fastdump
for /f "tokens=1* delims=:" %%a in ('findstr /b /c:"*::" "%~f0"') do set "%%b"
set olddir=%cd%

:profilecreate
if defined profile call :main
echo create profile for sql-fastdump:
echo.
set /p "host= MySQL server adress (Default = localhost): "
set /p "user= MySQL user (Default = root): "
set /p "pass= MySQL password: "
set /p "mangos= db - mangos (Default = mangos): "
set /p "char= db - characters (Default = characters): "
set /p "realm= db - realmd (Default = realmd): "
set /p "sd2= db - sd2 (Default = scriptdev2): "
>>"%~f0" call echo.
>>"%~f0" call echo *::host=%%host%%
>>"%~f0" call echo *::user=%%user%%
>>"%~f0" call echo *::pass=%%pass%%
>>"%~f0" call echo *::mangos=%%mangos%%
>>"%~f0" call echo *::char=%%char%%
>>"%~f0" call echo *::realm=%%realm%%
>>"%~f0" call echo *::sd2=%%sd2%%
>>"%~f0" call echo *::profile=isdefined
start sql-fastdump.bat
exit

:main
cls
if not "%cd%"=="%olddir%\dump" cd dump
if not "%dirname%"=="%date:~-4%-%date:~-7,2%-%date:~-10,2%-dump" set dirname="%date:~-4%-%date:~-7,2%-%date:~-10,2%-dump"
echo user: %user% @ host: %host%    password is %pass%
echo.
echo.
echo choose option:
echo   1 - dump all
echo   2 - dump db - %mangos%
echo   3 - dump db - %char%
echo   4 - dump db - %realm%
echo   5 - dump db - %sd2%
echo   6 - delete profile
echo   7 - infos
echo   X - close
set /p "main=choice?: "
if %main%==1 call :checkall
if %main%==2 call :checksingle
if %main%==3 call :checksingle
if %main%==4 call :checksingle
if %main%==5 call :checksingle
if %main%==6 call :deleteprofile
if %main%==7 call :infos
if %main%==x call :close
if %main%==X call :close
call :unknownoption

:checkall
set checkall=undef
if exist %dirname% set /p "checkall=dump already exists. delete? (y|n): "
if %checkall%==y rmdir %dirname% /S /Q && call :dumpall
if %checkall%==Y rmdir %dirname% /S /Q && call :dumpall
if %checkall%==n call :main
if %checkall%==N call :main
if not exist %dirname% call :dumpall
echo unknown option. press any key to continue.
pause >nul
call :main

:dumpall
mkdir %dirname%
echo dump db - %mangos%
.\mysqldump --host=%host% --user=%user% --password=%pass% %mangos% > ".\%dirname%\%mangos%.sql"
if %errorlevel%==0 echo  done.
echo.
echo dump db - %char%
.\mysqldump --host=%host% --user=%user% --password=%pass% %char% > ".\%dirname%\%char%.sql"
if %errorlevel%==0 echo  done.
echo.
echo dump db - %realm%
.\mysqldump --host=%host% --user=%user% --password=%pass% %realm% > ".\%dirname%\%realm%.sql"
if %errorlevel%==0 echo  done.
echo.
echo dump db - %sd2%
.\mysqldump --host=%host% --user=%user% --password=%pass% %sd2% > ".\%dirname%\%sd2%.sql"
if %errorlevel%==0 echo  done.
echo.
echo press any key to continue.
pause >nul
call :main

:checksingle
if %main%==2 set dumptarg=%mangos%
if %main%==3 set dumptarg=%char%
if %main%==4 set dumptarg=%realm%
if %main%==5 set dumptarg=%sd2%
set checksingle=undef
if exist ".\%dirname%\%dumptarg%.sql" set /p "checksingle=dump %dumptarg% already exists. delete? (y|n): "
if %checksingle%==y del ".\%dirname%\%dumptarg%.sql" /F >nul
if %checksingle%==Y del ".\%dirname%\%dumptarg%.sql" /F >nul
if %checksingle%==n call :main
if %checksingle%==N call :main
if not exist ".\%dirname%\%dumptarg%.sql" call :dumpsingle
echo unknown option. press any key to continue.
pause >nul
call :main

:dumpsingle
if not exist %dirname% mkdir %dirname%
echo dump db - %dumptarg%
.\mysqldump --host=%host% --user=%user% --password=%pass% %dumptarg% > ".\%dirname%\%dumptarg%.sql"
if %errorlevel%==0 echo  done.
echo.
echo press any key to continue.
pause >nul
call :main

:deleteprofile
set /p "deleteprofile=delete profile? (y|n): "
if "%deleteprofile%"=="n" call :main
if "%deleteprofile%"=="N" call :main
if "%deleteprofile%"=="y" (
echo.
echo this could take a while.. application will be closed
  >"%temp%\bat.tmp" type nul
  for /f "tokens=* delims=12334567890" %%a in ('findstr /b /n /v /c:"*::" "%~f0"') do (
    set "line=%%a"
    call :writeNew
  )
  move "%temp%\bat.tmp" "%~f0" >nul
  exit
)

if "%deleteprofile%"=="Y" (
echo.
echo this could take a while.. application will be closed
  >"%temp%\bat.tmp" type nul
  for /f "tokens=* delims=12334567890" %%a in ('findstr /b /n /v /c:"*::" "%~f0"') do (
    set "line=%%a"
    call :writeNew
  )
  move "%temp%\bat.tmp" "%~f0" >nul
  exit
)
echo unknown option. press any key to continue.
pause >nul
call :main

:writeNew
setlocal enabledelayedexpansion
>>"%temp%\bat.tmp" echo\!line:~1!
endlocal
goto :eof

:infos
echo sql-fastdump by houserock and isimp
echo get the newest version at github.com/houserock/sql-fastdump
echo.
echo.
echo changelog:
echo initial release: profilecreate
echo added dumpall-function
echo added check if dump already exists
echo added singledumps
echo added option for deleting profile
echo added infos
echo.
echo to see the whole changelog visit github.com/houserock/sql-fastdumps/commits
echo.
echo.
echo press any key to continue.
pause >nul
call :main

:unknownoption
echo unknown option. press any key to continue.
pause >nul
call :main

:close
echo thanks for using sql-fastdump.
pause >nul
exit