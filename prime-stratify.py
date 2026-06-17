#!/usr/bin/env python3
"""
j-Invariant Prime Stratification

Stratifies declarations by which q-expansion band their maximum prime falls into.
The j-invariant q-expansion acts as a natural periodic table:

  j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + 864299970q³ + ...

Each coefficient's max prime defines a boundary. A declaration's "energy level"
is determined by the highest prime dividing any numerical constant it contains.

Bands:
  q⁻¹ band:  primes 1         (identity)
  q⁰  band:  primes 2-31      (744 = 2³ × 3 × 31)
  q¹  band:  primes 32-1823   (196884 = 2² × 3³ × 1823) ← Monster 47,59,71 here
  q²  band:  primes 1824-2099 (21493760 = 2⁸ × 5 × 2099)
  q³  band:  primes 2100-355679
  q⁴  band:  primes (interval collapsed)
  q⁵  band:  primes 45768-777421
  q⁶  band:  primes 778422+
"""
import os, sys, json, re, math
from pathlib import Path
from collections import Counter, defaultdict

MATHLIB_SPLIT = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("aristotles_results/mathlib-split")
OUTPUT_JSON = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("aristotles_results/j-invariant-stratification.json")

# j-invariant q-expansion bands (canonical Sage truncation: up to q³ + O(q⁴))
J_BANDS = [
    ("q⁻¹",       0,      0,      "Identity origin"),
    ("q⁰",        2,     31,      "Foundation: 744 = 2³×3×31"),
    ("q¹",       32,   1823,      "Monster emergence: 196884 = 2²×3³×1823, 196883=47×59×71"),
    ("q²",     1824,   2099,      "Moonshine harmonics: 21493760 = 2⁸×5×2099"),
    ("q³",     2100, 355679,      "Higher irreps: 864299970 = 2×3×5×355679"),
    ("O(q⁴)", 355680, float('inf'), "Transcendental tail beyond q³ truncation"),
]

def get_band(max_p: int) -> tuple[str, str]:
    for label, lo, hi, desc in J_BANDS:
        if lo <= max_p <= hi:
            return label, desc
    return "q∞", "Beyond known coefficients"

# HashMap to distinguish hash collisions from mathematical constants
# These are internal compiler constants, not mathematical
HASH_PATTERNS = [
    'Lean_PersistentHashMap', 'Lean_PHash', 'Lean_instInhabited',
    'Lean_SMap', 'Std_HashMap', 'Std_HashSet', 'Lean_KeyedDecls',
    'Lean_ScopedEnvExtension', 'Lean_PersistentEnvExtension',
    'Lean_SimplePersistentEnvExtension', 'Lean_instMonad',
    'Lean_MonadCache', 'Lean_instNonempty', 'Lean_instExcept',
    'Lean_instToExpr', 'Lean_instToMessageData', 'Lean_instInhabitedOption',
    'Lean_instInhabitedPersistentArray', 'Lean_instInhabitedPersistentEnv',
    'Lean_instInhabitedScopedEnvExtension', 'Lean_instInhabitedScopedEntries',
    'Lean_instInhabitedStateStack', 'Lean_instAddErrorMessage',
]

def is_hash_noise(name: str, constants: list) -> bool:
    """Detect if the prime comes from compiler hash rather than math."""
    for pat in HASH_PATTERNS:
        if pat in name:
            return True
    # Values > 10^8 are overwhelmingly likely to be hashes
    for c in constants:
        if c.get('value', 0) > 10**8:
            return True
    return False

def prime_factors(n):
    if n < 2: return []
    factors = []
    d = 2
    while d * d <= n:
        while n % d == 0:
            factors.append(d)
            n //= d
        d += 1 if d == 2 else 2
    if n > 1: factors.append(n)
    return sorted(set(factors))

def max_prime_quick(n):
    """Fast max prime for reasonable-sized numbers."""
    if n < 2: return 0
    for p in [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47,
              53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113]:
        while n % p == 0:
            n //= p
        if n == 1: return p
    if n > 1:
        if n < 10**12:
            # Trial division for remaining
            for d in range(127, int(math.isqrt(n)) + 1, 2):
                if n % d == 0:
                    return max_prime_quick(n // d)
        return n
    return 0

KNOWN_MATH = {
    744: "j-invariant constant",
    1728: "j-invariant cube (12³)",
    196883: "Monster minimal dimension",
    196884: "j-invariant q¹ coeff",
    21296876: "Monster next irrep",
    21493760: "j-invariant q² coeff",
    842609326: "Monster large irrep",
    864299970: "j-invariant q³ coeff",
    196560: "Leech lattice kissing number",
    24: "Leech lattice dimension",
    196608: "2¹⁶×3",
}

print(f"=== j-Invariant Stratification ===")
print(f"Source: {MATHLIB_SPLIT}")

# Collect
bands = defaultdict(list)
band_counts = Counter()
noise_count = 0
math_count = 0
no_const_count = 0

for lean_file in sorted(MATHLIB_SPLIT.glob("**/*.lean")):
    if '.git' in str(lean_file) or lean_file.name == 'lakefile.toml':
        continue
    
    name = lean_file.stem
    content = lean_file.read_text(encoding='utf-8', errors='ignore')
    
    numbers = set()
    for m in re.finditer(r'\b(\d+)\b', content):
        n = int(m.group(1))
        if 2 <= n < 10**30:
            numbers.add(n)
    
    if not numbers:
        no_const_count += 1
        continue
    
    max_p = 0
    interesting = []
    
    for n in sorted(numbers):
        mp = max_prime_quick(n)
        if mp > max_p:
            max_p = mp
        if n in KNOWN_MATH or (mp > 0 and mp <= 97):
            interesting.append({
                "value": n,
                "max_prime": mp,
                "factors": prime_factors(n),
                "name": KNOWN_MATH.get(n, "")
            })
    
    if max_p == 0:
        no_const_count += 1
        continue
    
    # Classify
    if is_hash_noise(name, interesting):
        noise_count += 1
        continue
    
    band_label, band_desc = get_band(max_p)
    
    entry = {
        "max_prime": max_p,
        "band": band_label,
        "band_description": band_desc,
        "constants": interesting[:8],
        "total_constants": len(numbers),
        "all_factors": sorted(set().union(*[c["factors"] for c in interesting])),
    }
    
    bands[band_label].append({"name": name, **entry})
    band_counts[band_label] += 1
    math_count += 1

# Build output
result = {
    "j_invariant": {
        "formula": "j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + 864299970q³ + O(q⁴)",
        "sage": "j_invariant_qexp(4) = q^-1 + 744 + 196884*q + 21493760*q^2 + 864299970*q^3 + O(q^4)",
        "coefficients": [
            {"power": "q⁻¹", "value": 1, "max_prime": 0},
            {"power": "q⁰", "value": 744, "max_prime": 31, "factorization": "2³ × 3 × 31"},
            {"power": "q¹", "value": 196884, "max_prime": 1823, "factorization": "2² × 3³ × 1823", "monster_link": "196883+1; 196883 = 47×59×71"},
            {"power": "q²", "value": 21493760, "max_prime": 2099, "factorization": "2⁸ × 5 × 2099"},
            {"power": "q³", "value": 864299970, "max_prime": 355679, "factorization": "2 × 3 × 5 × 355679"},
            {"power": "O(q⁴)", "value": None, "max_prime": None, "factorization": None, "note": "Truncation bound — infinite series continues"},
        ],
        "monster_primes": {
            "196883": "47 × 59 × 71",
            "21296876": "2² × 31 × 41 × 59 × 71",
            "842609326": "2 × 13 × 29 × 31 × 47 × 59",
        },
    },
    "summary": {
        "total_declarations": no_const_count + noise_count + math_count,
        "with_mathematical_constants": math_count,
        "noise_filtered": noise_count,
        "no_constants": no_const_count,
        "bands": dict(band_counts),
    },
    "bands": {
        label: {
            "description": desc,
            "count": band_counts[label],
            "declarations": sorted(bands.get(label, []), key=lambda d: d["max_prime"], reverse=True),
        }
        for label, lo, hi, desc in J_BANDS
        if label in bands
    },
}

# Sort bands by q-power
OUTPUT_JSON.write_text(json.dumps(result, indent=2))

print(f"\n  Scanned: {no_const_count + noise_count + math_count}")
print(f"  Math constants: {math_count}")
print(f"  Hash noise filtered: {noise_count}")
print(f"  No constants: {no_const_count}")
print(f"\n  j-Invariant Bands:")
for label, lo, hi, desc in J_BANDS:
    c = band_counts.get(label, 0)
    if c > 0:
        bar = "█" * max(1, c // 3)
        hi_str = "∞" if hi == float('inf') else str(hi)
        print(f"    {label:>5s}  primes {lo:>5d}-{hi_str:<6s}  {c:>4d} decls  {bar}  {desc}")
        # Show top 3 examples
        if label in bands:
            for d in sorted(bands[label], key=lambda d: d["max_prime"], reverse=True)[:3]:
                consts = [str(c['value']) for c in d['constants'][:2]]
                print(f"           {d['name']:50s} max_p={d['max_prime']}  constants={consts}")

print(f"\n  Output: {OUTPUT_JSON}")
print(f"  Size: {OUTPUT_JSON.stat().st_size / 1024:.0f} KB")
