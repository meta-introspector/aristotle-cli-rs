import Mathlib
import RequestProject.Monster
import RequestProject.OggFractran

set_option autoImplicit false

/-!
# The Monster-ABI contract: Ogg arithmetic as a specification, symmetries as a contract

This file turns the previous file's Ogg-FRACTRAN engine (`RequestProject.OggFractran`) into a
*specification with an ABI contract*, following the design conversation:

* **Spec layer.** The state space is the Ogg lattice `S` (points of `ℕ` supported on the 15
  supersingular / Ogg primes), and the dynamics is the deterministic engine `oggStep`.
* **Encoding `φ`.** Each lattice state is mapped to its *weight vector* in the integral
  **weight lattice** `WeightLattice = ℕ →₀ ℤ`. On the Ogg lattice this is supported on the
  15 Ogg primes, i.e. `φ : S → ℤ¹⁵` — the same 15-prime integral lattice on which the graded
  Monster module `V = ⨁ₙ Vₙ` is supported. This is the map `oggWeight`.
* **Symmetry / ABI contract.** `WeightLattice` is an additive group acting on itself by
  translation; this is the lattice-level symmetry group `G`. The contract demands that every
  transition of an implementation be realized by an *allowed* group element `g ∈ G`:

      φ(F n) = g +ᵥ φ(n).

  Each Ogg fraction `q` contributes one generator `fractionShift q ∈ G`; halting contributes
  `0`. The set of allowed generators is `allowedShifts prog`.

The **Monster-ABI theorem** is `oggStep_weight_shift` / `oggStep_ABIConformant`: the engine
itself satisfies the contract — every step is a translation by an allowed shift. Finally,
`ABIConformant.of_refines` is the **refinement principle**: any implementation (Lean, and by
extension a faithfully modelled Rust/eBPF runtime) that is observationally equal to the spec
on the positive lattice is automatically ABI-conformant. This is the precise, machine-checked
"first draft of the contract".
-/

namespace OggABI

open OggFractran
open Monster (supersingularPrimes)

/-! ## 1. The encoding `φ` into the weight lattice -/

/-- The integral **weight lattice**: finitely-supported integer vectors indexed by primes.
On the Ogg lattice (see `oggWeight_support`) only the 15 Ogg coordinates are ever nonzero, so
this is the `ℤ¹⁵` on which the supersingular-graded Monster module is supported. -/
abbrev WeightLattice : Type := ℕ →₀ ℤ

/-- The encoding `φ`: a state's **weight vector** is its prime factorization, read as an
integer vector. Coordinate `p` is the `p`-adic valuation of `n`. -/
noncomputable def oggWeight (n : ℕ) : WeightLattice :=
  (Nat.factorization n).mapRange (fun k : ℕ => (k : ℤ)) (by simp)

/-
`φ(1) = 0`: the origin maps to the zero weight vector.
-/
theorem oggWeight_one : oggWeight 1 = 0 := by
  simp [oggWeight]

/-
`φ` is a monoid homomorphism on positive states: weights add under multiplication.
-/
theorem oggWeight_mul {a b : ℕ} (ha : 0 < a) (hb : 0 < b) :
    oggWeight (a * b) = oggWeight a + oggWeight b := by
  unfold oggWeight;
  ext; simp [Nat.factorization_mul, ha.ne', hb.ne']

/-
On the Ogg lattice the weight vector is supported on the 15 Ogg primes: `φ : S → ℤ¹⁵`.
-/
theorem oggWeight_support {n : ℕ} (h : OnOggLattice n) :
    (oggWeight n).support ⊆ oggSet := by
  convert h using 1;
  unfold oggWeight OnOggLattice;
  simp +decide [ Nat.factorization ];
  simp +decide [ Finset.subset_iff ];
  exact ⟨ fun h x hx₁ hx₂ hx₃ => h hx₁ ( Nat.Prime.ne_one hx₁ ) hx₃ hx₂, fun h x hx₁ hx₂ hx₃ hx₄ => h hx₁ hx₄ hx₃ ⟩

/-! ## 2. The symmetry group and the per-fraction generators -/

/-- The **shift** induced by an Ogg fraction `q`: the weight-lattice element `φ(num) − φ(den)`.
Firing `q` translates the weight vector by exactly this group element. -/
noncomputable def fractionShift (q : OggFraction) : WeightLattice :=
  oggWeight q.num - oggWeight q.den

/-
**Firing is a translation in the weight lattice.** When `q` is enabled at the positive
state `n`, the new weight vector is the old one shifted by `fractionShift q`.
-/
theorem oggWeight_fire (q : OggFraction) (n : ℕ) (hn : 0 < n) (hdvd : q.den ∣ n) :
    oggWeight ((n / q.den) * q.num) = oggWeight n + fractionShift q := by
  unfold oggWeight fractionShift;
  rw [ Nat.factorization_mul, Nat.factorization_div ];
  · ext; simp [oggWeight];
    rw [ Nat.cast_sub ];
    · ring;
    · exact ( Nat.factorization_le_iff_dvd ( by linarith [ q.den_pos ] ) ( by linarith ) ) |>.2 hdvd _;
  · assumption;
  · exact Nat.ne_of_gt ( Nat.div_pos ( Nat.le_of_dvd hn hdvd ) q.den_pos );
  · exact ne_of_gt q.num_pos

/-- The set of **allowed shifts** of a program: the identity `0` (halting) together with the
per-fraction generators. The ABI contract requires every step to use one of these. -/
def allowedShifts (prog : List OggFraction) : Set WeightLattice :=
  insert 0 (fractionShift '' {q | q ∈ prog})

/-- `0 ∈ allowedShifts prog`: halting is always permitted. -/
theorem zero_mem_allowedShifts (prog : List OggFraction) : (0 : WeightLattice) ∈ allowedShifts prog :=
  Set.mem_insert _ _

/-- Each fraction of the program contributes an allowed shift. -/
theorem fractionShift_mem_allowedShifts {prog : List OggFraction} {q : OggFraction}
    (hq : q ∈ prog) : fractionShift q ∈ allowedShifts prog :=
  Set.mem_insert_of_mem _ ⟨q, hq, rfl⟩

/-! ## 3. The Monster-ABI theorem: the engine satisfies the contract -/

/-
**Monster-ABI theorem (weight form).** Every step of the engine translates the weight
vector by an allowed shift: there is `g ∈ allowedShifts prog` with `φ(step n) = φ(n) + g`.
-/
theorem oggStep_weight_shift (prog : List OggFraction) (n : ℕ) (hn : 0 < n) :
    ∃ g ∈ allowedShifts prog, oggWeight (oggStep prog n) = oggWeight n + g := by
  unfold oggStep;
  cases h : List.find? ( fun q => decide ( n % q.den = 0 ) ) prog <;> simp_all +decide [ allowedShifts ];
  exact Or.inr ⟨ _, List.mem_of_find?_eq_some h, oggWeight_fire _ _ hn ( Nat.dvd_of_mod_eq_zero <| by simpa using ( List.find?_some h ) ) ⟩

/-- **Monster-ABI theorem (group-action form).** Reading the weight lattice as a group acting
on itself by translation, every step is the action of an allowed group element. -/
theorem oggStep_vadd (prog : List OggFraction) (n : ℕ) (hn : 0 < n) :
    ∃ g ∈ allowedShifts prog, oggWeight (oggStep prog n) = g +ᵥ oggWeight n := by
  obtain ⟨g, hg, hgeq⟩ := oggStep_weight_shift prog n hn
  exact ⟨g, hg, by simpa [add_comm] using hgeq⟩

/-! ## 4. ABI conformity and the refinement principle -/

/-- An implementation `impl : ℕ → ℕ` is **ABI-conformant** to the Ogg/Monster contract of a
program when, on positive states, it (1) stays positive, (2) stays on the Ogg lattice, and
(3) realizes each step as a translation by an allowed shift. These are exactly the three
guarantees a kernel-side verifier of an Ogg-FRACTRAN runtime would check. -/
structure ABIConformant (prog : List OggFraction) (impl : ℕ → ℕ) : Prop where
  /-- The implementation never collapses to the void. -/
  pos : ∀ n, 0 < n → 0 < impl n
  /-- The implementation never leaves the supersingular lattice. -/
  lattice : ∀ n, 0 < n → OnOggLattice n → OnOggLattice (impl n)
  /-- Every step is realized by an allowed symmetry-group element. -/
  symmetry : ∀ n, 0 < n → ∃ g ∈ allowedShifts prog, oggWeight (impl n) = oggWeight n + g

/-- **The reference engine is ABI-conformant.** -/
theorem oggStep_ABIConformant (prog : List OggFraction) :
    ABIConformant prog (oggStep prog) where
  pos n hn := oggStep_pos prog n hn
  lattice n hn hlat := oggStep_onLattice prog n hn hlat
  symmetry n hn := oggStep_weight_shift prog n hn

/-- `impl` **refines** `spec` when the two agree on every positive state — the observational
equivalence relating a concrete runtime to the reference engine. -/
def Refines (impl spec : ℕ → ℕ) : Prop := ∀ n, 0 < n → impl n = spec n

/-- **Refinement principle.** Any implementation observationally equal to an ABI-conformant
spec on positive states is itself ABI-conformant: conformity is preserved by refinement. This
is the bridge by which a faithfully-modelled Rust/eBPF runtime inherits the Monster-ABI
guarantees from the Lean reference engine. -/
theorem ABIConformant.of_refines {prog : List OggFraction} {impl spec : ℕ → ℕ}
    (h : ABIConformant prog spec) (hr : Refines impl spec) :
    ABIConformant prog impl where
  pos n hn := by rw [hr n hn]; exact h.pos n hn
  lattice n hn hlat := by rw [hr n hn]; exact h.lattice n hn hlat
  symmetry n hn := by rw [hr n hn]; exact h.symmetry n hn

/-! ## 5. A concrete instance of the contract -/

/-- The demo engine `[3/2]` is ABI-conformant. -/
theorem demoEngine_ABIConformant : ABIConformant demoEngine (oggStep demoEngine) :=
  oggStep_ABIConformant demoEngine

/-
A concrete reading of the contract: firing `3/2` at `8 = 2³` translates the weight vector
by `fractionShift twoToThree` (remove one `2`, add one `3`).
-/
theorem demo_shift :
    oggWeight (oggStep demoEngine 8) = oggWeight 8 + fractionShift twoToThree := by
  convert oggWeight_fire twoToThree 8 ( by decide ) ( by decide ) using 1

end OggABI