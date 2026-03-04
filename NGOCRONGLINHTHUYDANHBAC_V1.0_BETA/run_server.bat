@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

REM ==================================================================
REM ===                  CAU HINH CUA BAN                        ===
REM ==================================================================
REM !!! QUAN TRONG: Hay dat duong dan den thu muc JDK 21 cua ban o day.
set "JAVA_HOME=C:\Program Files\Java\jdk-21"
REM ==================================================================

REM Kiem tra JAVA_HOME
if not exist "%JAVA_HOME%\bin\javac.exe" (
    echo [LOI] Duong dan JAVA_HOME khong dung.
    echo Vui long mo file .bat nay va chinh sua lai duong dan den JDK 21.
    echo Duong dan hien tai: %JAVA_HOME%
    pause
    exit /b 1
)

echo Su dung Java tai: %JAVA_HOME%
echo.

REM Dinh nghia cac duong dan
set "SRC_DIR=src"
set "OUT_DIR=out\production\NGOCRONGLINHTHUYDANHBAC_V1.0_BETA"
set "LIB_DIR=lib"
set "SOURCE_FILES_LIST=sourcefiles.txt"

REM --- Buoc 1: Don dep build cu ---
echo [1/4] Dang don dep cac file da bien dich...
if exist "%OUT_DIR%" (
    rmdir /s /q "%OUT_DIR%"
)
mkdir "%OUT_DIR%"

REM --- Buoc 2: Xay dung Classpath ---
echo [2/4] Dang chuan bi de bien dich...
set "LIB_CLASSPATH="
for %%i in ("%LIB_DIR%\*.jar") do (
    set "LIB_CLASSPATH=!LIB_CLASSPATH!;%%i"
)
if defined LIB_CLASSPATH (
    set "LIB_CLASSPATH=!LIB_CLASSPATH:~1!"
)

REM --- Buoc 3: Bien dich ma nguon ---
echo [3/4] Dang bien dich ma nguon...
REM Tao danh sach tat ca cac file .java mot cach an toan
dir /s /b "%SRC_DIR%\*.java" > "%SOURCE_FILES_LIST%"

"%JAVA_HOME%\bin\javac.exe" -d "%OUT_DIR%" -cp "%LIB_CLASSPATH%" -encoding UTF-8 @"%SOURCE_FILES_LIST%"

if %errorlevel% neq 0 (
    echo.
    echo ***********************************
    echo ***    BIEN DICH THAT BAI!      ***
    echo ***********************************
    del "%SOURCE_FILES_LIST%"
    pause
    exit /b 1
)

del "%SOURCE_FILES_LIST%"
echo Bien dich thanh cong.
echo.

REM --- Buoc 4: Chay server ---
echo [4/4] Dang khoi dong server...
set "RUN_CLASSPATH=%OUT_DIR%;%LIB_CLASSPATH%"
"%JAVA_HOME%\bin\java.exe" -cp "%RUN_CLASSPATH%" server.ServerManager

echo.
echo Server da dung.
endlocal
pause