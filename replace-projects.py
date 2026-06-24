#!/usr/bin/env python3
"""Replace the PROJECTS array in notebooklm_cross.rs with the full list."""
import os

# Read current notebooklm_cross.rs
path = '/mnt/data1/time-2026/05-may/07/arist/src/notebooklm_cross.rs'
text = open(path).read()

# Read generated project list
projects_text = open('/tmp/projects.txt').read()
# Extract just the array entries (lines starting with "    (")
project_lines = [l.rstrip() for l in projects_text.split('\n') if l.strip().startswith('("')]

# Build new PROJECTS array
new_array = 'const PROJECTS: &[(&str, &str)] = &[\n'
new_array += '\n'.join(f'    {l}' for l in project_lines)
new_array += '\n];'

# Find and replace the old PROJECTS array
import re
# Find from "const PROJECTS" to the next "\n];"
old_start = text.index('const PROJECTS')
old_end = text.index('\n];', old_start) + 3
text = text[:old_start] + new_array + text[old_end:]

open(path, 'w').write(text)
print(f'Updated: {len(project_lines)} projects')
