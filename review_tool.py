#!/usr/bin/env python3
"""Aristotle Project Review Tool - Summarize, name, and analyze projects."""

import os
import json
import re
from pathlib import Path
from collections import defaultdict, Counter

PROJECTS_DIR = Path("/home/mdupont/projects/aristotle_results")


def extract_project_id(dir_name):
    """Extract UUID from directory name ending with _aristotle"""
    return dir_name.replace("_aristotle", "")


def extract_keywords(content):
    """Extract technical/domain keywords from text"""
    patterns = {
        "mathlib": re.findall(
            r"\b(?:mathlib|Lean|formal proof|sorry|axiom|lemma|theorem|proved|verified)\b",
            content,
            re.I,
        ),
        "group_theory": re.findall(
            r"\b(?:finite group|simple group|sporadic|monster|exponent|subgroup|character table)\b",
            content,
            re.I,
        ),
        "rust": re.findall(r"\b(?:rust|cargo|lake|lakefile)\b", content, re.I),
        "network": re.findall(
            r"\b(?:API|JSON|HTTP|REST|TCP|UDP|socket|peer)\b", content, re.I
        ),
        "trust": re.findall(
            r"\b(?:trust|certificate|grade|policy|refute|contest|signature)\b",
            content,
            re.I,
        ),
        "lean_files": re.findall(
            r"\b(?:lean\.toolchain|lakefile\.toml|mathlib-desc\.toml)\b", content
        ),
        "copied_files": re.findall(
            r"\b(?:README\.md|Makefile|\.gitignore|lean\.toml|flake\.nix)\b",
            content,
            re.I,
        ),
    }
    all_kw = []
    for p in patterns.values():
        all_kw.extend(p)
    return all_kw


def load_project_summary(project_path):
    """Load and analyze project summary"""
    summary_file = project_path / "ARISTOTLE_SUMMARY.md"
    status_file = project_path / "aristotle_status.json"

    summary = {
        "id": extract_project_id(project_path.name),
        "name": None,
        "description": "",
        "created": None,
        "updated": None,
        "status": None,
        "key_themes": [],
        "file_count": 0,
        "files": [],
        "top_keywords": [],
    }

    # Status metadata
    if status_file.exists():
        try:
            with open(status_file) as f:
                st = json.load(f)
                summary.update(
                    {
                        "created": st.get("created_at"),
                        "updated": st.get("last_updated"),
                        "status": st.get("status"),
                        "description_raw": st.get("description", ""),
                    }
                )
        except:
            pass

    # Summary content analysis
    themes = []
    desc = ""
    keywords = Counter()
    if summary_file.exists():
        try:
            with open(summary_file, encoding="utf-8") as f:
                content = f.read()
                first_lines = content.split("\n")[:3]
                desc = " ".join([l.strip() for l in first_lines if l.strip()])[:200]
                themes = re.findall(r"\*\*([^\*]+)\*\*", content)[:8]
                keywords.update(extract_keywords(content))
        except:
            pass

    # List files (top level only)
    files = []
    try:
        for f in sorted(project_path.iterdir()):
            files.append(f.name)
            if f.is_file():
                summary["file_count"] += 1
    except:
        pass

    # Apply summary fields
    summary["description"] = desc
    summary["key_themes"] = themes
    summary["files"] = files[:30]  # First 30 files
    summary["file_count"] = len(files)
    summary["top_keywords"] = [kw for kw, _ in keywords.most_common(8)]
    summary["suggested_name"] = suggest_project_name(summary, files)

    return summary


def suggest_project_name(summary, files):
    """Suggest descriptive project name based on content"""
    pid = summary["id"]
    desc_l = (summary["description"] + " " + " ".join(summary["key_themes"])).lower()
    file_str = " ".join(files).lower()

    # Check for known project types based on content
    if "jtable" in desc_l or "jtable" in file_str:
        return f"JTABLE-Numerics-{pid[:8]}"
    if "p2pis" in desc_l or "p2pis" in file_str:
        return f"P2PIS-Trust-Economics-{pid[:8]}"
    if "spectrum" in desc_l or "spectrum" in file_str:
        return f"SPECTRUM-Group-Theory-{pid[:8]}"
    if "axiom" in desc_l or "audit" in desc_l:
        return f"AXIOM-Audit-System-{pid[:8]}"
    if "crab" in desc_l or "crab" in file_str:
        return f"CRAB-Physics-Models-{pid[:8]}"
    if "rebase" in desc_l or "rebase" in file_str:
        return f"REBASE-Data-Processing-{pid[:8]}"
    if "lehner" in desc_l or "lehner" in file_str:
        return f"LEHNER-10000-Computing-{pid[:8]}"
    if "flying" in desc_l or "game" in desc_l or "rudder" in desc_l:
        return f"FLIGHT-Game-{pid[:8]}"
    if "infographics" in desc_l or "svg" in file_str.lower():
        return f"INFOGRAPHICS-Viz-{pid[:8]}"
    if "fold" in desc_l and "mathlib" not in desc_l:
        return f"DECL-FOLD-{pid[:8]}"
    if "complex" in desc_l or "quantization" in desc_l:
        return f"COMPLEX-Quantization-{pid[:8]}"

    # Fallback: use first meaningful theme
    if summary["key_themes"]:
        theme = summary["key_themes"][0].lower()
        clean = "".join(c for c in theme if c.isalnum() or c == " ")
        words = clean.split()[:2]
        name_part = "-".join(words).upper() or f"PROJECT"
        return f"{name_part}-{pid[:8]}"

    return f"PROJECT-{pid[:8]}"


def find_common_files(projects_dir):
    """Find files common across all projects (count basenames)"""
    common = defaultdict(int)
    total = 0
    for project_dir in projects_dir.glob("*_aristotle"):
        total += 1
        for f in project_dir.iterdir():
            if f.is_file():
                common[f.name] += 1
    return dict(common), total


def main():
    print("=" * 60)
    print("ARISTOTLE PROJECT REVIEW TOOL")
    print("=" * 60)

    # Get projects sorted by modification time (newest first)
    all_projects = sorted(
        PROJECTS_DIR.glob("*_aristotle"), key=lambda x: x.stat().st_mtime, reverse=True
    )
    print(f"\nTotal projects found: {len(all_projects)}")

    # Detailed review of newest 10 projects
    print("\n" + "-" * 60)
    print("NEWEST 10 PROJECTS - DETAILED REVIEW")
    print("-" * 60)

    results = []
    for pdir in all_projects[:10]:
        summary = load_project_summary(pdir)
        summary["suggested_name"] = suggest_project_name(summary, summary["files"])
        results.append(summary)

        print(f"\n{'=' * 60}")
        print(f"Project: {summary['id']}")
        print(f"Suggested Name: {summary['suggested_name']}")
        print(f"Created: {summary['created']}")
        print(f"Updated: {summary['updated']}")
        print(f"Status: {summary['status']}")
        print(f"File Count: {summary['file_count']}")
        print(f"\nDescription: {summary['description']}")
        print(f"\nKey Themes: {summary['key_themes']}")
        print(f"\nTop Keywords: {summary['top_keywords']}")
        print(f"\nSample Files: {summary['files'][:10]}")

    # Common files analysis across ALL projects
    print(f"\n{'=' * 60}")
    print(f"COMMON FILES ANALYSIS (across all {len(all_projects)} projects)")
    print(f"{'=' * 60}")

    common_files, total_proj = find_common_files(PROJECTS_DIR)
    sorted_common = sorted(common_files.items(), key=lambda x: -x[1])

    print(f"\nTop 20 most common files:")
    for name, count in sorted_common[:20]:
        pct = round(100 * count / total_proj, 1)
        print(f"  {count:4d} ({pct:5.1f}%)  {name}")

    # File categories
    print("\nFile category distribution:")
    categories = Counter()
    for name, count in common_files.items():
        ext = Path(name).suffix.lower() or "(no ext)"
        categories[ext] += 1
    for ext, cnt in categories.most_common(15):
        print(f"  {ext}: {cnt}")

    # Export results
    output_dir = Path("review_output")
    output_dir.mkdir(exist_ok=True)

    output = {
        "total_projects": len(all_projects),
        "newest_projects": results,
        "common_files_top50": sorted_common[:50],
        "file_categories": dict(categories),
    }

    with open(output_dir / "review_report.json", "w") as f:
        json.dump(output, f, indent=2)

    print(f"\nReview report saved to {output_dir / 'review_report.json'}")
    print("\nReview complete!")


if __name__ == "__main__":
    main()
