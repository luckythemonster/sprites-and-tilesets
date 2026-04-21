# Usage Guide

## Getting Started

### Quick Start
1. Browse ASSETS/ folder for organized asset categories
2. Tilesets are in ASSETS/tilesets/
3. Individual sprites are in ASSETS/sprites/
4. Interior decorations are in ASSETS/interiors/

### For Game Engines

#### Unity
- Import sprite/tileset folders directly into Assets/
- Use TextureImporter settings for pixel-perfect rendering
- Recommended TilePaletteSize: 16x16 pixels

#### Godot
- Drag and drop sprites into scenes
- Use TileMap nodes with tilesets
- Configure collision layers as needed

#### LibGDX / Other
- Copy tileset/sprite files to assets folder
- Use individual PNG files or sprite sheets
- Recommended: 16x16, 32x32 pixel sizes

## Best Practices

### Tile-Based Creation
1. Choose a tileset (e.g., ditharts-sci-fi-free)
2. Use TileMap tools in your engine
3. Layer multiple tilesets for complex scenes

### Sprite Animation
1. Extract individual sprites from sheets
2. Group frames by animation sequence
3. Configure animation speed (typically 8-10 FPS for retro)

### Color Schemes
- Cyberpunk: Neon colors (cyan, magenta, yellow on dark backgrounds)
- Sci-Fi: Cool tones (blues, grays, silvers)
- Nature: Warm tones (greens, browns, oranges)

## File Organization

Each tileset/sprite pack contains:
- PNG/image files (the actual assets)
- Documentation (if included)
- Metadata (size, colors, etc.)

## Batch Integration

To use all tilesets at once:
1. Create a "Master Tileset" folder
2. Copy all individual tiles into one palette
3. Reference from project configuration

## Troubleshooting

### Assets appear pixelated
- Check image scaling in game engine
- Use "Point" filtering instead of "Linear"
- Verify resolution matches original (usually 16x16 pixels)

### Assets look washed out
- Check color profile (should be sRGB)
- Verify no color correction is applied globally
- Check lighting/shader settings

### Can't find specific asset
- Search DOCUMENTATION/ASSET_INVENTORY.md
- Check all tilesets in sci-fi-basic-battlefields
- Check cyberpunk folder for neon-themed assets

## Performance Tips

- Batch similar tiles together
- Use sprite atlases for complex scenes
- Compress PNG files before final build
- Consider using 8-bit color depth for mobile

## Customization

### Recoloring Sprites
- Use hue-shift tools in image editor
- Create theme variants (dark/light mode)
- Consider weapon/armor color variations

### Combining Tilesets
- Import multiple tilesets into single project
- Create composite scenes mixing themes
- Use layers to manage complexity

---

For more information, see ASSET_INVENTORY.md
