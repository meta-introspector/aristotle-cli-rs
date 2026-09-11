import Mathlib
import RequestProject.MonsterWalk
import RequestProject.MonsterWalkFactors
import RequestProject.MonsterFactorShadow

/-!
# Monster-smoothness as a closure property

`RequestProject.MonsterWalkFactors` defined a number to be *Monster-smooth* when all of its
prime factors lie among the fifteen Monster primes.  This module studies smoothness as a
**closure property**: which operations preserve it?

We work with the general predicate `SmoothOver S n := n.primeFactors ⊆ S` for an arbitrary
finite prime-support `S`, of which `MonsterSmooth = SmoothOver monsterPrimeFs` is the special
case (`monsterSmooth_iff_smoothOver`).  Smoothness over a fixed support is closed under:

* **divisors** (`SmoothOver.of_dvd`): a divisor of a smooth number is smooth;
* **products** (`SmoothOver.mul`): a product of smooth numbers is smooth;
* **gcd** (`SmoothOver.gcd_left` / `SmoothOver.gcd_right`): the gcd is smooth as soon as
  *either* argument is;
* **lcm** (`SmoothOver.lcm`): the lcm of two smooth numbers is smooth.

CRT-style recombination is just a product of pairwise-coprime parts, so it inherits
`SmoothOver.mul`.

Finally we apply this to the factor-shadow split.  For a Monster-smooth shadow
`L = gcd(L,R) · gcd(L,P)` (see `MonsterFactorShadow.smooth_shadow_gcd_split`), **both**
components stay Monster-smooth (`shadow_gcd_split_components_smooth`): smoothness is preserved
in each slot, even though the split entangles "removed" and "surviving" primes.
-/

namespace MonsterSmoothClosure

open MonsterWalk MonsterWalkFactors MonsterFactorShadow

/-- `SmoothOver S n` : every prime factor of `n` lies in the finite support `S`. -/
def SmoothOver (S : Finset ℕ) (n : ℕ) : Prop := n.primeFactors ⊆ S

instance (S : Finset ℕ) (n : ℕ) : Decidable (SmoothOver S n) := by
  unfold SmoothOver; infer_instance

/-- `MonsterSmooth` is exactly `SmoothOver monsterPrimeFs`. -/
theorem monsterSmooth_iff_smoothOver (n : ℕ) :
    MonsterSmooth n ↔ SmoothOver monsterPrimeFs n := Iff.rfl

/-- `0` and `1` are smooth over any support (they have no prime factors). -/
theorem SmoothOver.zero (S : Finset ℕ) : SmoothOver S 0 := by
  simp [SmoothOver]

theorem SmoothOver.one (S : Finset ℕ) : SmoothOver S 1 := by
  simp [SmoothOver]

/-- **Closed under divisors.** A divisor of a smooth number is smooth. -/
theorem SmoothOver.of_dvd {S : Finset ℕ} {m n : ℕ} (hmn : m ∣ n) (hn : n ≠ 0)
    (h : SmoothOver S n) : SmoothOver S m :=
  (Nat.primeFactors_mono hmn hn).trans h

/-- **Closed under multiplication.** A product of smooth numbers is smooth. -/
theorem SmoothOver.mul {S : Finset ℕ} {m n : ℕ}
    (hm : SmoothOver S m) (hn : SmoothOver S n) : SmoothOver S (m * n) := by
  unfold SmoothOver at *
  rcases eq_or_ne m 0 with hm0 | hm0
  · simp [hm0]
  rcases eq_or_ne n 0 with hn0 | hn0
  · simp [hn0]
  · rw [Nat.primeFactors_mul hm0 hn0]
    exact Finset.union_subset hm hn

/-- **Closed under gcd (left).** If `m ≠ 0` is smooth then `gcd m n` is smooth.  (The
hypothesis `m ≠ 0` is necessary: `gcd 0 n = n` need not be smooth.) -/
theorem SmoothOver.gcd_left {S : Finset ℕ} {m n : ℕ} (hm0 : m ≠ 0) (hm : SmoothOver S m) :
    SmoothOver S (Nat.gcd m n) :=
  SmoothOver.of_dvd (Nat.gcd_dvd_left m n) hm0 hm

/-- **Closed under gcd (right).** If `n ≠ 0` is smooth then `gcd m n` is smooth. -/
theorem SmoothOver.gcd_right {S : Finset ℕ} {m n : ℕ} (hn0 : n ≠ 0) (hn : SmoothOver S n) :
    SmoothOver S (Nat.gcd m n) := by
  rw [Nat.gcd_comm]; exact SmoothOver.gcd_left hn0 hn

/-- **Closed under lcm.** The lcm of two smooth numbers is smooth. -/
theorem SmoothOver.lcm {S : Finset ℕ} {m n : ℕ}
    (hm : SmoothOver S m) (hn : SmoothOver S n) : SmoothOver S (Nat.lcm m n) := by
  rcases eq_or_ne m 0 with hm0 | hm0
  · simp [hm0, Nat.lcm, SmoothOver]
  rcases eq_or_ne n 0 with hn0 | hn0
  · simp [hn0, Nat.lcm, SmoothOver]
  · have hlcm : Nat.lcm m n ∣ m * n := Nat.lcm_dvd_mul m n
    have hmn0 : m * n ≠ 0 := Nat.mul_ne_zero hm0 hn0
    exact SmoothOver.of_dvd hlcm hmn0 (SmoothOver.mul hm hn)

/-! ## Application: the factor-shadow split stays Monster-smooth in each component -/

/-- **Component smoothness of the shadow split.** For each Monster-Walk group whose
leading-digit shadow `L` divides `|𝕄|` (hence is Monster-smooth), both pieces of the split
`L = gcd(L,R) · gcd(L,P)` are themselves Monster-smooth — the "removed" component
`gcd(L,R)` and the "surviving" component `gcd(L,P)`.  Smoothness is preserved in each slot
even though the split entangles removed and surviving primes. -/
theorem shadow_gcd_split_components_smooth :
    ∀ g ∈ monsterWalkGroups, shadow g ∣ monsterOrder →
      MonsterSmooth (Nat.gcd (shadow g) (removedProd g)) ∧
      MonsterSmooth (Nat.gcd (shadow g) (partialPart g)) := by
  intro g hg hdvd
  have hmono : monsterOrder ≠ 0 := by native_decide
  have hsg0 : shadow g ≠ 0 := by
    rintro h0
    rw [h0] at hdvd
    exact hmono (Nat.eq_zero_of_zero_dvd hdvd)
  have hsmooth : MonsterSmooth (shadow g) := by
    have : (shadow g ∣ monsterOrder ↔ MonsterSmooth (shadow g)) := by
      have hmem : shadow g ∈ walkSeqs := by
        have := walkSeqs_eq_group_sequences
        have : shadow g ∈ monsterWalkGroups.map (fun g => g.sequence.toNat!) := by
          exact List.mem_map.2 ⟨g, hg, rfl⟩
        rwa [walkSeqs_eq_group_sequences] at this
      exact factor_iff_monsterSmooth (shadow g) hmem
    exact this.1 hdvd
  rw [monsterSmooth_iff_smoothOver] at hsmooth
  exact ⟨SmoothOver.gcd_left hsg0 hsmooth, SmoothOver.gcd_left hsg0 hsmooth⟩

/-! ## Summary -/

/-- **Summary.** Smoothness over a fixed prime support is closed under divisors, products,
gcd, and lcm; consequently the factor-shadow split is Monster-smooth in both components. -/
theorem monster_smooth_closure_summary :
    (∀ (S : Finset ℕ) (m n : ℕ), SmoothOver S m → SmoothOver S n → SmoothOver S (m * n)) ∧
    (∀ (S : Finset ℕ) (m n : ℕ), SmoothOver S m → SmoothOver S n → SmoothOver S (Nat.lcm m n)) ∧
    (∀ (S : Finset ℕ) (m n : ℕ), m ∣ n → n ≠ 0 → SmoothOver S n → SmoothOver S m) :=
  ⟨fun _ _ _ => SmoothOver.mul, fun _ _ _ => SmoothOver.lcm, fun _ _ _ => SmoothOver.of_dvd⟩

end MonsterSmoothClosure
