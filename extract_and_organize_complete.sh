#!/bin/bash

################################################################################
# COMPLETE GAME ASSET EXTRACTION AND ORGANIZATION SCRIPT
# Purpose: Extract 27+ archives (ZIP, 7z, RAR) and organize into ASSETS/
# Features: Auto-categorization, manifest creation, backups, detailed logging
################################################################################

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Paths
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="${ROOT_DIR}/ASSETS"
ARCHIVES_BACKUP="${ROOT_DIR}/ARCHIVES"
TEMP_EXTRACT="${ROOT_DIR}/TEMP_EXTRACT"
LOG_FILE="${ROOT_DIR}/extraction_manifest_$(date +%Y%m%d_%H%M%S).log"
INVENTORY_FILE="${ROOT_DIR}/ASSET_INVENTORY_$(date +%Y%m%d_%H%M%S).txt"

# Create necessary directories
mkdir -p "${ASSETS_DIR}"/{tilesets,sprites,interiors,ui,props,effects}
mkdir -p "${ARCHIVES_BACKUP}/original-zips"
mkdir -p "${ARCHIVES_BACKUP}/original-7z"
mkdir -p "${ARCHIVES_BACKUP}/original-rar"
mkdir -p "${TEMP_EXTRACT}"

# Tracking variables
EXTRACTED_COUNT=0
ORGANIZED_COUNT=0
ERROR_COUNT=0

################################################################################
# LOGGING FUNCTIONS
################################################################################

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "${LOG_FILE}"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1" | tee -a "${LOG_FILE}"
}

log_error() {
    echo -e "${RED}✗ ERROR:${NC} $1" | tee -a "${LOG_FILE}"
    ((ERROR_COUNT++))
}

log_warning() {
    echo -e "${YELLOW}⚠ WARNING:${NC} $1" | tee -a "${LOG_FILE}"
}

################################################################################
# EXTRACTION FUNCTIONS
################################################################################

# Check if required tools are installed
check_requirements() {
    log "Checking for required extraction tools..."
    
    local missing=()
    
    command -v unzip &> /dev/null || missing+=("unzip")
    command -v 7z &> /dev/null || missing+=("7z")
    command -v unar &> /dev/null || missing+=("unar")  # For RAR files
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_warning "Missing tools: ${missing[*]}"
        log "Installing required packages..."
        sudo apt-get update -qq
        sudo apt-get install -y -qq unzip p7zip-full unar &> /dev/null
        log_success "Required tools installed"
    else
        log_success "All required tools available"
    fi
}

# Extract ZIP files
extract_zip() {
    local zip_file="$1"
    local extract_dir="$2"
    
    log "Extracting ZIP: $(basename "$zip_file")"
    
    if unzip -q "$zip_file" -d "$extract_dir" 2>/dev/null; then
        log_success "Extracted: $(basename "$zip_file")"
        ((EXTRACTED_COUNT++))
        return 0
    else
        log_error "Failed to extract: $(basename "$zip_file")"
        return 1
    fi
}

# Extract 7z files
extract_7z() {
    local archive="$1"
    local extract_dir="$2"
    
    log "Extracting 7z: $(basename "$archive")"
    
    if 7z x "$archive" -o"$extract_dir" -y &>/dev/null; then
        log_success "Extracted: $(basename "$archive")"
        ((EXTRACTED_COUNT++))
        return 0
    else
        log_error "Failed to extract: $(basename "$archive")"
        return 1
    fi
}

# Extract RAR files
extract_rar() {
    local archive="$1"
    local extract_dir="$2"
    
    log "Extracting RAR: $(basename "$archive")"
    
    if unar "$archive" -o "$extract_dir" &>/dev/null; then
        log_success "Extracted: $(basename "$archive")"
        ((EXTRACTED_COUNT++))
        return 0
    else
        log_error "Failed to extract: $(basename "$archive")"
        return 1
    fi
}

################################################################################
# CATEGORIZATION FUNCTIONS
################################################################################

# Determine asset category based on filename and content
categorize_asset() {
    local source_path="$1"
    local filename=$(basename "$source_path" | tr '[:upper:]' '[:lower:]')
    
    # Tileset detection
    if [[ "$filename" =~ (tileset|tile|map|terrain|background) ]]; then
        if [[ "$filename" =~ (cyb|cyber|punk|neon) ]]; then
            echo "tilesets/cyberpunk"
        elif [[ "$filename" =~ (scifi|sci-fi|space|station|facility) ]]; then
            echo "tilesets/sci-fi"
        elif [[ "$filename" =~ (dungeon|cave|dark|tech) ]]; then
            echo "tilesets/dungeons"
        elif [[ "$filename" =~ (city|urban|building|town) ]]; then
            echo "tilesets/city"
        elif [[ "$filename" =~ (topdown|top-down|2d|top) ]]; then
            echo "tilesets/topdown"
        elif [[ "$filename" =~ (cursed|land|nature|forest) ]]; then
            echo "tilesets/fantasy"
        else
            echo "tilesets/misc"
        fi
    # Character sprite detection
    elif [[ "$filename" =~ (character|sprite|avatar|player|npc) ]]; then
        if [[ "$filename" =~ (cyb|cyber|punk) ]]; then
            echo "sprites/cyberpunk"
        else
            echo "sprites/characters"
        fi
    # Environment/props detection
    elif [[ "$filename" =~ (environment|prop|object|item|decoration) ]]; then
        echo "sprites/environment"
    # Interior detection
    elif [[ "$filename" =~ (interior|room|furniture|inside|indoor) ]]; then
        echo "interiors"
    # UI detection
    elif [[ "$filename" =~ (ui|hud|button|menu|interface|health|bar) ]]; then
        echo "ui"
    # Effects detection
    elif [[ "$filename" =~ (effect|particle|animation|magic|spell) ]]; then
        echo "effects"
    else
        echo "props"
    fi
}

################################################################################
# ORGANIZATION FUNCTIONS
################################################################################

# Move PNG files to appropriate locations
organize_png_files() {
    log "\\n=== Organizing standalone PNG files ==="
    
    local png_files=(
        "Inside_C.png|interiors"
        "MysticChroma_Basics.png|tilesets/misc"
        "MysticAcid_basics_PetricakeGames.png|tilesets/misc"
        "SciFi_DungeonTileset16x16_0x72Like.png|tilesets/dungeons"
        "TileSet v1.0.png|tilesets/misc"
        "spr_tile_itch.png|sprites/environment"
    )
    
    for entry in "${png_files[@]}"; do
        IFS='|' read -r filename category <<< "$entry"
        local source="${ROOT_DIR}/${filename}"
        local dest="${ASSETS_DIR}/${category}/${filename}"
        
        if [ -f "$source" ]; then
            mkdir -p "$(dirname "$dest")"
            if cp "$source" "$dest"; then
                log_success "Organized: $filename → $category"
                echo "$category/${filename}" >> "${INVENTORY_FILE}"
                ((ORGANIZED_COUNT++))
            else
                log_error "Failed to copy: $filename"
            fi
        fi
    done
}

# Recursively organize extracted files
organize_extracted_files() {
    log "\\n=== Organizing extracted files ==="
    
    find "${TEMP_EXTRACT}" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" -o -name "*.json" -o -name "*.tmx" -o -name "*.tsx" \) | while read -r file; do
        local filename=$(basename "$file")
        local category=$(categorize_asset "$file")
        local dest_dir="${ASSETS_DIR}/${category}"
        
        mkdir -p "$dest_dir"
        
        if cp "$file" "$dest_dir/${filename}"; then
            log_success "Organized: ${filename} → ${category}"
            echo "${category}/${filename}" >> "${INVENTORY_FILE}"
            ((ORGANIZED_COUNT++))
        else
            log_error "Failed to copy: $filename"
        fi
    done
}

# Recursive extraction for nested archives
extract_nested() {
    local dir="$1"
    local depth="${2:-0}"
    local max_depth=3
    
    if [ "$depth" -ge "$max_depth" ]; then
        log_warning "Max extraction depth reached for: $dir"
        return
    fi
    
    # Find and extract nested archives
    find "$dir" -type f \( -name "*.zip" -o -name "*.7z" -o -name "*.rar" \) | while read -r nested_archive; do
        local nested_dir="${dir}/nested_extract_${depth}"
        mkdir -p "$nested_dir"
        
        log "Found nested archive: $(basename "$nested_archive")"
        
        case "$nested_archive" in
            *.zip)  extract_zip "$nested_archive" "$nested_dir" ;;
            *.7z)   extract_7z "$nested_archive" "$nested_dir" ;;
            *.rar)  extract_rar "$nested_archive" "$nested_dir" ;;
        esac
        
        extract_nested "$nested_dir" $((depth + 1))
    done
}

################################################################################
# BACKUP FUNCTIONS
################################################################################

# Backup original archives
backup_archives() {
    log "\\n=== Backing up original archives ==="
    
    # Backup ZIP files
    log "Backing up ZIP archives..."
    for zip in "${ROOT_DIR}"/*.zip; do
        if [ -f "$zip" ]; then
            cp "$zip" "${ARCHIVES_BACKUP}/original-zips/" 2>/dev/null && \
                log_success "Backed up: $(basename "$zip")" || \
                log_error "Failed to backup: $(basename "$zip")"
        fi
    done
    
    # Backup 7z files
    log "Backing up 7z archives..."
    for archive in "${ROOT_DIR}"/*.7z; do
        if [ -f "$archive" ]; then
            cp "$archive" "${ARCHIVES_BACKUP}/original-7z/" 2>/dev/null && \
                log_success "Backed up: $(basename "$archive")" || \
                log_error "Failed to backup: $(basename "$archive")"
        fi
    done
    
    # Backup RAR files
    log "Backing up RAR archives..."
    for archive in "${ROOT_DIR}"/*.rar; do
        if [ -f "$archive" ]; then
            cp "$archive" "${ARCHIVES_BACKUP}/original-rar/" 2>/dev/null && \
                log_success "Backed up: $(basename "$archive")" || \
                log_error "Failed to backup: $(basename "$archive")"
        fi
    done
}

################################################################################
# MAIN EXTRACTION WORKFLOW
################################################################################

extract_all_archives() {
    log "\\n=== EXTRACTING ALL ARCHIVES ==="
    
    # Process ZIP files
    log "\\n--- ZIP Archives ---"
    for zip in "${ROOT_DIR}"/*.zip; do
        if [ -f "$zip" ]; then
            extract_dir="${TEMP_EXTRACT}/$(basename "$zip" .zip)"
            mkdir -p "$extract_dir"
            extract_zip "$zip" "$extract_dir"
            extract_nested "$extract_dir" 0
        fi
    done
    
    # Process 7z files
    log "\\n--- 7z Archives ---"
    for archive in "${ROOT_DIR}"/*.7z; do
        if [ -f "$archive" ]; then
            extract_dir="${TEMP_EXTRACT}/$(basename "$archive" .7z)"
            mkdir -p "$extract_dir"
            extract_7z "$archive" "$extract_dir"
            extract_nested "$extract_dir" 0
        fi
    done
    
    # Process RAR files
    log "\\n--- RAR Archives ---"
    for archive in "${ROOT_DIR}"/*.rar; do
        if [ -f "$archive" ]; then
            extract_dir="${TEMP_EXTRACT}/$(basename "$archive" .rar)"
            mkdir -p "$extract_dir"
            extract_rar "$archive" "$extract_dir"
            extract_nested "$extract_dir" 0
        fi
    done
    
    log_success "Extraction complete! Extracted $EXTRACTED_COUNT archives"
}

################################################################################
# VERIFICATION FUNCTIONS
################################################################################

verify_organization() {
    log "\\n=== VERIFYING ASSET ORGANIZATION ==="
    
    # Count files in each category
    for category in tilesets sprites interiors ui props effects; do
        local count=$(find "${ASSETS_DIR}/${category}" -type f 2>/dev/null | wc -l)
        if [ "$count" -gt 0 ]; then
            log_success "$category: $count files"
        fi
    done
}

generate_summary() {
    log "\\n=== GENERATION COMPREHENSIVE SUMMARY ==="
    
    {
        echo "================================"
        echo "ASSET EXTRACTION SUMMARY"
        echo "================================"
        echo "Date: $(date)"
        echo "Root Directory: $ROOT_DIR"
        echo ""
        echo "EXTRACTION STATISTICS:"
        echo "  - Archives Extracted: $EXTRACTED_COUNT"
        echo "  - Files Organized: $ORGANIZED_COUNT"
        echo "  - Errors Encountered: $ERROR_COUNT"
        echo ""
        echo "DIRECTORY STRUCTURE:"
        find "${ASSETS_DIR}" -maxdepth 2 -type d | sort
        echo ""
        echo "FILE COUNTS BY CATEGORY:"
        for category in tilesets sprites interiors ui props effects; do
            local count=$(find "${ASSETS_DIR}/${category}" -type f 2>/dev/null | wc -l)
            echo "  - $category: $count files"
        done
        echo ""
        echo "DETAILED FILE LISTING:"
        echo "================================"
        find "${ASSETS_DIR}" -type f | sort
    } | tee -a "${LOG_FILE}"
}

################################################################################
# CLEANUP FUNCTION
################################################################################

cleanup() {
    log "\\n=== CLEANUP ==="
    
    # Remove temporary extraction directory
    if [ -d "${TEMP_EXTRACT}" ]; then
        log "Removing temporary extraction directory..."
        rm -rf "${TEMP_EXTRACT}"
        log_success "Temporary files cleaned up"
    fi
}

################################################################################
# MAIN EXECUTION
################################################################################

main() {
    clear
    
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║   GAME ASSET EXTRACTION & ORGANIZATION SCRIPT v1.0         ║"
    echo "║   Processing 27+ Archives (ZIP, 7z, RAR)                   ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    log "Starting asset extraction and organization process..."
    log "Log file: $LOG_FILE"
    log "Inventory file: $INVENTORY_FILE"
    
    # Initialize inventory
    > "${INVENTORY_FILE}"
    
    # Execute workflow
    check_requirements
    backup_archives
    extract_all_archives
    organize_png_files
    organize_extracted_files
    verify_organization
    generate_summary
    cleanup
    
    # Final status
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   ✓ EXTRACTION AND ORGANIZATION COMPLETE!                  ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Statistics:"
    echo "  - Archives Extracted: $EXTRACTED_COUNT"
    echo "  - Files Organized: $ORGANIZED_COUNT"
    echo "  - Errors: $ERROR_COUNT"
    echo ""
    echo "Output Files:"
    echo "  - Log: $(basename "$LOG_FILE")"
    echo "  - Inventory: $(basename "$INVENTORY_FILE")"
    echo ""
    echo "Next Steps:"
    echo "  1. Review: cat $LOG_FILE"
    echo "  2. Verify: ls -la ASSETS/"
    echo "  3. Backup originals are in: ARCHIVES/"
}

# Run main if script is executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
