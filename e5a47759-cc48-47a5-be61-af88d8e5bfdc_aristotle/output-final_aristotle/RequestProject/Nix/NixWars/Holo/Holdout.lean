import RequestProject.Nix.NixWars.Holo.Instance

/-!
# From fit to prediction: a held-out region, and description lengths that are derived

`Instance.lean` fits the `M₁₁` overlay to an archive whose links *are* the
Cayley edges, and the residual comes out empty.  That is honest but circular,
and the model costs (64, 4, 4) are stipulated.  This file sharpens both.

**A corpus nobody designed.**  `chorded` is the same eleven cells with one extra
link, between `MODULAR_FORM` and `MONSTER_GROUP`, which no group in the family
predicts.  It is still a legitimate archive: distinct keys, closed links.

**Fit here, predict there.**  The cells are split into a fit region (the first
six) and a held-out region (the last five), and `residualOn` measures a model
only on the pairs inside a region.  Every candidate fits the fit region exactly
(`m11_fits_train`, `cyclic_fits_train`, `dihedral_fits_train`) and the numbers
that matter are the out-of-sample ones: `m11_holdout_residual` and its siblings
report **two** wrong pairs out of sample, and `dihedral_fits_train_but_not_all`
shows a model that fits the region perfectly and is wrong about eight pairs of
the whole corpus.  Fitting what you have loaded does not certify the rest.

**Derived description lengths.**  `bitsFor` is a ceiling base-2 logarithm
(`le_two_pow_bitsFor`), and every cost below is computed from it rather than
declared: a group model costs the bits to write its generators as permutations
plus the bits to give each concept a coordinate (`groupBits`), and a residual
pair costs `2⌈log₂ n⌉` bits (`pairBits`) — which at `n = 11` is the 8 bits per
pair that `Instance.lean` assumes.

**The table, and what it says.**  With the costs derived, the cyclic model —
not `M₁₁` — minimises description length on this corpus (`cyclic_is_best`,
`cyclic_beats_m11`): the ring is explained by both, and the cheaper description
wins.  `M₁₁` is selected only against models that fail to explain the links.
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Holo
namespace Holdout

open Archive Instance

/-! ## Description lengths, derived -/

/-- The number of bits needed to write down a number below `n`. -/
def bitsFor : Nat → Nat
  | 0 => 0
  | 1 => 0
  | n + 2 => bitsFor ((n + 3) / 2) + 1

theorem bitsFor_succ_succ (n : Nat) : bitsFor (n + 2) = bitsFor ((n + 3) / 2) + 1 := by
  rw [bitsFor]

/-- **`bitsFor n` really is enough bits for `n` values.** -/
theorem le_two_pow_bitsFor : ∀ n : Nat, n ≤ 2 ^ bitsFor n
  | 0 => by simp [bitsFor]
  | 1 => by simp [bitsFor]
  | n + 2 => by
    have ih := le_two_pow_bitsFor ((n + 3) / 2)
    rw [bitsFor_succ_succ, pow_succ]
    omega

/-- The bits spent naming which model of the family is meant. -/
def nameBits : Nat := bitsFor 5

/-- The bits to write down a group model on `n` points: `gens` generators, each
a permutation of the points, and a coordinate of length `coordLen` for each
concept. -/
def groupBits (n gens coordLen : Nat) : Nat :=
  nameBits + gens * (n * bitsFor n) + n * (coordLen * bitsFor n)

/-- The bits to record one corrected pair on `n` concepts. -/
def pairBits (n : Nat) : Nat := 2 * bitsFor n

/-- The eight bits a pair that `Instance.lean` assumes are the derived cost at
eleven concepts. -/
theorem pairBits_eleven : pairBits 11 = 8 := by norm_num [pairBits, bitsFor]

/-! ## The candidate models, at their derived costs -/

/-- The rotation of the ring: the Cayley graph of the cyclic group. -/
def cyclicPred (i j : Nat) : Bool := decide (j = (i + 1) % 11 ∨ i = (j + 1) % 11)

/-- Rotation and reflection: the Cayley graph of the dihedral group. -/
def dihedralPred (i j : Nat) : Bool :=
  decide (j = (i + 1) % 11 ∨ i = (j + 1) % 11 ∨ (j = (11 - i) % 11 ∧ i ≠ j))

/-- No links at all. -/
def noneModel : Model := { name := "no links", pred := fun _ _ => false, cost := nameBits }

/-- Every link. -/
def allModel : Model := { name := "all links", pred := fun i j => i != j, cost := nameBits }

/-- The cyclic group: one generator, a one-point coordinate. -/
def cyclicModel : Model :=
  { name := "cyclic C11", pred := cyclicPred, cost := groupBits 11 1 1 }

/-- The dihedral group: two generators, a one-point coordinate. -/
def dihedralModel : Model :=
  { name := "dihedral D11", pred := dihedralPred, cost := groupBits 11 2 1 }

/-- `M₁₁`: two generators, and a four-point coordinate for each concept, which
names its group element uniquely by sharp 4-transitivity. -/
def m11Derived : Model :=
  { name := "M11 Cayley", pred := m11Pred, cost := groupBits 11 2 4 }

/-- The family searched over. -/
def family : List Model := [noneModel, cyclicModel, dihedralModel, m11Derived, allModel]

theorem derived_costs :
    noneModel.cost = 3 ∧ allModel.cost = 3 ∧ cyclicModel.cost = 91 ∧
      dihedralModel.cost = 135 ∧ m11Derived.cost = 267 := by
  norm_num [noneModel, allModel, cyclicModel, dihedralModel, m11Derived, groupBits, nameBits,
    bitsFor]

/-! ## A corpus nobody designed -/

/-- The same eleven cells with one extra, mutual link — `MODULAR_FORM` to
`MONSTER_GROUP` — which no group of the family predicts. -/
def chordedCell (i : Nat) : Cell :=
  if i = 7 then { key := 7, payload := [48, 49, 50, 51], links := [6, 8, 10] }
  else if i = 10 then { key := 10, payload := [60, 61, 62, 63], links := [9, 0, 7] }
  else conceptCell i

/-- The chorded archive. -/
def chorded : Archive := (List.range 11).map chordedCell

theorem chorded_keys_nodup : (chorded.map Cell.key).Nodup := by decide

theorem chorded_links_closed : LinksClosed chorded := by decide

/-- It is a genuine archive with mutually supportive neighbours: the chord is a
link in both directions. -/
theorem chorded_mutual : MutualSupport chorded :=
  mutualSupport_of_cells chorded_keys_nodup chorded_links_closed (by decide)

/-- And it stores nothing twice. -/
theorem chorded_duplication : chorded.duplication = 0 := by decide

/-! ## Fit here, predict there -/

/-- The residual measured only on the pairs inside a region: what a model gets
wrong among the cells the client has actually loaded. -/
def residualOn (M : Model) (A : Archive) (S : List Nat) : List (Nat × Nat) :=
  (M.residual A).filter fun p => p.1 ∈ S && p.2 ∈ S

/-- **Fitting a region is exactly an empty residual on that region.** -/
theorem residualOn_eq_nil_iff_fitsOn (M : Model) (A : Archive) (S : List Nat) :
    residualOn M A S = [] ↔ M.FitsOn A S := by
  constructor
  · intro h p hp
    by_contra hc
    push_neg at hc
    have : p ∈ residualOn M A S := List.mem_filter.mpr ⟨hp, by simp [hc.1, hc.2]⟩
    rw [h] at this
    exact absurd this List.not_mem_nil
  · intro h
    apply List.filter_eq_nil_iff.mpr
    intro p hp
    rcases h p hp with h1 | h1 <;> simp [h1]

/-- The cells the model is fitted on: the first six. -/
def fitKeys : List Nat := [0, 1, 2, 3, 4, 5]

/-- The cells held out: the last five, not loaded when the model was fitted. -/
def heldOutKeys : List Nat := [6, 7, 8, 9, 10]

theorem fit_and_heldOut_partition :
    fitKeys ++ heldOutKeys = chorded.map Cell.key ∧ fitKeys.length + heldOutKeys.length = 11 := by
  decide

/-- **The `M₁₁` overlay fits the region it was fitted on**, chord and all — the
chord lies outside it. -/
theorem m11_fits_train : residualOn m11Derived chorded fitKeys = [] := by native_decide

/-- **And here is what it costs out of sample**: on the five held-out cells the
overlay is wrong about two ordered pairs — the chord, in both directions. -/
theorem m11_holdout_residual :
    residualOn m11Derived chorded heldOutKeys = [(7, 10), (10, 7)] := by native_decide

/-- The cyclic model fits the same region, and is wrong about the same two
pairs out of sample. -/
theorem cyclic_fits_train : residualOn cyclicModel chorded fitKeys = [] := by decide

theorem cyclic_holdout_residual :
    residualOn cyclicModel chorded heldOutKeys = [(7, 10), (10, 7)] := by decide

/-- So does the dihedral model … -/
theorem dihedral_fits_train : residualOn dihedralModel chorded fitKeys = [] := by decide

/-- … and yet the dihedral model is wrong about ten ordered pairs of the corpus
as a whole.  **Fitting the region you have loaded does not certify the
rest**: three different groups explain the fit region exactly and disagree
about what lies outside it. -/
theorem dihedral_fits_train_but_not_all :
    residualOn dihedralModel chorded fitKeys = [] ∧
      (dihedralModel.residual chorded).length = 10 ∧
        (dihedralModel.residual holoArchive).length = 8 := by
  decide

/-- On the original ring the out-of-sample residual of the group models is
empty — that corpus was built from the group, and this is the measurement that
says so. -/
theorem holdout_residual_on_ring :
    residualOn m11Derived holoArchive heldOutKeys = [] ∧
      residualOn cyclicModel holoArchive heldOutKeys = [] := by
  native_decide

/-! ## The table -/

/-- The description lengths of the whole family on the ring, at derived costs. -/
theorem table_on_ring :
    noneModel.descriptionLength holoArchive (pairBits 11) = 179 ∧
      cyclicModel.descriptionLength holoArchive (pairBits 11) = 91 ∧
        dihedralModel.descriptionLength holoArchive (pairBits 11) = 199 ∧
          m11Derived.descriptionLength holoArchive (pairBits 11) = 267 ∧
            allModel.descriptionLength holoArchive (pairBits 11) = 707 := by
  native_decide

/-- And on the chorded corpus, where no candidate explains everything. -/
theorem table_on_chorded :
    noneModel.descriptionLength chorded (pairBits 11) = 195 ∧
      cyclicModel.descriptionLength chorded (pairBits 11) = 107 ∧
        dihedralModel.descriptionLength chorded (pairBits 11) = 215 ∧
          m11Derived.descriptionLength chorded (pairBits 11) = 283 ∧
            allModel.descriptionLength chorded (pairBits 11) = 691 := by
  native_decide

/-- **Once the description lengths are derived rather than stipulated, the
cyclic group wins.**  The ring is explained exactly by both the cyclic model and
the `M₁₁` overlay, and the cheaper description is selected. -/
theorem cyclic_beats_m11 :
    cyclicModel.descriptionLength holoArchive (pairBits 11) <
      m11Derived.descriptionLength holoArchive (pairBits 11) := by
  obtain ⟨_, hc, _, hm, _⟩ := table_on_ring
  omega

/-- The search over the family returns the cyclic model, on both corpora. -/
theorem cyclic_is_best :
    (Model.bestModel family holoArchive (pairBits 11)).map Model.name = some "cyclic C11" ∧
      (Model.bestModel family chorded (pairBits 11)).map Model.name = some "cyclic C11" := by
  native_decide

/-- So `M₁₁` beats the models that do not explain the links, and loses to the
model that explains them more cheaply. -/
theorem m11_beats_the_unexplaining :
    m11Derived.descriptionLength holoArchive (pairBits 11) <
        allModel.descriptionLength holoArchive (pairBits 11) ∧
      m11Derived.descriptionLength holoArchive (pairBits 11) >
        cyclicModel.descriptionLength holoArchive (pairBits 11) := by
  obtain ⟨_, hc, _, hm, ha⟩ := table_on_ring
  omega

end Holdout
end Holo
end NixWars
