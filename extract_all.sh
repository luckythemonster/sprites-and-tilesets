#!/bin/bash
cd /workspaces/sprites-and-tilesets

# Extract all zip files
for zip_file in *.zip; do
  echo "Extracting $zip_file..."
  unzip -q "$zip_file" -d "${zip_file%.zip}"
done

# Extract 7z file
echo "Extracting cyb assets.7z..."
7z x "cyb assets.7z" -o"cyb_assets"

echo "Extraction complete!"
ls -la
