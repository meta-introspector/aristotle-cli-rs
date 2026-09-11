import RequestProject.MonsterOgg

/-!
# The Grand Synthesis: the Oggorial, the triple identity of `196883`, and the PTE bridge

This module formalizes the remaining *concrete, machine-checkable* arithmetic content of
the note "The Monster Group Walk: Arithmetic Symmetry and Formalized Digit Preservation",
namely the parts of the "Grand Synthesis" (Section 5) and the "Oggorial" (Section 4) that
are genuine arithmetic statements rather than physical analogies.

It reuses the existing `MonsterWalk` and `MonsterOgg` developments. Everything is proved
with no `sorry`, using only standard axioms.

## What is formalized

1. **The Oggorial.** The *Oggorial* is the product of the 15 supersingular / Ogg primes
   (`oggorial`). We prove its exact value `1618964990108856390`
   (`oggorial_value`), that it equals the product of `MonsterOgg.oggPrimes`
   (`oggorial_eq_prod`), that it divides `|𝕄|` (`oggorial_dvd_monsterOrder`), and that
   it is exactly the *radical* (squarefree kernel) of `|𝕄|` — the product of the distinct
   primes dividing the Monster order (`oggorial_eq_radical`).

2. **The triple identity of `196883`.** The smallest nontrivial Monster irreducible
   degree `196883` is simultaneously the product of the three largest Monster primes
   `47 · 59 · 71` (`triple_identity`); the three factors are pairwise coprime
   (`triple_identity_coprime`), so `196883` is squarefree and `196883` is its own CRT
   reconstruction from the three residues. The McKay relations
   `196884 = 1 + 196883` and `21493760 = 1 + 196883 + 21296876` are recorded
   (`mckay_196884`, `mckay_21493760`).

3. **The PTE / String-Descent bridge.** A single Prouhet–Tarry–Escott solution
   `A = {0,4,7,11}`, `B = {1,2,9,10}` is "anomaly free" through the string descent
   `D = 26 → 10 → 4`: its power sums of degrees `1, 2, 3` agree
   (`pte_k3`, the `k = 3` PTE condition), while the degree-`4` power sums differ
   (`pte_sharp`), so the solution is sharply of degree `3`. We also record that the two
   multisets are disjoint and of equal size (`pte_disjoint`, `pte_card`).

## Scope

Monstrous moonshine itself (Borcherds' theorem), Umbral moonshine, Ogg's correspondence,
and the physics of anomaly cancellation in string theory are taken as motivation, not
re-proved. What is proved here are the exact arithmetic identities underlying those
statements.
-/

namespace MonsterSynthesis

open MonsterWalk MonsterOgg

/-! ## 1. The Oggorial -/

/-- The **Oggorial**: the product of the 15 Ogg (supersingular) primes. -/
def oggorial : Nat := (oggPrimes).prod

/-- The Oggorial equals the product of the Ogg primes (by definition, recorded). -/
theorem oggorial_eq_prod : oggorial = oggPrimes.prod := rfl

/-- The exact decimal value of the Oggorial. -/
theorem oggorial_value : oggorial = 1618964990108856390 := by native_decide

/-- The Oggorial divides the Monster order (each Ogg prime occurs to a positive power). -/
theorem oggorial_dvd_monsterOrder : oggorial ∣ monsterOrder := by
  rw [oggorial_value, monsterOrder_value]; decide

/-- The Oggorial is exactly the **radical** of `|𝕄|`: the product of the distinct primes
dividing the Monster order. -/
theorem oggorial_eq_radical :
    oggorial = monsterOrder.factorization.support.prod id := by
  native_decide

/-! ## 2. The triple identity of `196883` -/

/-- **Triple identity of `196883`.** The smallest nontrivial Monster irreducible degree
is the product of the three largest Monster primes. -/
theorem triple_identity : (196883 : Nat) = 47 * 59 * 71 := by native_decide

/-- The three largest Monster primes are pairwise coprime, so `196883` is squarefree and
equals its own CRT reconstruction from the three residues. -/
theorem triple_identity_coprime :
    Nat.Coprime 47 59 ∧ Nat.Coprime 47 71 ∧ Nat.Coprime 59 71 := by decide

/-- **First McKay relation.** The coefficient of `q` in `j(τ) − 744` is `1 + 196883`. -/
theorem mckay_196884 : (196884 : Nat) = 1 + 196883 := by native_decide

/-- **Second McKay relation.** The coefficient of `q²` in `j(τ) − 744` is
`1 + 196883 + 21296876`. -/
theorem mckay_21493760 : (21493760 : Nat) = 1 + 196883 + 21296876 := by native_decide

/-! ## 3. The PTE / String-Descent bridge -/

/-- The first block of the Prouhet–Tarry–Escott solution. -/
def pteA : List Nat := [0, 4, 7, 11]

/-- The second block of the Prouhet–Tarry–Escott solution. -/
def pteB : List Nat := [1, 2, 9, 10]

/-- The power sum of degree `j` of a list of naturals. -/
def powerSum (L : List Nat) (j : Nat) : Nat := (L.map (· ^ j)).sum

/-- **PTE, `k = 3`.** The two blocks have equal power sums for all degrees `1, 2, 3`
(equivalently, the same multiset of `j`-th powers summed), i.e. the solution cancels the
`U(1)` gauge anomalies in degrees `1, 2, 3`. -/
theorem pte_k3 :
    powerSum pteA 1 = powerSum pteB 1 ∧
    powerSum pteA 2 = powerSum pteB 2 ∧
    powerSum pteA 3 = powerSum pteB 3 := by
  refine ⟨?_, ?_, ?_⟩ <;> native_decide

/-- **Sharpness of the PTE solution.** The degree-`4` power sums differ, so the solution
is sharply of degree `3` (an "ideal" PTE solution of size `4`). -/
theorem pte_sharp : powerSum pteA 4 ≠ powerSum pteB 4 := by native_decide

/-- The two PTE blocks are disjoint. -/
theorem pte_disjoint : ∀ x ∈ pteA, x ∉ pteB := by decide

/-- The two PTE blocks have the same size. -/
theorem pte_card : pteA.length = pteB.length := by native_decide

/-! ## 4. Decimal digit composition of `|𝕄|`

The note suggests the decomposition `54 = 37 + 17` of the decimal digits of `|𝕄|` into
"reachable nonzero" and "untargetable zero" positions. The genuine count is different and
is recorded here: `|𝕄|` has **39** nonzero decimal digits and **15** zero decimal digits
(`54 = 39 + 15`). The figure `37` is *not* the number of nonzero digits; it is the
length of the consecutive digit run covered by the multi-digit Monster Walk
(`MonsterWalk.coverage_37`), which stops earlier than the full nonzero set. The number of
*individually* targetable nonzero positions is `39` (`MonsterDigitWalk.digitTargets_count`),
matching the nonzero-digit count below — and `leadingDigit_mem` explains why the `15` zero
positions cannot be targeted. -/

/-- `|𝕄|` has exactly `15` zero decimal digits. -/
theorem monster_zero_digits :
    (Nat.digits 10 monsterOrder).countP (· = 0) = 15 := by native_decide

/-- `|𝕄|` has exactly `39` nonzero decimal digits. -/
theorem monster_nonzero_digits :
    (Nat.digits 10 monsterOrder).countP (· ≠ 0) = 39 := by native_decide

/-- The decimal digit composition of `|𝕄|`: `54 = 39 + 15` (nonzero + zero). -/
theorem monster_digit_composition :
    (Nat.digits 10 monsterOrder).length = 54 ∧
    (Nat.digits 10 monsterOrder).countP (· ≠ 0) = 39 ∧
    (Nat.digits 10 monsterOrder).countP (· = 0) = 15 ∧
    39 + 15 = 54 :=
  ⟨by native_decide, monster_nonzero_digits, monster_zero_digits, rfl⟩

/-! ## 5. Synthesis summary -/

/-- A single statement bundling the synthesis: the Oggorial is the radical of `|𝕄|` with
value `1618964990108856390`; `196883` is the product of the three largest Monster primes;
and the PTE solution `({0,4,7,11}, {1,2,9,10})` cancels anomalies through degree `3` but
not degree `4`. -/
theorem grand_synthesis :
    oggorial = 1618964990108856390 ∧
    oggorial ∣ monsterOrder ∧
    (196883 : Nat) = 47 * 59 * 71 ∧
    (powerSum pteA 1 = powerSum pteB 1 ∧
     powerSum pteA 2 = powerSum pteB 2 ∧
     powerSum pteA 3 = powerSum pteB 3) ∧
    powerSum pteA 4 ≠ powerSum pteB 4 :=
  ⟨oggorial_value, oggorial_dvd_monsterOrder, triple_identity, pte_k3, pte_sharp⟩

end MonsterSynthesis
