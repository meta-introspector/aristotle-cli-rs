import RequestProject.Nix.NixWars.Holo.Geometry
import RequestProject.Nix.NixWars.Holo.M11

/-!
# Structural overlays: a model, its residual, and the cost of both

A group such as `M₁₁` can be used as a *template* for the archive's link
geometry rather than as a primitive: assign each concept a coordinate, let the
group say which concepts should be linked, and keep the difference.

* `Model` — a predicted link relation plus the cost, in bits, of writing the
  model itself down.
* `residual` — the pairs where the prediction and the archive disagree: what
  the structure fails to explain.  It is **part of the representation**:
  `reconstruct_eq_actual` proves that prediction corrected by residual returns
  the archive's own links exactly, so nothing is discarded.
* `descriptionLength` — `L(G) + L(D ∣ G)`, the cost of the model plus the cost
  of the residual.  `bestModel` picks the cheapest of a list of candidates, and
  `bestModel_le` proves no candidate is cheaper: choosing the structure is a
  minimum-description-length problem, and `M₁₁` is a *discovered* coordinate
  system exactly when it wins.
* Fitting and prediction.  `FitsOn M A S` says the model explains every link
  inside the loaded region `S`.  It is monotone (`FitsOn_mono`): a model that
  fits what you have loaded fits every smaller region.  Fitting a region does
  **not** by itself extend to the rest of the archive — `fit_subset_not_global`
  exhibits an archive, a model and a region where the fit is perfect inside and
  wrong outside — so the holographic claim (loaded cells predict the
  organisation of unloaded cells) is a real, falsifiable statement about a
  particular archive and model, tested by `residual_eq_nil_iff`.
-/

set_option maxRecDepth 10000

namespace NixWars
namespace Holo

open Archive

/-- A structural model of the archive's link geometry: which pairs of concepts
it predicts to be linked, what it costs to write the model down, and a name. -/
structure Model where
  /-- What the model is called. -/
  name : String
  /-- The predicted link relation. -/
  pred : Nat → Nat → Bool
  /-- The description length, in bits, of the model itself: `L(G)`. -/
  cost : Nat

namespace Model

/-- The archive's own link relation. -/
def actual (A : Archive) (i j : Nat) : Bool := decide (j ∈ A.nbrs i)

/-- The ordered pairs of concepts the model is asked about. -/
def pairs (A : Archive) : List (Nat × Nat) :=
  (A.map Cell.key).flatMap fun i => (A.map Cell.key).map fun j => (i, j)

/-- The residual `E = D - Π(D)`: the pairs the structure gets wrong. -/
def residual (M : Model) (A : Archive) : List (Nat × Nat) :=
  (pairs A).filter fun p => M.pred p.1 p.2 ≠ actual A p.1 p.2

/-- The archive as the model reconstructs it: prediction, corrected by the
residual. -/
def reconstruct (M : Model) (A : Archive) (i j : Nat) : Bool :=
  if (i, j) ∈ M.residual A then !M.pred i j else M.pred i j

/-- **The error is part of the representation, not a loss.**  Model plus
residual returns the archive's links exactly. -/
theorem reconstruct_eq_actual (M : Model) (A : Archive) {i j : Nat}
    (h : (i, j) ∈ pairs A) : M.reconstruct A i j = actual A i j := by
  unfold reconstruct
  by_cases hr : (i, j) ∈ M.residual A
  · rw [if_pos hr]
    have : M.pred i j ≠ actual A i j := by
      have := List.mem_filter.mp hr
      simpa using this.2
    revert this
    cases M.pred i j <;> cases actual A i j <;> simp
  · rw [if_neg hr]
    by_contra hne
    exact hr (List.mem_filter.mpr ⟨h, by simpa using hne⟩)

/-- The model explains the archive completely exactly when the residual is
empty. -/
theorem residual_eq_nil_iff (M : Model) (A : Archive) :
    M.residual A = [] ↔ ∀ p ∈ pairs A, M.pred p.1 p.2 = actual A p.1 p.2 := by
  constructor
  · intro h p hp
    by_contra hne
    have : p ∈ M.residual A := List.mem_filter.mpr ⟨hp, by simpa using hne⟩
    rw [h] at this
    exact absurd this (List.not_mem_nil)
  · intro h
    apply List.filter_eq_nil_iff.mpr
    intro p hp
    simp [h p hp]

/-- `L(G) + L(D ∣ G)`: the bits spent on the model plus the bits spent on the
residual, at `bits` bits a pair. -/
def descriptionLength (M : Model) (A : Archive) (bits : Nat) : Nat :=
  M.cost + bits * (M.residual A).length

/-- The cheapest model of a list of candidates. -/
def bestModel (Ms : List Model) (A : Archive) (bits : Nat) : Option Model :=
  Ms.argmin (fun M => M.descriptionLength A bits)

theorem bestModel_mem {Ms : List Model} {A : Archive} {bits : Nat} {M : Model}
    (h : bestModel Ms A bits = some M) : M ∈ Ms :=
  List.argmin_mem h

/-- **Choosing the structure is a minimum-description-length problem**: the
model returned is at least as cheap as every candidate. -/
theorem bestModel_le {Ms : List Model} {A : Archive} {bits : Nat} {M : Model}
    (h : bestModel Ms A bits = some M) :
    ∀ N ∈ Ms, M.descriptionLength A bits ≤ N.descriptionLength A bits :=
  fun _ hN => List.le_of_mem_argmin hN h

/-! ## Fitting a region and predicting outside it -/

/-- The model explains every link inside the loaded region `S`. -/
def FitsOn (M : Model) (A : Archive) (S : List Nat) : Prop :=
  ∀ p ∈ M.residual A, p.1 ∉ S ∨ p.2 ∉ S

instance (M : Model) (A : Archive) (S : List Nat) : Decidable (M.FitsOn A S) :=
  inferInstanceAs (Decidable (∀ p ∈ M.residual A, p.1 ∉ S ∨ p.2 ∉ S))

/-- **A model that fits what you have loaded fits every smaller region.** -/
theorem FitsOn_mono {M : Model} {A : Archive} {S T : List Nat} (hST : T ⊆ S)
    (h : M.FitsOn A S) : M.FitsOn A T := by
  intro p hp
  rcases h p hp with h1 | h2
  · exact Or.inl fun hc => h1 (hST hc)
  · exact Or.inr fun hc => h2 (hST hc)

/-- A model with an empty residual fits everything. -/
theorem FitsOn_of_residual_nil {M : Model} {A : Archive} (h : M.residual A = [])
    (S : List Nat) : M.FitsOn A S := by
  intro p hp
  rw [h] at hp
  exact absurd hp (List.not_mem_nil)

/-- **Predicting outside the loaded region is a real claim, not a tautology.**
Here is an archive, a model and a loaded region such that the model explains
every link inside the region and still gets a link outside it wrong: fitting
what you have loaded does not by itself determine the rest. -/
theorem fit_subset_not_global :
    ∃ (M : Model) (A : Archive) (S : List Nat),
      M.FitsOn A S ∧ ¬ M.FitsOn A (A.map Cell.key) := by
  -- two concepts, `0` and `1`; the model predicts no links at all, and the
  -- archive links `1` to `0`.  Loading only `0` hides the disagreement.
  refine ⟨⟨"empty", fun _ _ => false, 0⟩,
    [⟨0, [10], []⟩, ⟨1, [11], [0]⟩], [0], ?_, ?_⟩
  · decide
  · decide

end Model
end Holo
end NixWars
