@echo off
setlocal

:: Script permettant de convertir tous les fichiers de traductions .ods dans le dossier translations en des fichiers .csv apte à être utilisés
:: --- CONFIGURATION ---
:: Chemin d'accès à Libre Office Calc
set "SOFFICE_PATH=C:\Program Files\LibreOffice\program\soffice.exe"

:: Vérification si LibreOffice est trouvé
if not exist "%SOFFICE_PATH%" (
    echo [ERREUR] Impossible de trouver soffice.exe a l'emplacement :
    echo "%SOFFICE_PATH%"
    echo.
    echo Merci de modifier le fichier .bat avec le bon chemin vers LibreOffice.
    pause
    exit /b
)

:: Se placer dans le dossier où se trouve le script
cd /d "%~dp0"

set "FORCE=0"
if "%~1"=="--force" set "FORCE=1"
if "%~1"=="-f" set "FORCE=1"

echo Démarrage de la conversion des fichiers .ods en .csv...
if "%FORCE%"=="1" (
    echo [INFO] Mode --force active : tous les fichiers seront convertis.
)
echo -------------------------------------------------------

set "CONVERT_COUNT=0"
set "SKIP_COUNT=0"

:: Boucle sur tous les fichiers .ods du dossier
for %%f in (*.ods) do (
    call :process_file "%%f"
)

echo.
echo -------------------------------------------------------
echo Conversion terminee ! (%CONVERT_COUNT% converti(s), %SKIP_COUNT% deja a jour)
pause
exit /b

:process_file
set "ODS_FILE=%~1"
set "CSV_FILE=%~n1.csv"

if "%FORCE%"=="0" (
    if exist "%CSV_FILE%" (
        powershell -NoProfile -Command "if ((Get-Item -LiteralPath '%CSV_FILE%').LastWriteTime -ge (Get-Item -LiteralPath '%ODS_FILE%').LastWriteTime) { exit 0 } else { exit 1 }"
        if not errorlevel 1 (
            echo [IGNORE] %ODS_FILE% (%CSV_FILE% est deja a jour)
            set /a SKIP_COUNT+=1
            goto :eof
        )
    )
)

echo Traitement de : %ODS_FILE%
"%SOFFICE_PATH%" --headless --convert-to csv:"Text - txt - csv (StarCalc)":44,34,76 "%ODS_FILE%"
set /a CONVERT_COUNT+=1
goto :eof