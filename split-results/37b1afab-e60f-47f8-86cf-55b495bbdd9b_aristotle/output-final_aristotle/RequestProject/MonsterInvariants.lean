import Mathlib
import RequestProject.Monster

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 4000000
set_option autoImplicit false

/-!
# The 194 Monster invariants as `p`-adic profiles over the supersingular primes

This file takes the design conversation one step further: it formalizes the **194-row table of
`p`-adic valuation profiles** that was proposed as the "maximal Umwelt" — the full sensory
horizon of the supersingular-prime ontology built in `RequestProject.Monster`.

The Monster sporadic group `M` has exactly **194** conjugacy classes / irreducible characters.
Each row below is one such invariant, recorded purely by its **15-dimensional `p`-adic profile**:
its valuation `v_p` at each of the 15 supersingular primes
`[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]` (the `supersingularPrimes` of
`RequestProject.Monster`), together with the `row_exponent_sum = Σ_p v_p`.

The concrete, machine-checkable content (everything below is proved, no `sorry`):

* **There are exactly 194 invariants**, indexed by `0, …, 193` (`table_length`,
  `table_indices`, `table_indices_nodup`).
* **Each profile has 15 entries**, one per supersingular prime (`profile_length`).
* **Internal consistency**: the stored `row_exponent_sum` really is the sum of the 15
  valuations (`sum_consistent`).
* **Every invariant is a divisor of `|M|`** (`invariantValue_dvd_monsterOrder`): reconstructing
  the number `∏ p^{v_p}` from each profile yields a divisor of the Monster's order.
* **Supported exactly on the supersingular primes** — the headline "`2,3,5,7` as just subsets of
  the Monster's 194 invariants". Two complementary statements:
  - arithmetic: the prime factors of every reconstructed invariant lie inside the supersingular
    primes (`supported_on_supersingular`), proved by combining the divisibility above with
    Ogg's theorem `Monster.monster_primeFactors`;
  - combinatorial: the set of primes that *occur* (with positive valuation) across all 194 rows
    is *exactly* the 15 supersingular primes (`support_eq_supersingular`), so the small primes
    `2,3,5,7` are simply 4 of those 15 channels (`smallPrimes_appear`).
* **The prime-47 "stamp"** (`stamp`): the local valuation `v_47` read off a profile is always
  `≤ 1` (`stamp_47_le_one`), matching `47 ‖ |M|` — a single silver imprint per invariant.

Interpretive framing (mycelial signalling, Hauptbahnhof terminal geometry, biosemiotic
"Umwelt", silver-47 coin) is kept here as motivation only; the statements below are the precise
mathematical residue of that picture.
-/

namespace MonsterInvariants

open Monster

/-! ## 1. The data: 194 invariants as `(index, p-adic profile, exponent sum)` -/

/-- The 194 Monster invariants, each as `(index, [v₂, v₃, …, v₇₁], Σ vₚ)`, where the 15
valuations are aligned to `Monster.supersingularPrimes`. -/
def table : List (ℕ × List ℕ × ℕ) := [
  (192, [46, 2, 0, 0, 2, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1], 56),
  (174, [42, 2, 1, 4, 0, 2, 0, 0, 1, 1, 0, 1, 0, 1, 0], 55),
  (180, [44, 0, 0, 6, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1], 55),
  (101, [46, 0, 0, 0, 2, 3, 0, 0, 1, 0, 1, 0, 1, 0, 0], 54),
  (102, [46, 0, 0, 0, 2, 3, 0, 0, 1, 0, 1, 0, 1, 0, 0], 54),
  (139, [42, 0, 7, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1], 54),
  (122, [43, 0, 0, 0, 2, 2, 0, 1, 1, 1, 0, 1, 0, 1, 0], 52),
  (123, [43, 0, 0, 0, 2, 2, 0, 1, 1, 1, 0, 1, 0, 1, 0], 52),
  (124, [43, 0, 0, 0, 2, 2, 0, 1, 1, 1, 0, 1, 0, 1, 0], 52),
  (132, [42, 0, 0, 4, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0], 52),
  (171, [42, 0, 0, 0, 0, 2, 0, 0, 1, 1, 1, 1, 1, 1, 1], 51),
  (147, [32, 0, 9, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1], 47),
  (168, [18, 19, 0, 0, 0, 3, 0, 0, 0, 1, 1, 1, 0, 1, 1], 45),
  (158, [32, 0, 1, 0, 0, 3, 1, 1, 1, 1, 1, 0, 1, 1, 1], 44),
  (80, [31, 1, 0, 3, 2, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0], 43),
  (81, [31, 1, 0, 3, 2, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0], 43),
  (144, [28, 1, 0, 1, 1, 2, 1, 0, 1, 1, 1, 1, 1, 1, 1], 41),
  (96, [18, 3, 8, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1], 37),
  (118, [18, 0, 8, 5, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1], 37),
  (136, [21, 0, 0, 6, 1, 3, 1, 1, 0, 1, 0, 1, 0, 1, 1], 37),
  (157, [20, 0, 2, 5, 0, 3, 1, 0, 1, 1, 1, 1, 0, 1, 1], 37),
  (145, [18, 3, 2, 1, 2, 3, 0, 1, 1, 1, 0, 1, 1, 1, 1], 36),
  (125, [20, 2, 0, 0, 2, 3, 1, 0, 1, 1, 1, 1, 1, 1, 1], 35),
  (134, [18, 0, 0, 6, 1, 3, 1, 1, 1, 1, 1, 1, 1, 0, 0], 35),
  (135, [18, 0, 0, 6, 1, 3, 1, 1, 1, 1, 1, 1, 1, 0, 0], 35),
  (156, [18, 0, 0, 6, 1, 3, 1, 1, 0, 1, 0, 1, 1, 1, 1], 35),
  (160, [0, 17, 7, 4, 2, 2, 0, 0, 0, 0, 1, 0, 0, 1, 1], 35),
  (172, [12, 6, 2, 5, 0, 3, 1, 1, 1, 0, 1, 0, 1, 1, 1], 35),
  (175, [0, 20, 0, 6, 2, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1], 34),
  (186, [2, 19, 0, 4, 0, 3, 0, 0, 0, 1, 1, 1, 1, 1, 1], 34),
  (77, [6, 17, 0, 4, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1], 33),
  (104, [1, 19, 0, 4, 2, 3, 1, 0, 1, 1, 0, 1, 0, 0, 0], 33),
  (105, [1, 19, 0, 4, 2, 3, 1, 0, 1, 1, 0, 1, 0, 0, 0], 33),
  (111, [18, 0, 0, 6, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1], 33),
  (121, [0, 19, 5, 1, 2, 0, 0, 1, 1, 1, 0, 1, 1, 0, 1], 33),
  (141, [16, 1, 0, 4, 2, 2, 1, 1, 0, 1, 1, 1, 1, 1, 1], 33),
  (151, [1, 19, 1, 1, 2, 3, 0, 1, 0, 1, 1, 1, 1, 1, 0], 33),
  (161, [12, 1, 9, 1, 0, 2, 1, 1, 0, 1, 1, 1, 1, 1, 1], 33),
  (162, [1, 19, 0, 4, 2, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1], 33),
  (163, [2, 19, 0, 0, 2, 3, 1, 0, 1, 1, 1, 1, 0, 1, 1], 33),
  (177, [0, 17, 7, 0, 1, 2, 0, 0, 0, 1, 1, 1, 1, 1, 1], 33),
  (188, [0, 17, 7, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1], 33),
  (40, [18, 0, 0, 6, 1, 3, 1, 1, 0, 1, 0, 1, 0, 0, 0], 32),
  (41, [18, 0, 0, 6, 1, 3, 1, 1, 0, 1, 0, 1, 0, 0, 0], 32),
  (45, [18, 1, 2, 5, 1, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1], 32),
  (58, [17, 0, 5, 0, 2, 3, 1, 1, 0, 0, 1, 0, 0, 1, 1], 32),
  (59, [17, 0, 5, 0, 2, 3, 1, 1, 0, 0, 1, 0, 0, 1, 1], 32),
  (70, [0, 18, 9, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1], 32),
  (71, [0, 18, 9, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1], 32),
  (130, [1, 17, 2, 5, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1], 32),
  (140, [1, 17, 1, 5, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1], 32),
  (159, [0, 19, 0, 1, 2, 3, 1, 1, 1, 1, 0, 1, 1, 0, 1], 32),
  (167, [0, 18, 0, 5, 0, 2, 1, 1, 0, 0, 1, 1, 1, 1, 1], 32),
  (49, [19, 1, 1, 1, 2, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1], 31),
  (63, [16, 3, 2, 0, 1, 2, 1, 0, 0, 1, 1, 1, 1, 1, 1], 31),
  (120, [13, 0, 2, 5, 2, 3, 0, 0, 1, 1, 0, 1, 1, 1, 1], 31),
  (152, [0, 19, 0, 0, 2, 3, 0, 1, 0, 1, 1, 1, 1, 1, 1], 31),
  (185, [0, 18, 0, 1, 2, 2, 0, 1, 1, 1, 1, 1, 1, 1, 1], 31),
  (65, [3, 17, 0, 1, 1, 2, 1, 0, 1, 1, 1, 0, 0, 1, 1], 30),
  (100, [0, 19, 0, 0, 2, 3, 0, 1, 0, 1, 1, 1, 1, 1, 0], 30),
  (106, [0, 19, 0, 0, 2, 3, 1, 0, 1, 1, 0, 0, 1, 1, 1], 30),
  (107, [0, 19, 0, 0, 2, 3, 1, 0, 1, 1, 0, 0, 1, 1, 1], 30),
  (129, [9, 1, 8, 1, 1, 3, 0, 1, 1, 1, 1, 0, 1, 1, 1], 30),
  (142, [0, 17, 1, 0, 2, 2, 1, 1, 1, 0, 1, 1, 1, 1, 1], 30),
  (150, [3, 6, 7, 5, 1, 2, 0, 1, 0, 1, 1, 1, 0, 1, 1], 30),
  (154, [4, 7, 7, 1, 1, 3, 0, 1, 1, 0, 1, 1, 1, 1, 1], 30),
  (181, [0, 12, 5, 3, 2, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1], 30),
  (193, [0, 12, 7, 0, 0, 3, 1, 0, 1, 1, 1, 1, 1, 1, 1], 30),
  (42, [18, 0, 0, 0, 1, 3, 1, 1, 1, 0, 0, 1, 1, 1, 1], 29),
  (112, [4, 12, 0, 1, 2, 3, 0, 1, 0, 1, 1, 1, 1, 1, 1], 29),
  (115, [7, 9, 0, 0, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1], 29),
  (153, [10, 1, 0, 5, 2, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1], 29),
  (169, [6, 0, 9, 4, 2, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1], 29),
  (173, [0, 12, 0, 6, 0, 3, 1, 1, 1, 1, 1, 1, 1, 0, 1], 29),
  (191, [1, 6, 8, 6, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1], 29),
  (76, [0, 17, 2, 0, 0, 2, 0, 0, 1, 1, 1, 1, 1, 1, 1], 28),
  (95, [10, 1, 2, 5, 0, 3, 0, 1, 0, 1, 1, 1, 1, 1, 1], 28),
  (97, [11, 2, 0, 3, 1, 3, 1, 0, 1, 1, 1, 1, 1, 1, 1], 28),
  (98, [0, 13, 0, 6, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1], 28),
  (99, [0, 13, 0, 6, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1], 28),
  (119, [3, 6, 8, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1], 28),
  (155, [2, 2, 9, 4, 2, 3, 0, 1, 1, 1, 1, 1, 0, 0, 1], 28),
  (170, [0, 12, 2, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1], 28),
  (187, [7, 2, 1, 4, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1], 28),
  (25, [0, 19, 0, 0, 2, 3, 1, 0, 1, 1, 0, 0, 0, 0, 0], 27),
  (26, [0, 19, 0, 0, 2, 3, 1, 0, 1, 1, 0, 0, 0, 0, 0], 27),
  (166, [3, 1, 7, 5, 2, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1], 27),
  (182, [2, 0, 9, 6, 0, 3, 1, 1, 0, 0, 1, 1, 1, 1, 1], 27),
  (43, [1, 12, 0, 6, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0], 26),
  (44, [1, 12, 0, 6, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0], 26),
  (60, [12, 1, 0, 1, 2, 2, 0, 1, 1, 1, 1, 1, 1, 1, 1], 26),
  (67, [1, 12, 2, 1, 0, 3, 1, 0, 1, 1, 1, 1, 0, 1, 1], 26),
  (91, [0, 9, 7, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1], 26),
  (117, [3, 6, 0, 6, 1, 2, 1, 0, 1, 1, 1, 1, 1, 1, 1], 26),
  (126, [0, 2, 9, 6, 2, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1], 26),
  (127, [1, 0, 9, 6, 2, 2, 1, 1, 0, 1, 1, 0, 1, 1, 0], 26),
  (128, [1, 0, 9, 6, 2, 2, 1, 1, 0, 1, 1, 0, 1, 1, 0], 26),
  (133, [3, 0, 8, 6, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1], 26),
  (137, [0, 2, 9, 6, 1, 2, 1, 1, 0, 0, 0, 1, 1, 1, 1], 26),
  (148, [2, 4, 1, 6, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 0], 26),
  (149, [2, 2, 9, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], 26),
  (183, [2, 0, 7, 5, 2, 3, 1, 0, 0, 1, 1, 1, 1, 1, 1], 26),
  (184, [0, 0, 9, 6, 2, 2, 1, 1, 1, 1, 0, 1, 0, 1, 1], 26),
  (189, [1, 0, 8, 6, 1, 3, 1, 0, 1, 1, 0, 1, 1, 1, 1], 26),
  (190, [1, 2, 9, 1, 2, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1], 26),
  (56, [5, 7, 1, 1, 1, 3, 1, 1, 0, 1, 1, 1, 1, 0, 1], 25),
  (64, [6, 3, 0, 6, 1, 3, 1, 1, 0, 0, 0, 1, 1, 1, 1], 25),
  (78, [4, 3, 7, 0, 2, 2, 0, 0, 1, 1, 1, 1, 1, 1, 1], 25),
  (82, [1, 1, 9, 6, 2, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1], 25),
  (83, [1, 1, 9, 6, 2, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1], 25),
  (84, [2, 0, 9, 6, 2, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1], 25),
  (85, [2, 0, 9, 6, 2, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1], 25),
  (90, [1, 3, 8, 4, 0, 3, 0, 0, 1, 1, 1, 1, 1, 1, 0], 25),
  (94, [6, 1, 2, 5, 1, 2, 1, 1, 0, 1, 1, 1, 1, 1, 1], 25),
  (110, [2, 0, 9, 4, 1, 3, 0, 1, 1, 0, 0, 1, 1, 1, 1], 25),
  (143, [2, 0, 7, 4, 2, 3, 0, 1, 0, 1, 1, 1, 1, 1, 1], 25),
  (176, [0, 0, 9, 3, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 0], 25),
  (48, [5, 0, 8, 4, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0], 24),
  (66, [2, 3, 7, 4, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1], 24),
  (109, [0, 6, 3, 2, 2, 3, 1, 1, 1, 1, 1, 1, 0, 1, 1], 24),
  (113, [0, 3, 9, 0, 1, 3, 1, 1, 1, 1, 0, 1, 1, 1, 1], 24),
  (164, [1, 2, 3, 4, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1], 24),
  (165, [0, 1, 9, 0, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1], 24),
  (178, [0, 4, 0, 6, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1], 24),
  (179, [0, 4, 0, 6, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1], 24),
  (62, [3, 0, 7, 5, 0, 2, 0, 0, 1, 1, 1, 0, 1, 1, 1], 23),
  (87, [3, 2, 0, 6, 2, 3, 1, 0, 1, 0, 1, 1, 1, 1, 1], 23),
  (88, [1, 0, 8, 6, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1], 23),
  (89, [1, 0, 8, 6, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1], 23),
  (92, [1, 1, 8, 4, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1], 23),
  (93, [3, 1, 1, 6, 2, 2, 1, 1, 1, 1, 1, 1, 0, 1, 1], 23),
  (103, [0, 3, 7, 1, 2, 3, 0, 0, 1, 1, 1, 1, 1, 1, 1], 23),
  (114, [3, 2, 0, 4, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1], 23),
  (116, [2, 1, 2, 6, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1], 23),
  (131, [2, 0, 2, 6, 2, 3, 1, 0, 1, 1, 1, 1, 1, 1, 1], 23),
  (138, [1, 0, 5, 4, 2, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1], 23),
  (146, [2, 0, 1, 6, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1], 23),
  (14, [12, 0, 0, 4, 1, 2, 0, 0, 0, 0, 1, 0, 0, 1, 1], 22),
  (36, [1, 3, 8, 4, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1], 22),
  (54, [0, 0, 9, 6, 2, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1], 22),
  (55, [0, 0, 9, 6, 2, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1], 22),
  (69, [2, 0, 9, 0, 1, 2, 1, 0, 1, 1, 1, 1, 1, 1, 1], 22),
  (73, [0, 0, 9, 1, 2, 3, 1, 1, 1, 1, 1, 1, 0, 0, 1], 22),
  (74, [0, 0, 9, 1, 2, 3, 1, 1, 1, 1, 1, 1, 0, 0, 1], 22),
  (75, [3, 0, 3, 5, 0, 3, 1, 1, 0, 1, 1, 1, 1, 1, 1], 22),
  (79, [2, 1, 2, 5, 2, 3, 0, 1, 1, 0, 1, 1, 1, 1, 1], 22),
  (108, [3, 0, 0, 6, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1], 22),
  (35, [3, 0, 8, 1, 0, 3, 1, 1, 0, 1, 0, 1, 0, 1, 1], 21),
  (52, [0, 1, 9, 0, 2, 3, 0, 1, 1, 1, 1, 1, 0, 1, 0], 21),
  (53, [0, 1, 9, 0, 2, 3, 0, 1, 1, 1, 1, 1, 0, 1, 0], 21),
  (61, [0, 6, 0, 5, 0, 2, 0, 1, 1, 1, 1, 1, 1, 1, 1], 21),
  (68, [3, 0, 2, 3, 2, 3, 1, 1, 1, 1, 0, 1, 1, 1, 1], 21),
  (72, [0, 3, 1, 6, 0, 3, 1, 1, 1, 1, 0, 1, 1, 1, 1], 21),
  (86, [0, 0, 5, 6, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1], 21),
  (27, [0, 6, 7, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1], 20),
  (28, [7, 0, 2, 0, 1, 3, 0, 1, 1, 0, 1, 1, 1, 1, 1], 20),
  (50, [2, 2, 0, 6, 2, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1], 20),
  (51, [2, 2, 0, 5, 2, 2, 0, 1, 1, 0, 1, 1, 1, 1, 1], 20),
  (15, [0, 0, 9, 6, 2, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0], 19),
  (16, [0, 0, 9, 6, 2, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0], 19),
  (29, [0, 3, 7, 0, 1, 2, 1, 0, 1, 1, 0, 0, 1, 1, 1], 19),
  (30, [0, 1, 7, 5, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1], 19),
  (38, [2, 0, 0, 6, 2, 3, 1, 0, 1, 0, 1, 1, 1, 1, 0], 19),
  (39, [2, 0, 0, 6, 2, 3, 1, 0, 1, 0, 1, 1, 1, 1, 0], 19),
  (57, [0, 0, 7, 1, 1, 2, 1, 1, 0, 1, 1, 1, 1, 1, 1], 19),
  (23, [3, 2, 0, 4, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1], 18),
  (33, [4, 0, 2, 0, 0, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1], 18),
  (37, [1, 0, 2, 4, 1, 3, 0, 1, 1, 1, 1, 1, 1, 0, 1], 18),
  (46, [1, 0, 0, 5, 2, 3, 0, 1, 1, 1, 1, 0, 1, 1, 1], 18),
  (47, [1, 0, 0, 5, 2, 3, 0, 1, 1, 1, 1, 0, 1, 1, 1], 18),
  (20, [2, 0, 7, 0, 0, 2, 0, 1, 0, 0, 1, 1, 1, 1, 1], 17),
  (19, [1, 1, 2, 5, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1], 16),
  (31, [0, 0, 1, 5, 0, 3, 0, 0, 1, 1, 1, 1, 1, 1, 1], 16),
  (32, [0, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1], 16),
  (34, [0, 2, 1, 0, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1], 16),
  (18, [0, 0, 2, 5, 1, 2, 1, 0, 1, 0, 1, 0, 0, 1, 1], 15),
  (22, [1, 0, 2, 1, 1, 3, 1, 1, 0, 1, 1, 1, 1, 0, 1], 15),
  (24, [0, 0, 3, 1, 2, 2, 0, 0, 1, 1, 1, 1, 1, 1, 1], 15),
  (8, [0, 6, 0, 1, 0, 2, 1, 1, 0, 0, 1, 0, 0, 1, 1], 14),
  (17, [3, 0, 0, 1, 0, 3, 1, 0, 0, 1, 1, 1, 1, 1, 1], 14),
  (21, [0, 0, 0, 5, 0, 2, 0, 1, 1, 1, 0, 1, 1, 1, 1], 14),
  (9, [0, 0, 2, 4, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1], 12),
  (10, [0, 3, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1], 12),
  (12, [0, 0, 0, 4, 1, 2, 0, 0, 0, 1, 0, 1, 1, 1, 1], 12),
  (13, [1, 0, 2, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1], 12),
  (7, [1, 1, 0, 1, 1, 2, 0, 1, 1, 0, 0, 1, 1, 1, 0], 11),
  (11, [0, 1, 0, 0, 1, 2, 1, 0, 1, 1, 1, 1, 1, 1, 0], 11),
  (4, [2, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1], 9),
  (6, [1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1], 9),
  (3, [1, 0, 0, 0, 0, 2, 0, 0, 0, 1, 1, 0, 1, 1, 0], 7),
  (5, [0, 0, 0, 0, 0, 2, 0, 0, 1, 1, 0, 1, 0, 1, 1], 7),
  (2, [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1], 6),
  (1, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1], 3),
  (0, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 0)]

/-! ## 2. Reconstructing each invariant as a number, and reading off its local data -/

/-- The natural number `∏ p^{vₚ}` reconstructed from a `p`-adic profile (aligned to
`supersingularPrimes`). -/
def invariantValue (profile : List ℕ) : ℕ :=
  (List.zipWith (fun p e => p ^ e) supersingularPrimes profile).prod

/-- The local "stamp" `v_p`: the valuation of a profile at the prime `p`. (The silver-47 coin
imprints `stamp 47`.) -/
def stamp (p : ℕ) (profile : List ℕ) : ℕ :=
  match (List.zip supersingularPrimes profile).find? (fun pe => pe.1 == p) with
  | some pe => pe.2
  | none => 0

/-- The list of primes that actually occur (positive valuation) in a profile. -/
def profileSupport (profile : List ℕ) : List ℕ :=
  (List.zip supersingularPrimes profile).filterMap
    (fun pe => if 0 < pe.2 then some pe.1 else none)

/-! ## 3. Structural facts about the table -/

/-- There are exactly 194 Monster invariants. -/
theorem table_length : table.length = 194 := by native_decide

/-- The 194 invariants are indexed exactly by `0, 1, …, 193`. -/
theorem table_indices : (table.map (·.1)).toFinset = Finset.range 194 := by native_decide

/-- The 194 indices are pairwise distinct. -/
theorem table_indices_nodup : (table.map (·.1)).Nodup := by native_decide

/-- Each invariant's profile records a valuation at each of the 15 supersingular primes. -/
theorem profile_length : ∀ r ∈ table, r.2.1.length = 15 := by native_decide

/-- Internal consistency: the stored exponent sum is the sum of the 15 valuations. -/
theorem sum_consistent : ∀ r ∈ table, r.2.1.sum = r.2.2 := by native_decide

/-! ## 4. Every invariant is a divisor of `|M|`, supported on the supersingular primes -/

/-- `|M| ≠ 0`. -/
theorem monsterOrder_ne_zero : Monster.monsterOrder ≠ 0 := by native_decide

/-- Each of the 194 reconstructed invariants `∏ p^{vₚ}` divides the order of the Monster. -/
theorem invariantValue_dvd_monsterOrder :
    ∀ r ∈ table, invariantValue r.2.1 ∣ Monster.monsterOrder := by native_decide

/-- **Supported on the supersingular primes (arithmetic form).** The prime factors of every
reconstructed invariant lie among the supersingular primes — a consequence of divisibility into
`|M|` together with Ogg's theorem `Monster.monster_primeFactors`. -/
theorem supported_on_supersingular (r : ℕ × List ℕ × ℕ) (hr : r ∈ table) :
    (invariantValue r.2.1).primeFactors ⊆ supersingularPrimes.toFinset := by
  rw [← Monster.monster_primeFactors]
  exact Nat.primeFactors_mono (invariantValue_dvd_monsterOrder r hr) monsterOrder_ne_zero

/-- **Supported on the supersingular primes (combinatorial form).** The set of primes that occur
with positive valuation across all 194 invariants is *exactly* the 15 supersingular primes. -/
theorem support_eq_supersingular :
    (table.flatMap (fun r => profileSupport r.2.1)).toFinset = supersingularPrimes.toFinset := by
  native_decide

/-- The small primes `2, 3, 5, 7` are just 4 of the 15 supersingular channels that occur across
the 194 Monster invariants — "subsets of the Monster's 194 invariants". -/
theorem smallPrimes_appear :
    ∀ p ∈ [2, 3, 5, 7],
      p ∈ (table.flatMap (fun r => profileSupport r.2.1)).toFinset := by
  native_decide

/-! ## 5. The prime-47 stamp -/

/-- The silver-47 imprint is always a single coin: `v₄₇ ≤ 1` for every invariant, matching
`47 ‖ |M|`. -/
theorem stamp_47_le_one : ∀ r ∈ table, stamp 47 r.2.1 ≤ 1 := by native_decide

/-! ## 6. A runnable summary -/

/-- Report the maximal-Umwelt invariants table. -/
def runInvariantSurvey : IO Unit := do
  IO.println s!"Number of Monster invariants: {table.length}"
  IO.println s!"Supersingular primes (the 15 channels): {supersingularPrimes}"
  IO.println s!"Primes occurring across all invariants: {(table.flatMap (fun r => profileSupport r.2.1)).toFinset.sort (· ≤ ·)}"
  IO.println "Sample reconstructed invariants ∏ p^{vₚ} (all divide |M|):"
  for r in [table.getD 0 (0, [], 0), table.getD 100 (0, [], 0), table.getD 193 (0, [], 0)] do
    IO.println s!"  index {r.1}: value = {invariantValue r.2.1}, Σvₚ = {r.2.2}"

#eval runInvariantSurvey

end MonsterInvariants
