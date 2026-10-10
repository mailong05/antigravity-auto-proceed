#!/usr/bin/env python3
"""
Antigravity Auto-Proceed Enabler (Cross-platform Python Version)
Works on Windows, macOS, and Linux.
"""

import json
import os
import shutil
import sys
from datetime import datetime
from pathlib import Path


def get_config_dir() -> Path:
    return Path.home() / ".gemini" / "config"


def patch_config(revert: bool = False):
    config_dir = get_config_dir()
    config_file = config_dir / "config.json"
    projects_dir = config_dir / "projects"

    target_policy = (
        "CASCADE_COMMANDS_AUTO_EXECUTION_OFF"
        if revert
        else "CASCADE_COMMANDS_AUTO_EXECUTION_EAGER"
    )
    mode_name = "RESTORE (OFF)" if revert else "ALWAYS PROCEED (EAGER)"

    print(f"=== Antigravity Config Patch [{mode_name}] ===")

    if not config_file.exists():
        print(f"[!] Config file not found at: {config_file}")
        print("[!] Please run Antigravity at least once first.")
        sys.exit(1)

    # 1. Backup
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = config_dir / f"config.json.bak_{timestamp}"
    shutil.copy2(config_file, backup_file)
    print(f"[+] Backup saved: {backup_file.name}")

    # 2. Patch global config
    try:
        with open(config_file, "r", encoding="utf-8") as f:
            data = json.load(f)

        if "userSettings" not in data:
            data["userSettings"] = {}

        data["userSettings"]["autoExecutionPolicy"] = target_policy

        with open(config_file, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)

        print(f"[v] Global config.json updated to: {target_policy}")
    except Exception as e:
        print(f"[!] Error modifying config.json: {e}")
        sys.exit(1)

    # 3. Patch project configs
    if projects_dir.exists():
        patched_count = 0
        for p_file in projects_dir.glob("*.json"):
            try:
                with open(p_file, "r", encoding="utf-8") as f:
                    p_data = json.load(f)

                if "settings" in p_data and isinstance(p_data["settings"], dict):
                    if "autoExecutionPolicy" in p_data["settings"]:
                        p_data["settings"]["autoExecutionPolicy"] = target_policy
                        with open(p_file, "w", encoding="utf-8") as f:
                            json.dump(p_data, f, indent=2, ensure_ascii=False)
                        patched_count += 1
            except Exception:
                pass
        if patched_count > 0:
            print(f"[v] Updated {patched_count} project config(s).")

    print("\n[SUCCESS] Configuration updated successfully!")
    print("[!] Please restart or reload Antigravity to apply changes.")


if __name__ == "__main__":
    is_revert = "--revert" in sys.argv
    patch_config(revert=is_revert)
