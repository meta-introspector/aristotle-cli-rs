/-
# Aperiodicity is *exactly* the absence of nontrivial group divisors

`RequestProject/KrohnRhodes/TransitionMonoid.lean` proves one direction: an
aperiodic monoid of state maps has no nontrivial group divisor. That direction
is what the safety claim uses, but on its own it leaves open the possibility
that `IsAperiodic` is simply too strong a hypothesis — that it excludes group
structure only because it excludes almost everything.

This file closes the gap by proving the **converse** for a finite state set: if
the monoid is *not* aperiodic, then a nontrivial cyclic group `ZMod p`
(`p ≥ 2`) really does divide it. Hence, for a finite state set,

  aperiodic  ↔  no nontrivial group divides the monoid

(`isAperiodic_iff_no_cyclic_divisor`). So "group complexity 0" as used in this
development is not an artefact of the definition: it is equivalent to the
intrinsic, group-theoretic statement.

The construction is the classical one for finite semigroups: the powers of a
non-aperiodic element `f` are eventually periodic with some minimal period
`p ≥ 2`, and `{f ^ (N + j) : j < p}` — with `N` a multiple of `p` past the
index — is a cyclic group of order `p` sitting inside the monoid (its identity
is the idempotent `f ^ N`, not the identity map, which is exactly why
`GroupDivides` is stated with a `MulHom`).
-/
import RequestProject.KrohnRhodes.TransitionMonoid

namespace KrohnRhodes

open Function

variable {Q : Type*}

/-! ## Eventual periodicity of powers in a finite transformation monoid -/

/-- In a finite monoid of state maps, the powers of any element are eventually
periodic. -/
lemma exists_eventual_period [Finite Q] (f : Function.End Q) :
    ∃ p, 0 < p ∧ ∃ i, ∀ n, i ≤ n → f ^ (n + p) = f ^ n := by
  have : Finite (Function.End Q) := inferInstanceAs (Finite (Q → Q))
  obtain ⟨a, b, hab, h⟩ := Finite.exists_ne_map_eq_of_infinite (fun n : ℕ => f ^ n)
  rcases lt_or_gt_of_ne hab with hlt | hlt
  · refine ⟨b - a, by omega, a, ?_⟩
    intro n hn
    have hb : b = a + (b - a) := by omega
    have hstep : f ^ (a + (b - a)) = f ^ a := by rw [← hb]; exact h.symm
    calc f ^ (n + (b - a)) = f ^ (a + (b - a)) * f ^ (n - a) := by
          rw [← pow_add]; congr 1; omega
    _ = f ^ a * f ^ (n - a) := by rw [hstep]
    _ = f ^ n := by rw [← pow_add]; congr 1; omega
  · refine ⟨a - b, by omega, b, ?_⟩
    intro n hn
    have ha : a = b + (a - b) := by omega
    have hstep : f ^ (b + (a - b)) = f ^ b := by rw [← ha]; exact h
    calc f ^ (n + (a - b)) = f ^ (b + (a - b)) * f ^ (n - b) := by
          rw [← pow_add]; congr 1; omega
    _ = f ^ b * f ^ (n - b) := by rw [hstep]
    _ = f ^ n := by rw [← pow_add]; congr 1; omega

/-- Periodicity propagates to all multiples of the period. -/
lemma pow_add_mul_period (f : Function.End Q) {p i : ℕ}
    (h : ∀ n, i ≤ n → f ^ (n + p) = f ^ n) :
    ∀ k n, i ≤ n → f ^ (n + k * p) = f ^ n := by
  intro k
  induction k with
  | zero => intro n _; simp
  | succ k ih =>
      intro n hn
      have : n + (k + 1) * p = (n + k * p) + p := by ring
      rw [this, h _ (by omega), ih n hn]

/-- Two exponents past the index that are congruent modulo the period give the
same power. -/
lemma pow_eq_pow_of_mod_eq (f : Function.End Q) {p i : ℕ}
    (h : ∀ n, i ≤ n → f ^ (n + p) = f ^ n) {a b : ℕ} (ha : i ≤ a) (hb : i ≤ b)
    (hab : a % p = b % p) : f ^ a = f ^ b := by
  have key : ∀ x y : ℕ, i ≤ x → x ≤ y → x % p = y % p → f ^ x = f ^ y := by
    intro x y hx hxy hmod
    obtain ⟨k, hk⟩ : p ∣ y - x := (Nat.modEq_iff_dvd' hxy).mp hmod
    rw [Nat.mul_comm] at hk
    have hy : y = x + k * p := by omega
    rw [hy, pow_add_mul_period f h k x hx]
  rcases le_total a b with hle | hle
  · exact key a b ha hle hab
  · exact (key b a hb hle hab.symm).symm

/-! ## The nontrivial cyclic divisor of a non-aperiodic monoid -/

/-- **Converse to `subsingleton_of_isAperiodic_of_groupDivides`.** If a monoid of
state maps on a finite state set is not aperiodic, then some nontrivial cyclic
group `ZMod p`, `p ≥ 2`, divides it. -/
theorem exists_cyclic_divisor_of_not_isAperiodic [Finite Q] {M : Submonoid (Function.End Q)}
    (h : ¬ IsAperiodic M) :
    ∃ p : ℕ, 2 ≤ p ∧ GroupDivides M (Multiplicative (ZMod p)) := by
  classical
  rw [IsAperiodic] at h
  push_neg at h
  obtain ⟨f, hfM, hf⟩ := h
  have hSne : ∃ p, 0 < p ∧ ∃ i, ∀ n, i ≤ n → f ^ (n + p) = f ^ n := exists_eventual_period f
  set p := Nat.find hSne with hpdef
  obtain ⟨hppos, i, hper⟩ := Nat.find_spec hSne
  have hp2 : 2 ≤ p := by
    by_contra hlt
    have hp1 : p = 1 := by omega
    have hstep := hper i le_rfl
    rw [← hpdef, hp1] at hstep
    exact hf i hstep
  haveI : NeZero p := ⟨by omega⟩
  -- `N` is a multiple of `p` past the index `i`
  set N := p * (i + 1) with hNdef
  have hNi : i ≤ N := by nlinarith [hppos]
  have hNmod : ∀ c : ℕ, (c + N) % p = c % p := by
    intro c
    rw [hNdef, Nat.add_mul_mod_self_left]
  -- the candidate group elements: `f ^ (N + j)` for `j < p`
  have hpow : ∀ a b : ℕ, a % p = b % p → f ^ (N + a) = f ^ (N + b) := by
    intro a b hab
    refine pow_eq_pow_of_mod_eq f hper (by omega) (by omega) ?_
    have h1 : (N + a) % p = a % p := by rw [Nat.add_comm N a, hNmod]
    have h2 : (N + b) % p = b % p := by rw [Nat.add_comm N b, hNmod]
    rw [h1, h2, hab]
  refine ⟨p, hp2, ?_⟩
  refine ⟨⟨fun k => f ^ (N + (Multiplicative.toAdd k).val), ?_⟩, ?_, ?_⟩
  · -- multiplicativity
    intro k l
    have hmul : (Multiplicative.toAdd (k * l)) = Multiplicative.toAdd k + Multiplicative.toAdd l :=
      rfl
    have hval : (Multiplicative.toAdd (k * l)).val =
        ((Multiplicative.toAdd k).val + (Multiplicative.toAdd l).val) % p := by
      rw [hmul, ZMod.val_add]
    simp only [hval]
    set a := (Multiplicative.toAdd k).val
    set b := (Multiplicative.toAdd l).val
    have hsum : f ^ (N + a) * f ^ (N + b) = f ^ (N + (N + a + b)) := by
      rw [← pow_add]; congr 1; omega
    rw [hsum]
    refine hpow _ _ ?_
    have h1 : (N + a + b) % p = (a + b) % p := by
      have hcomm : N + a + b = (a + b) + N := by omega
      rw [hcomm, hNmod]
    simp [h1]
  · -- injectivity
    intro k l hkl
    have hkl' : f ^ (N + (Multiplicative.toAdd k).val) = f ^ (N + (Multiplicative.toAdd l).val) :=
      hkl
    have key : ∀ x y : Multiplicative (ZMod p),
        (Multiplicative.toAdd x).val ≤ (Multiplicative.toAdd y).val →
        f ^ (N + (Multiplicative.toAdd x).val) = f ^ (N + (Multiplicative.toAdd y).val) →
        (Multiplicative.toAdd x).val = (Multiplicative.toAdd y).val := by
      intro x y hxy hfxy
      by_contra hne
      set a := (Multiplicative.toAdd x).val
      set b := (Multiplicative.toAdd y).val
      have hbp : b < p := ZMod.val_lt _
      have hd : 0 < b - a ∧ b - a < p := by omega
      have hmem : 0 < b - a ∧ ∃ j, ∀ n, j ≤ n → f ^ (n + (b - a)) = f ^ n := by
        refine ⟨hd.1, N + a, ?_⟩
        intro n hn
        have h1 : n + (b - a) = (N + b) + (n - (N + a)) := by omega
        have h2 : n = (N + a) + (n - (N + a)) := by omega
        rw [h1, pow_add, ← hfxy, ← pow_add, ← h2]
      have hle2 : p ≤ b - a := by
        rw [hpdef]; exact Nat.find_le (h := hSne) hmem
      omega
    rcases le_total (Multiplicative.toAdd k).val (Multiplicative.toAdd l).val with hle | hle
    · have := key k l hle hkl'
      exact Multiplicative.toAdd.injective (ZMod.val_injective p this)
    · have := key l k hle hkl'.symm
      exact Multiplicative.toAdd.injective (ZMod.val_injective p this.symm)
  · -- membership
    intro k
    exact pow_mem hfM _

/-- **Aperiodicity, intrinsically.** For a finite state set, a monoid of state
maps is aperiodic exactly when no nontrivial cyclic group divides it — and hence
(with `subsingleton_of_isAperiodic_of_groupDivides`) exactly when no nontrivial
group at all divides it. -/
theorem isAperiodic_iff_no_cyclic_divisor [Finite Q] (M : Submonoid (Function.End Q)) :
    IsAperiodic M ↔ ∀ p : ℕ, 2 ≤ p → ¬ GroupDivides M (Multiplicative (ZMod p)) := by
  constructor
  · intro hM p hp hdiv
    have hcard := card_eq_one_of_isAperiodic_of_groupDivides hM hdiv
    have : Nat.card (Multiplicative (ZMod p)) = p := by
      haveI : NeZero p := ⟨by omega⟩
      simp [Nat.card_eq_fintype_card]
    omega
  · intro hM
    by_contra hcon
    obtain ⟨p, hp, hdiv⟩ := exists_cyclic_divisor_of_not_isAperiodic hcon
    exact hM p hp hdiv

/-- **Group complexity `0`, intrinsically, for automata.** A recognizer over a
finite state set has group complexity `0` exactly when no nontrivial cyclic
group divides its transition monoid. -/
theorem groupComplexityZero_iff_no_cyclic_divisor {A : Type*} [Finite Q] (D : DFA A Q) :
    GroupComplexityZero D ↔
      ∀ p : ℕ, 2 ≤ p → ¬ GroupDivides (transitionMonoid D) (Multiplicative (ZMod p)) :=
  isAperiodic_iff_no_cyclic_divisor _

end KrohnRhodes
