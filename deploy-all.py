#!/usr/bin/env python3
"""
Aristotle Project Deploy Builder
Generates deployment artifacts for aristo projects
"""

import json
import os
import shutil
from datetime import datetime
from pathlib import Path

# Read the dedup report
with open('dedup-report.json') as f:
    report = json.load(f)

# Get the list of canonical projects in newest→oldest order
projects = []
for g in report['groups']:
    # Read the actual status file to get created_at
    project_dir = g['canonical']
    status_file = Path(project_dir) / 'aristotle_status.json'
    if status_file.exists():
        with open(status_file) as f:
            status_data = json.load(f)
        created_at = status_data.get('created_at')
    else:
        created_at = None
    
    projects.append({
        'id': g['canonical'],
        'description': g['description'],
        'created_at': created_at,
        'archived_count': len(g['archived'])
    })

# Sort projects by created_at (newest first) - fallback to description length
projects.sort(key=lambda p: (p['created_at'] or '', -len(p['description'])))

# Create deployment directory structure
DEPLOY_ROOT = Path('deploy/manifests')
DEPLOY_ROOT.mkdir(parents=True, exist_ok=True)

# Create master index
index_content = ["# Aristotle Project Deployment Manifest\n\n"]
index_content.append("## Projects (Newest → Oldest)\n\n")

for idx, project in enumerate(projects):
    project_dir = DEPLOY_ROOT / f"project-{project['id']}"
    project_dir.mkdir(exist_ok=True)
    
    # Create manifest.json
    manifest = {
        "project_id": project['id'],
        "description": project['description'],
        "created_at": project['created_at'],
        "archived_count": project['archived_count'],
        "order": idx + 1,
        "deployment_date": datetime.now().isoformat(),
        "artifacts": {
            "systemd": True,
            "webpage": True,
            "nix_package": True,
            "lean_artifacts": True,
            "tasks": True,
            "skills": True
        }
    }
    
    manifest_path = project_dir / "manifest.json"
    with open(manifest_path, 'w') as f:
        json.dump(manifest, f, indent=2)
    
    # Create systemd service file
    service_content = f"""[Unit]
Description=Aristotle Project {project['id']}
After=network.target

[Service]
Type=simple
User=mdupont
Group=mdupont
WorkingDirectory=/mnt/data1/time-2026/05-may/07/arist/{project['id']}
Environment=HOME=/home/mdupont
Environment=PATH=/home/mdupont/.elan/bin:/home/mdupont/.nix-profile/bin:/usr/local/bin:/usr/bin:/bin
ExecStart=/mnt/data1/time-2026/05-may/07/arist/target/release/aristotle-manager serve --port 9876 --forward
Restart=on-failure
RestartSec=5s
KillSignal=SIGINT
TimeoutStopSec=15s
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=full
ProtectHome=read-only

[Install]
WantedBy=multi-user.target
"""
    
    service_path = project_dir / "systemd" / f"aristotle-manager-{project['id']}.service"
    service_path.parent.mkdir(exist_ok=True)
    with open(service_path, 'w') as f:
        f.write(service_content)
    
    # Create nix package file
    nix_content = f"""# Nix package for {project['id']}
{{
    description = "Aristotle Project {project['id']} deployment";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ ];
    
    buildCommand = ''
        mkdir -p $out
        cp -r * $out/
    '';
    
    meta = with lib; {{
        maintainer = "mdupont";
        description = "Aristotle Project {project['id']} deployment";
        license = "MIT";
        platforms = [ "x86_64-linux" ];
    }};
}}
"""
    
    nix_path = project_dir / "nix" / "flake.nix"
    nix_path.parent.mkdir(exist_ok=True)
    with open(nix_path, 'w') as f:
        f.write(nix_content)
    
    # Add each project to index
    for idx, project in enumerate(projects):
        index_content.append(f"{idx+1}. **{project['id']}**\n")
        index_content.append(f"   Created: {project['created_at'] or 'N/A'}\n")
        index_content.append(f"   Archived: {project['archived_count']} projects\n")
        index_content.append(f"\n")

# Write master index
index_path = DEPLOY_ROOT / "index.md"
with open(index_path, 'w') as f:
    f.write("\n".join(index_content))

print(f"Generated {len(projects)} project deployments in {DEPLOY_ROOT}")
print("Master index created at", index_path)