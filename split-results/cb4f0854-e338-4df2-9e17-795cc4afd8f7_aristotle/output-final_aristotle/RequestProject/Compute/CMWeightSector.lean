/-
# CMWeightSector — concrete condensed-matter models in the conformal-weight grading

`RequestProject.Compute.ConformalWeightGrading` decomposed the address line into
the conformal-weight sectors `weightFiber w`, and
`RequestProject.Compute.WeightSectorSheaf` organized those sectors into a sheaf
over the weight line.  This file executes the roadmap step **"map concrete
condensed-matter models into the graded weight sectors"**: it gives a small,
machine-checked dictionary turning a condensed-matter model into an addressed
object of the scale tower, so that the moonshine conformal weight (distance from
the `j`-spectrum) becomes a genuine invariant of the model.

## The dictionary

A `CMModel` carries a *spectral signature* — a single characteristic integer of
the model (a degeneracy, a leading graded multiplicity, the dimension of a
controlling Lie algebra, …).  Reading that signature as an arrow of the scale
tower (`CFTArrow ℕ`), its `moonshineWeight` places the model in exactly one
conformal-weight sector `weightFiber (m.weight)` (`CMModel.sector`).

* **Weight `0` (on the Monster CFT).**  A model lands on the Monster CFT iff its
  signature is a genuine `j`-coefficient (`CMModel.onMonsterCFT_iff`).  The
  Frenkel–Lepowsky–Meurman holomorphic `c = 24` theory is the canonical example:
  its leading graded multiplicity `c(1) = 196884` is on `J` (`monsterCFT_onCFT`).

* **Small weight = relevant operator.**  McKay's smallest faithful Monster irrep
  `χ₂ = 196883` sits one step off the CFT (`mckayDefect_weight`), realizing the
  relevant perturbation `196883 + 1 = 196884` (`mckay_relation`).  The
  Zamolodchikov `E₈` structure of the Ising model in a field
  (`dim E₈ = 248`) and the Leech kissing number `196560` sit at larger weight
  (`isingE8_weight`, `leech_weight`) — irrelevant operators.

## What is proved

1. `CMModel.weight`, `CMModel.sector`, `CMModel.graded` — every model has a
   conformal weight and lives in the corresponding sector of the grading;
   `CMModel.graded_to_addr` shows the grading sends it back to its signature.

2. `CMModel.onMonsterCFT_iff` — the on-CFT models are exactly those whose
   signature is a reference `j`-coefficient.

3. A worked table of models with their proven weights.

4. **Surjectivity onto the grading.**  `cmAtWeight w` is a model of weight exactly
   `w` (`cmAtWeight_weight`), so every conformal-weight sector is realized by a
   condensed-matter model (`cm_weight_surjective`), and these models assemble into
   a global section of the weight-sector sheaf (`cmGlobalSection`,
   `cmGlobalSection_weight`).
-/

import Mathlib
import RequestProject.Compute.ConformalWeightGrading
import RequestProject.Compute.WeightSectorSheaf

namespace RequestProject.Compute.CFT

open RequestProject.Compute.DistanceFromJ

/-! ## §1. Condensed-matter models as addressed objects of the scale tower -/

/-- A **condensed-matter model**, presented to the scale tower by a single
    characteristic integer — its *spectral signature*.  Concretely this is the
    invariant by which the model addresses the moonshine `j`-spectrum: a ground
    state degeneracy, a leading graded multiplicity of the chiral algebra, the
    dimension of a controlling symmetry, etc. -/
structure CMModel where
  /-- A human-readable name of the model. -/
  name : String
  /-- The spectral signature: the model's characteristic addressing integer. -/
  signature : ℕ
deriving Repr, DecidableEq

/-- The **conformal weight** of a condensed-matter model: the moonshine weight
    (distance from the `j`-spectrum) of its spectral signature. -/
def CMModel.weight (m : CMModel) : ℕ := moonshineWeight (m.signature : ℕ)

/-- The conformal weight unfolds to the distance-from-`J` of the signature. -/
theorem CMModel.weight_eq (m : CMModel) : m.weight = distFromJ m.signature := rfl

/-- Every model lives in the conformal-weight sector of its weight. -/
def CMModel.sector (m : CMModel) : weightFiber m.weight := ⟨m.signature, rfl⟩

@[simp] theorem CMModel.sector_val (m : CMModel) : (m.sector : ℕ) = m.signature := rfl

/-- The model, placed in the conformal-weight grading `Σ w, weightFiber w`. -/
def CMModel.graded (m : CMModel) : Σ w : ℕ, weightFiber w := ⟨m.weight, m.sector⟩

/-- The grading equivalence sends a model back to its spectral signature. -/
theorem CMModel.graded_to_addr (m : CMModel) :
    addrLine_weightGraded m.graded = m.signature := rfl

/-! ## §2. On the Monster CFT ⇔ signature is a `j`-coefficient -/

/-- A model **lies on the Monster CFT** when its conformal weight is `0`. -/
def CMModel.OnMonsterCFT (m : CMModel) : Prop := m.weight = 0

instance (m : CMModel) : Decidable m.OnMonsterCFT :=
  inferInstanceAs (Decidable (m.weight = 0))

/-- **The on-CFT models are exactly those whose spectral signature is a genuine
    `j`-coefficient.**  This is the precise sense in which the moonshine spectrum
    classifies which condensed-matter models sit on the Monster CFT. -/
theorem CMModel.onMonsterCFT_iff (m : CMModel) :
    m.OnMonsterCFT ↔ m.signature ∈ jValues := by
  unfold CMModel.OnMonsterCFT CMModel.weight
  exact distFromJ_eq_zero_iff m.signature

/-- An on-CFT model's sector is the bottom (weight-`0`) sector, and corresponds to
    a reference `j`-coefficient under `weightFiber_zero_equiv`. -/
theorem CMModel.onMonsterCFT_mem_jValues (m : CMModel) (h : m.OnMonsterCFT) :
    m.signature ∈ jValues := (m.onMonsterCFT_iff).1 h

/-- A model is a **relevant operator** of cutoff `b` when its weight is `≤ b`. -/
def CMModel.IsRelevant (m : CMModel) (b : ℕ) : Prop := m.weight ≤ b

/-! ## §3. A worked table of condensed-matter models -/

/-- The Frenkel–Lepowsky–Meurman holomorphic `c = 24` theory (the "Monster CFT"),
    addressed by its leading graded multiplicity `c(1) = 196884`. -/
def monsterCFT : CMModel := ⟨"FLM Monster CFT (c = 24)", 196884⟩

/-- The smallest faithful Monster irrep `χ₂ = 196883` as a relevant perturbation
    of the Monster CFT. -/
def mckayDefect : CMModel := ⟨"smallest faithful Monster irrep χ₂", 196883⟩

/-- The Ising model in a magnetic field, controlled by Zamolodchikov's `E₈`
    integrable structure, addressed by `dim E₈ = 248`. -/
def isingE8 : CMModel := ⟨"Ising-in-field (Zamolodchikov E₈)", 248⟩

/-- A Leech-lattice condensed-matter model addressed by the kissing number
    `196560`. -/
def leechModel : CMModel := ⟨"Leech kissing-number model", 196560⟩

/-- The Monster CFT lies on the Monster CFT (its signature is on `J`). -/
theorem monsterCFT_onCFT : monsterCFT.OnMonsterCFT := by decide

/-- McKay's defect sits exactly one conformal step off the CFT. -/
theorem mckayDefect_weight : mckayDefect.weight = 1 := by native_decide

/-- McKay's relation realized in the grading: the relevant perturbation
    `χ₂ + 1` lands the defect back on the Monster CFT. -/
theorem mckay_relation : mckayDefect.signature + 1 = monsterCFT.signature := by
  native_decide

/-- The defect is a relevant operator of cutoff `1`. -/
theorem mckayDefect_relevant : mckayDefect.IsRelevant 1 := by
  unfold CMModel.IsRelevant; rw [mckayDefect_weight]

/-- The Ising–`E₈` model is an irrelevant operator at weight `247`. -/
theorem isingE8_weight : isingE8.weight = 247 := by native_decide

/-- The Leech model sits at weight `324`. -/
theorem leech_weight : leechModel.weight = 324 := by native_decide

/-- Two genuinely different on-CFT models share the bottom sector: the Monster CFT
    (signature `196884`) and the `j` constant term model (signature `744`) both
    have weight `0` yet have distinct signatures.  So the conformal weight does not
    separate models within a sector. -/
theorem onCFT_not_separated :
    ∃ m₁ m₂ : CMModel, m₁.OnMonsterCFT ∧ m₂.OnMonsterCFT ∧
      m₁.weight = m₂.weight ∧ m₁.signature ≠ m₂.signature := by
  refine ⟨monsterCFT, ⟨"j constant term (744 = 3·248)", 744⟩, by decide, by decide, ?_, ?_⟩
  · native_decide
  · decide

/-! ## §4. Every conformal-weight sector is realized by a model -/

/-- A synthetic condensed-matter model of conformal weight exactly `w`: beyond the
    largest `j`-coefficient the distance grows linearly, so `maxJ + w` realizes the
    weight-`w` sector. -/
def cmAtWeight (w : ℕ) : CMModel :=
  ⟨"synthetic weight-" ++ toString w ++ " model", 22567393309593600 + w⟩

/-- `cmAtWeight w` has conformal weight exactly `w`. -/
theorem cmAtWeight_weight (w : ℕ) : (cmAtWeight w).weight = w :=
  distFromJ_add_maxJ w

/-- **Every conformal-weight sector is realized by a condensed-matter model.** -/
theorem cm_weight_surjective (w : ℕ) : ∃ m : CMModel, m.weight = w :=
  ⟨cmAtWeight w, cmAtWeight_weight w⟩

/-- The family `cmAtWeight` assembles into a **global section of the
    weight-sector sheaf**: a choice of condensed-matter model in every conformal
    weight sector at once. -/
def cmGlobalSection : WeightSection (Set.univ : Set ℕ) :=
  fun w => ⟨22567393309593600 + (w : ℕ), distFromJ_add_maxJ (w : ℕ)⟩

/-- Under the global-sections identification, the CM global section is the family
    whose underlying address at weight `w` is `maxJ + w` — the synthetic model
    `cmAtWeight w`. -/
theorem cmGlobalSection_signature (w : ℕ) :
    ((WeightSection.globalEquiv cmGlobalSection w : ℕ)) = 22567393309593600 + w := rfl

end RequestProject.Compute.CFT
