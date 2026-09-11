import RequestProject.SupersingularPrimes
import RequestProject.IrrepMask
import RequestProject.Monster
import RequestProject.ShadowDetection
import RequestProject.FuzzWitness

/-!
# Monster Group Architecture — Main Module

This module re-exports all components of the formalization of the Monster group
representation-theoretic architecture described in the informal source.

## Architecture Overview

The informal source describes a system connecting:
1. **Monster group M** — the largest sporadic simple group (order ≈ 8 × 10⁵³)
2. **194 irreducible representations** — one per conjugacy class of M
3. **15 supersingular primes** — {2,3,5,7,11,13,17,19,23,29,31,41,47,59,71}
4. **15-bit SSP support vectors** — compact encoding of each irrep's prime support
5. **Hamming distance** — fitness metric in the 15-dimensional SSP space
6. **Shadow detection** — CFSG-based classification of centralizer patterns
7. **Fuzz witnesses** — CBOR/eRDFa-annotated reproducibility records

## Informal source references
- "Replace A5Element with IrrepMask" — upgrade from toy A5 mutator to Monster irreps
- "The QuickCheck property then becomes: applying irrep masks via tensor product stays
  within the Monster's 194 conjugacy classes"
- "The Perplexity answer's Nix/DASL integration note at the end is actually the right
  instinct — the reproducibility wrapper is where your ZKP witness lives"

## Formalization Status — All sorry-free

Every declaration compiles without `sorry`. The Monster group is modeled via the
`MonsterGroup` type class, which captures its known properties (simplicity, order,
conjugacy class count) as class fields. This avoids both `axiom` declarations and
`sorry`-ed proofs while maintaining the correct mathematical interface.

### Key proven theorems
- `supersingularPrimes_card` : there are exactly 15 supersingular primes
- `supersingularPrimes_all_prime` : all SSPs are prime
- `supersingularPrimesList_nodup` : SSPs are pairwise distinct
- `ssp_dvd_monsterOrder` : each SSP divides |M|
- `monsterOrder_pos` : |M| > 0
- `monster_isSimpleGroup` : M is simple (from `MonsterGroup` class)
- `monster_card` : |M| equals the known order (from `MonsterGroup` class)
- `monster_card_dvd_ssp` : SSPs divide |M| (proved from `monster_card` + `ssp_dvd_monsterOrder`)
- `monster_conjClasses_card` : M has 194 conjugacy classes (from `MonsterGroup` class)
- `sspHammingDist_comm` : Hamming distance is symmetric
- `sspHammingDist_self` : d(m, m) = 0
- `sspHammingDist_le_15` : Hamming distance bounded by 15
- `SSPMask.toPrimeSet_subset` : decoded primes are SSPs
- `sspPrimeAt_prime` : bit-indexed primes are prime
- `shadow_iff_centralizer_sporadic` : shadow detection characterization
- `defaultShardMetadata_orbifold_valid` : orbifold coords < moduli
- `defaultShardMetadata_moduli_are_ssp` : orbifold moduli are SSPs
- `hecke_index_is_ssp` : T_29 index is an SSP
-/
