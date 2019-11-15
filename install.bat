@echo off
title VSCode Installer
set nopause=0
echo %* | find /i "-nopause" 1>nul && set nopause=1

set unzip=%~dp0winutils\7za.exe
set shorc=%~dp0winutils\CreateShortcut.vbs
set curlz=%~dp0winutils\curl.7z
set curld=%temp%\curl
set curle=%curld%\curl.exe

set TargetDir=%LocalAppData%\Programs\Code
set BinDir=%TargetDir%\bin
set DataDir=%appdata%\Code\User
set file=%temp%\vscode.zip

set url=https://go.microsoft.com/fwlink/?Linkid=850641

set DesktopDir=
for /f "tokens=2* skip=2" %%a in ('"reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folderss" /v Desktop 2>nul"') do (
    for /f "tokens=*" %%c in ('echo %%b') do (
        set DesktopDir=%%~c
    )
)
if "%DesktopDir%"=="" set DesktopDir=%UserProfile%\Desktop

echo Verificando curl
if not exist "%curle%" "%unzip%" x "%curlz%" -o"%curld%" -y 1>nul
if not exist "%curle%" goto _CurlNotFound
echo:

echo Fazendo download
"%curle%" -L %url% -o "%file%"
echo:

echo Extraindo
"%unzip%" x "%file%" -o"%TargetDir%" -y -bb0
echo:

echo %PATH% | find /i "%BinDir%" 1>nul && goto _Settings
echo Adicionando ao PATH
set currentPath=
for /f "tokens=2*" %%a in ('reg query HKCU\Environment /v Path') do set currentPath=%%~b
setx PATH "%BinDir%;%currentPath%"
set PATH=%BinDir%;%PATH%
echo:

:_Settings
echo Aplicando configura‡äes
if not exist "%DataDir%" mkdir "%DataDir%"
copy /y "%~dp0settings.json" "%DataDir%\"
echo:

echo Instalando extensäes
for /f "usebackq tokens=*" %%a in ("%~dp0extensions.txt") do call code.cmd --install-extension %%a
echo:

<nul set /p dummy=Criando atalho na  rea de trabalho... 
cscript /nologo "%shorc%" "%DesktopDir%\VSCode.lnk" "%TargetDir%\Code.exe" && echo Pronto.

goto _End

:_CurlNotFound
echo curl nÆo encontrado.
goto _End

:_End
if %nopause%==0 pause