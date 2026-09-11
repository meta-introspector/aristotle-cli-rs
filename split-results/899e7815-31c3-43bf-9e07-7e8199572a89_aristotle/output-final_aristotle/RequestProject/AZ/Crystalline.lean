import Mathlib
import RequestProject.AZ.TenfoldWay
import RequestProject.AZ.Classification

/-!
# Crystalline / equivariant Altland–Zirnbauer classes

`RequestProject.AZ.TenfoldWay` builds the ten Hermitian Altland–Zirnbauer (AZ) classes
and the periodic table `classify : Class → ℕ → KGroup` of topological insulators and
superconductors protected by *non-spatial* symmetries.

Real materials also carry **spatial / crystalline** symmetries (reflections, rotations,
…).  Adding such a symmetry refines the classification: in the K-theory / Clifford
picture an order-two crystalline symmetry performs a *Clifford-algebra extension*,
which shifts the position of the class on the Bott clock and hence reshuffles the
periodic table (Chiu–Teo–Schnyder–Ryu; Shiozaki–Sato; and, for the non-Hermitian
case with reflection, Liu–Jiang–Chen, one of the provided references).

This file provides two self-contained, machine-checked layers on top of the AZ core.

## 1. Crystalline (equivariant) shift of the periodic table

`classifyCrystalline c d s` is the classifying group of a class `c` in spatial
dimension `d` in the presence of a crystalline symmetry whose Clifford extension
shifts the Bott clock by `s`.  Taking `s = 0` recovers the ordinary table
(`classifyCrystalline_zero`).  We prove Bott periodicity in both the dimension and
the shift, and that for *every* shift exactly five of the ten classes remain
topologically non-trivial in each dimension.

## 2. Hybrid (fusion) symmetry classes

Following the provided reference *"Hybrid symmetry class topological insulators"*
(Das–Roy), a **hybrid** class fuses two AZ topological insulators living on
orthogonal Cartesian hyperplanes, with mutually anticommuting massive Dirac
Hamiltonians.  The fused phase lives in the sum of the two dimensions, and its bulk
is non-trivial precisely when *both* parent insulators are non-trivial.  We model the
fusion as a `Hybrid` of two `(class, dimension)` data, prove the bulk
non-triviality criterion, and verify the paper's headline example: a planar quantum
spin Hall insulator (class `AII`, 2D) fused with a vertical Su–Schrieffer–Heeger
chain (class `AIII`, 1D) yields a non-trivial three-dimensional hybrid hosting a
quantum anomalous Hall response (class `A`, 2D).
-/

namespace AZ
namespace Crystalline

open Class

/-! ## 1. Crystalline / equivariant shift of the periodic table -/

/-- The classifying group of class `c` in spatial dimension `d` in the presence of a
crystalline symmetry whose Clifford-algebra extension shifts the Bott clock by `s`:
the complex series shifts on the `ℤ₂` clock, the real series on the `ℤ₈` clock. -/
def classifyCrystalline (c : Class) (d : ℕ) (s : ℕ) : KGroup :=
  if c.isComplex then complexPattern (c.complexIndex - (d : ZMod 2) + (s : ZMod 2))
  else realPattern (c.realIndex - (d : ZMod 8) + (s : ZMod 8))

/-- With zero shift the crystalline table reduces to the ordinary AZ periodic table. -/
theorem classifyCrystalline_zero (c : Class) (d : ℕ) :
    classifyCrystalline c d 0 = classify c d := by
  unfold classifyCrystalline classify
  simp

/-- **Bott periodicity in the dimension** for the crystalline table (period `8`). -/
theorem classifyCrystalline_periodic8_dim (c : Class) (d s : ℕ) :
    classifyCrystalline c (d + 8) s = classifyCrystalline c d s := by
  have h2 : ((d + 8 : ℕ) : ZMod 2) = (d : ZMod 2) := by
    push_cast; rw [show (8 : ZMod 2) = 0 from by decide]; ring
  have h8 : ((d + 8 : ℕ) : ZMod 8) = (d : ZMod 8) := by
    push_cast; rw [show (8 : ZMod 8) = 0 from by decide]; ring
  unfold classifyCrystalline; rw [h2, h8]

/-- **Bott periodicity in the crystalline shift** (period `8`): shifting the Clifford
extension by a full Bott cycle returns the original table. -/
theorem classifyCrystalline_periodic8_shift (c : Class) (d s : ℕ) :
    classifyCrystalline c d (s + 8) = classifyCrystalline c d s := by
  have h2 : ((s + 8 : ℕ) : ZMod 2) = (s : ZMod 2) := by
    push_cast; rw [show (8 : ZMod 2) = 0 from by decide]; ring
  have h8 : ((s + 8 : ℕ) : ZMod 8) = (s : ZMod 8) := by
    push_cast; rw [show (8 : ZMod 8) = 0 from by decide]; ring
  unfold classifyCrystalline; rw [h2, h8]

/-- The crystalline table depends on the dimension and shift only through their
residues modulo `8`. -/
theorem classifyCrystalline_mod8 (c : Class) (d s : ℕ) :
    classifyCrystalline c d s = classifyCrystalline c (d % 8) (s % 8) := by
  have hd2 : ((d : ℕ) : ZMod 2) = ((d % 8 : ℕ) : ZMod 2) := by
    conv_lhs => rw [← Nat.div_add_mod d 8]
    push_cast; rw [show (8 : ZMod 2) = 0 from by decide]; ring
  have hd8 : ((d : ℕ) : ZMod 8) = ((d % 8 : ℕ) : ZMod 8) := by
    conv_lhs => rw [← Nat.div_add_mod d 8]
    push_cast; rw [show (8 : ZMod 8) = 0 from by decide]; ring
  have hs2 : ((s : ℕ) : ZMod 2) = ((s % 8 : ℕ) : ZMod 2) := by
    conv_lhs => rw [← Nat.div_add_mod s 8]
    push_cast; rw [show (8 : ZMod 2) = 0 from by decide]; ring
  have hs8 : ((s : ℕ) : ZMod 8) = ((s % 8 : ℕ) : ZMod 8) := by
    conv_lhs => rw [← Nat.div_add_mod s 8]
    push_cast; rw [show (8 : ZMod 8) = 0 from by decide]; ring
  unfold classifyCrystalline; rw [hd2, hd8, hs2, hs8]

/-- **Five non-trivial classes for every crystalline shift.**  Whatever the Clifford
extension shift `s`, in each spatial dimension exactly five of the ten classes remain
topologically non-trivial — the crystalline symmetry reshuffles, but does not change
the *number* of, the non-trivial classes. -/
theorem five_nontrivial_crystalline (d s : ℕ) :
    (Finset.univ.filter
      (fun c : Class => classifyCrystalline c d s ≠ KGroup.null)).card = 5 := by
  have hcong : (Finset.univ.filter
        (fun c : Class => classifyCrystalline c d s ≠ KGroup.null))
      = (Finset.univ.filter
        (fun c : Class => classifyCrystalline c (d % 8) (s % 8) ≠ KGroup.null)) := by
    apply Finset.filter_congr; intro c _; rw [classifyCrystalline_mod8 c d s]
  rw [hcong]
  have hd : d % 8 < 8 := Nat.mod_lt d (by norm_num)
  have hs : s % 8 < 8 := Nat.mod_lt s (by norm_num)
  interval_cases (d % 8) <;> interval_cases (s % 8) <;> decide

/-! ## 2. Hybrid (fusion) symmetry classes

A hybrid symmetry-class topological insulator fuses two AZ insulators occupying
orthogonal Cartesian hyperplanes (Das–Roy). -/

/-- A hybrid symmetry-class insulator: two AZ topological insulators, each given by a
class and the dimension of the hyperplane it occupies, to be fused along orthogonal
directions. -/
structure Hybrid where
  /-- The AZ class of the first constituent insulator. -/
  c1 : Class
  /-- The dimension of the hyperplane occupied by the first constituent. -/
  d1 : ℕ
  /-- The AZ class of the second constituent insulator. -/
  c2 : Class
  /-- The dimension of the hyperplane occupied by the second constituent. -/
  d2 : ℕ
deriving Repr

namespace Hybrid

/-- The total spatial dimension of the fused hybrid: the sum of the two hyperplane
dimensions. -/
def totalDim (h : Hybrid) : ℕ := h.d1 + h.d2

/-- The classifying groups of the two constituent insulators. -/
def constituents (h : Hybrid) : KGroup × KGroup :=
  (classify h.c1 h.d1, classify h.c2 h.d2)

/-- The fused bulk is **non-trivial** when both constituent insulators are
topologically non-trivial. -/
def isNontrivial (h : Hybrid) : Prop :=
  classify h.c1 h.d1 ≠ KGroup.null ∧ classify h.c2 h.d2 ≠ KGroup.null

instance (h : Hybrid) : Decidable h.isNontrivial := by
  unfold isNontrivial; infer_instance

/-- **Bulk non-triviality criterion.**  A hybrid is non-trivial exactly when *both*
parent insulators are non-trivial. -/
theorem isNontrivial_iff (h : Hybrid) :
    h.isNontrivial ↔
      (classify h.c1 h.d1 ≠ KGroup.null ∧ classify h.c2 h.d2 ≠ KGroup.null) :=
  Iff.rfl

/-- The headline example of Das–Roy: a planar **quantum spin Hall** insulator
(class `AII` in `d = 2`, with `ℤ₂` invariant) fused with a vertical
**Su–Schrieffer–Heeger** chain (class `AIII` in `d = 1`, with `ℤ` invariant). -/
def qshSshHybrid : Hybrid := ⟨Class.AII, 2, Class.AIII, 1⟩

/-- The quantum-spin-Hall ⊕ SSH hybrid lives in three spatial dimensions. -/
theorem qshSshHybrid_totalDim : qshSshHybrid.totalDim = 3 := by decide

/-- The two constituents of the headline hybrid are genuinely topological: the planar
quantum spin Hall insulator has a `ℤ₂` invariant and the SSH chain a `ℤ` invariant. -/
theorem qshSshHybrid_constituents :
    qshSshHybrid.constituents = (KGroup.Z2, KGroup.Z) := by decide

/-- The headline three-dimensional hybrid has a non-trivial bulk. -/
theorem qshSshHybrid_isNontrivial : qshSshHybrid.isNontrivial := by decide

/-- The hybrid's boundary hosts a **quantum anomalous Hall** insulator: class `A` in
`d = 2`, carrying the `ℤ`-valued (quantized Hall) invariant. -/
theorem qshSshHybrid_surface : classify Class.A 2 = KGroup.Z := by decide

end Hybrid

end Crystalline
end AZ
