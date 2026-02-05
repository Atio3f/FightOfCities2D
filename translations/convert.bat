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

echo Démarrage de la conversion des fichiers .ods en .csv...
echo -------------------------------------------------------

:: Boucle sur tous les fichiers .ods du dossier
for %%f in (*.ods) do (
    echo Traitement de : %%f
    "%SOFFICE_PATH%" --headless --convert-to csv:"Text - txt - csv (StarCalc)":44,34,76 "%%f"
)

echo.
echo -------------------------------------------------------
echo Conversion terminée !
pause