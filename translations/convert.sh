#!/bin/sh

# Script permettant de convertir tous les fichiers de traductions .ods dans le dossier translations en des fichiers .csv apte à être utilisés
# --- CONFIGURATION ---
# Chemin d'accès à Libre Office Calc (par défaut sur Ubuntu)
SOFFICE_PATH="/usr/bin/soffice"

# Vérification si LibreOffice est trouvé
if [ ! -f "$SOFFICE_PATH" ]; then
    echo "[ERREUR] Impossible de trouver soffice à l'emplacement :"
    echo "  $SOFFICE_PATH"
    echo ""
    echo "Sur Ubuntu, installez LibreOffice Calc avec :"
    echo "  sudo apt install libreoffice-calc"
    echo ""
    echo "Ou modifiez ce script avec le bon chemin vers soffice."
    exit 1
fi

# Se placer dans le dossier où se trouve le script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "Démarrage de la conversion des fichiers .ods en .csv..."
echo "-------------------------------------------------------"

# Vérifier s'il y a des fichiers .ods
ODS_COUNT=$(ls *.ods 2>/dev/null | wc -l)
if [ "$ODS_COUNT" -eq 0 ]; then
    echo "[INFO] Aucun fichier .ods trouvé dans le dossier."
    exit 0
fi

HAS_ERROR=0

# Boucle sur tous les fichiers .ods du dossier
for f in *.ods; do
    echo "Traitement de : $f"
    "$SOFFICE_PATH" --headless --convert-to csv:"Text - txt - csv (StarCalc)":44,34,76 --outdir "$SCRIPT_DIR" "$f"
done

echo ""
echo "--- Vérification des fichiers CSV générés ---"

for f in *.ods; do
    CSV_FILE="${f%.ods}.csv"
    if [ ! -f "$CSV_FILE" ]; then
        echo "[ERREUR] Le fichier $CSV_FILE n'a pas été généré !"
        HAS_ERROR=1
        continue
    fi

    # Lire la première ligne (header)
    HEADER=$(head -n 1 "$CSV_FILE")

    # Vérifier que le header contient "key" (ou "keys") en première colonne et les langues "fr" et "en"
    FIRST_COL=$(echo "$HEADER" | cut -d',' -f1)
    if [ "$FIRST_COL" != "key" ] && [ "$FIRST_COL" != "keys" ]; then
        echo "[ERREUR] $CSV_FILE : La première ligne ne commence pas par 'key' ou 'keys'."
        echo "         Header trouvé : $HEADER"
        echo "         Le fichier ODS '$f' a probablement une ligne d'en-tête manquante (key,fr,en)."
        HAS_ERROR=1
    fi

    if ! echo "$HEADER" | grep -q "fr"; then
        echo "[ERREUR] $CSV_FILE : La colonne 'fr' est absente du header."
        HAS_ERROR=1
    fi

    if ! echo "$HEADER" | grep -q "en"; then
        echo "[ERREUR] $CSV_FILE : La colonne 'en' est absente du header."
        HAS_ERROR=1
    fi

    # Vérifier qu'il y a au moins une ligne de données (en plus du header)
    LINE_COUNT=$(wc -l < "$CSV_FILE")
    if [ "$LINE_COUNT" -le 1 ]; then
        echo "[AVERTISSEMENT] $CSV_FILE : Aucune donnée trouvée (seulement le header). Vérifiez le fichier ODS."
    else
        DATA_LINES=$((LINE_COUNT - 1))
        echo "[OK] $CSV_FILE : $DATA_LINES ligne(s) de données."
    fi
done

echo ""
echo "-------------------------------------------------------"
if [ "$HAS_ERROR" -ne 0 ]; then
    echo "Conversion terminée avec des ERREURS !"
    echo "Corrigez les fichiers .ods concernés (ajoutez la ligne d'en-tête 'key,fr,en') puis relancez ce script."
    exit 1
else
    echo "Conversion terminée avec succès !"
fi
