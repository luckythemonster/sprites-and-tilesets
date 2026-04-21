#!/bin/bash

# Organize original archive files into theme-based folders
cd /workspaces/sprites-and-tilesets

echo "================================"
echo "ORGANIZING ARCHIVE FILES"
echo "================================"
echo

# Create theme-based archive folders
mkdir -p archives-cyberpunk
mkdir -p archives-scifi
mkdir -p archives-characters
mkdir -p archives-tilesets
mkdir -p archives-dungeons
mkdir -p archives-environments
mkdir -p archives-misc

echo "[1/2] Moving archives to organized folders..."
echo

# Cyberpunk archives
for file in CyberPunk*.zip CP_V1*.zip cyb*.7z; do
    [ -f "$file" ] && mv "$file" archives-cyberpunk/ && echo "✓ $file → archives-cyberpunk/"
done

# Sci-Fi archives
for file in Sci-Fi*.zip *spacestation*.zip *facility*.zip *INTERIOR*.zip; do
    [ -f "$file" ] && mv "$file" archives-scifi/ && echo "✓ $file → archives-scifi/"
done

# Character & Avatar archives
for file in *Character*.zip *Eris*.zip *template*.zip Diceforce*.zip *1bit*.7z; do
    [ -f "$file" ] && mv "$file" archives-characters/ && echo "✓ $file → archives-characters/"
done

# Tileset archives
for file in *Ditharts*.zip *neo_zero*.zip *TileMap*.zip; do
    [ -f "$file" ] && mv "$file" archives-tilesets/ && echo "✓ $file → archives-tilesets/"
done

# Dungeon archives
for file in *Dungeon*.zip *Tech*.zip *Roguelike*.zip; do
    [ -f "$file" ] && mv "$file" archives-dungeons/ && echo "✓ $file → archives-dungeons/"
done

# Environment/City archives
for file in *Cursed*.zip *City*.rar *city*.zip *Ranitaya*.zip; do
    [ -f "$file" ] && mv "$file" archives-environments/ && echo "✓ $file → archives-environments/"
done

# Catch remaining
for file in *.zip *.7z *.rar; do
    [ -f "$file" ] && mv "$file" archives-misc/ && echo "✓ $file → archives-misc/"
done

# Move images to separate folder
mkdir -p archives-images
for file in *.png *.tsx; do
    [ -f "$file" ] && mv "$file" archives-images/ && echo "✓ $file → archives-images/"
done

echo
echo "[2/2] Summary:"
echo "================================"
find archives-* -type f | while read dir; do
    folder=$(dirname "$dir")
    count=$(find "$folder" -type f | wc -l)
    echo "$folder: $count files"
done | sort | uniq -c | sort -rn

echo
echo "Total organized:"
find archives-* -type f | wc -l | xargs echo "  Files:"

echo
echo "✓ ARCHIVE ORGANIZATION COMPLETE"
echo "================================"
