# Asset Repository Quick Reference

## At a Glance

| What | Where | Best For |
|------|-------|----------|
| Sci-Fi Battle Maps | `ASSETS/tilesets/sci-fi-basic-battlefields/` | Top-down RPGs |
| Cyberpunk Environments | `ASSETS/tilesets/cyberpunk/` | Dystopian games |
| Professional Tilesets | `ASSETS/tilesets/ditharts-sci-fi-free/` | Any sci-fi project |
| Interior Decoration | `ASSETS/interiors/Inside_C.png` | Spaceship/Building interiors |
| Characters & NPCs | `ASSETS/sprites/characters/` | Player characters, enemies |
| Environmental Sprites | `ASSETS/sprites/environment/` | Trees, rocks, scenery |
| Props & Objects | `ASSETS/sprites/props/` | Items, furniture, interactive |
| UI & Menus | `ASSETS/ui/` | HUD, buttons, interfaces |

## File Organization

```
Root Level:
├── README.md (complete overview)
├── ORGANIZATION_PLAN.md (full plan)
├── extract_all.sh (automation script)
├── ASSETS/ → organized asset files
├── ARCHIVES/ → original files backup
└── DOCUMENTATION/ → guides & reference
```

## Key Facts

- **Total Archives**: 6 files (mostly sci-fi/cyberpunk themed)
- **Inside_C.png**: Contains ~70 unique interior tiles
- **Theme**: Sci-Fi, Cyberpunk, Futuristic
- **Format**: PNG with transparency
- **Tile Size**: Typically 16x16 or 32x32 pixels
- **Status**: FREE/PUBLIC DOMAIN assets

## Extraction Commands (One-Liner)

```bash
cd /workspaces/sprites-and-tilesets && unzip -q "CyberPunk Asset Pack.zip" -d "ASSETS/tilesets/cyberpunk/" && unzip -q "Sci-Fi Asset Pack.zip" -d "ASSETS/sprites/environment/" && unzip -q "Sci-Fi_Basic_Battlefields.zip" -d "ASSETS/tilesets/sci-fi-basic-battlefields/" && unzip -q "Ditharts_Free_Scifi_Tileset_v01.zip" -d "ASSETS/tilesets/ditharts-sci-fi-free/" && 7z x "cyb assets.7z" -o"ASSETS/sprites/cyberpunk/" && mv Inside_C.png ASSETS/interiors/ && echo "✓ All assets extracted!"
```

## Most Useful Documents

1. **README.md** - Start here for overview
2. **DOCUMENTATION/USAGE_GUIDE.md** - Integration instructions
3. **DOCUMENTATION/EXTRACTION_INSTRUCTIONS.md** - How to extract
4. **DOCUMENTATION/ASSET_INVENTORY.md** - Complete catalog

## Project Recommendations

### Small Sci-Fi Game
- Use: sci-fi-basic-battlefields + interiors
- Skip: extra cyberpunk assets

### Cyberpunk RPG
- Use: cyberpunk tilesets + cyberpunk sprites
- Prioritize: neon/industrial aesthetic

### Complete Game
- Use: All tilesets + organize sprites by role
- Create: Master tilemap combining all themes

## Requirements for Extraction

| Tool | Platform |
|------|----------|
| `unzip` | Linux/macOS/Windows (via WSL) |
| `7z` | Install p7zip-full (Linux) or 7-zip (Windows/Mac) |

## Next Actions

1. ✓ Analysis complete
2. ✓ Structure created
3. ⏳ Extract archives (run extraction commands)
4. ⏳ Verify file organization
5. ⏳ Begin game development

---

**Status**: Organization structure and documentation complete
**TODO**: Extract archives to ASSETS/ folders
