#!/usr/bin/env python3
"""
ASSET EXTRACTION PREVIEW & ANALYSIS TOOL
Analyzes archive contents and predicts categorization without extracting
"""

import os
import sys
import zipfile
import json
from pathlib import Path
from collections import defaultdict
from datetime import datetime

class AssetAnalyzer:
    def __init__(self, root_dir):
        self.root_dir = Path(root_dir)
        self.archives = {
            'zip': [],
            '7z': [],
            'rar': [],
            'png': []
        }
        self.file_categories = defaultdict(list)
        self.stats = {
            'total_archives': 0,
            'total_predicted_files': 0,
            'by_type': defaultdict(int),
            'by_category': defaultdict(int)
        }
        
    def find_all_archives(self):
        """Find all archive and image files"""
        print("\n" + "="*70)
        print("SCANNING FOR ARCHIVES AND IMAGES")
        print("="*70)
        
        for file in self.root_dir.glob('*'):
            if file.is_file():
                if file.suffix.lower() == '.zip':
                    self.archives['zip'].append(file)
                elif file.suffix.lower() == '.7z':
                    self.archives['7z'].append(file)
                elif file.suffix.lower() == '.rar':
                    self.archives['rar'].append(file)
                elif file.suffix.lower() == '.png':
                    self.archives['png'].append(file)
        
        print(f"✓ Found {len(self.archives['zip'])} ZIP archives")
        print(f"✓ Found {len(self.archives['7z'])} 7z archives")
        print(f"✓ Found {len(self.archives['rar'])} RAR archives")
        print(f"✓ Found {len(self.archives['png'])} PNG images")
    
    def categorize_asset(self, filename):
        """Predict category based on filename"""
        name_lower = filename.lower()
        
        # Tileset categories
        if any(word in name_lower for word in ['tileset', 'tile', 'map', 'terrain']):
            if any(word in name_lower for word in ['cyb', 'cyber', 'punk', 'neon']):
                return 'tilesets/cyberpunk'
            elif any(word in name_lower for word in ['scifi', 'sci-fi', 'space', 'station', 'facility']):
                return 'tilesets/sci-fi'
            elif any(word in name_lower for word in ['dungeon', 'cave', 'dark', 'tech']):
                return 'tilesets/dungeons'
            elif any(word in name_lower for word in ['city', 'urban', 'building', 'town']):
                return 'tilesets/city'
            elif any(word in name_lower for word in ['topdown', 'top-down', '2d', 'top']):
                return 'tilesets/topdown'
            elif any(word in name_lower for word in ['cursed', 'land', 'nature', 'forest']):
                return 'tilesets/fantasy'
            else:
                return 'tilesets/misc'
        
        # Character/Sprite categories
        elif any(word in name_lower for word in ['character', 'sprite', 'avatar', 'player', 'npc']):
            if any(word in name_lower for word in ['cyb', 'cyber', 'punk']):
                return 'sprites/cyberpunk'
            else:
                return 'sprites/characters'
        
        # Environment
        elif any(word in name_lower for word in ['environment', 'prop', 'object', 'item']):
            return 'sprites/environment'
        
        # Interior
        elif any(word in name_lower for word in ['interior', 'room', 'furniture', 'inside', 'indoor']):
            return 'interiors'
        
        # UI
        elif any(word in name_lower for word in ['ui', 'hud', 'button', 'menu', 'interface']):
            return 'ui'
        
        # Effects
        elif any(word in name_lower for word in ['effect', 'particle', 'animation', 'magic']):
            return 'effects'
        
        else:
            return 'props'
    
    def analyze_zip(self, zip_path):
        """Analyze contents of ZIP file (non-destructive)"""
        try:
            with zipfile.ZipFile(zip_path, 'r') as zf:
                files = zf.namelist()
                image_files = [f for f in files if f.lower().endswith(('.png', '.jpg', '.jpeg', '.gif'))]
                data_files = [f for f in files if f.lower().endswith(('.json', '.tsx', '.tmx', '.txt'))]
                
                return {
                    'total': len(files),
                    'images': len(image_files),
                    'data': len(data_files),
                    'sample_files': image_files[:5] if image_files else files[:5]
                }
        except Exception as e:
            return {'error': str(e)}
    
    def generate_preview(self):
        """Generate categorization preview"""
        print("\n" + "="*70)
        print("ARCHIVE CONTENTS PREVIEW & CATEGORIZATION")
        print("="*70)
        
        # Analyze ZIP files
        if self.archives['zip']:
            print("\n📦 ZIP ARCHIVES:")
            print("-" * 70)
            for zip_file in sorted(self.archives['zip']):
                category = self.categorize_asset(zip_file.stem)
                info = self.analyze_zip(zip_file)
                
                print(f"\n  {zip_file.name}")
                print(f"    Size: {zip_file.stat().st_size / (1024**2):.2f} MB")
                if 'error' not in info:
                    print(f"    Files: {info['total']} (📷 {info['images']} images, 📄 {info['data']} data)")
                    print(f"    Samples: {', '.join(info['sample_files'][:3])}")
                print(f"    → {category}/")
                
                self.file_categories[category].append(zip_file.name)
                self.stats['by_category'][category] += info.get('total', 0)
        
        # Analyze 7z files
        if self.archives['7z']:
            print("\n\n📦 7Z ARCHIVES:")
            print("-" * 70)
            for archive in sorted(self.archives['7z']):
                category = self.categorize_asset(archive.stem)
                size_mb = archive.stat().st_size / (1024**2)
                print(f"\n  {archive.name}")
                print(f"    Size: {size_mb:.2f} MB (will be extracted)")
                print(f"    → {category}/")
                self.file_categories[category].append(archive.name)
        
        # Analyze RAR files
        if self.archives['rar']:
            print("\n\n📦 RAR ARCHIVES:")
            print("-" * 70)
            for archive in sorted(self.archives['rar']):
                category = self.categorize_asset(archive.stem)
                size_mb = archive.stat().st_size / (1024**2)
                print(f"\n  {archive.name}")
                print(f"    Size: {size_mb:.2f} MB (will be extracted)")
                print(f"    → {category}/")
                self.file_categories[category].append(archive.name)
        
        # Analyze PNG files
        if self.archives['png']:
            print("\n\n🖼️  STANDALONE IMAGES:")
            print("-" * 70)
            for png_file in sorted(self.archives['png']):
                category = self.categorize_asset(png_file.stem)
                size_kb = png_file.stat().st_size / 1024
                print(f"\n  {png_file.name}")
                print(f"    Size: {size_kb:.1f} KB")
                print(f"    → {category}/")
                self.file_categories[category].append(png_file.name)
    
    def generate_organization_chart(self):
        """Generate predicted folder structure"""
        print("\n" + "="*70)
        print("PREDICTED ORGANIZATION STRUCTURE")
        print("="*70)
        
        # Build hierarchy
        hierarchy = defaultdict(lambda: defaultdict(list))
        
        for category, files in sorted(self.file_categories.items()):
            parts = category.split('/')
            if len(parts) == 2:
                main, sub = parts
                for f in files:
                    hierarchy[main][sub].append(f)
            else:
                for f in files:
                    hierarchy[category]['.'].append(f)
        
        # Print tree
        for main_cat in sorted(hierarchy.keys()):
            print(f"\nASSETS/{main_cat}/")
            subs = hierarchy[main_cat]
            for sub_cat in sorted(subs.keys()):
                if sub_cat == '.':
                    for file in sorted(subs[sub_cat])[:3]:
                        print(f"  ├── {file}")
                    remaining = len(subs[sub_cat]) - 3
                    if remaining > 0:
                        print(f"  └── ... and {remaining} more files")
                else:
                    files = subs[sub_cat]
                    print(f"  ├── {sub_cat}/ ({len(files)} files)")
                    for file in sorted(files)[:2]:
                        print(f"  │   ├── {file}")
                    if len(files) > 2:
                        print(f"  │   └── ... and {len(files)-2} more files")
    
    def generate_statistics(self):
        """Generate extraction statistics"""
        print("\n" + "="*70)
        print("EXTRACTION STATISTICS")
        print("="*70)
        
        total_archives = len(self.archives['zip']) + len(self.archives['7z']) + len(self.archives['rar'])
        
        print(f"\nArchives to Extract:")
        print(f"  ZIP files:   {len(self.archives['zip']):>3}")
        print(f"  7z files:    {len(self.archives['7z']):>3}")
        print(f"  RAR files:   {len(self.archives['rar']):>3}")
        print(f"  PNG images:  {len(self.archives['png']):>3}")
        print(f"  {'─'*25}")
        print(f"  Total:       {total_archives + len(self.archives['png']):>3} items")
        
        # Calculate total sizes
        total_size = 0
        for archive_list in self.archives.values():
            for file in archive_list:
                total_size += file.stat().st_size
        
        print(f"\nTotal Data Size: {total_size / (1024**3):.2f} GB")
        
        print(f"\nOrganization Summary:")
        for category in sorted(self.file_categories.keys()):
            count = len(self.file_categories[category])
            print(f"  {category:.<35} {count:>3} archives")
        
        print(f"\nExpected Processing Time:")
        print(f"  Extraction:  1-2 minutes")
        print(f"  Organizing: 1-2 minutes")
        print(f"  Total:      2-3 minutes")
    
    def export_json(self, output_file):
        """Export analysis data as JSON"""
        data = {
            'timestamp': datetime.now().isoformat(),
            'root_directory': str(self.root_dir),
            'archives': {
                'zip': [str(f) for f in self.archives['zip']],
                '7z': [str(f) for f in self.archives['7z']],
                'rar': [str(f) for f in self.archives['rar']],
                'png': [str(f) for f in self.archives['png']]
            },
            'categorization': {
                category: files 
                for category, files in sorted(self.file_categories.items())
            }
        }
        
        with open(output_file, 'w') as f:
            json.dump(data, f, indent=2)
        
        print(f"\n✓ Analysis exported to: {output_file}")
    
    def run_full_analysis(self):
        """Execute complete analysis"""
        print("\n" + "="*70)
        print("ASSET EXTRACTION PREVIEW & ANALYSIS")
        print(f"Directory: {self.root_dir}")
        print(f"Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print("="*70)
        
        self.find_all_archives()
        self.generate_preview()
        self.generate_organization_chart()
        self.generate_statistics()
        
        # Export JSON
        output_json = self.root_dir / f"extraction_preview_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        self.export_json(output_json)
        
        print("\n" + "="*70)
        print("NEXT STEPS:")
        print("-" * 70)
        print("1. Review this preview to verify categorization")
        print("2. Make script executable: chmod +x extract_and_organize_complete.sh")
        print("3. Run extraction:          ./extract_and_organize_complete.sh")
        print("4. Monitor progress:        tail -f extraction_manifest_*.log")
        print("="*70)


def main():
    root_dir = Path('/workspaces/sprites-and-tilesets')
    
    if not root_dir.exists():
        print(f"Error: Directory not found: {root_dir}")
        sys.exit(1)
    
    analyzer = AssetAnalyzer(root_dir)
    analyzer.run_full_analysis()


if __name__ == '__main__':
    main()
