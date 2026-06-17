#!/usr/bin/env python3
"""
Source-level Lean splitter — splits .lean files at declaration boundaries,
preserving original compilable source code. Each declaration gets a flake.nix.

Usage: python3 split-source.py <input-dir> <output-dir>
"""
import re, sys, json
from pathlib import Path

INPUT = Path(sys.argv[1]) if len(sys.argv) > 1 else Path('aristotles_results')
OUTPUT = Path(sys.argv[2]) if len(sys.argv) > 2 else Path('aristotles_results/split-source')

DECL_RE = re.compile(
    r'^(?:/--[^\n]*\n)?\s*(?:@\[[^\]]*\]\s*)?'
    r'(def |theorem |lemma |example |inductive |structure |class |instance |'
    r'opaque |axiom |abbrev |elab |macro |syntax |scoped |'
    r'noncomputable def |unsafe def |partial def )'
    r'\s+(\S+)',
    re.MULTILINE
)

def sanitize(name): return name.replace('.','_').replace('/','_')

def split_file(path):
    content = path.read_text(errors='ignore')
    decls = list(DECL_RE.finditer(content))
    if not decls: return []
    results = []
    for i, m in enumerate(decls):
        name, kind = m.group(2), m.group(1).strip()
        start = m.start()
        end = decls[i+1].start() if i+1 < len(decls) else len(content)
        body = content[start:end].strip()
        results.append({'name': name, 'kind': kind, 'body': body})
    return results

def flake(name):
    return f'''{{
  description = "Lean: {name}";
  inputs = {{ nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; }};
  outputs = {{ self, nixpkgs }}: {{
    packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.stdenv.mkDerivation {{
      pname = "{name}"; version = "0.1.0"; src = ./.;
      installPhase = "mkdir $out; cp {name}.lean $out/";
    }};
  }};
}}'''

print(f"=== Source Splitter: {INPUT} -> {OUTPUT} ===")
OUTPUT.mkdir(parents=True, exist_ok=True)

rp_dirs = list(INPUT.glob('*_aristotle/output-final_aristotle/RequestProject'))
print(f"Found {len(rp_dirs)} RequestProject dirs\n")

total, files = 0, 0
for rp in sorted(rp_dirs):
    proj = rp.parent.parent.name.replace('_aristotle','')
    for lf in sorted(rp.glob('*.lean')):
        if 'Main' in lf.name: continue
        decls = split_file(lf)
        if not decls: continue
        files += 1
        for d in decls:
            sn = sanitize(d['name'])
            ddir = OUTPUT / proj / sn
            ddir.mkdir(parents=True, exist_ok=True)
            (ddir / f"{sn}.lean").write_text(d['body'])
            (ddir / 'flake.nix').write_text(flake(d['name']))
            total += 1
    if files <= 10:
        print(f"  {proj}: {sum(1 for d in split_file(lf) for lf in rp.glob('*.lean') if 'Main' not in lf.name)} decls")

print(f"\nDone: {files} files, {total} declarations")
