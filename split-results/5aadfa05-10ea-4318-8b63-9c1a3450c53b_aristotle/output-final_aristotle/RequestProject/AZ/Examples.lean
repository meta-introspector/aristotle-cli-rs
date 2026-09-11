import Mathlib
import RequestProject.AZ.SpectralReduction

/-!
# Concrete lower-dimensional topological models, tested against the K-groups

This file exercises the Altland–Zirnbauer (AZ) classification (`RequestProject.AZ.TenfoldWay`),
its blade classifier (`RequestProject.AZ.BladeClassify`) and the integer-indexed higher
K-theory `Blade.kGroupN` (`RequestProject.AZ.SpectralReduction`) on the standard catalogue of
condensed-matter topological insulators and superconductors.

Each entry is a real, named physical model — the SSH chain, the Kitaev Majorana wire, the
Haldane / Chern insulator, the Kane–Mele / BHZ quantum spin Hall insulator, the p+ip
superconductor, the 3D strong topological insulator, the ³He-B superfluid, etc.  For every
one we:

* record its AZ symmetry class and spatial dimension as a `CMModel`;
* realise it as a `Blade` carrying its Clifford signature (`CMModel.blade`);
* read off its classifying group both directly (`classify`) and through the integer-indexed
  K-theory ladder (`Blade.kGroupN`), and **prove the two agree** with the textbook value.

The bridge lemma `selfBlade_kGroupN` shows the blade-level higher K-theory `kGroupN`
reproduces the physical periodic table on every natural dimension, so the named-model
theorems below are simultaneously checks of the periodic table *and* of the `ℤ`-indexed
K-groups.  We also include Bott-periodicity round-trips on the concrete blades
(`kitaev_periodic`, `haldane_periodic`) showing the higher/lower K-groups of an actual model
repeat with period `8` (real) / `2` (complex).
-/

namespace AZ

open Class

/-- The integer-indexed K-theory of the self-blade of a class reproduces the physical
periodic table on every natural spatial dimension.  This is the bridge that lets us state
each physical model's invariant either as `classify` or as a higher K-group `kGroupN`. -/
theorem selfBlade_kGroupN (c : Class) (d : ℕ) :
    (selfBlade c).kGroupN (d : ℤ) = classify c d := by
  rw [← Blade.kGroup_eq_kGroupN]
  unfold Blade.kGroup
  rw [nearestClass_selfBlade]

/-! ## A catalogue entry -/

/-- A named condensed-matter topological model: its AZ symmetry class and spatial
dimension.  (The `name` is documentation only.) -/
structure CMModel where
  /-- A human-readable name for the model. -/
  name : String
  /-- The Altland–Zirnbauer symmetry class of the model. -/
  cls : Class
  /-- The spatial dimension of the model. -/
  dim : ℕ
deriving Repr

namespace CMModel

/-- The Clifford blade realising a model: the self-blade of its symmetry class, carrying the
class's Clifford signature `Cl_{p,q}`. -/
def blade (M : CMModel) : Blade := selfBlade M.cls

/-- The classifying group of a model, read directly off the periodic table. -/
def kGroup (M : CMModel) : KGroup := classify M.cls M.dim

/-- The classifying group of a model, read through the integer-indexed higher K-theory of
its blade. -/
def kGroupN (M : CMModel) : KGroup := M.blade.kGroupN (M.dim : ℤ)

/-- For every model, the direct periodic-table invariant and the blade-level higher
K-theory invariant coincide. -/
theorem kGroup_eq_kGroupN (M : CMModel) : M.kGroup = M.kGroupN := by
  rw [kGroup, kGroupN, blade, selfBlade_kGroupN]

end CMModel

/-! ## The catalogue of physical models

Conventions follow the standard Kitaev / Schnyder–Ryu–Furusaki–Ludwig table. -/

/-- **SSH chain / polyacetylene** — a 1D chiral (sublattice-symmetric) insulator,
class `AIII`.  Its winding number is a `ℤ` invariant. -/
def sshChain : CMModel := ⟨"SSH chain (polyacetylene)", Class.AIII, 1⟩

/-- **Kitaev Majorana wire** — a 1D spinless p-wave superconductor, class `D`.
Its end Majorana zero mode is protected by a `ℤ₂` invariant. -/
def kitaevWire : CMModel := ⟨"Kitaev Majorana wire", Class.D, 1⟩

/-- **BDI Majorana chain** — a 1D time-reversal-invariant spinless superconductor,
class `BDI`, with a `ℤ` (integer Majorana-mode) invariant. -/
def bdiChain : CMModel := ⟨"BDI Majorana chain", Class.BDI, 1⟩

/-- **DIII time-reversal superconducting wire** — a 1D class `DIII` superconductor with a
`ℤ₂` invariant (a Majorana Kramers pair at each end). -/
def diiiWire : CMModel := ⟨"DIII TRI superconducting wire", Class.DIII, 1⟩

/-- **Haldane / Chern insulator** — a 2D quantum anomalous Hall insulator with broken
time-reversal, class `A`.  Its Chern number is a `ℤ` invariant. -/
def haldane : CMModel := ⟨"Haldane / Chern insulator", Class.A, 2⟩

/-- **p+ip superconductor** — a 2D chiral spinless superconductor, class `D`, with a `ℤ`
(BdG Chern number) invariant. -/
def pPlusIp : CMModel := ⟨"p+ip superconductor", Class.D, 2⟩

/-- **Kane–Mele / BHZ quantum spin Hall insulator** — a 2D time-reversal-invariant
(`T² = -1`) insulator, class `AII`, with a `ℤ₂` invariant. -/
def quantumSpinHall : CMModel := ⟨"Kane–Mele / BHZ quantum spin Hall", Class.AII, 2⟩

/-- **3D strong topological insulator** (e.g. Bi₂Se₃) — a 3D class `AII` insulator with a
`ℤ₂` invariant and a single protected surface Dirac cone. -/
def ti3D : CMModel := ⟨"3D strong topological insulator (Bi₂Se₃)", Class.AII, 3⟩

/-- **³He-B superfluid** — a 3D time-reversal-invariant superfluid, class `DIII`, with a
`ℤ` (winding) invariant. -/
def helium3B : CMModel := ⟨"³He-B superfluid", Class.DIII, 3⟩

/-! ## Verified invariants

Each theorem states the textbook classifying group of the model, proved through the
integer-indexed higher K-theory `kGroupN` of the model's Clifford blade (so it is at once a
check of the periodic table and of the `ℤ`-graded K-groups). -/

/-- The SSH chain carries a `ℤ` winding invariant. -/
theorem sshChain_kGroup : sshChain.kGroupN = KGroup.Z := by decide

/-- The Kitaev wire carries a `ℤ₂` Majorana invariant. -/
theorem kitaevWire_kGroup : kitaevWire.kGroupN = KGroup.Z2 := by decide

/-- The BDI Majorana chain carries a `ℤ` invariant. -/
theorem bdiChain_kGroup : bdiChain.kGroupN = KGroup.Z := by decide

/-- The DIII superconducting wire carries a `ℤ₂` invariant. -/
theorem diiiWire_kGroup : diiiWire.kGroupN = KGroup.Z2 := by decide

/-- The Haldane / Chern insulator carries a `ℤ` Chern invariant. -/
theorem haldane_kGroup : haldane.kGroupN = KGroup.Z := by decide

/-- The p+ip superconductor carries a `ℤ` BdG-Chern invariant. -/
theorem pPlusIp_kGroup : pPlusIp.kGroupN = KGroup.Z := by decide

/-- The quantum spin Hall insulator carries a `ℤ₂` invariant. -/
theorem quantumSpinHall_kGroup : quantumSpinHall.kGroupN = KGroup.Z2 := by decide

/-- The 3D strong topological insulator carries a `ℤ₂` invariant. -/
theorem ti3D_kGroup : ti3D.kGroupN = KGroup.Z2 := by decide

/-- The ³He-B superfluid carries a `ℤ` invariant. -/
theorem helium3B_kGroup : helium3B.kGroupN = KGroup.Z := by decide

/-! ## Trivial vs non-trivial cells

The same symmetry class can be topologically trivial in a different dimension; the K-theory
ladder records this.  For instance the `AII` quantum spin Hall response is non-trivial in 2D
but the bare `AII` class is trivial in 1D. -/

/-- `AII` is topologically trivial in spatial dimension 1 (no 1D quantum spin Hall phase). -/
theorem aii_trivial_1d : (selfBlade Class.AII).kGroupN (1 : ℤ) = KGroup.null := by decide

/-- `AII` becomes non-trivial in spatial dimension 2 — the quantum spin Hall effect. -/
theorem aii_nontrivial_2d : (selfBlade Class.AII).kGroupN (2 : ℤ) ≠ KGroup.null := by decide

/-! ## Bott periodicity on concrete models

The higher and lower K-groups of an actual physical model repeat: period `8` for the real
classes, period `2` for the complex classes.  This is the `ℤ`-indexed K-theory ladder
exhibited on concrete blades. -/

/-- The real Kitaev wire's K-groups repeat with period `8`: the K-group eight dimensions
below agrees with the physical one. -/
theorem kitaev_periodic (n : ℤ) :
    kitaevWire.blade.kGroupN (n + 8) = kitaevWire.blade.kGroupN n :=
  Blade.kGroupN_periodic8 _ (by decide) n

/-- The complex Haldane / Chern insulator's K-groups repeat with period `2`. -/
theorem haldane_periodic (n : ℤ) :
    haldane.blade.kGroupN (n + 2) = haldane.blade.kGroupN n :=
  Blade.kGroupN_periodic2 _ (by decide) n

/-- A full period-`8` window of the Kitaev (class `D`) K-theory ladder across dimensions
`0,…,7`, exhibiting the real Bott clock `ℤ₂, ℤ₂, ℤ, 0, 0, 0, 2ℤ, 0` of class `D`. -/
theorem kitaev_ladder :
    kitaevWire.blade.kGroupN 0 = KGroup.Z2 ∧ kitaevWire.blade.kGroupN 1 = KGroup.Z2 ∧
    kitaevWire.blade.kGroupN 2 = KGroup.Z ∧ kitaevWire.blade.kGroupN 3 = KGroup.null ∧
    kitaevWire.blade.kGroupN 4 = KGroup.null ∧ kitaevWire.blade.kGroupN 5 = KGroup.null ∧
    kitaevWire.blade.kGroupN 6 = KGroup.twoZ ∧ kitaevWire.blade.kGroupN 7 = KGroup.null := by
  decide

end AZ
