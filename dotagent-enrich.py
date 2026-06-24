#!/usr/bin/env python3
"""
dotagent-enrich.py — Cross-reference every dotagent task and skill against
the DASL shared memory (lean4-repl at localhost:8156).

For each SKILL.md in ~/dotagents/tasks/ and ~/dotagents/skills/:
  1. Parse YAML frontmatter (name, description, crq)
  2. Extract keywords from content (declaration names, spec references, theorem names)
  3. Query REPL /search for each keyword
  4. Insert/update "## Shmem Cross-References" section with matched declarations

Usage:
  python3 dotagent-enrich.py [--dry-run] [--skills | --tasks | --all]
  python3 dotagent-enrich.py --single ~/dotagents/tasks/dasl-populate-shmem/SKILL.md

Output: Updated SKILL.md files with shmem cross-references.
"""
import os, sys, json, re, requests
from pathlib import Path
from datetime import datetime

# Configuration
DOTAGENTS = Path(os.environ.get('DOTAGENTS', os.path.expanduser('~/dotagents')))
REPL = os.environ.get('LEAN4_REPL', 'http://localhost:8156')
DRY_RUN = '--dry-run' in sys.argv

# Keywords to extract from SKILL.md content
KEYWORD_PATTERNS = [
    # Declaration names (backtick-wrapped or capital CamelCase)
    r'`([A-Z][a-zA-Z0-9_\.]*?)`',
    # Theorem/lemma/def references
    r'\b(Block|CID|IPLD|CarStorage|UnifiedIPLD|MultiHash|ContentAddress|DAG|Codec|Sheaf|Bott|Monster|Weaver|Primes|Godel|VibeRegister|IPLDMonsterSchema|DASLType|IPLDNode|CARBlock|IPLDCodeGen)\b',
    # Spec document references
    r'(specs?/[a-zA-Z0-9_\-\./]+)',
    # CRQ references
    r'(CRQ-[A-Z]+-\d+)',
    # Pastebin CIDs
    r'(bafk[a-f0-9]{20,60})',
    # DASL addresses
    r'(0xda51[a-f0-9]{8,16})',
]


def parse_frontmatter(text):
    """Extract YAML frontmatter fields from SKILL.md."""
    meta = {}
    if text.startswith('---'):
        end = text.find('---', 3)
        if end > 0:
            fm = text[3:end].strip()
            for line in fm.split('\n'):
                line = line.strip()
                if ':' in line:
                    key, _, val = line.partition(':')
                    meta[key.strip()] = val.strip()
    return meta


def extract_keywords(text):
    """Extract all relevant keywords from SKILL.md content."""
    keywords = set()
    # Skip frontmatter for content keywords
    if text.startswith('---'):
        end = text.find('---', 3)
        if end > 0:
            text = text[end+3:]
    
    # Skip common template boilerplate words
    SKIP_WORDS = {'Also', 'Approach', 'See', 'Trigger', 'Setup', 'Steps', 'Files'
                  'Output', 'Input', 'Description', 'Context', 'Task', 'Status',
                  'Usage', 'Commands', 'Script', 'Location', 'Pipeline', 'Plan'}
    
    for pattern in KEYWORD_PATTERNS:
        for match in re.finditer(pattern, text):
            kw = match.group(1).strip()
            if len(kw) >= 2 and not kw.startswith('http') and kw not in SKIP_WORDS:
                keywords.add(kw)
    
    # Also extract from headings
    for match in re.finditer(r'^#+\s+(.+)$', text, re.MULTILINE):
        heading = match.group(1).strip()
        for word in heading.split():
            if word[0].isupper() and len(word) >= 3 and word not in SKIP_WORDS:
                keywords.add(word)
    
    return sorted(keywords)


def search_shmem(query):
    """Query the lean4-repl search endpoint."""
    try:
        resp = requests.get(f'{REPL}/search', params={'q': query}, timeout=5)
        if resp.status_code == 200:
            return resp.json()
    except Exception as e:
        return {'error': str(e)}
    return []


def build_xref_section(keywords, hits):
    """Build the '## Shmem Cross-References' markdown section."""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    lines = [
        f'## Shmem Cross-References',
        f'',
        f'> Generated: {timestamp} | REPL: {REPL} | Declarations loaded: 366',
        f'',
        f'| Keyword | Shmem Matches | Type |',
        f'|---------|--------------|------|',
    ]
    
    found_any = False
    for kw in keywords:
        matches = hits.get(kw, [])
        if matches:
            found_any = True
            if isinstance(matches, list):
                for m in matches[:3]:
                    name = m.get('name', '?') if isinstance(m, dict) else str(m)
                    kind = m.get('kind', '?') if isinstance(m, dict) else '?'
                    lines.append(f'| {kw} | {name} | {kind} |')
            else:
                lines.append(f'| {kw} | {len(matches)} results | — |')
    
    if not found_any:
        searchable = [kw for kw in keywords if any(c.isupper() for c in kw)]
        if searchable:
            lines.append(f'| — | No matches in shmem for {len(keywords)} keywords | — |')
            lines.append(f'| — | Searchable terms: {", ".join(searchable[:10])} | — |')
        else:
            lines.append(f'| — | No declarative keywords found | — |')
    
    return '\n'.join(lines)


def enrich_skill(skill_path, dry_run=False):
    """Enrich a single SKILL.md with shmem cross-references."""
    text = skill_path.read_text()
    meta = parse_frontmatter(text)
    keywords = extract_keywords(text)
    
    if not keywords:
        print(f'  ⏭ {skill_path.name}: no keywords found, skipping')
        return False
    
    # Remove existing cross-reference section if present
    lines = text.split('\n')
    new_lines = []
    skip_until = None
    found_section = []
    in_xref = False
    
    for line in lines:
        if line.strip() == '## Shmem Cross-References':
            in_xref = True
            continue
        if in_xref:
            if line.startswith('## ') or line.startswith('# '):
                in_xref = False
                # Keep this new section heading
                new_lines.append('')
                new_lines.append(line)
            continue
        new_lines.append(line)
    
    # Query shmem for each keyword (batch or sequential)
    hits = {}
    for kw in keywords:
        result = search_shmem(kw)
        if result and (not isinstance(result, list) or len(result) > 0):
            hits[kw] = result
    
    # Build and append cross-reference section
    xref = build_xref_section(keywords, hits)
    
    if new_lines and new_lines[-1].strip():
        new_lines.append('')
    new_lines.append(xref)
    
    new_text = '\n'.join(new_lines)
    
    if dry_run:
        print(f'  📝 {skill_path.relative_to(Path.home())}')
        print(f'     keywords: {len(keywords)} ({", ".join(keywords[:5])}...)')
        print(f'     shmem hits: {len(hits)}')
    else:
        skill_path.write_text(new_text)
        print(f'  ✏️ {skill_path.relative_to(Path.home())}: {len(keywords)} keywords, {len(hits)} shmem hits')
    
    return len(hits) > 0


def main():
    single = None
    scope = 'all'
    
    for i, arg in enumerate(sys.argv):
        if arg == '--single' and i+1 < len(sys.argv):
            single = sys.argv[i+1]
        elif arg == '--tasks':
            scope = 'tasks'
        elif arg == '--skills':
            scope = 'skills'
    
    print(f'=== Dotagent Enrich — Shmem Cross-Referencer ===')
    print(f'  REPL: {REPL}')
    print(f'  Mode: {"DRY RUN" if DRY_RUN else "LIVE"}')
    print(f'  Scope: {scope if not single else f"single: {single}"}')
    print()
    
    # Verify REPL is accessible
    repl_decls = 0
    try:
        health = requests.get(f'{REPL}/health', timeout=3)
        if health.status_code == 200:
            repl_decls = health.json().get('declarations', 0)
            print(f'  REPL: {repl_decls} declarations loaded')
        else:
            print(f'  ⚠ REPL not healthy: {health.status_code}')
    except Exception as e:
        print(f'  ⚠ REPL unreachable: {e}')
        print(f'  Continuing with empty shmem...')
    
    # Check parquet enriched index
    parquet_path = '/mnt/data1/nix/vendor/rust/github/data/proofs/indexed_files_enriched.parquet'
    parquet_count = 0
    if Path(parquet_path).exists():
        try:
            import pandas as pd
            df = pd.read_parquet(parquet_path)
            parquet_count = len(df)
            print(f'  Parquet: {parquet_count} enriched files')
        except Exception:
            print(f'  ⚠ Parquet unreadable (pandas not available?)')
    else:
        print(f'  ⚠ Parquet index not found')
    
    if single:
        path = Path(single).expanduser()
        if path.exists() and path.name == 'SKILL.md':
            enrich_skill(path, DRY_RUN)
        else:
            print(f'  ⚠ Not a SKILL.md: {single}')
        return
    
    total = 0
    enriched = 0
    
    if scope in ('tasks', 'all'):
        tasks_dir = DOTAGENTS / 'tasks'
        if tasks_dir.exists():
            for skill in sorted(tasks_dir.glob('*/SKILL.md')):
                total += 1
                if enrich_skill(skill, DRY_RUN):
                    enriched += 1
    
    if scope in ('skills', 'all'):
        skills_dir = DOTAGENTS / 'skills'
        if skills_dir.exists():
            for skill in sorted(skills_dir.glob('*/SKILL.md')):
                total += 1
                if enrich_skill(skill, DRY_RUN):
                    enriched += 1
    
    print(f'\n=== Total: {total} files, {enriched} enriched ===')


if __name__ == '__main__':
    main()
