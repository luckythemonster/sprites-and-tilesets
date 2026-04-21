#!/bin/bash

# Comprehensive Asset Extraction and Organization Script
# Handles: ZIP, 7z, RAR, PNG files

set -e  # Exit on error

cd /workspaces/sprites-and-tilesets

echo "=================================="
echo "ASSET EXTRACTION & ORGANIZATION"
echo "=================================="
echo

# Create necessary directories
echo "[1/5] Creating directory structure..."
mkdir -p ASSETS/tilesets/{cyberpunk,sci-fi,sci-fi-basic-battlefields,ditharts-sci-fi-free,dungeons,misc}
mkdir -p ASSETS/sprites/{characters,environment,props,cyberpunk}
mkdir -p ASSETS/interiors
mkdir -p ASSETS/ui
mkdir -p ASSETS/misc
mkdir -p ARCHIVES/original-zips
mkdir -p ARCHIVES/original-7z
mkdir -p ARCHIVES/original-rar
mkdir -p TEMP_EXTRACT

echo "[2/5] Extracting ZIP archives..."
# Extract ZIP files with intelligent naming
for zip_file in *.zip; do
    if [ -f "$zip_file" ]; then
        zipname="${zip_file%.zip}"
        echo "  Extracting: $zip_file"
        unzip -q "$zip_file" -d "TEMP_EXTRACT/$zipname" || echo "  ⚠ Warning: Failed to extract $zip_file"
    fi
done

echo "[3/5] Extracting 7z archives..."
# Extract 7z files
for seven_file in *.7z; do
    if [ -f "$seven_file" ]; then
        sevname="${seven_file%.7z}"
        echo "  Extracting: $seven_file"
        7z x "$seven_file" -o"TEMP_EXTRACT/$sevname" > /dev/null 2>&1 || echo "  ⚠ Warning: Failed to extract $seven_file"
    fi
done

echo "[4/5] Extracting RAR archives (if available)..."
# Try to extract RAR files (requires unar or bsdtar)
for rar_file in *.rar; do
    if [ -f "$rar_file" ]; then
        rarname="${rar_file%.rar}"
        echo "  Extracting: $rar_file"
        if command -v unar &> /dev/null; then
            unar -o "TEMP_EXTRACT" "$rar_file" > /dev/null 2>&1 || echo "  ⚠ Warning: Failed to extract $rar_file"
        else
            echo "  ⚠ unar not installed, skipping $rar_file"
        fi
    fi
done

echo "[5/5] Moving PNG/TSX files to interiors folder..."
# Move standalone image files
for img_file in *.png *.tsx; do
    if [ -f "$img_file" ] && [ ! -d "$img_file" ]; then
        echo "  Moving: $img_file"
        mv "$img_file" "ASSETS/interiors/" || echo "  ⚠ Failed to move $img_file"
    fi
done

echo
echo "=================================="
echo "EXTRACTION COMPLETE"
echo "=================================="
echo

# List what was extracted
echo "Extracted archives contents:"
find TEMP_EXTRACT -type d -maxdepth 1 | sort | tail -n +2 | while read dir; do
    dirname=$(basename "$dir")
    count=$(find "$dir" -type f | wc -l)
    echo "  ✓ $dirname ($count files)"
done

echo
echo "Moving archives to backup..."
# Backup original archives
mv *.zip ARCHIVES/original-zips/ 2>/dev/null || true
mv *.7z ARCHIVES/original-7z/ 2>/dev/null || true
mv *.rar ARCHIVES/original-rar/ 2>/dev/null || true

echo "✓ Archives backed up to ARCHIVES/"
echo
echo "Next: Run 'organize.sh' to intelligently sort and organize assets"
echo "=================================="
