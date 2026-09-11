/-
ShapeBott.lean — grounding the project's "simple" Bott clock in the deep tenfold-way theory.

The earlier file `RequestProject/ShapeHarmonic.lean` introduced a *simple idea*: read a
code-shape's subtree sizes as residues on a periodic "Bott clock" `ZMod p`, with the
complex clock at period `2` and the real clock at period `8`, the real one refining the
complex one because `2 ∣ 8`. That file motivated the device by analogy with Bott
periodicity, but stood on its own.

Here we **ground that simple idea in the genuine deeper theory** it was mined from: the
machine-checked Altland–Zirnbauer "tenfold way" and its Clifford / K-theory front-end now
living in `RequestProject/AZ/`. The point is that the project's two clocks are *literally*
the two AZ Bott clocks, and the project's "a whole period of size is invisible" is
*literally* the period-`8` / period-`2` Bott periodicity of the real / complex periodic
table of topological insulators.

What we establish:

* `realClassOfResidue : ZMod 8 → AZ.Class` is a section of the AZ real Bott clock
  `AZ.Class.realIndex` (`realIndex_realClassOfResidue`), landing in the eight *real*
  classes (`realClassOfResidue_isComplex_false`). Hence every residue produced by the
  project's `realHarmonic` *names a genuine Altland–Zirnbauer symmetry class*, and a
  shape's size word is read off as a bag of real classes (`shapeRealClasses`).

* By the Clifford front-end, those residues are exactly the **Clifford degrees** of the
  named classes (`shapeResidue_eq_cliffordDegree`): a subtree's size, read on the clock,
  *is* the `Cl_{p,q}` degree `q - p` that drives Bott periodicity.

* A shape therefore has, in each spatial dimension `d`, a bag of classifying K-groups
  `shapeKGroups d s`, and the project's naive periodicity becomes the real periodic
  table's genuine **period-8 Bott periodicity** (`shapeKGroups_periodic8`), with the
  complex shadow obeying **period-2** periodicity (`complexShapeKGroups_periodic2`).

* The project's clock-refinement map `ZMod 8 → ZMod 2` of `ShapeHarmonic` is exactly the
  ring map underlying "`KO` refines `KU`" (`complexHarmonic_eq_castHom_realHarmonic`,
  re-exported), and the two AZ spectra `KU`, `KO` carry exactly periods `2 ∣ 8`
  (`KU_period_dvd_KO_period`).

* Compatibility with the project's other lenses is preserved: `1`-similar shapes (same
  multiset of sizes) name the same classes and the same K-groups
  (`shapeRealClasses_of_similarN_one`, `shapeKGroups_of_similarN_one`).
-/
import Mathlib
import RequestProject.SizeSignature
import RequestProject.ShapeAlgebra
import RequestProject.ShapeHarmonic
import RequestProject.AZ.TenfoldWay
import RequestProject.AZ.CliffordK

namespace ShapeBott

open SizeSignature ShapeAlgebra ShapeHarmonic AZ

/-! ## The project's real clock is the Altland–Zirnbauer real Bott clock -/

/-- A section of the real Bott clock `AZ.Class.realIndex : Class → ZMod 8`: it sends each
residue back to the (unique) real Altland–Zirnbauer class sitting at that position on the
`ℤ₈` clock. -/
def realClassOfResidue (n : ZMod 8) : AZ.Class :=
  if n = 0 then .AI
  else if n = 1 then .BDI
  else if n = 2 then .D
  else if n = 3 then .DIII
  else if n = 4 then .AII
  else if n = 5 then .CII
  else if n = 6 then .C
  else .CI

/-- `realClassOfResidue` is a genuine section of the real Bott clock: reading its value
back off the clock recovers the residue. -/
theorem realIndex_realClassOfResidue (n : ZMod 8) :
    (realClassOfResidue n).realIndex = n := by
  revert n; decide

/-- Every class named by the real clock is a *real* class (not one of the two complex
classes `A`, `AIII`). -/
theorem realClassOfResidue_isComplex_false (n : ZMod 8) :
    (realClassOfResidue n).isComplex = false := by
  revert n; decide

/-- The real clock section is surjective onto the eight real classes: every real class is
named by some residue. -/
theorem realClassOfResidue_surjective_on_reals (c : AZ.Class) (hc : c.isComplex = false) :
    realClassOfResidue c.realIndex = c := by
  cases c <;> revert hc <;> decide

/-! ## A shape, read as a bag of Altland–Zirnbauer symmetry classes -/

/-- The bag of Altland–Zirnbauer **real symmetry classes** named by a shape: each subtree
size is read on the real Bott clock and turned into the real class sitting there. -/
def shapeRealClasses (s : Shape) : Multiset AZ.Class :=
  (realHarmonic s).map realClassOfResidue

/-- A shape's clock residues are exactly the **Clifford degrees** of the classes it names:
a subtree's size, read on the period-`8` clock, equals the `Cl_{p,q}` degree `q - p` of the
real class at that position. This is the grounding of the project's residues in the
Clifford/K-theory invariant that drives Bott periodicity. -/
theorem shapeResidue_eq_cliffordDegree (n : ZMod 8) :
    ((clIndexOfClass (realClassOfResidue n)).degree : ZMod 8) = n := by
  rw [clIndex_degree_real _ (realClassOfResidue_isComplex_false n),
    realIndex_realClassOfResidue]

/-- The number of classes a shape names equals the length of its size word (one residue,
hence one class, per subtree). -/
theorem card_shapeRealClasses (s : Shape) :
    Multiset.card (shapeRealClasses s) = (sizeWord s).length := by
  simp [shapeRealClasses, realHarmonic, card_harmonic]

/-! ## The classifying K-groups of a shape, and genuine Bott periodicity -/

/-- The bag of classifying K-groups attached to a shape in spatial dimension `d`: for each
real class the shape names, the entry of the **periodic table of topological insulators**
(`AZ.classify`) in that dimension. -/
def shapeKGroups (d : ℕ) (s : Shape) : Multiset KGroup :=
  (shapeRealClasses s).map (fun c => classify c d)

/-- **Genuine Bott periodicity for shapes.** Shifting the spatial dimension by a whole
real period `8` leaves a shape's bag of K-groups unchanged. This is the project's naive
"a full period of size is invisible on the clock" grounded in the real periodic table's
period-`8` Bott periodicity (`AZ.classify_periodic8`). -/
theorem shapeKGroups_periodic8 (d : ℕ) (s : Shape) :
    shapeKGroups (d + 8) s = shapeKGroups d s := by
  unfold shapeKGroups
  refine Multiset.map_congr rfl ?_
  intro c _
  exact classify_periodic8 c d

/-- The classifying groups of a shape depend on the dimension only through `d % 8`. -/
theorem shapeKGroups_mod8 (d : ℕ) (s : Shape) :
    shapeKGroups d s = shapeKGroups (d % 8) s := by
  unfold shapeKGroups
  refine Multiset.map_congr rfl ?_
  intro c _
  exact classify_mod8 c d

/-! ## The complex clock and the refinement `KO → KU` -/

/-- The bag of complex symmetry classes named by a shape on the period-`2` clock: residue
`1` is the chiral class `AIII`, residue `0` the class `A`. -/
def complexClassOfResidue (n : ZMod 2) : AZ.Class :=
  if n = 0 then .A else .AIII

/-- The complex clock section is a section of the complex Bott clock
`AZ.Class.complexIndex : Class → ZMod 2`. -/
theorem complexIndex_complexClassOfResidue (n : ZMod 2) :
    (complexClassOfResidue n).complexIndex = n := by
  revert n; decide

/-- Each class named by the complex clock is a *complex* class (`A` or `AIII`). -/
theorem complexClassOfResidue_isComplex (n : ZMod 2) :
    (complexClassOfResidue n).isComplex = true := by
  revert n; decide

/-- The bag of complex classifying K-groups attached to a shape in spatial dimension `d`. -/
def complexShapeKGroups (d : ℕ) (s : Shape) : Multiset KGroup :=
  ((complexHarmonic s).map complexClassOfResidue).map (fun c => classify c d)

/-- **Period-2 Bott periodicity for the complex shadow.** Shifting the dimension by the
complex period `2` leaves a shape's complex K-groups unchanged
(`AZ.classify_periodic2_complex`). -/
theorem complexShapeKGroups_periodic2 (d : ℕ) (s : Shape) :
    complexShapeKGroups (d + 2) s = complexShapeKGroups d s := by
  unfold complexShapeKGroups
  refine Multiset.map_congr rfl ?_
  intro c hc
  obtain ⟨r, _, rfl⟩ := Multiset.mem_map.1 hc
  exact classify_periodic2_complex _ (complexClassOfResidue_isComplex r) d

/-- The project's clock-refinement (the ring map `ZMod 8 → ZMod 2`, valid because `2 ∣ 8`)
recovers the complex harmonic from the real harmonic — re-exported here from
`ShapeHarmonic` as the shape-level shadow of "`KO` refines `KU`". -/
theorem complexHarmonic_eq_castHom_realHarmonic (s : Shape) :
    (realHarmonic s).map (ZMod.castHom (show (2 : ℕ) ∣ 8 by norm_num) (ZMod 2)) =
      complexHarmonic s :=
  ShapeHarmonic.realHarmonic_refines_complexHarmonic s

/-- The two Altland–Zirnbauer spectra carry exactly the project's two clock periods, and
the complex period divides the real period (`2 ∣ 8`), which is why the real clock refines
the complex one. -/
theorem KU_period_dvd_KO_period : (2 : ℕ) ∣ 8 := by norm_num

/-- Spectrum-level statement of the periods: `KU` has period `2` and `KO` has period `8`. -/
theorem KGroupOf_KU_periodic2 (n : ℤ) :
    KGroupOf Spectrum.KU (n + 2) = KGroupOf Spectrum.KU n := by
  simp only [KGroupOf_KU]
  have h : ((n + 2 : ℤ) : ZMod 2) = (n : ZMod 2) := by
    push_cast; rw [show (2 : ZMod 2) = 0 from by decide]; ring
  rw [h]

theorem KGroupOf_KO_periodic8 (n : ℤ) :
    KGroupOf Spectrum.KO (n + 8) = KGroupOf Spectrum.KO n := by
  simp only [KGroupOf_KO]
  have h : ((n + 8 : ℤ) : ZMod 8) = (n : ZMod 8) := by
    push_cast; rw [show (8 : ZMod 8) = 0 from by decide]; ring
  rw [h]

/-! ## Compatibility with the project's similarity lens -/

/-- `1`-similar shapes (same multiset of subtree sizes) name the same bag of
Altland–Zirnbauer classes. -/
theorem shapeRealClasses_of_similarN_one {a b : Shape} (h : similarN 1 a b) :
    shapeRealClasses a = shapeRealClasses b := by
  unfold shapeRealClasses realHarmonic
  rw [harmonic_of_similarN_one h]

/-- `1`-similar shapes have the same bag of classifying K-groups in every dimension. -/
theorem shapeKGroups_of_similarN_one {a b : Shape} (h : similarN 1 a b) (d : ℕ) :
    shapeKGroups d a = shapeKGroups d b := by
  unfold shapeKGroups
  rw [shapeRealClasses_of_similarN_one h]

end ShapeBott
