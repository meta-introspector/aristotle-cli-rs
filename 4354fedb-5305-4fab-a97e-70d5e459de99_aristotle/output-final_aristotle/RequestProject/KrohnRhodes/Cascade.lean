/-
# Cascades (wreath products of transformation semigroups) and aperiodicity

The Krohn-Rhodes decomposition writes a finite automaton as a **cascade**
(a wreath product of transformation semigroups): a stack of layers in which each
layer reads the input letter *and* the state of the layers below it, but never
the state of the layers above it.

This file formalizes the one-step cascade and proves the theorem that makes
"group complexity 0" a *proved* rather than a *cited* notion in this
development:

* `KrohnRhodes.isAperiodicElem_cascade` — a single cascade transformation is
  aperiodic whenever its base component is aperiodic and each of its fibre
  components is aperiodic;
* `KrohnRhodes.transitionMonoid_isAperiodic_of_cascade` — hence the transition
  monoid of a cascade automaton is aperiodic whenever the base machine's
  transition monoid is aperiodic and the top layer's letter actions all lie in
  an aperiodic monoid;
* `KrohnRhodes.flipFlop` and `KrohnRhodes.isAperiodic_flipFlop` — the flip-flop
  ("reset") monoid `U₂ = {identity} ∪ {constants}` is such an aperiodic monoid.

Together with `RequestProject/KrohnRhodes/Aperiodic.lean` (aperiodic ⟺ no
nontrivial group divisor) this yields, by induction over layers, the certified
statement used by the VM in `RequestProject/VM/`: *a machine assembled purely
from reset layers has no nontrivial group divisor at all.* That is the
complexity-0 half of Krohn-Rhodes, proved here rather than assumed.
-/
import RequestProject.KrohnRhodes.Aperiodic

namespace KrohnRhodes

open Function

variable {R Q A : Type*}

/-! ## Aperiodic elements -/

/-- A single state map is **aperiodic** when its powers eventually stabilize. -/
def IsAperiodicElem (f : Function.End Q) : Prop := ∃ n, f ^ (n + 1) = f ^ n

lemma isAperiodic_iff_forall_isAperiodicElem (M : Submonoid (Function.End Q)) :
    IsAperiodic M ↔ ∀ f ∈ M, IsAperiodicElem f := Iff.rfl

/-- Stabilization propagates to all larger exponents. -/
lemma IsAperiodicElem.eventually {f : Function.End Q} (h : IsAperiodicElem f) :
    ∃ n, ∀ m, n ≤ m → f ^ (m + 1) = f ^ m := by
  obtain ⟨n, hn⟩ := h
  refine ⟨n, ?_⟩
  intro m hm
  obtain ⟨k, rfl⟩ : ∃ k, m = n + k := ⟨m - n, by omega⟩
  calc f ^ (n + k + 1) = f ^ (n + 1) * f ^ k := by rw [← pow_add]; congr 1; omega
  _ = f ^ n * f ^ k := by rw [hn]
  _ = f ^ (n + k) := by rw [← pow_add]

lemma pow_eq_pow_of_stable {f : Function.End Q} {N : ℕ}
    (h : ∀ m, N ≤ m → f ^ (m + 1) = f ^ m) : ∀ m, N ≤ m → f ^ m = f ^ N := by
  intro m hm
  obtain ⟨k, rfl⟩ : ∃ k, m = N + k := ⟨m - N, by omega⟩
  induction k with
  | zero => rfl
  | succ k ih =>
      have hk : N ≤ N + k := by omega
      have : f ^ (N + k + 1) = f ^ (N + k) := h _ hk
      rw [show N + (k + 1) = N + k + 1 from rfl, this, ih hk]

/-! ## The one-step cascade -/

/-- The transformation of the top layer accumulated along `n` steps: the base
component moves the fibre index, and the fibre transformations are composed
along that orbit. -/
private def cascadePow (τ : Q → Function.End R) (σ : Function.End Q) :
    ℕ → Q → Function.End R
  | 0, _ => 1
  | n + 1, q => τ ((σ ^ n) q) * cascadePow τ σ n q

private lemma cascadePow_apply (τ : Q → Function.End R) (σ : Function.End Q)
    {F : Function.End (R × Q)} (hF : ∀ r q, F (r, q) = (τ q r, σ q)) (n : ℕ) (r : R) (q : Q) :
    (F ^ n) (r, q) = (cascadePow τ σ n q r, (σ ^ n) q) := by
  induction n generalizing r q with
  | zero => rfl
  | succ n ih =>
      have hpow : (F ^ (n + 1)) (r, q) = F ((F ^ n) (r, q)) := by
        rw [pow_succ']
        rfl
      rw [hpow, ih r q, hF]
      have hσ : (σ ^ (n + 1)) q = σ ((σ ^ n) q) := by
        rw [pow_succ']
        rfl
      rw [hσ]
      rfl

/-- Along the orbit, past the point where the base component has stabilized, the
accumulated top transformation is a power of a single map. -/
private lemma cascadePow_eq_pow_mul (τ : Q → Function.End R) (σ : Function.End Q) {N : ℕ}
    (hσ : ∀ m, N ≤ m → (σ ^ (m + 1) : Function.End Q) = σ ^ m) (q : Q) :
    ∀ k, cascadePow τ σ (N + k) q = (τ ((σ ^ N) q)) ^ k * cascadePow τ σ N q := by
  intro k
  induction k with
  | zero => simp
  | succ k ih =>
      have hstep : cascadePow τ σ (N + k + 1) q
          = τ ((σ ^ (N + k)) q) * cascadePow τ σ (N + k) q := rfl
      have hfix : (σ ^ (N + k)) q = (σ ^ N) q := by
        rw [pow_eq_pow_of_stable hσ (N + k) (by omega)]
      rw [show N + (k + 1) = N + k + 1 from rfl, hstep, hfix, ih, ← mul_assoc, ← pow_succ']

/-- **Cascade aperiodicity, pointwise.** A transformation of `R × Q` that acts on
the base `Q` by `σ` and on the fibre by `τ q` (depending only on the base state)
is aperiodic as soon as `σ` and every `τ q` are. -/
theorem isAperiodicElem_cascade [Finite Q] {F : Function.End (R × Q)} {τ : Q → Function.End R}
    {σ : Function.End Q} (hF : ∀ r q, F (r, q) = (τ q r, σ q)) (hσ : IsAperiodicElem σ)
    (hτ : ∀ q, IsAperiodicElem (τ q)) : IsAperiodicElem F := by
  classical
  haveI : Fintype Q := Fintype.ofFinite Q
  obtain ⟨N, hN⟩ := hσ.eventually
  choose k hk using fun q : Q => (hτ ((σ ^ N) q)).eventually
  set K := Finset.univ.sup k with hK
  refine ⟨N + K, ?_⟩
  funext x
  obtain ⟨r, q⟩ := x
  have hkq : k q ≤ K := Finset.le_sup (f := k) (Finset.mem_univ q)
  have hbase : (σ ^ (N + K + 1)) q = (σ ^ (N + K)) q := by
    rw [pow_eq_pow_of_stable hN (N + K + 1) (by omega),
      pow_eq_pow_of_stable hN (N + K) (by omega)]
  have hfib : cascadePow τ σ (N + K + 1) q = cascadePow τ σ (N + K) q := by
    have h1 : cascadePow τ σ (N + (K + 1)) q
        = (τ ((σ ^ N) q)) ^ (K + 1) * cascadePow τ σ N q :=
      cascadePow_eq_pow_mul τ σ hN q (K + 1)
    have h2 : cascadePow τ σ (N + K) q = (τ ((σ ^ N) q)) ^ K * cascadePow τ σ N q :=
      cascadePow_eq_pow_mul τ σ hN q K
    have h3 : (τ ((σ ^ N) q)) ^ (K + 1) = (τ ((σ ^ N) q)) ^ K := hk q K hkq
    rw [show N + K + 1 = N + (K + 1) from rfl, h1, h2, h3]
  rw [cascadePow_apply τ σ hF, cascadePow_apply τ σ hF, hbase, hfib]

/-! ## The flip-flop (reset) monoid -/

/-- The **flip-flop monoid** `U₂` on a state set: the identity together with all
constant maps. This is the group-free building block of Krohn-Rhodes theory (a
"reset" component: each letter either does nothing or forces a fixed state). -/
def flipFlop (R : Type*) : Submonoid (Function.End R) where
  carrier := {f | f = 1 ∨ ∃ c : R, f = fun _ => c}
  one_mem' := Or.inl rfl
  mul_mem' := by
    rintro f g (rfl | ⟨c, rfl⟩) (rfl | ⟨d, rfl⟩)
    · exact Or.inl (by simp)
    · exact Or.inr ⟨d, by funext x; rfl⟩
    · exact Or.inr ⟨c, by funext x; rfl⟩
    · exact Or.inr ⟨c, by funext x; rfl⟩

lemma mem_flipFlop_iff {f : Function.End R} :
    f ∈ flipFlop R ↔ f = 1 ∨ ∃ c : R, f = fun _ => c := Iff.rfl

lemma const_mem_flipFlop (c : R) : (fun _ => c : Function.End R) ∈ flipFlop R :=
  Or.inr ⟨c, rfl⟩

/-- The flip-flop monoid is aperiodic: resets have no group structure. -/
theorem isAperiodic_flipFlop : IsAperiodic (flipFlop R) := by
  rintro f (rfl | ⟨c, rfl⟩)
  · exact ⟨0, by simp⟩
  · refine ⟨1, ?_⟩
    funext x
    rfl

/-! ## Cascade automata -/

/-- **Cascade shape is preserved by the generated monoid.** If every generator
acts on the base by `sQ a` and on the fibre by `sR a q` (depending only on the
base state), then so does every element of the generated monoid, with fibre
component in the submonoid `N` that contains the generators' fibre actions. -/
theorem exists_cascade_shape {sR : A → Q → Function.End R}
    {sQ : A → Function.End Q} {S : A → Function.End (R × Q)}
    (hS : ∀ a r q, S a (r, q) = (sR a q r, sQ a q))
    {N : Submonoid (Function.End R)} (hmem : ∀ a q, sR a q ∈ N) :
    ∀ f ∈ Submonoid.closure (Set.range S), ∃ τ : Q → Function.End R,
      (∀ q, τ q ∈ N) ∧ ∃ g ∈ Submonoid.closure (Set.range sQ),
        ∀ r q, f (r, q) = (τ q r, g q) := by
    intro f hf
    induction hf using Submonoid.closure_induction with
    | mem f hf =>
        obtain ⟨a, rfl⟩ := hf
        exact ⟨sR a, fun q => hmem a q, sQ a,
          Submonoid.subset_closure ⟨a, rfl⟩, fun r q => hS a r q⟩
    | one => exact ⟨fun _ => 1, fun _ => N.one_mem, 1, (Submonoid.closure _).one_mem,
        fun r q => rfl⟩
    | mul f₁ f₂ _ _ ih₁ ih₂ =>
        obtain ⟨τ₁, hτ₁, g₁, hg₁, h₁⟩ := ih₁
        obtain ⟨τ₂, hτ₂, g₂, hg₂, h₂'⟩ := ih₂
        refine ⟨fun q => τ₁ (g₂ q) * τ₂ q, fun q => N.mul_mem (hτ₁ _) (hτ₂ q),
          g₁ * g₂, (Submonoid.closure _).mul_mem hg₁ hg₂, ?_⟩
        intro r q
        show f₁ (f₂ (r, q)) = _
        rw [h₂' r q, h₁ (τ₂ q r) (g₂ q)]
        rfl

/-- **Cascade aperiodicity, for generated monoids.** If every generator splits as
a cascade, the generated monoid is aperiodic as soon as the base generated monoid
is aperiodic and all fibre actions lie in an aperiodic monoid `N`. -/
theorem isAperiodic_closure_of_cascade [Finite Q] {sR : A → Q → Function.End R}
    {sQ : A → Function.End Q} {S : A → Function.End (R × Q)}
    (hS : ∀ a r q, S a (r, q) = (sR a q r, sQ a q))
    {N : Submonoid (Function.End R)} (hmem : ∀ a q, sR a q ∈ N) (hN : IsAperiodic N)
    (h₂ : IsAperiodic (Submonoid.closure (Set.range sQ))) :
    IsAperiodic (Submonoid.closure (Set.range S)) := by
  intro f hf
  obtain ⟨τ, hτN, g, hg, hshapef⟩ := exists_cascade_shape hS hmem f hf
  exact isAperiodicElem_cascade (τ := τ) (σ := g) hshapef (h₂ g hg) fun q => hN _ (hτN q)

/-- **Cascade aperiodicity, for automata.** If the step function of `D` splits as
a cascade over a base automaton `D₂` whose transition monoid is aperiodic, with
all top-layer letter actions lying in an aperiodic monoid `N`, then `D`'s
transition monoid is aperiodic — i.e. `D` has Krohn-Rhodes group complexity `0`.
-/
theorem transitionMonoid_isAperiodic_of_cascade [Finite Q] {D : DFA A (R × Q)} {D₂ : DFA A Q}
    {N : Submonoid (Function.End R)} {top : A → Q → Function.End R}
    (hstep : ∀ a r q, D.step (r, q) a = (top a q r, D₂.step q a))
    (hmem : ∀ a q, top a q ∈ N) (hN : IsAperiodic N)
    (h₂ : IsAperiodic (transitionMonoid D₂)) : IsAperiodic (transitionMonoid D) := by
  intro f hf
  obtain ⟨w, rfl⟩ := exists_word_of_mem D hf
  -- the word map of `D` is itself of cascade shape
  have hshape : ∀ w : List A, ∃ τ : Q → Function.End R, (∀ q, τ q ∈ N) ∧
      ∀ r q, wordMap D w (r, q) = (τ q r, wordMap D₂ w q) := by
    intro w
    induction w with
    | nil => exact ⟨fun _ => 1, fun _ => N.one_mem, fun r q => rfl⟩
    | cons a w ih =>
        obtain ⟨τ, hτ, hτ'⟩ := ih
        refine ⟨fun q => τ (D₂.step q a) * top a q, fun q => N.mul_mem (hτ _) (hmem a q), ?_⟩
        intro r q
        have h1 : wordMap D (a :: w) (r, q) = wordMap D (w) (D.step (r, q) a) := rfl
        have h2 : wordMap D₂ (a :: w) q = wordMap D₂ w (D₂.step q a) := rfl
        rw [h1, hstep, hτ' (top a q r) (D₂.step q a), h2]
        rfl
  obtain ⟨τ, hτN, hτ⟩ := hshape w
  refine isAperiodicElem_cascade (τ := τ) (σ := wordMap D₂ w) ?_ ?_ ?_
  · intro r q
    exact hτ r q
  · exact h₂ _ (wordMap_mem D₂ w)
  · intro q
    exact hN _ (hτN q)

end KrohnRhodes
