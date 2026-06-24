#!/usr/bin/env python3
"""
audit-aristo-batches.py — Check all Aristotle batch files for rule violations.

Rules (from Aristotle's own responses):
  1. No software engineering tasks (Rust, Nix, Python, binary, shmem, push)
  2. Every prompt must have at least one formalizable mathematical claim
  3. No references to external files — data must be inline
  4. Every Lean snippet must be syntactically valid
  5. Empty prompts must be rejected

Output: audit report with per-batch pass/fail
"""
import os, sys, re
from pathlib import Path

CHUNKS_DIR = Path(os.environ.get('ARISTO_CHUNKS', '/mnt/data1/time-2026/05-may/07/arist/aristotles_results/aristotle-chunks'))

SWE_PATTERNS = [
    r'\bRust\b', r'\bNix\b', r'\bPython\b', r'\bbinary\b', r'\bshmem\b', 
    r'\bpush\b.*\bshmem', r'\bbuild\b.*\bbinary', r'\bcompile\b', 
    r'\bCAR\b.*\bpush\b', r'\blark\b', r'\bpyparsing\b',
    r'\bnginx\b', r'\bTantivy\b', r'\bIPLD\b.*\bpush\b',
    r'\b121-combination\b', r'\bmatrix\b.*\brun\b'
]

MATH_PATTERNS = [
    r'\bProve\b', r'\bTheorem\b', r'\btheorem\b', r'\bproof\b', 
    r'\bformalize\b', r'\bShow that\b', r'\bDefine\b.*\bprove\b',
    r'\bconjecture\b', r'\blemma\b', r'\bcorollary\b',
    r'\baxiom\b', r'\bproperty\b.*\bprove\b'
]

def check_batch(path):
    text = path.read_text()
    size = len(text)
    
    swe_hits = []
    for pat in SWE_PATTERNS:
        for m in re.finditer(pat, text, re.IGNORECASE):
            swe_hits.append(m.group())
    
    math_hits = []
    for pat in MATH_PATTERNS:
        for m in re.finditer(pat, text, re.IGNORECASE):
            math_hits.append(m.group())
    
    has_file_refs = bool(re.search(r'(?:\.sqlite|\.json|batch-\d+\.txt|\.car)', text, re.IGNORECASE))
    
    # Check for inline data (< 50 lines is suspicious)
    lines = text.strip().split('\n')
    non_comment_lines = [l for l in lines if not l.strip().startswith('#') and l.strip()]
    
    problems = []
    if swe_hits:
        problems.append(f'SWE tasks found: {swe_hits[:5]}')
    if not math_hits:
        problems.append('No mathematical claims found')
    if has_file_refs:
        problems.append('References external files — data must be inline')
    if len(non_comment_lines) < 5:
        problems.append(f'Too short ({len(non_comment_lines)} non-comment lines) — likely empty')
    
    return {
        'file': path.name,
        'size': size,
        'lines': len(non_comment_lines),
        'math_count': len(math_hits),
        'swe_count': len(swe_hits),
        'problems': problems,
        'pass': len(problems) == 0
    }

def main():
    print("=== Aristotle Batch Audit ===\n")
    results = []
    for f in sorted(CHUNKS_DIR.glob('*.txt')):
        r = check_batch(f)
        results.append(r)
        status = '✅' if r['pass'] else '❌'
        print(f"{status} {r['file']:30s} {r['size']:>6}B  math={r['math_count']:>3}  swe={r['swe_count']:>3}  lines={r['lines']:>4}")
        if r['problems']:
            for p in r['problems']:
                print(f"     ⚠ {p}")
    
    passed = sum(1 for r in results if r['pass'])
    failed = sum(1 for r in results if not r['pass'])
    print(f"\n=== Results: {passed} pass, {failed} fail ===")
    return 0 if failed == 0 else 1

if __name__ == '__main__':
    sys.exit(main())
