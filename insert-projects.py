#!/usr/bin/env python3
"""Insert project list into notebooklm_cross.rs and build."""
path = '/mnt/data1/time-2026/05-may/07/arist/src/notebooklm_cross.rs'
text = open(path).read()

# Read project list from /tmp/projects.txt
projects_text = open('/tmp/projects.txt').read()
lines = [l.rstrip() for l in projects_text.split('\n') if l.strip().startswith('("')]

array = 'const PROJECTS: &[(&str, &str)] = &[\n'
array += '\n'.join(f'    {l}' for l in lines)
array += '\n];'

text = text.replace(
    'const PROJECTS: &[(&str, &str)] = &[INSERTED_BY_SCRIPT];',
    array
)

open(path, 'w').write(text)
print(f'Inserted {len(lines)} projects')
