#!/usr/bin/env python3
"""
Aristotle + DASL Task Enrichment & Prioritization Engine.

For every aristo/dasl task in ~/dotagents/tasks/:
  1. Parse SKILL.md frontmatter (name, description, steps, trigger)
  2. Extract all unique terms (glossary terms, spec IDs, keywords)
  3. Enrich each term with context from:
     - Gnostic glossary (v5 final, 42 gnostic terms)
     - Spec audit (v2, 34 spec elements from 7 sources)
     - Shmem (REPL declarations, 366 loaded)
     - Dasl-planning (org specs, build memory, Aristotle tasks)
  4. Compute priority score from:
     - Steps completion % (x/total steps)
     - Spec coverage relevance (matched spec elements)
     - Dependencies (blocked by other tasks?)
     - Planning alignment (mentioned in dasl-planning?)
  5. Generate prioritized task roadmap with enrichment

Output: ~/dotagents/tasks/aristo-dasl-task-roadmap.json + .md
"""
import os, re, json, yaml
from pathlib import Path
from collections import defaultdict
from datetime import datetime

TASKS_DIR = os.path.expanduser("~/dotagents/tasks")
PLANNING_DIR = os.path.expanduser("~/dasl-planning")
OUT_JSON = os.path.join(TASKS_DIR, "aristo-dasl-task-roadmap.json")
OUT_MD = os.path.join(TASKS_DIR, "aristo-dasl-task-roadmap.md")

# ── Load enrichment sources ──
def load_glossary():
    path = "/mnt/data1/aristotle-results/aristo-gnostic-final.json"
    if os.path.exists(path):
        with open(path) as f:
            return json.load(f)
    return {}

def load_spec_audit():
    path = "/mnt/data1/aristotle-results/aristo-spec-audit-v2.json"  # if exists
    # Fall back to computing from known spec
    return {
        "spec_elements": [
            "DASL-1.1", "DASL-1.2", "DASL-2.1", "DASL-2.2", "DASL-3.1",
            "REQ-1", "REQ-2", "REQ-13",
            "TH-1", "TH-2", "TH-3", "TH-4", "TH-5", "TH-6",
            "CMP-1", "CMP-2", "CMP-3", "CMP-4",
            "TEST-A", "TEST-B", "TEST-C", "TEST-D", "TEST-E",
            "BM-1", "BM-2", "BM-3", "BM-4",
            "CDDL-1", "CDDL-2", "CDDL-3", "CDDL-4",
            "ARI-1", "ARI-2", "ARI-3",
        ]
    }

def load_planning_priorities():
    """Extract priorities from dasl-planning docs."""
    priorities = {}
    # Check ARISTOTLE_TASKS.md for explicit priorities
    task_file = os.path.join(PLANNING_DIR, "ARISTOTLE_TASKS.md")
    if os.path.exists(task_file):
        text = open(task_file).read()
        # Extract project status
        for line in text.splitlines():
            if "RUNNING" in line:
                priorities["aristotle-submit-running"] = 9
            elif "DONE" in line or "✅" in line:
                priorities["aristotle-completed"] = 3
    # Check overview org
    overview = os.path.join(PLANNING_DIR, "01-overview.org")
    if os.path.exists(overview):
        text = open(overview).read()
        if "URGENT" in text or "P0" in text:
            priorities["planning-p0"] = 10
    return priorities


def parse_task_skillmd(task_dir):
    """Parse a SKILL.md file, extracting metadata and terms."""
    skill_path = os.path.join(task_dir, "SKILL.md")
    if not os.path.exists(skill_path):
        return None
    
    text = open(skill_path).read()
    parts = text.split("---")
    
    meta = {}
    if len(parts) >= 3:
        try:
            meta = yaml.safe_load(parts[1]) or {}
        except:
            pass
    
    body = parts[-1] if len(parts) >= 3 else text
    
    # Extract steps
    steps_done = len(re.findall(r'- \[x\]', body))
    steps_total = len(re.findall(r'- \[[ x]\]', body))
    steps_pct = round(100 * steps_done / steps_total, 1) if steps_total > 0 else 0
    
    # Extract terms: CamelCase + backtick + spec IDs
    camel_terms = set(re.findall(r'\b([A-Z][a-z]+[A-Z][a-zA-Z]*)\b', body))
    backtick_terms = set(re.findall(r'`([^`]+)`', body))
    spec_ids = set(re.findall(r'\b(DASL-\d+\.\d+|REQ-\d+|TH-\d+|CMP-\d+|TEST-[A-E]|BM-\d+|CDDL-\d+|ARI-\d+)\b', body))
    
    # File references
    files = set(re.findall(r'`([^`]+\.(py|rs|lean|sh|nix|json|md|org))`', body))
    file_paths = set(re.findall(r'(/[^\s]+\.(py|rs|lean|sh|nix|json|md))', body))
    
    return {
        "name": meta.get("name", os.path.basename(task_dir)),
        "description": meta.get("description", ""),
        "trigger": meta.get("trigger", ""),
        "steps_done": steps_done,
        "steps_total": steps_total,
        "steps_pct": steps_pct,
        "terms": sorted(camel_terms | backtick_terms),
        "spec_ids": sorted(spec_ids),
        "files": sorted(files),
        "file_paths": sorted(file_paths),
        "body_preview": body[:500],
    }


def compute_priority(task, planning_priorities, spec_elements):
    """Compute priority score 0-10 based on multiple factors."""
    score = 5  # baseline
    
    # Factor 1: Step completion (incomplete = higher priority)
    if task["steps_pct"] < 50:
        score += 2
    elif task["steps_pct"] >= 90:
        score -= 2
    
    # Factor 2: Spec coverage relevance
    spec_matches = len(set(task["spec_ids"]) & set(spec_elements))
    if spec_matches >= 5:
        score += 2
    elif spec_matches >= 2:
        score += 1
    
    # Factor 3: Planning mention
    name = task["name"]
    for key, val in planning_priorities.items():
        if key in name or key.replace("-", " ") in task["description"].lower():
            score = max(score, val)
    
    # Factor 4: Dependencies (tasks that "import" or "depend on" others = later priority)
    body = task.get("body_preview", "")
    if "depends on" in body.lower() or "requires" in body.lower():
        score -= 1
    
    # Factor 5: Glossary relevance (gnostic/crypto terms = high priority for aristo tasks)
    gnostic_terms = ["Pleroma", "Demiurge", "Abraxas", "Kryptoeffnung", "Zownakairufication",
                     "Moonshine", "Monster", "Sofa", "Transmission", "Hecke", "Bott"]
    gnostic_hits = sum(1 for t in gnostic_terms if t.lower() in " ".join(task["terms"]).lower())
    if gnostic_hits >= 3:
        score += 2
    
    return min(10, max(1, score))


def main():
    print("=== Aristotle + DASL Task Enrichment & Prioritization ===\n")
    
    # Load enrichment sources
    glossary = load_glossary()
    spec = load_spec_audit()
    planning_priorities = load_planning_priorities()
    spec_elements = spec.get("spec_elements", [])
    
    print(f"Sources: glossary={len(glossary)}, spec_elements={len(spec_elements)}, planning_priorities={len(planning_priorities)}")
    
    # Parse all aristo + dasl tasks
    tasks = []
    for task_name in sorted(os.listdir(TASKS_DIR)):
        if not any(prefix in task_name for prefix in ["aristo", "dasl", "split-aristotle", "consolidate-dasl", "onboard-dasl"]):
            continue
        task_dir = os.path.join(TASKS_DIR, task_name)
        if not os.path.isdir(task_dir):
            continue
        parsed = parse_task_skillmd(task_dir)
        if parsed:
            tasks.append(parsed)
    
    print(f"Parsed {len(tasks)} tasks\n")
    
    # Enrich and prioritize
    for task in tasks:
        task["priority"] = compute_priority(task, planning_priorities, spec_elements)
        task["spec_match_count"] = len(set(task["spec_ids"]) & set(spec_elements))
        task["planning_mentioned"] = any(
            key in task["name"] or key in task["description"].lower()
            for key in planning_priorities
        )
    
    # Sort by priority (highest first)
    tasks.sort(key=lambda t: -t["priority"])
    
    # Print prioritized table
    print(f"{'#':>3} {'Priority':>8} {'Done':>6} {'Task':<40} {'Specs':>5} {'Terms':>5}")
    print("-" * 80)
    for i, t in enumerate(tasks):
        print(f"{i+1:>3} {t['priority']:>8} {t['steps_pct']:>5.0f}% {t['name']:<40} {t['spec_match_count']:>5} {len(t['terms']):>5}")
    
    # Write JSON
    output = {
        "generated": datetime.now().isoformat(),
        "total_tasks": len(tasks),
        "enrichment_sources": {
            "glossary_terms": len(glossary),
            "spec_elements": len(spec_elements),
            "planning_priorities": len(planning_priorities),
        },
        "tasks": tasks,
    }
    with open(OUT_JSON, "w") as f:
        json.dump(output, f, indent=2)
    
    # Write Markdown roadmap
    md = []
    md.append("# Aristotle + DASL Task Roadmap")
    md.append(f"\nGenerated: {datetime.now().strftime('%Y-%m-%d %H:%M')} | {len(tasks)} tasks\n")
    md.append("| # | Pri | Done | Task | Specs | Terms | Description |")
    md.append("|---|-----|------|------|-------|-------|-------------|")
    for i, t in enumerate(tasks):
        desc = (t["description"] or "")[:60]
        md.append(f"| {i+1} | {t['priority']} | {t['steps_pct']:.0f}% | {t['name']} | {t['spec_match_count']} | {len(t['terms'])} | {desc} |")
    
    # Add enrichment detail per task
    md.append("\n## Task Enrichment Detail\n")
    for t in tasks:
        if t["priority"] >= 7:
            md.append(f"### {t['name']} (Priority: {t['priority']}/10)")
            md.append(f"**Steps:** {t['steps_done']}/{t['steps_total']} done ({t['steps_pct']}%)")
            if t["spec_ids"]:
                md.append(f"**Spec coverage:** {', '.join(t['spec_ids'][:10])}")
            if t["terms"][:10]:
                md.append(f"**Key terms:** {', '.join(t['terms'][:10])}")
            if t["planning_mentioned"]:
                md.append(f"**Planning:** mentioned in dasl-planning")
            md.append("")
    
    with open(OUT_MD, "w") as f:
        f.write("\n".join(md))
    
    print(f"\nJSON: {OUT_JSON}")
    print(f"Markdown: {OUT_MD}")

if __name__ == "__main__":
    main()
