#!/usr/bin/env python3
"""
macOS System Theme Watcher for Kitty & NvChad
Monitors system appearance changes and triggers theme switching scripts automatically
"""

import subprocess
import time
import os
import sys
from pathlib import Path

class SystemThemeWatcher:
    def __init__(self):
        self.current_theme = self.get_current_theme()
        self.theme_script = Path.home() / ".config/dotfiles/kitty/theme-switcher.sh"
        
        # Ensure script is executable
        if self.theme_script.exists():
            os.chmod(self.theme_script, 0o755)
        else:
            print(f"Error: Theme script not found at {self.theme_script}")
            sys.exit(1)
            
        print(f"🎨 Starting theme watcher. Current system theme: {self.current_theme}")
        
    def get_current_theme(self):
        """Check current macOS appearance setting"""
        try:
            result = subprocess.run(
                ["defaults", "read", "-g", "AppleInterfaceStyle"],
                capture_output=True,
                text=True,
                check=False
            )
            return "dark" if "Dark" in result.stdout else "light"
        except Exception:
            return "light"  # Default to light if unable to detect
    
    def switch_theme(self, theme):
        """Execute theme switching script"""
        try:
            print(f"🔄 System switched to {theme} mode. Updating kitty and Neovim themes...")
            
            # Run the theme-switcher script in auto mode
            # This detects system theme and applies appropriate kitty/nvim themes
            result = subprocess.run(
                [str(self.theme_script), "auto"], 
                capture_output=True,
                text=True,
                check=False
            )
            
            if result.returncode == 0:
                print(f"✅ Successfully switched to {theme} theme")
                # Print the kitty theme that was selected
                output_lines = result.stdout.strip().split('\n')
                if output_lines:
                    kitty_theme = output_lines[0]
                    print(f"   Kitty: {kitty_theme}")
                    
                # Find NvChad theme from output
                for line in output_lines:
                    if "NvChad theme updated to:" in line:
                        nvchad_theme = line.split(": ")[1]
                        print(f"   NvChad: {nvchad_theme}")
                        break
            else:
                print(f"❌ Error switching theme: {result.stderr}")
                
        except Exception as e:
            print(f"❌ Exception switching theme: {e}")
    
    def watch(self, poll_interval=1):
        """Watch for theme changes"""
        print(f"👀 Monitoring system theme changes (polling every {poll_interval}s)")
        print("   Press Ctrl+C to stop")
        print()
        
        try:
            while True:
                new_theme = self.get_current_theme()
                if new_theme != self.current_theme:
                    print(f"🌓 Theme change detected: {self.current_theme} → {new_theme}")
                    self.current_theme = new_theme
                    self.switch_theme(new_theme)
                    print()
                
                time.sleep(poll_interval)
                
        except KeyboardInterrupt:
            print("\\n🛑 Stopping theme watcher...")
            sys.exit(0)
        except Exception as e:
            print(f"❌ Error in theme watcher: {e}")
            sys.exit(1)

def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(description="Monitor macOS system theme and auto-switch kitty/nvim themes")
    parser.add_argument("--interval", "-i", type=float, default=1, 
                       help="Polling interval in seconds (default: 1)")
    parser.add_argument("--test", "-t", action="store_true",
                       help="Test current theme detection and exit")
    
    args = parser.parse_args()
    
    watcher = SystemThemeWatcher()
    
    if args.test:
        print(f"Current system theme: {watcher.current_theme}")
        print("Testing theme switch...")
        watcher.switch_theme(watcher.current_theme)
        return
    
    watcher.watch(args.interval)

if __name__ == "__main__":
    main()