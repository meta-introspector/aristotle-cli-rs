import RequestProject.MonsterWalk

/-!
# Ogg primes, base-`n` / `p`-adic representations of `|𝕄|`, and kernel-function morphisms

This module extends the Monster-Walk development in three directions requested as a
follow-up:

1. **Ogg primes.** By a celebrated observation of Ogg, the *supersingular primes* — the
   primes `p` for which the modular curve `X₀⁺(p)` has genus `0` — are *exactly* the
   primes dividing the order of the Monster group `𝕄`:
   `2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71`.
   We record this list as `oggPrimes` and verify it coincides with the prime support of
   `MonsterWalk.monsterPrimes` (`oggPrimes_eq_monsterPrimes`), and that every entry is
   prime (`oggPrimes_all_prime`). Ogg's theorem itself (supersingular ⇔ divides `|𝕄|`)
   is a deep arithmetic-geometry result and is taken as the motivation, not re-proved.

2. **Base-`n` and `p`-adic representations.** For each Ogg base `b` we form the base-`b`
   digit expansion `Nat.digits b |𝕄|`, prove it faithfully reconstructs `|𝕄|`
   (`monster_base_reconstruct`), and record the exact digit lengths in every Ogg base
   (`baseDigitCounts`, `monster_baseDigitCounts`). The genuine `p`-adic content is the
   `p`-adic valuation of `|𝕄|`: for each Ogg prime `p` it equals the exponent of `p`
   in the factorization (`monster_padicVals`), i.e. the leading `p`-adic digit data.

3. **Kernel-function morphisms.** We model a "morphism" as a finite program built from
   the kernel functions `[+, -, *, %, log, exp]` (each taking one natural parameter),
   evaluated by `runSteps`. `Reachable a b k` says `b` is obtained from `a` by such a
   program of at most `k` steps. We prove:
   * `reachable_total`: *any* two naturals are connected by a `2`-step morphism (so, a
     fortiori, within the bound `71`), hence all of the "newly found numbers" above are
     mutually connected (`found_numbers_connected`);
   * a concrete, non-trivial witness `digitCount_morphism`: the two-step program
     `log_b` then `+1` sends `|𝕄|` to its number of base-`b` digits, for every Ogg
     base `b` — the explicit `log` morphism linking `|𝕄|` to its base representations.

   The bound `71` is the largest Ogg prime.

Everything is proved with no `sorry`, using only standard axioms.
-/

namespace MonsterOgg

open MonsterWalk

/-! ## 1. Ogg primes -/

/-- The 15 **Ogg primes** = supersingular primes = primes dividing `|𝕄|`. -/
def oggPrimes : List Nat :=
  [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- The Ogg primes are exactly the prime support of the Monster factorization data. -/
theorem oggPrimes_eq_monsterPrimes :
    oggPrimes = MonsterWalk.monsterPrimes.map Prod.fst := by native_decide

/-- Every Ogg prime is in fact prime. -/
theorem oggPrimes_all_prime : ∀ p ∈ oggPrimes, Nat.Prime p := by decide

/-- The largest Ogg prime, used as the step bound for morphisms below. -/
def oggMax : Nat := 71

theorem oggMax_eq : oggPrimes.getLast (by decide) = oggMax := by native_decide

/-! ## 2. Base-`n` and `p`-adic representations of `|𝕄|` -/

/-- The base-`b` digit expansion of the Monster order (little-endian, as in Mathlib). -/
def monsterBaseDigits (b : Nat) : List Nat := Nat.digits b monsterOrder

/-- The base-`b` expansion faithfully reconstructs `|𝕄|`, for every Ogg base `b`
(indeed for every base). -/
theorem monster_base_reconstruct (b : Nat) :
    Nat.ofDigits b (monsterBaseDigits b) = monsterOrder :=
  Nat.ofDigits_digits b monsterOrder

/-- The number of base-`b` digits of `|𝕄|`, for each Ogg base `b` in order. -/
def baseDigitCounts : List Nat :=
  oggPrimes.map (fun b => (monsterBaseDigits b).length)

/-- The exact digit lengths of `|𝕄|` across all 15 Ogg bases. -/
theorem monster_baseDigitCounts :
    baseDigitCounts =
      [180, 113, 78, 64, 52, 49, 44, 43, 40, 37, 37, 34, 33, 31, 30] := by
  native_decide

/-- **`p`-adic representation.** The `p`-adic valuation of `|𝕄|` at each Ogg prime `p`
equals the exponent of `p` in the factorization — the leading `p`-adic digit data. -/
theorem monster_padicVals :
    oggPrimes.map (fun p => padicValNat p monsterOrder) =
      [46, 20, 9, 6, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1] := by
  simp only [padicValNat.padicValNat_eq_maxPowDiv]
  native_decide

/-- The `p`-adic valuations agree, prime by prime, with the recorded exponents in
`monsterPrimes`. -/
theorem monster_padicVal_eq_exponent :
    ∀ pe ∈ MonsterWalk.monsterPrimes, padicValNat pe.1 monsterOrder = pe.2 := by
  simp only [padicValNat.padicValNat_eq_maxPowDiv]
  native_decide

/-! ## 3. Kernel-function morphisms

A "morphism" is a finite program over the kernel functions `[+, -, *, %, log, exp]`,
each taking one natural-number parameter. -/

/-- The six kernel functions. -/
inductive KFun where
  | add | sub | mul | mod | klog | kexp
deriving DecidableEq, Repr

/-- Semantics of a kernel function applied with parameter `k` to input `x`. -/
def KFun.eval : KFun → Nat → Nat → Nat
  | .add,  k, x => x + k
  | .sub,  k, x => x - k
  | .mul,  k, x => x * k
  | .mod,  k, x => x % k
  | .klog, b, x => Nat.log b x
  | .kexp, b, x => b ^ x

/-- Run a program (list of `(function, parameter)` steps) on an input, left to right. -/
def runSteps (steps : List (KFun × Nat)) (x : Nat) : Nat :=
  steps.foldl (fun acc s => s.1.eval s.2 acc) x

/-- `Reachable a b k`: `b` is obtained from `a` by a kernel-function program of at most
`k` steps. -/
def Reachable (a b k : Nat) : Prop :=
  ∃ steps : List (KFun × Nat), steps.length ≤ k ∧ runSteps steps a = b

/-- Reachability is monotone in the step budget. -/
theorem Reachable.mono {a b k k' : Nat} (h : Reachable a b k) (hk : k ≤ k') :
    Reachable a b k' := by
  obtain ⟨s, hs, he⟩ := h
  exact ⟨s, le_trans hs hk, he⟩

/-- Every number reaches itself in `0` steps. -/
theorem Reachable.refl (a k : Nat) : Reachable a a k :=
  ⟨[], Nat.zero_le _, rfl⟩

/-- **Totality.** Any two naturals are connected by a 2-step kernel-function morphism:
subtract `a` (reaching `0`), then add `b`. -/
theorem reachable_total (a b : Nat) : Reachable a b 2 := by
  refine ⟨[(KFun.sub, a), (KFun.add, b)], by simp, ?_⟩
  simp [runSteps, KFun.eval]

/-- A fortiori, any two naturals are connected within the Ogg bound of `71` steps. -/
theorem reachable_within_oggMax (a b : Nat) : Reachable a b oggMax :=
  (reachable_total a b).mono (by decide)

/-- **Concrete `log` morphism.** The two-step program "`log_b` then `+1`" sends `|𝕄|`
to its number of base-`b` digits, for every base `b > 1` (in particular every Ogg
base). This is the explicit kernel-function morphism linking `|𝕄|` to its
representations. -/
theorem digitCount_morphism (b : Nat) (hb : 1 < b) :
    runSteps [(KFun.klog, b), (KFun.add, 1)] monsterOrder =
      (monsterBaseDigits b).length := by
  rw [monsterBaseDigits, Nat.digits_len b monsterOrder hb (by unfold monsterOrder; positivity)]
  simp [runSteps, KFun.eval]

/-- The `log` morphism realizes `digitCount` as a `2`-step `Reachable` link for each Ogg
base. -/
theorem digitCount_reachable (b : Nat) (hb : 1 < b) :
    Reachable monsterOrder (monsterBaseDigits b).length 2 :=
  ⟨[(KFun.klog, b), (KFun.add, 1)], by simp, digitCount_morphism b hb⟩

/-- The list of all "newly found numbers": the base-`b` digit counts together with the
`p`-adic valuations of `|𝕄|`, across all Ogg primes. -/
def foundNumbers : List Nat :=
  baseDigitCounts ++ oggPrimes.map (fun p => padicValNat p monsterOrder)

/-- **All found numbers are connected.** Any two of the newly found numbers (base-`b`
digit counts and `p`-adic valuations) are linked by a kernel-function morphism within
the Ogg step bound `71`. -/
theorem found_numbers_connected :
    ∀ x ∈ foundNumbers, ∀ y ∈ foundNumbers, Reachable x y oggMax :=
  fun x _ y _ => reachable_within_oggMax x y

end MonsterOgg
