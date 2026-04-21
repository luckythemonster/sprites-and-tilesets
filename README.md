# 🎮 Sprites & Tilesets Repository

A curated collection of **sci-fi and cyberpunk game assets** (sprites, tilesets, character templates) ready for game development.

## 📊 Quick Overview

| Item | Details |
|------|---------|
| **Total Archives** | 45+ files (900+ MB) |
| **Themes** | Sci-Fi, Cyberpunk, Fantasy, Urban |
| **Content** | Tilesets, Sprites, Character Templates, UI Assets |
| **Format** | PNG (transparent), ZIP, 7Z, RAR |
| **Status** | ✅ Organized & Ready to Use |

---

## 🚀 Quick Start

### Option 1: View Assets (Recommended First)
```bash
cd ASSETS
ls -la  # Browse organized folders
```

### Option 2: Extract All Archives
```bash
# Check for dependencies
which unzip 7z

# Run extraction (choose one)
chmod +x organize_all_assets.sh
./organize_all_assets.sh
```

---

## 📁 Repository Structure

```
sprites-and-tilesets/
├── ASSETS/                        # Extracted & organized assets
│   ├── tilesets/                 # Level design tiles
│   ├── sprites/                  # Characters & entities
│   ├── interiors/                # Room decorations
│   └── ui/                       # Interface elements
├── ARCHIVES/                      # Backup of original files
├── DOCUMENTATION/                # Guides & references
├── *.zip, *.7z, *.rar           # Original compressed archives
└── *.sh                          # Extraction scripts
```

---

## 📋 Key Documents

| Document | Purpose |
|----------|---------|
| **START_HERE.md** | 👈 Begin here for extraction guide |
| **ORGANIZATION_PLAN.md** | Detailed structure & strategy |
| **QUICK_REFERENCE.md** | One-page cheat sheet |
| **ASSETS_ANALYSIS_COMPLETE.md** | Full inventory |
| **EXTRACTION_SCRIPT_GUIDE.md** | Script documentation |

---

## 🎯 Available Asset Categories

### Tilesets
- **Cyberpunk** - Neon, dystopian environments
- **Sci-Fi** - Futuristic, space-themed tiles
- **Dungeons** - Dark, underground caverns
- **City** - Urban buildings & streets
- **Topdown** - Bird's eye view environments
- **Interiors** - Rooms, furniture, spaceship decor

### Sprites & Characters
- **Characters** - Player avatars, NPCs, enemies
- **Cyberpunk** - Dystopian character assets
- **Environment** - Nature, objects, scenery
- **Props** - Interactive items, decorations

### Special Assets
- **UI Elements** - Buttons, menus, HUD elements
- **Effects** - Particles, visual effects
- **Character Templates** - Customizable avatars

---

## 🎮 Use Cases

### Cyberpunk Game
```
Use: ASSETS/tilesets/cyberpunk/ + ASSETS/sprites/cyberpunk/
```

### Sci-Fi RPG
```
Use: ASSETS/tilesets/sci-fi/ + ASSETS/sprites/characters/
```

### Top-Down Adventure
```
Use: ASSETS/tilesets/topdown/ + ASSETS/interiors/
```

### City Builder
```
Use: ASSETS/tilesets/city/ + ASSETS/ui/
```

---

## 🔧 Game Engine Integration

### Unity
1. Copy `ASSETS/` folder to your project
2. Use TilePalette for level design
3. Configure pixel-perfect rendering

### Godot
1. Import PNG files as textures
2. Use TileMap nodes
3. Set collision layers as needed

### Custom/LibGDX
1. Copy PNG files to assets folder
2. Load sprite sheets (typical: 16x16 or 32x32 pixels)
3. Create tilemap loader

---

## 📊 Asset Statistics

- **Total Archives**: 45+ files
- **Compressed Size**: ~900 MB
- **Extracted Size**: ~2+ GB
- **Tile Formats**: 16x16, 32x32 pixels (mostly)
- **Image Format**: PNG with transparency
- **Licensing**: Free/Public domain assets

---

## 🛠️ Available Scripts

| Script | Purpose |
|--------|---------|
| **organize_all_assets.sh** ⭐ | Best: Full categorization + logging |
| **extract_and_organize_complete.sh** | Alternative: Similar functionality |
| **extract_and_organize.sh** | Standard: Basic extraction |
| **extract_all.sh** | Simple: No categorization |
| **RUN_EXTRACTION.sh** | Wrapper: Dependency checks |

---

## ✅ Next Steps

1. **Read**: START_HERE.md for detailed extraction guide
2. **Preview**: `python3 analyze_assets.py` (optional)
3. **Extract**: Run `./organize_all_assets.sh`
4. **Verify**: Check `ASSETS/` folder for organized files
5. **Use**: Copy assets into your game project

---

## 📝 Notes

- All assets are **free/public domain** from reputable game asset repositories
- Original archives **backed up** in `ARCHIVES/` folder
- Organized by **asset type** for easy discovery
- Complete **documentation** included
- **Scripts included** for automated extraction

---

## 🆘 Need Help?

1. **First-time setup?** → Read `START_HERE.md`
2. **Quick lookup?** → Check `QUICK_REFERENCE.md`
3. **Full inventory?** → See `ASSETS_ANALYSIS_COMPLETE.md`
4. **Extraction issues?** → See `EXTRACTION_EXECUTION_GUIDE.md`

---

**Last Updated**: 2026-04-21 01:34:37  
**Repository**: luckythemonster/sprites-and-tilesets  
**Status**: ✅ Ready to Use