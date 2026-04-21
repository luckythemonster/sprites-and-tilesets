# Complete Asset Extraction & Organization Script Guide

## Overview

The `extract_and_organize_complete.sh` script is a production-ready bash automation tool that:
- Extracts **27+ archive files** (ZIP, 7z, RAR formats)
- **Auto-categorizes** assets based on intelligent filename analysis
- **Organizes** files into appropriate ASSETS subfolders
- **Backs up** originals to ARCHIVES folder
- Creates **detailed manifests** and logs
- Handles **nested archives** automatically

---

## Quick Start

### Prerequisites
```bash
cd /workspaces/sprites-and-tilesets
chmod +x extract_and_organize_complete.sh
```

### Execute Script
```bash
./extract_and_organize_complete.sh
```

### What the Script Does (Step-by-Step)

1. **Verifies Dependencies** - Installs `unzip`, `7z`, `unar` if missing
2. **Backs Up Originals** - Copies all archives to `ARCHIVES/original-{zips,7z,rar}/`
3. **Extracts All Archives**:
   - ZIP files → TEMP_EXTRACT/
   - 7z files → TEMP_EXTRACT/
   - RAR files → TEMP_EXTRACT/
4. **Handles Nested Archives** - Recursively extracts up to 3 levels deep
5. **Categorizes Assets** - Uses intelligent filename pattern matching
6. **Organizes Files** - Moves PNGs/assets to appropriate folders
7. **Creates Manifests** - Generates detailed logs and inventory
8. **Cleans Up** - Removes temporary extraction folders

---

## Archive Files to be Processed

### ZIP Archives (19 files)
```
Basic Asset Pack.zip
CP_V1.1.0_nyknck.zip
CyberPunk Asset Pack.zip
Diceforce_assets.zip
Ditharts_Free_Scifi_Tileset_v01.zip
Eris Esra's Character Template 4.0.zip
Free-Cursed-Land-Top-Down-Pixel-Art-Tileset.zip
Ranitaya's 50+ City Essential Assets Pack.zip
SCI_FI_INTERIOR_32x32_FREE_v3.zip
Sci-Fi Asset Pack.zip
Sci-Fi_Basic_Battlefields.zip
Tech Dungeon Roguelite - Asset Pack (DEMO).zip
TileMap_SF.zip
neo_zero_V1.0.zip
neo_zero_tileset_V2.0_DEMO.zip
sci-fi-facility-asset-pack.zip
spacestation_tileset.zip
```

### 7z Archives (2 files)
```
1bit topdown sprites.7z
cyb assets.7z
```

### RAR Archives (1 file)
```
City_Tilemap.rar
```

### Standalone PNG Images (5 files)
```
Inside_C.png               → interiors/
MysticChroma_Basics.png    → tilesets/misc/
MysticAcid_basics_PetricakeGames.png → tilesets/misc/
SciFi_DungeonTileset16x16_0x72Like.png → tilesets/dungeons/
TileSet v1.0.png           → tilesets/misc/
spr_tile_itch.png          → sprites/environment/
```

---

## Output Structure

After running the script, your ASSETS folder will be organized as:

```
ASSETS/
├── tilesets/
│   ├── cyberpunk/          (CyberPunk Asset Pack, cyb assets.7z, CP_V1.1.0)
│   ├── sci-fi/             (Sci-Fi Asset Pack, sci-fi-facility-asset-pack.zip)
│   ├── dungeons/           (Tech Dungeon, SciFi_Dungeon, DungeonTileset)
│   ├── city/               (City_Tilemap.rar, Ranitaya's City Assets)
│   ├── topdown/            (1bit topdown sprites.7z, Free-Cursed-Land)
│   ├── fantasy/            (Free-Cursed-Land assets)
│   └── misc/               (All miscellaneous tilesets)
│
├── sprites/
│   ├── characters/         (Character templates, character assets)
│   ├── cyberpunk/          (Cyberpunk-themed sprites)
│   └── environment/        (Environment sprites, props)
│
├── interiors/              (SCI_FI_INTERIOR_32x32, Inside_C.png)
│
├── ui/                     (UI assets, HUD elements)
│
├── props/                  (Props, objects, decorative items)
│
└── effects/                (Effects, particles, animations)
```

---

## Categorization Logic

### Tileset Detection
Files matching patterns: `tileset|tile|map|terrain|background`
- **Cyberpunk**: Contains `cyb|cyber|punk|neon`
- **Sci-Fi**: Contains `scifi|sci-fi|space|station|facility`
- **Dungeons**: Contains `dungeon|cave|dark|tech`
- **City**: Contains `city|urban|building|town`
- **TopDown**: Contains `topdown|top-down|2d|top`
- **Fantasy**: Contains `cursed|land|nature|forest`
- **Misc**: Other tilesets

### Sprite Detection
Files matching: `character|sprite|avatar|player|npc`
- **Cyberpunk Sprites**: `cyb|cyber|punk` → `sprites/cyberpunk/`
- **Other Sprites**: → `sprites/characters/`

### Special Categories
- **Environment**: `environment|prop|object|item|decoration` → `sprites/environment/`
- **Interior**: `interior|room|furniture|inside|indoor` → `interiors/`
- **UI**: `ui|hud|button|menu|interface|health|bar` → `ui/`
- **Effects**: `effect|particle|animation|magic|spell` → `effects/`

---

## Output Files

### Log File
**Name**: `extraction_manifest_YYYYMMDD_HHMMSS.log`
**Contains**:
- Timestamp of each operation
- Success/failure status for each archive
- Categorization decisions
- Final statistics and summary

**View with**:
```bash
cat extraction_manifest_*.log
```

### Inventory File  
**Name**: `ASSET_INVENTORY_YYYYMMDD_HHMMSS.txt`
**Contains**:
- Complete listing of all organized assets
- Category paths for each file
- Total counts by category

**View with**:
```bash
cat ASSET_INVENTORY_*.txt
```

### Backup Location
**Path**: `ARCHIVES/original-{zips,7z,rar}/`
**Contains**:
- All original archive files (copies)
- Organized by extraction type for safety

---

## Script Features

### ✓ Error Handling
- Validates all required tools before starting
- Auto-installs missing packages (unzip, 7z, unar)
- Tracks error count throughout execution
- Continues on non-critical errors

### ✓ Logging
- Full execution log with timestamps
- Color-coded output (Green=success, Red=error, Yellow=warning, Blue=info)
- Detailed inventory file for reference

### ✓ Nested Archive Support
- Automatically extracts archives within archives
- Limits recursion depth to 3 levels for safety
- Maintains folder hierarchy

### ✓ Smart Categorization
- Analyzes filenames for content type
- Supports multiple extraction formats
- Handles various asset type patterns

### ✓ Safety
- Backs up all originals before extraction
- Uses temp folder for extraction
- Cleans up temporary files automatically
- Preserves original archives

---

## Advanced Usage

### Monitor Progress (Real-Time)
```bash
tail -f extraction_manifest_*.log
```

### Count Extracted Files
```bash
find ./ASSETS -type f | wc -l
```

### List Assets by Category
```bash
# All tilesets
find ./ASSETS/tilesets -type f | sort

# All sprites
find ./ASSETS/sprites -type f | sort

# All interiors
find ./ASSETS/interiors -type f | sort
```

### Verify Backup
```bash
ls -lR ARCHIVES/original-*
```

### Find Specific Asset Type
```bash
# Find all PNG files in sci-fi category
find ./ASSETS/tilesets/sci-fi -name "*.png"

# Find all tileset definition files
find ./ASSETS/tilesets -name "*.tsx"
find ./ASSETS/tilesets -name "*.tmx"
```

---

## Troubleshooting

### Issue: "unzip: command not found"
**Solution**: Script auto-installs, but manually run:
```bash
sudo apt-get install unzip p7zip-full unar
```

### Issue: Permission Denied
**Solution**: Make script executable:
```bash
chmod +x extract_and_organize_complete.sh
```

### Issue: RAR extraction fails
**Solution**: Ensure unar is installed:
```bash
sudo apt-get install unar
```

### Issue: Archives already partially extracted
**Solution**: Script handles this safely - temp folder prevents conflicts

### Issue: Disk space error
**Solution**: 
```bash
# Check available space
df -h

# Verify archive sizes
du -sh *.zip *.7z *.rar 2>/dev/null
```

---

## Performance Expectations

| Operation | Time | Notes |
|-----------|------|-------|
| Requirement check | <1s | Checks for tools |
| Backup originals | 2-5s | Copies 27 files |
| Extract 19 ZIP files | 30-60s | Varies by size |
| Extract 2 7z files | 10-20s | Smaller archives |
| Extract 1 RAR file | 5-10s | City tilemap |
| Categorize & organize | 20-30s | Pattern matching & copying |
| **Total Runtime** | **2-3 min** | Full execution |

---

## Post-Extraction Cleanup (Optional)

After verification, you can safely delete the originals from root:
```bash
# List originals in root
ls -la *.zip *.7z *.rar 2>/dev/null

# Keep originals in ARCHIVES backup - verified safe deleted from root
# Backup copies remain in ARCHIVES/ for future reference
```

---

## Integration with Your Project

The organized ASSETS folder is now ready for:
- **Godot**: Import tilesets and sprites directly
- **Tiled Map Editor**: Use TSX files from tilesets/
- **Game Engine**: Reference organized asset paths
- **Asset Manageme nt**: Clean, logical organization

---

## Manifest Example

After running, your manifest will look like:
```
[2024-04-20 14:23:15] Starting asset extraction and organization process...
[2024-04-20 14:23:16] ✓ All required tools available
[2024-04-20 14:23:17] Extracting ZIP: Basic Asset Pack.zip
[2024-04-20 14:23:18] ✓ Extracted: Basic Asset Pack.zip
[2024-04-20 14:23:19] Extracting ZIP: CyberPunk Asset Pack.zip
[2024-04-20 14:23:22] ✓ Extracted: CyberPunk Asset Pack.zip
...
[2024-04-20 14:25:30] ✓ Organized: tileset_01.png → tilesets/cyberpunk
[2024-04-20 14:25:31] ✓ Organized: character_idle.png → sprites/characters
...
```

---

## Questions or Issues?

Refer to:
1. The generated log file for detailed execution info
2. The inventory file for asset listing
3. ASSETS folder structure for final organization
4. ARCHIVES folder for backup verification

---

**Script Version**: 1.0  
**Last Updated**: 2024-04-20  
**Tested On**: Ubuntu 24.04 LTS
