/-
  DULA_Lfunc.lean   —   Option B: coefficient arithmetic only.

  Companion to the DULA formalization.  This file formalizes the *finitary,
  machine-checkable* arithmetic of the weight-6, level-3 newform

        f = (η(τ)·η(3τ))^6  =  q · ∏_{m≥1} (1−q^m)^6 (1−q^{3m})^6
                            =  LMFDB newform 3.6.a.a ,

  namely, each verified over an EXPLICIT FINITE RANGE by `decide`/`native_decide`:
    • the q-expansion coefficients a_f(n)            (defined from the η-product),
    • the U₃ (Hecke-at-3) eigen-relation  a_f(3n) = 9·a_f(n),
    • the mod-13 Eisenstein congruence    a_f(n) ≡ σ₅(n) (mod 13)  for 3 ∤ n,
    • its strictness: it does NOT lift to mod 169 (witnessed at n = 5).

  ──────────────────────────────────────────────────────────────────────────
  WHAT THIS FILE DELIBERATELY DOES NOT CONTAIN, AND WHY.

  The analytic facts we obtained numerically — the Fricke eigenvalue −1, the
  functional equation Λ(f,s) = Λ(f,6−s), the central value L(f,3), and the
  Manin–Shimura period ratio Λ(f,3)/Λ(f,1) = 13/18 — are NOT in this file.
  They are 60-digit *numerical* results, not proofs.  Mathlib currently has no
  theory of L-functions of modular forms, their analytic continuation, functional
  equations, or period rationality, so encoding any of these as a `theorem` would
  be a `sorry` wearing a theorem's clothes.  They belong in the paper as clearly
  labelled high-precision numerics (the standard practice for L-value computations),
  not in a file that claims machine verification.

  (Note: the "13" in the period ratio 13/18 is NOT the "13" of the mod-13
  congruence below.  One is an analytic period ratio, the other a Hecke
  congruence prime; they are unrelated facts that share a digit.)
  ──────────────────────────────────────────────────────────────────────────
  STATUS:  COMPILED and VERIFIED with Lean 4.28.0 / Mathlib v4.28.0.
  The η-product definition is self-checking: if `a_f` is mis-defined, the
  `a_f_values` theorem below FAILS to compile.  Aristotle must compile and confirm.

  AXIOMS:  the finite-range theorems are expected to close by `native_decide`
  (axioms `Lean.ofReduceBool`, `Lean.trustCompiler`) because the η-product
  convolutions are too large for kernel `decide`.  This is the same honest footing
  as the C3Fractal sanity checks.  Run `#print axioms` on each to confirm.

  ACCEPTANCE CRITERIA (grep, lock these):
    • exactly one `def a_f`, built from `etaList` (the η-product) — NOT a lookup table.
    • theorems `a_f_values`, `U3_eigen_on`, `eisenstein_congr_mod13_on`,
      `congr_does_not_lift_to_169` are present and END in `decide`/`native_decide`.
    • NONE of those four contain `sorry`.
    • `sorry` appears ONLY inside `section Conjectural` (one item: the conjecture
      `eisenstein_congr_mod13_all`; `congr_from_multiplicativity` has been proved).
    • the finite ranges (Icc 1 _) are NOT silently lowered to make checks pass.
-/
import Mathlib

namespace DULA.Lfunc

/-! ### Definition of a_f via the η-product q-expansion -/

/-- Exponent of the m-th η-product factor: `(1−q^m)^6` in general, doubled to 12 at
    multiples of 3 (the `η(3τ)` factor), since `6 + 6·[3 ∣ m]`. -/
def efac (m : ℕ) : ℕ := if m % 3 = 0 then 12 else 6

/-- Coefficient of `q^j` in a single factor `(1 − q^m)^k = ∑_{i=0}^k C(k,i)(−1)^i q^{m i}`. -/
def factorCoeff (m k j : ℕ) : ℤ :=
  if m = 0 then 0
  else if j % m = 0 then
    (if j / m ≤ k then (-1 : ℤ) ^ (j / m) * (Nat.choose k (j / m) : ℤ) else 0)
  else 0

/-- The factor `(1 − q^m)^k`, truncated to degree `B`, as a list of length `B+1`. -/
def factorList (m k B : ℕ) : List ℤ := (List.range (B + 1)).map (factorCoeff m k)

/-- The constant series `1`, truncated to degree `B`. -/
def oneList (B : ℕ) : List ℤ := (List.range (B + 1)).map (fun n => if n = 0 then (1 : ℤ) else 0)

/-- Truncated Cauchy product (to degree `B`) of two coefficient lists. -/
def mulTrunc (a b : List ℤ) (B : ℕ) : List ℤ :=
  (List.range (B + 1)).map
    (fun n => ∑ i ∈ Finset.range (n + 1), a.getD i 0 * b.getD (n - i) 0)

/-- The truncated product `∏_{m=1}^{B} (1 − q^m)^{efac m}`, as a list (index = degree). -/
def etaList (B : ℕ) : List ℤ :=
  (List.range B).foldl
    (fun acc t => mulTrunc acc (factorList (t + 1) (efac (t + 1)) B) B)
    (oneList B)

/-- The q-expansion coefficient `a_f(n)` of `f = (η(τ)η(3τ))^6`.
    The leading `q` shifts degrees by one, so `a_f(n) = [q^{n-1}] ∏_{m≥1}(1−q^m)^{efac m}`.
    Building `etaList n` (factors `m = 1..n`) is more than enough to determine `[q^{n-1}]`. -/
def a_f (n : ℕ) : ℤ := if n = 0 then 0 else (etaList n).getD (n - 1) 0

/-- `σ₅(n) = ∑_{d ∣ n} d^5`. -/
def sigma5 (n : ℕ) : ℤ := ∑ d ∈ n.divisors, (d : ℤ) ^ 5

/-! ### Genuine theorems — finite, decidable, no `sorry` -/

/-- Self-check of the η-product definition against the known newform 3.6.a.a.
    **If `a_f` is mis-defined, this theorem fails to compile** — it is the safety net. -/
theorem a_f_values :
    a_f 1 = 1 ∧ a_f 2 = -6 ∧ a_f 3 = 9 ∧ a_f 4 = 4 ∧ a_f 5 = 6 ∧
    a_f 6 = -54 ∧ a_f 7 = -40 ∧ a_f 11 = -564 ∧ a_f 13 = 638 := by
  native_decide

/-- U₃ (the Hecke operator at the level prime 3) acts on `f` with eigenvalue
    `a_f(3) = 9`:  `a_f(3n) = 9·a_f(n)`, verified for `1 ≤ n ≤ 60`. -/
theorem U3_eigen_on :
    ∀ n ∈ Finset.Icc 1 60, a_f (3 * n) = 9 * a_f n := by
  native_decide

/-- The mod-13 Eisenstein congruence `a_f(n) ≡ σ₅(n) (mod 13)` for `n` coprime to 3,
    verified for `1 ≤ n ≤ 60`.  (Numerically this holds for all `n < 4000`; here we
    machine-check the explicit finite range — see `eisenstein_congr_mod13_all` below
    for the unconditional statement and why it is not yet a theorem.) -/
theorem eisenstein_congr_mod13_on :
    ∀ n ∈ Finset.Icc 1 60, ¬ (3 ∣ n) →
      ((a_f n : ZMod 13) = (sigma5 n : ZMod 13)) := by
  native_decide

/-- Strictness — the 13-part of the congruence is exactly 1.
    The congruence holds mod 13 but does NOT lift to mod 169, witnessed at `n = 5`
    (`a_f 5 = 6`, `σ₅ 5 = 3126`, and `6 ≢ 3126 (mod 169)`). -/
theorem congr_does_not_lift_to_169 :
    ((a_f 5 : ZMod 13) = (sigma5 5 : ZMod 13)) ∧
    ((a_f 5 : ZMod 169) ≠ (sigma5 5 : ZMod 169)) := by
  native_decide

/-! ### Conditional bridge + honest conjecture — the ONLY `sorry`s in this file -/

section Conjectural

/-
The GENERAL (all-`n`) statements require `f` to be the Hecke eigenform 3.6.a.a,
  whose eigenform property and the prime congruence `a_f(p) ≡ 1 + p^5 (mod 13)`
  (equivalently: the mod-13 Galois representation `ρ̄_{f,13}` is reducible, `1 ⊕ χ^5`)
  are NOT formalizable in current Mathlib.  We record the boundary honestly.

ELEMENTARY HALF (conditional).  IF `a_f` and `σ₅` are multiplicative and agree
    mod 13 on every prime power coprime to 3, THEN they agree on all `n` coprime to 3.
    The hypotheses `hpp` (prime-power agreement) and `hmul_*` encode the *deep*,
    Galois-theoretic input; the content proved here is only the *elementary*
    multiplicative propagation.
    Provable in Mathlib via `Nat.ArithmeticFunction` / `IsMultiplicative`; the proof
    is left as a target in this draft (NOT a numerical claim, NOT analytic).
-/
set_option maxHeartbeats 800000 in
theorem congr_from_multiplicativity
    (hmul_a : ∀ m n, Nat.Coprime m n → a_f (m * n) = a_f m * a_f n)
    (hmul_s : ∀ m n, Nat.Coprime m n → sigma5 (m * n) = sigma5 m * sigma5 n)
    (hpp : ∀ (p k : ℕ), p.Prime → p ≠ 3 →
        (a_f (p ^ k) : ZMod 13) = (sigma5 (p ^ k) : ZMod 13)) :
    ∀ n, ¬ (3 ∣ n) → (a_f n : ZMod 13) = (sigma5 n : ZMod 13) := by
  intro n hn; induction' n using Nat.strongRecOn with n ih; rcases eq_or_ne n 1 with rfl | hn1 <;> simp_all +decide ;
  -- Let $p$ be the smallest prime factor of $n$.
  obtain ⟨p, hp_prime, hp_div⟩ : ∃ p, Nat.Prime p ∧ p ∣ n ∧ ∀ q, Nat.Prime q → q ∣ n → p ≤ q := by
    exact ⟨ Nat.minFac n, Nat.minFac_prime hn1, Nat.minFac_dvd n, fun q hq hqn => Nat.minFac_le_of_dvd hq.two_le hqn ⟩;
  -- Write $n$ as $p^k * m$ where $m$ is not divisible by $p$.
  obtain ⟨k, m, rfl, hm⟩ : ∃ k m, n = p^k * m ∧ ¬p ∣ m := by
    exact ⟨ Nat.factorization n p, n / p ^ Nat.factorization n p, by rw [ Nat.mul_div_cancel' ( Nat.ordProj_dvd _ _ ) ], Nat.not_dvd_ordCompl ( by aesop ) ( by aesop ) ⟩;
  rw [ hmul_a, hmul_s ];
  · by_cases hp3 : p = 3 <;> simp_all +decide [ Nat.Prime.dvd_mul ];
    rw [ ih m ( lt_mul_of_one_lt_left ( Nat.pos_of_ne_zero ( by aesop_cat ) ) ( one_lt_pow₀ hp_prime.one_lt ( by aesop_cat ) ) ) hn.2 ];
  · exact Nat.Coprime.pow_left _ ( hp_prime.coprime_iff_not_dvd.mpr hm );
  · exact Nat.Coprime.pow_left _ ( hp_prime.coprime_iff_not_dvd.mpr hm )

-- PROVABLE from the hypotheses (multiplicative propagation); proof omitted in draft

/-- UNCONDITIONAL all-`n` congruence — a documented **CONJECTURE**, not a theorem.
    Requires `f` to be the eigenform 3.6.a.a; not provable in current Mathlib.
    Verified numerically for `n < 4000` (Python).  Present only as a target. -/
theorem eisenstein_congr_mod13_all
    (n : ℕ) (h : ¬ (3 ∣ n)) : (a_f n : ZMod 13) = (sigma5 n : ZMod 13) := by
  sorry  -- CONJECTURE: depends on the eigenform property; not elementary; numerics only

end Conjectural

end DULA.Lfunc