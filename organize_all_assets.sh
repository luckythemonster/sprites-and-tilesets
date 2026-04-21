#!/bin/bash

# Comprehensive Asset Extraction & Organization Script
# Handles: ZIP, 7z, RAR archives with intelligent categorization
# Output: Organized ASSETS folder structure + detailed log

set -e
cd /workspaces/sprites-and-tilesets

# Timestamp for logs
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="extraction_manifest_${TIMESTAMP}.log"
INVENTORY_FILE="ASSET_INVENTORY_${TIMESTAMP}.txt"

echo "[$(date)] Starting Asset Extraction..." | tee "$LOG_FILE"
echo "================================" | tee -a "$LOG_FILE"

# Create directory structure
mkdir -p ASSETS/tilesets/{cyberpunk,sci-fi,dungeons,city,topdown,fantasy,misc}
mkdir -p ASSETS/sprites/{characters,cyberpunk,environment,props}
mkdir -p ASSETS/interiors
mkdir -p ASSETS/ui
mkdir -p ASSETS/effects
mkdir -p ARCHIVES/{original-zips,original-7z,original-rar}
mkdir -p TEMP_EXTRACT

echo "[$(date)] Directory structure created" | tee -a "$LOG_FILE"

# Extract ZIP files with intelligent categorization
echo "[$(date)] Extracting ZIP archives..." | tee -a "$LOG_FILE"
for zip_file in *.zip; do
    if [ -f "$zip_file" ]; then
        zipname="${zip_file%.zip}"
        echo "  Processing: $zip_file" | tee -a "$LOG_FILE"
        
        mkdir -p "TEMP_EXTRACT/$zipname"
        unzip -q "$zip_file" -d "TEMP_EXTRACT/$zipname" 2>/dev/null || {
            echo "  ⚠ Warning: Failed to extract $zip_file" | tee -a "$LOG_FILE"
            continue
        }
    fi
done

# Extract 7z files
echo "[$(date)] Extracting 7z archives..." | tee -a "$LOG_FILE"
for seven_file in *.7z; do
    if [ -f "$seven_file" ]; then
        sevname="${seven_file%.7z}"
        echo "  Processing: $seven_file" | tee -a "$LOG_FILE"
        
        mkdir -p "TEMP_EXTRACT/$sevname"
        7z x "$seven_file" -o"TEMP_EXTRACT/$sevname" > /dev/null 2>&1 || {
            echo "  ⚠ Warning: Failed to extract $seven_file" | tee -a "$LOG_FILE"
            continue
        }
    fi
done

# Try to extract RAR files (requires unar/bsdtar)
echo "[$(date)] Processing RAR archives..." | tee -a "$LOG_FILE"
for rar_file in *.rar; do
    if [ -f "$rar_file" ]; then
        rarname="${rar_file%.rar}"
        echo "  Processing: $rar_file" | tee -a "$LOG_FILE"
        
        mkdir -p "TEMP_EXTRACT/$rarname"
        if command -v unar &> /dev/null; then
            unar -o "TEMP_EXTRACT" "$rar_file" > /dev/null 2>&1 || {
                echo "  ⚠ Warning: Failed to extract $rar_file" | tee -a "$LOG_FILE"
            }
        elif command -v bsdtar &> /dev/null; then
            bsdtar -xf "$rar_file" -C "TEMP_EXTRACT/$rarname" 2>/dev/null || {
                echo "  ⚠ Warning: Failed to extract $rar_file" | tee -a "$LOG_FILE"
            }
        else
            echo "  ⚠ RAR extraction tools not installed (unar/bsdtar)" | tee -a "$LOG_FILE"
        fi
    fi
done

# Categorize and organize extracted files
echo "[$(date)] Categorizing and organizing assets..." | tee -a "$LOG_FILE"

categorize_and_move() {
    local source_dir=$1
    local filename=$2
    local filepath="$source_dir/$filename"
    
    # Skip if not a file
    [ ! -f "$filepath" ] && return
    
    local target_dir=""
    local lowername=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
    
    # Categorize based on filename patterns
    if echo "$lowername" | grep -qiE "(cyberpunk|neon|cp_)"; then
        target_dir="ASSETS/tilesets/cyberpunk"
    elif echo "$lowername" | grep -qiE "(city|urban|town)"; then
        target_dir="ASSETS/tilesets/city"
    elif echo "$lowername" | grep -qiE "(dungeon|crypt|cave|tech)"; then
        target_dir="ASSETS/tilesets/dungeons"
    elif echo "$lowername" | grep -qiE "(topdown|top-down|1bit|8bit)"; then
        target_dir="ASSETS/sprites"  # Often sprites
    elif echo "$lowername" | grep -qiE "(interior|inside|room|furniture)"; then
        target_dir="ASSETS/interiors"
    elif echo "$lowername" | grep -qiE "(character|avatar|npc|player|sprite)"; then
        target_dir="ASSETS/sprites/characters"
    elif echo "$lowername" | grep -qiE "(space|station|sci-?fi|sci_fi|scifi)"; then
        target_dir="ASSETS/tilesets/sci-fi"
    elif echo "$lowername" | grep -qiE "(cursed|fantasy|magic|dungeon)"; then
        target_dir="ASSETS/tilesets/fantasy"
    elif echo "$lowername" | grep -qiE "(ui|menu|hud|button|icon)"; then
        target_dir="ASSETS/ui"
    elif echo "$lowername" | grep -qiE "(effect|particle|fire|smoke)"; then
        target_dir="ASSETS/effects"
    else
        target_dir="ASSETS/tilesets/misc"
    fi
    
    # Create target and move file
    mkdir -p "$target_dir"
    cp "$filepath" "$target_dir/" 2>/dev/null && echo "    → $target_dir/$filename" >> "$LOG_FILE"
}

# Process extracted files
for extract_dir in TEMP_EXTRACT/*; do
    if [ -d "$extract_dir" ]; then
        dirname=$(basename "$extract_dir")
        echo "  Organizing: $dirname" | tee -a "$LOG_FILE"
        
        # Find all files (recursively) and categorize
        find "$extract_dir" -type f | while read -r filepath; do
            filename=$(basename "$filepath")
            # Get parent directory for context
            parent=$(dirname "$filepath")
            categorize_and_move "$parent" "$filename"
        done
    fi
done

# Move standalone PNG files
echo "[$(date)] Moving standalone image files..." | tee -a "$LOG_FILE"
for img_file in *.png *.tsx *.jpg *.gif 2>/dev/null; do
    if [ -f "$img_file" ] && [ ! -d "$img_file" ]; then
        # Categorize PNGs
        lowername=$(echo "$img_file" | tr '[:upper:]' '[:lower:]')
        if echo "$lowername" | grep -qiE "(interior|inside|room)"; then
            cp "$img_file" ASSETS/interiors/ && echo "  → ASSETS/interiors/$img_file" | tee -a "$LOG_FILE"
        elif echo "$lowername" | grep -qiE "(ui|menu|hud)"; then
            cp "$img_file" ASSETS/ui/ && echo "  → ASSETS/ui/$img_file" | tee -a "$LOG_FILE"
        else
            cp "$img_file" ASSETS/tilesets/misc/ && echo "  → ASSETS/tilesets/misc/$img_file" | tee -a "$LOG_FILE"
        fi
    fi
done

# Backup original archives
echo "[$(date)] Backing up original archives..." | tee -a "$LOG_FILE"
for file in *.zip; do [ -f "$file" ] && mv "$file" ARCHIVES/original-zips/ 2>/dev/null && echo "  ✓ Backed up: $file" | tee -a "$LOG_FILE"; done
for file in *.7z; do [ -f "$file" ] && mv "$file" ARCHIVES/original-7z/ 2>/dev/null && echo "  ✓ Backed up: $file" | tee -a "$LOG_FILE"; done
for file in *.rar; do [ -f "$file" ] && mv "$file" ARCHIVES/original-rar/ 2>/dev/null && echo "  ✓ Backed up: $file" | tee -a "$LOG_FILE"; done

# Clean up temp extraction folder
rm -rf TEMP_EXTRACT

# Generate inventory
echo "[$(date)] Generating asset inventory..." | tee -a "$LOG_FILE"
echo "# Asset Inventory (Generated: $(date))" > "$INVENTORY_FILE"
echo "" >> "$INVENTORY_FILE"
echo "## Summary" >> "$INVENTORY_FILE"
find ASSETS -type f | sort | while read file; do
    echo "  $file" >> "$INVENTORY_FILE"
done

# Summary statistics
total_files=$(find ASSETS -type f | wc -l)
tileset_files=$(find ASSETS/tilesets -type f | wc -l)
sprite_files=$(find ASSETS/sprites -type f | wc -l)
interior_files=$(find ASSETS/interiors -type f | wc -l)

echo "" | tee -a "$LOG_FILE"
echo "================================" | tee -a "$LOG_FILE"
echo "EXTRACTION COMPLETE" | tee -a "$LOG_FILE"
echo "================================" | tee -a "$LOG_FILE"
echo "Total Files Organized: $total_files" | tee -a "$LOG_FILE"
echo "  - Tilesets: $tileset_files" | tee -a "$LOG_FILE"
echo "  - Sprites: $sprite_files" | tee -a "$LOG_FILE"
echo "  - Interiors: $interior_files" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "Log file: $LOG_FILE" | tee -a "$LOG_FILE"
echo "Inventory file: $INVENTORY_FILE" | tee -a "$LOG_FILE"
echo "Backed up archives: ARCHIVES/" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "✓ All assets extracted and organized successfully!" | tee -a "$LOG_FILE"
