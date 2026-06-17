#!/usr/bin/env python3
"""
Fix unified-dasl project: replace Split.* stub imports with proper Mathlib imports.
Adds placeholder content for empty stub files.

Usage: python3 fix-unified-imports.py [unified-dasl-dir]
"""
import re, sys
from pathlib import Path

UNIFIED = Path(sys.argv[1]) if len(sys.argv) > 1 else Path('aristotles_results/unified-dasl/UnifiedDasl')

fixed = 0
skipped = 0

for lean_file in sorted(UNIFIED.rglob('*.lean')):
    content = lean_file.read_text(encoding='utf-8', errors='ignore')
    original = content
    
    # Remove Split.* imports (stub artifacts)
    content = re.sub(r'import Split\.\S+', '', content)
    
    # Check if file is effectively empty
    lines = [l for l in content.split('\n') if l.strip() and not l.strip().startswith('--')]
    is_stub = not lines or all(
        l.strip().startswith('--') for l in content.split('\n') if l.strip()
    )
    
    if is_stub:
        decl_name = lean_file.stem
        comment_lines = [l for l in original.split('\n') if l.strip().startswith('--')]
        
        content = f'''import Mathlib

/-!
# {decl_name}

This declaration was extracted from the DASL mathlib-split pool.
Original stub information:
{chr(10).join(comment_lines[:10]) if comment_lines else "-- (no info available)"}

To be formalized with proper Lean4 proofs.
-/

-- TODO: Formalize {decl_name}
'''
    
    if content != original:
        lean_file.write_text(content)
        fixed += 1
    else:
        skipped += 1

print(f"Fixed: {fixed}, Skipped (already OK): {skipped}")
print(f"Total: {fixed + skipped} files in {UNIFIED}")
