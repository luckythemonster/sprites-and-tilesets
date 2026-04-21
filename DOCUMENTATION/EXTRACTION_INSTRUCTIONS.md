# Extraction Instructions

If you need to manually extract the archives, use these commands:

## Linux/macOS

```bash
# Navigate to project directory
cd /workspaces/sprites-and-tilesets

# Extract zip files
unzip -q "CyberPunk Asset Pack.zip" -d "ASSETS/tilesets/cyberpunk/"
unzip -q "Sci-Fi Asset Pack.zip" -d "ASSETS/sprites/environment/"
unzip -q "Sci-Fi_Basic_Battlefields.zip" -d "ASSETS/tilesets/sci-fi-basic-battlefields/"
unzip -q "Ditharts_Free_Scifi_Tileset_v01.zip" -d "ASSETS/tilesets/ditharts-sci-fi-free/"

# Extract 7z file
7z x "cyb assets.7z" -o"ASSETS/sprites/cyberpunk/"

# Move original archives to backup location
mv "CyberPunk Asset Pack.zip" ARCHIVES/original-zips/
mv "Sci-Fi Asset Pack.zip" ARCHIVES/original-zips/
mv "Sci-Fi_Basic_Battlefields.zip" ARCHIVES/original-zips/
mv "Ditharts_Free_Scifi_Tileset_v01.zip" ARCHIVES/original-zips/
mv "cyb assets.7z" ARCHIVES/original-7z/

# Move PNG to interiors folder
mv Inside_C.png ASSETS/interiors/

# Verify extraction
echo "Assets extracted successfully!"
ls -la ASSETS/
```

## Windows PowerShell

```powershell
# Extract using built-in Expand-Archive (Windows 10+)
$source = "C:\path\to\sprites-and-tilesets"
cd $source

Expand-Archive -Path "CyberPunk Asset Pack.zip" -DestinationPath "ASSETS\tilesets\cyberpunk\"
Expand-Archive -Path "Sci-Fi Asset Pack.zip" -DestinationPath "ASSETS\sprites\environment\"
Expand-Archive -Path "Sci-Fi_Basic_Battlefields.zip" -DestinationPath "ASSETS\tilesets\sci-fi-basic-battlefields\"
Expand-Archive -Path "Ditharts_Free_Scifi_Tileset_v01.zip" -DestinationPath "ASSETS\tilesets\ditharts-sci-fi-free\"

# For 7z, use 7-Zip CLI or third-party tool
# 7z x "cyb assets.7z" -o"ASSETS\sprites\cyberpunk\"
```

## Installation Requirements

### Linux
```bash
# Install unzip if not present
sudo apt-get install unzip

# Install 7z support
sudo apt-get install p7zip-full
```

### macOS
```bash
# Using Homebrew
brew install p7zip
# unzip is included by default
```

### Windows
- Download [7-Zip](https://www.7-zip.org/) for .7z support
- Windows 10+ has built-in ZIP support
- Use WinRAR or similar for .7z files

## Verification

After extraction, verify the contents:

```bash
# List extracted assets
find ASSETS -type f | head -20

# Count total files
find ASSETS -type f | wc -l

# Check folder structure
tree ASSETS/ -L 2
```

---

**Note**: If terminal access in VS Code is unavailable, use your OS file manager or command line directly.
