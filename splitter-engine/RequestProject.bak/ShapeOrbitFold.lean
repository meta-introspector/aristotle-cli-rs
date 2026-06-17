/-
ShapeOrbitFold.lean — harmonic analysis of the Bott clock: orbits and folds.

`RequestProject/ShapeHarmonic.lean` reads a code-shape's subtree sizes as residues on a
periodic *Bott clock* `ZMod p` (the harmonic spectrum), with the complex clock at period `2`
and the real clock at period `8`. That file establishes the harmonic as an additive
homomorphism and the refinement `ZMod 8 → ZMod 2`.

Here we add the **harmonic-analysis layer** that the clock structure asks for. A finite Bott
clock `ZMod p` is a *cyclic group*, and harmonic analysis on a cyclic group is organised by
its two canonical operations:

* **Rotation (the orbit).** The group `ZMod p` acts on the harmonic spectrum by *clock
  rotation* `rotate k` — add the offset `k` to every residue. This is the regular action of
  the cyclic group on its own functions; the *orbit* of a spectrum is the set of all its
  rotations. We prove `rotate` is a genuine group action (`rotate_zero`, `rotate_add`),
  preserves the spectrum's cardinality (`card_rotate`), is periodic with a full turn invisible
  (`rotate_period`), and that the harmonic is **rotation-equivariant**: shifting every size by
  a constant `c` rotates the spectrum by `c` (`listHarmonic_map_add`, `harmonic_shift_mem_orbit`).
  The orbit (`orbit`) is closed under rotation (`orbit_closed`) and has at most `p` elements
  (`card_orbit_le`).

* **Folding (refinement onto divisor clocks).** For every divisor `d ∣ p` the ring map
  `ZMod p → ZMod d` *folds* the fine clock onto a coarser one (`fold`). Folding the harmonic
  at period `p` yields the harmonic at period `d` (`fold_harmonic`), folds compose along a
  divisor chain (`fold_comp`), and folding intertwines rotation (`fold_rotate`). The Bott
  chain `1 ∣ 2 ∣ 4 ∣ 8` is exactly such a fold tower; the project's "`KO` refines `KU`"
  refinement `ZMod 8 → ZMod 2` is the single fold `fold (show (2:ℕ) ∣ 8)` (`realHarmonic_fold`).

Together: **orbits** are the symmetry of a fixed clock, **folds** are the morphisms between
clocks, and the harmonic spectrum is equivariant for both — a small, fully machine-checked
slice of harmonic analysis on the Bott-periodicity clocks of the project's own code.
-/
import Mathlib
import RequestProject.SizeSignature
import RequestProject.ShapeAlgebra
import RequestProject.ShapeHarmonic

namespace ShapeOrbitFold

open SizeSignature ShapeAlgebra ShapeHarmonic

/-! ## Clock rotation: the cyclic-group action on harmonic spectra -/

/-- **Clock rotation by `k`.** Add the offset `k` to every residue of a harmonic spectrum.
This is the (regular) action of the cyclic group `ZMod p` on multisets over the Bott clock. -/
def rotate {p : ℕ} (k : ZMod p) (m : Multiset (ZMod p)) : Multiset (ZMod p) :=
  m.map (· + k)

@[simp] theorem rotate_zero {p : ℕ} (m : Multiset (ZMod p)) : rotate 0 m = m := by
  -- By definition of rotation, adding 0 to each element of the multiset leaves it unchanged.
  simp [rotate]

/-
**Rotation is a group action.** Rotating by `k₁ + k₂` is rotating by `k₂` then by `k₁`.
-/
theorem rotate_add {p : ℕ} (k₁ k₂ : ZMod p) (m : Multiset (ZMod p)) :
    rotate (k₁ + k₂) m = rotate k₁ (rotate k₂ m) := by
  simp +decide [ rotate, ← add_assoc ];
  ac_rfl

/-
Rotation preserves the number of residues (it permutes the clock).
-/
@[simp] theorem card_rotate {p : ℕ} (k : ZMod p) (m : Multiset (ZMod p)) :
    Multiset.card (rotate k m) = Multiset.card m := by
  unfold rotate; aesop;

/-
**A full turn is invisible.** Rotating by a whole period `p` (which is `0` on the clock)
returns the spectrum unchanged — the Bott periodicity of the rotation action.
-/
theorem rotate_period {p : ℕ} (m : Multiset (ZMod p)) :
    rotate ((p : ℕ) : ZMod p) m = m := by
  cases p <;> aesop

/-! ## Rotation-equivariance of the harmonic -/

/-
**The harmonic is rotation-equivariant.** Shifting every size in a word by a constant `c`
rotates the harmonic spectrum by `c` on the clock.
-/
theorem listHarmonic_map_add (p c : ℕ) (l : List Nat) :
    listHarmonic p (l.map (· + c)) = rotate (c : ZMod p) (listHarmonic p l) := by
  unfold listHarmonic rotate;
  induction l <;> aesop

/-! ## Folding: refinement onto a coarser (divisor) clock -/

/-- **Clock fold.** For a divisor `d ∣ p`, the ring map `ZMod p → ZMod d` folds the fine clock
onto the coarser clock, applied residue-by-residue to a spectrum. -/
def fold {d p : ℕ} (h : d ∣ p) (m : Multiset (ZMod p)) : Multiset (ZMod d) :=
  m.map (ZMod.castHom h (ZMod d))

/-
**Folding the harmonic = the coarser harmonic.** Folding the period-`p` harmonic of a
shape onto a divisor clock `d` recovers the period-`d` harmonic — the general refinement, of
which `KO ↠ KU` is the case `d = 2, p = 8`.
-/
theorem fold_harmonic (d p : ℕ) (h : d ∣ p) (s : Shape) :
    fold h (harmonic p s) = harmonic d s := by
  unfold fold;
  unfold ShapeHarmonic.harmonic;
  unfold listHarmonic;
  induction ( sizeWord s ) <;> aesop

/-
**Folds compose along a divisor chain** `e ∣ d ∣ p`.
-/
theorem fold_comp {e d p : ℕ} (h1 : e ∣ d) (h2 : d ∣ p) (m : Multiset (ZMod p)) :
    fold h1 (fold h2 m) = fold (h1.trans h2) m := by
  convert Multiset.map_map _ _ m using 2;
  convert Multiset.map_map _ _ m using 2;
  any_goals tauto;
  simp +decide [ Function.comp ];
  ext; simp [fold];
  congr! 2;
  convert RingHom.comp_apply ( ZMod.castHom h1 ( ZMod e ) ) ( ZMod.castHom h2 ( ZMod d ) ) _ using 1;
  cases p <;> cases d <;> cases e <;> aesop

/-
Folding preserves the number of residues.
-/
@[simp] theorem card_fold {d p : ℕ} (h : d ∣ p) (m : Multiset (ZMod p)) :
    Multiset.card (fold h m) = Multiset.card m := by
  unfold fold; aesop;

/-
**Fold intertwines rotation.** Folding a rotated spectrum is the same as rotating the
folded spectrum by the folded offset: orbits and folds commute.
-/
theorem fold_rotate {d p : ℕ} (h : d ∣ p) (k : ZMod p) (m : Multiset (ZMod p)) :
    fold h (rotate k m) = rotate (ZMod.castHom h (ZMod d) k) (fold h m) := by
  unfold fold rotate; aesop;

/-
The project's `KO`-refines-`KU` map is the single fold `ZMod 8 → ZMod 2`.
-/
theorem realHarmonic_fold (s : Shape) :
    fold (show (2 : ℕ) ∣ 8 by norm_num) (realHarmonic s) = complexHarmonic s := by
  convert fold_harmonic 2 8 _ s using 1

/-! ## The orbit of a harmonic spectrum -/

/-- **The orbit** of a spectrum under the rotation action: the finite set of all its clock
rotations. -/
def orbit (p : ℕ) [NeZero p] (m : Multiset (ZMod p)) : Finset (Multiset (ZMod p)) :=
  Finset.univ.image (fun k : ZMod p => rotate k m)

/-
A spectrum lies in its own orbit (rotate by `0`).
-/
theorem self_mem_orbit (p : ℕ) [NeZero p] (m : Multiset (ZMod p)) :
    m ∈ orbit p m := by
  exact Finset.mem_image.mpr ⟨ 0, Finset.mem_univ _, by simp +decide ⟩

/-
Every rotation of a spectrum lies in its orbit.
-/
theorem rotate_mem_orbit {p : ℕ} [NeZero p] (k : ZMod p) (m : Multiset (ZMod p)) :
    rotate k m ∈ orbit p m := by
  -- By definition of orbit, rotate k m is in the image of the function that maps x to rotate x m over all x in ZMod p.
  simp [orbit]

/-
**The orbit is closed under rotation.** Rotating an orbit element stays in the orbit.
-/
theorem orbit_closed {p : ℕ} [NeZero p] (k : ZMod p) {m x : Multiset (ZMod p)}
    (hx : x ∈ orbit p m) : rotate k x ∈ orbit p m := by
  obtain ⟨ j, hj ⟩ := Finset.mem_image.mp hx;
  exact Finset.mem_image.mpr ⟨ k + j, Finset.mem_univ _, by rw [ ← hj.2, rotate_add ] ⟩

/-
**The orbit has at most `p` elements** (orbit of a `p`-element cyclic group).
-/
theorem card_orbit_le (p : ℕ) [NeZero p] (m : Multiset (ZMod p)) :
    (orbit p m).card ≤ p := by
  exact Finset.card_image_le.trans ( by simp +decide [ ZMod.card ] )

/-
**Equivariance, packaged.** Shifting every size of a word by a constant keeps the harmonic
in the same orbit: the spectrum is determined up to clock rotation by the multiset of sizes
modulo a global shift.
-/
theorem harmonic_shift_mem_orbit (p c : ℕ) [NeZero p] (l : List Nat) :
    listHarmonic p (l.map (· + c)) ∈ orbit p (listHarmonic p l) := by
  rw [ listHarmonic_map_add ] ; exact rotate_mem_orbit _ _;

/-! ## Burnside / orbit counting: rotation as a finite additive group action

Clock rotation makes `ZMod p` act additively on harmonic spectra. We register this as a genuine
`AddAction` — both on the full (infinite) spectrum space `Multiset (ZMod p)` and on the finite
space `Sym (ZMod p) n` of spectra of a *fixed* size `n` (rotation preserves cardinality). On the
finite space Mathlib's orbit–stabiliser theorem and Burnside's lemma apply, giving an exact
orbit-size law and a count of the spectra up to rotation. -/

/-- Rotation is the additive action of the cyclic Bott clock `ZMod p` on its spectra. -/
instance instAddActionMultiset {p : ℕ} : AddAction (ZMod p) (Multiset (ZMod p)) where
  vadd := rotate
  zero_vadd := rotate_zero
  add_vadd := rotate_add

/-- The action's `+ᵥ` is exactly clock rotation. -/
@[simp] theorem vadd_eq_rotate {p : ℕ} (k : ZMod p) (m : Multiset (ZMod p)) :
    k +ᵥ m = rotate k m := rfl

/-- **The combinatorial orbit is the group-action orbit.** The `Finset` `orbit p m` of all clock
rotations of `m` is, as a set, exactly the `AddAction.orbit` of `m` under `ZMod p`. -/
theorem coe_orbit_eq_addOrbit (p : ℕ) [NeZero p] (m : Multiset (ZMod p)) :
    (orbit p m : Set (Multiset (ZMod p))) = AddAction.orbit (ZMod p) m := by
  ext x
  simp only [orbit, Finset.coe_image, Finset.coe_univ, Set.image_univ, Set.mem_range,
    AddAction.mem_orbit_iff]
  constructor
  · rintro ⟨k, rfl⟩; exact ⟨k, rfl⟩
  · rintro ⟨k, rfl⟩; exact ⟨k, rfl⟩

/-- **Orbit–stabiliser, sharpened.** The orbit size of any spectrum *divides* the period `p`
(it is `p` divided by the size of the stabilising subgroup of clock shifts). This refines
`card_orbit_le`. -/
theorem card_orbit_dvd (p : ℕ) [NeZero p] (m : Multiset (ZMod p)) :
    (orbit p m).card ∣ p := by
  haveI hfo : Fintype (AddAction.orbit (ZMod p) m) := by
    apply Set.Finite.fintype
    rw [← coe_orbit_eq_addOrbit]
    exact (orbit p m).finite_toSet
  haveI : Fintype (AddAction.stabilizer (ZMod p) m) := Fintype.ofFinite _
  have h1 : (orbit p m).card = Fintype.card (AddAction.orbit (ZMod p) m) := by
    rw [← Set.toFinset_card]
    apply Finset.card_bij (fun a _ => a)
    · intro a ha
      simp only [Set.mem_toFinset]; rw [← coe_orbit_eq_addOrbit]; exact ha
    · intro a _ b _ h; exact h
    · intro b hb
      refine ⟨b, ?_, rfl⟩
      simp only [Set.mem_toFinset] at hb; rw [← coe_orbit_eq_addOrbit] at hb; exact hb
  have hos := AddAction.card_orbit_mul_card_stabilizer_eq_card_addGroup (ZMod p) m
  rw [ZMod.card] at hos
  rw [h1]; exact ⟨_, hos.symm⟩

/-! ### The finite shape space `Sym (ZMod p) n` and Burnside's count -/

/-- **Rotation on fixed-size spectra.** Clock rotation restricted to the spectra of size `n`
(`Sym (ZMod p) n`), which is finite — the right carrier for orbit counting. -/
def rotateSym {p n : ℕ} (k : ZMod p) (s : Sym (ZMod p) n) : Sym (ZMod p) n :=
  ⟨rotate k s.1, by rw [card_rotate]; exact s.2⟩

@[simp] theorem rotateSym_val {p n : ℕ} (k : ZMod p) (s : Sym (ZMod p) n) :
    (rotateSym k s).1 = rotate k s.1 := rfl

/-- Rotation is the additive action of `ZMod p` on the finite spectrum space `Sym (ZMod p) n`. -/
instance instAddActionSym {p n : ℕ} : AddAction (ZMod p) (Sym (ZMod p) n) where
  vadd := rotateSym
  zero_vadd s := by apply Subtype.ext; show rotate 0 s.1 = s.1; simp
  add_vadd k₁ k₂ s := by
    apply Subtype.ext; show rotate (k₁ + k₂) s.1 = rotate k₁ (rotate k₂ s.1); exact rotate_add ..

noncomputable instance instFintypeFixedBySym {p n : ℕ} [NeZero p] (a : ZMod p) :
    Fintype (AddAction.fixedBy (Sym (ZMod p) n) a) := by
  classical exact Set.Finite.fintype (Set.toFinite _)

noncomputable instance instFintypeOrbitsSym {p n : ℕ} [NeZero p] :
    Fintype (Quotient (AddAction.orbitRel (ZMod p) (Sym (ZMod p) n))) := Fintype.ofFinite _

noncomputable instance instFintypeOrbitSym {p n : ℕ} [NeZero p] (s : Sym (ZMod p) n) :
    Fintype (AddAction.orbit (ZMod p) s) := by classical exact Set.Finite.fintype (Set.toFinite _)

noncomputable instance instFintypeStabilizerSym {p n : ℕ} [NeZero p] (s : Sym (ZMod p) n) :
    Fintype (AddAction.stabilizer (ZMod p) s) := Fintype.ofFinite _

/-- **Orbit–stabiliser theorem** on the finite shape space: for a fixed-size spectrum, the orbit
size times the stabiliser size equals the period `p`. -/
theorem card_orbit_mul_card_stabilizer (p n : ℕ) [NeZero p] (s : Sym (ZMod p) n) :
    Fintype.card (AddAction.orbit (ZMod p) s) * Fintype.card (AddAction.stabilizer (ZMod p) s)
      = p := by
  rw [AddAction.card_orbit_mul_card_stabilizer_eq_card_addGroup (ZMod p) s, ZMod.card]

/-- Consequently the orbit size of a fixed-size spectrum divides `p`. -/
theorem card_orbit_sym_dvd (p n : ℕ) [NeZero p] (s : Sym (ZMod p) n) :
    Fintype.card (AddAction.orbit (ZMod p) s) ∣ p :=
  ⟨_, (card_orbit_mul_card_stabilizer p n s).symm⟩

/-- **Burnside's lemma on the Bott clock.** The number of size-`n` spectra up to clock rotation,
multiplied by the period `p`, equals the total number of clock shifts fixing each spectrum,
summed over all `p` rotations. (The usual "average number of fixed points = number of orbits".) -/
theorem burnside_card_orbits (p n : ℕ) [NeZero p] :
    (∑ a : ZMod p, Fintype.card (AddAction.fixedBy (Sym (ZMod p) n) a))
      = Fintype.card (Quotient (AddAction.orbitRel (ZMod p) (Sym (ZMod p) n))) * p := by
  rw [AddAction.sum_card_fixedBy_eq_card_orbits_mul_card_addGroup (ZMod p) (Sym (ZMod p) n),
    ZMod.card]

/-! ## A discrete Fourier transform on the Bott clock and the rotation-invariant power spectrum

Fix any `p`-th root of unity `ζ ∈ ℂ`. It defines the additive character `AddChar.zmodChar p hζ`
on the clock `ZMod p`, and the **discrete Fourier transform** of a spectrum `m` at frequency `j`
is the character sum `dft hζ m j = Σ_{r ∈ m} ζ^{(j·r)}`. The DFT is still a homomorphism
(`dft_add`), and the key harmonic-analysis facts hold: **rotation becomes a phase**
(`dft_rotate`), every character value has modulus one (`norm_zmodChar`), and therefore the
**power spectrum** `|dft|²` is a *rotation invariant* (`powerSpectrum_rotate`) — a numerical
fingerprint constant on each orbit (`powerSpectrum_of_mem_orbit`). -/

/-- **Discrete Fourier transform** of a spectrum `m` at frequency `j`, with respect to a chosen
`p`-th root of unity `ζ`: the character sum `Σ_{r ∈ m} ζ^{(j·r)}`. -/
noncomputable def dft {p : ℕ} [NeZero p] {ζ : ℂ} (hζ : ζ ^ p = 1)
    (m : Multiset (ZMod p)) (j : ZMod p) : ℂ :=
  (m.map (fun r => AddChar.zmodChar p hζ (j * r))).sum

/-- **The DFT is additive in concatenation** (the harmonic stays a homomorphism in Fourier
space): the transform of a sum of spectra is the sum of the transforms. -/
theorem dft_add {p : ℕ} [NeZero p] {ζ : ℂ} (hζ : ζ ^ p = 1)
    (m₁ m₂ : Multiset (ZMod p)) (j : ZMod p) :
    dft hζ (m₁ + m₂) j = dft hζ m₁ j + dft hζ m₂ j := by
  simp [dft, Multiset.map_add]

/-- The DFT of a harmonic of concatenated words splits additively. -/
theorem dft_listHarmonic_append {p : ℕ} [NeZero p] {ζ : ℂ} (hζ : ζ ^ p = 1)
    (l₁ l₂ : List Nat) (j : ZMod p) :
    dft hζ (listHarmonic p (l₁ ++ l₂)) j
      = dft hζ (listHarmonic p l₁) j + dft hζ (listHarmonic p l₂) j := by
  rw [listHarmonic_append, dft_add]

/-- **Rotation becomes a phase.** Rotating a spectrum by `k` multiplies its DFT at frequency `j`
by the phase `ζ^{(j·k)}`. -/
theorem dft_rotate {p : ℕ} [NeZero p] {ζ : ℂ} (hζ : ζ ^ p = 1)
    (k : ZMod p) (m : Multiset (ZMod p)) (j : ZMod p) :
    dft hζ (rotate k m) j = AddChar.zmodChar p hζ (j * k) * dft hζ m j := by
  unfold dft rotate
  rw [Multiset.map_map]
  rw [show (fun r => AddChar.zmodChar p hζ (j * r)) ∘ (· + k)
        = (fun r => AddChar.zmodChar p hζ (j * k) * AddChar.zmodChar p hζ (j * r)) from ?_]
  · rw [Multiset.sum_map_mul_left]
  · funext r
    simp only [Function.comp_apply]
    rw [mul_add, AddChar.map_add_eq_mul, mul_comm]

/-- **Every character value has modulus one** (a `p`-th root of unity lies on the unit circle). -/
theorem norm_zmodChar {p : ℕ} [NeZero p] {ζ : ℂ} (hζ : ζ ^ p = 1) (x : ZMod p) :
    ‖AddChar.zmodChar p hζ x‖ = 1 := by
  rw [AddChar.zmodChar_apply]
  have hz : ‖ζ‖ = 1 := by
    have hpow : ‖ζ‖ ^ p = 1 := by rw [← norm_pow, hζ, norm_one]
    nlinarith [norm_nonneg ζ,
      (pow_eq_one_iff_of_nonneg (norm_nonneg ζ) (NeZero.ne p)).mp hpow]
  rw [norm_pow, hz, one_pow]

/-- **The power spectrum** of a spectrum at frequency `j`: the squared modulus of its DFT. -/
noncomputable def powerSpectrum {p : ℕ} [NeZero p] {ζ : ℂ} (hζ : ζ ^ p = 1)
    (m : Multiset (ZMod p)) (j : ZMod p) : ℝ := ‖dft hζ m j‖ ^ 2

/-- **The power spectrum is rotation-invariant.** Rotating a spectrum leaves its power spectrum
unchanged (the phase from `dft_rotate` has modulus one). -/
theorem powerSpectrum_rotate {p : ℕ} [NeZero p] {ζ : ℂ} (hζ : ζ ^ p = 1)
    (k : ZMod p) (m : Multiset (ZMod p)) (j : ZMod p) :
    powerSpectrum hζ (rotate k m) j = powerSpectrum hζ m j := by
  unfold powerSpectrum
  rw [dft_rotate, norm_mul, norm_zmodChar, one_mul]

/-- **The power spectrum is constant on each orbit** — the right invariant for orbit counting:
any rotation of a spectrum has the same power spectrum. -/
theorem powerSpectrum_of_mem_orbit {p : ℕ} [NeZero p] {ζ : ℂ} (hζ : ζ ^ p = 1)
    {m x : Multiset (ZMod p)} (hx : x ∈ orbit p m) (j : ZMod p) :
    powerSpectrum hζ x j = powerSpectrum hζ m j := by
  obtain ⟨k, _, rfl⟩ := Finset.mem_image.mp hx
  exact powerSpectrum_rotate hζ k m j

end ShapeOrbitFold