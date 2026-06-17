import Mathlib
import RequestProject.AZ.TenfoldWay
import RequestProject.AZ.Classification

/-!
# A Clifford / K-theory front-end for the Altland–Zirnbauer tenfold way

`RequestProject.AZ.TenfoldWay` builds the ten Altland–Zirnbauer (AZ) classes, their
Bott clocks (`ℤ₂` for the two complex classes, `ℤ₈` for the eight real ones) and the
periodic table `classify : Class → ℕ → KGroup`.

This file makes the Bott clocks *explicitly Clifford-theoretic* and exposes a small
simulation / encoding API on top of the classification.  It has three layers.

## 1. Clifford / K-theory layer

* `ClIndex` — a Clifford signature `Cl_{p,q}`, with its **Clifford degree** `q - p`.
* `clIndexOfClass : Class → ClIndex` — the AZ↔Clifford dictionary, chosen so that the
  Clifford degree of a class equals its Bott-clock position (`realIndex`/`complexIndex`).
* `Spectrum` (`KU`/`KO`) and `spectrumOfClass` — which K-theory spectrum governs a class.
* `KGroupOf : Spectrum → ℤ → KGroup` — the Bott-periodic K-groups, written with explicit
  `n % 2` / `n % 8` clocks.
* `classifyViaClifford` and the bridge theorem
  `classify_eq_classifyViaClifford : classify c d = classifyViaClifford c d`,
  re-expressing the entire periodic table through Clifford degrees and `KGroupOf`.

## 2. Moonshine / CRT encoding layer

* `Slot` (a `(class, dimension)` cell of the table), `SlotData` (a slot + an arithmetic
  invariant), and `Slot.isNontrivial`.
* `five_nontrivial_slots` — the tenfold-way count, restated for slots.
* `CRTPair` together with `pack`/`unpack` built from `ZMod.chineseRemainder`, and the
  round-trip theorems `unpack_pack`, `pack_unpack`, `reconstruct_fst`, `reconstruct_snd`,
  packing/recovering per-slot invariants via the Chinese Remainder Theorem.

## 3. Simulation API

* `Phase` (symmetry data + dimension) with `Phase.cls`, `Phase.kGroup`, `Phase.slot`,
  `Phase.clifford`, and the bridge `Phase.kGroup_eq_clifford`.
-/

namespace AZ

open Class

/-! ## 1. Clifford / K-theory layer -/

/-- A real Clifford signature `Cl_{p,q}`.  Only the **Clifford degree** `q - p`
matters for the K-theory pattern; carrying `p` and `q` separately keeps the geometric
signature data around. -/
structure ClIndex where
  /-- Number of generators squaring to `+1`. -/
  p : ℤ
  /-- Number of generators squaring to `-1`. -/
  q : ℤ
deriving DecidableEq, Repr

/-- The Clifford degree `q - p` of a signature `Cl_{p,q}`; this is the homotopy-theoretic
invariant that drives Bott periodicity. -/
def ClIndex.degree (i : ClIndex) : ℤ := i.q - i.p

/-- The AZ ↔ Clifford dictionary.  The Clifford degree of each class is chosen to equal
its Bott-clock position: the real classes climb the `ℤ₈` clock `AI, BDI, …, CI`
(degrees `0,…,7`), and the two complex classes sit at degrees `0` (`A`) and `1` (`AIII`)
on the `ℤ₂` clock. -/
def clIndexOfClass : Class → ClIndex
  | .A    => ⟨0, 0⟩
  | .AIII => ⟨0, 1⟩
  | .AI   => ⟨0, 0⟩
  | .BDI  => ⟨0, 1⟩
  | .D    => ⟨0, 2⟩
  | .DIII => ⟨0, 3⟩
  | .AII  => ⟨0, 4⟩
  | .CII  => ⟨0, 5⟩
  | .C    => ⟨0, 6⟩
  | .CI   => ⟨0, 7⟩

/-- For a real class, the Clifford degree is exactly its `ℤ₈` Bott-clock position. -/
theorem clIndex_degree_real (c : Class) (hc : c.isComplex = false) :
    ((clIndexOfClass c).degree : ZMod 8) = c.realIndex := by
  cases c <;> simp_all [clIndexOfClass, ClIndex.degree, Class.isComplex, Class.realIndex]

/-- For a complex class, the Clifford degree is exactly its `ℤ₂` Bott-clock position. -/
theorem clIndex_degree_complex (c : Class) (hc : c.isComplex = true) :
    ((clIndexOfClass c).degree : ZMod 2) = c.complexIndex := by
  cases c <;> simp_all [clIndexOfClass, ClIndex.degree, Class.isComplex, Class.complexIndex]

/-- The two K-theory spectra appearing in the tenfold way: complex `KU` and real `KO`. -/
inductive Spectrum
  | KU
  | KO
deriving DecidableEq, Repr

/-- Which spectrum governs a class: the complex classes are `KU`, the real ones `KO`. -/
def spectrumOfClass : Class → Spectrum
  | .A | .AIII => Spectrum.KU
  | _ => Spectrum.KO

/-- The Bott-periodic K-groups of a spectrum in degree `n`, written with explicit Bott
clocks: `KU` has period `2` and `KO` has period `8`. -/
def KGroupOf (E : Spectrum) (n : ℤ) : KGroup :=
  match E with
  | Spectrum.KU =>
      if n % 2 = 0 then KGroup.Z else KGroup.null
  | Spectrum.KO =>
      let m := n % 8
      if m = 0 then KGroup.Z
      else if m = 1 then KGroup.Z2
      else if m = 2 then KGroup.Z2
      else if m = 4 then KGroup.twoZ
      else KGroup.null

/-- The explicit `KU` clock agrees with the period-`2` `complexPattern`. -/
theorem KGroupOf_KU (n : ℤ) : KGroupOf Spectrum.KU n = complexPattern (n : ZMod 2) := by
  have h_mod2 : (n % 2 = 0) ↔ (n : ZMod 2) = 0 := by
    rw [ZMod.intCast_zmod_eq_zero_iff_dvd]
    omega
  unfold KGroupOf complexPattern
  simp only [h_mod2]

/-- The explicit `KO` clock agrees with the period-`8` `realPattern`. -/
theorem KGroupOf_KO (n : ℤ) : KGroupOf Spectrum.KO n = realPattern (n : ZMod 8) := by
  unfold KGroupOf realPattern
  have hcast : (↑n : ZMod 8) = ((n % 8 : ℤ) : ZMod 8) := by
    rw [ZMod.intCast_eq_intCast_iff]; simp [Int.ModEq]
  rw [hcast]
  have h0 := Int.emod_nonneg n (by decide : (8 : ℤ) ≠ 0)
  have h8 := Int.emod_lt_of_pos n (by decide : (0 : ℤ) < 8)
  interval_cases (n % 8) <;> rfl

/-- The K-theory degree of a class in spatial dimension `d`: the Clifford degree of the
class shifted down by `d` (the standard dimensional shift in the tenfold way). -/
def degreeOf (c : Class) (d : ℕ) : ℤ := (clIndexOfClass c).degree - (d : ℤ)

/-- The periodic table re-expressed through Clifford degrees and K-theory spectra. -/
def classifyViaClifford (c : Class) (d : ℕ) : KGroup :=
  KGroupOf (spectrumOfClass c) (degreeOf c d)

/-- **The Clifford / K-theory front-end is faithful.**  The original periodic table
`classify` coincides, class-by-class and dimension-by-dimension, with the K-groups
`KGroupOf` evaluated at the Clifford degrees. -/
theorem classify_eq_classifyViaClifford (c : Class) (d : ℕ) :
    classify c d = classifyViaClifford c d := by
  cases c <;>
    simp +decide [classify, classifyViaClifford, degreeOf, KGroupOf_KU, KGroupOf_KO,
      spectrumOfClass] <;>
    congr! 1

/-! ## 2. Moonshine / CRT encoding layer -/

/-- A slot of the periodic table: an AZ class together with a spatial dimension. -/
structure Slot where
  /-- The Altland–Zirnbauer symmetry class. -/
  cls : Class
  /-- The spatial dimension. -/
  dim : ℕ
deriving DecidableEq, Repr

/-- The classifying group attached to a slot. -/
def Slot.kGroup (s : Slot) : KGroup := classify s.cls s.dim

/-- A slot is *non-trivial* when its classifying group is non-zero, i.e. it supports a
non-trivial topological phase. -/
def Slot.isNontrivial (s : Slot) : Prop := s.kGroup ≠ KGroup.null

instance (s : Slot) : Decidable s.isNontrivial := by unfold Slot.isNontrivial; infer_instance

/-- An arithmetic payload attached to a slot — a hook for Moonshine / CRT data. -/
structure SlotData where
  /-- The slot the payload belongs to. -/
  slot : Slot
  /-- The arithmetic invariant carried by the slot. -/
  invariant : ℤ
deriving Repr

/-- **Five non-trivial slots in every dimension**, restated at the level of slots:
in each spatial dimension exactly five of the ten classes give a non-trivial slot. -/
theorem five_nontrivial_slots (d : ℕ) :
    (Finset.univ.filter (fun c : Class => (Slot.mk c d).isNontrivial)).card = 5 := by
  convert AZ.five_nontrivial_per_dimension d using 1

/-- A two-modulus Chinese-Remainder packing scheme: two pairwise-coprime moduli into which
a pair of slot invariants can be packed and from which they can be uniquely recovered. -/
structure CRTPair where
  /-- First modulus. -/
  m : ℕ
  /-- Second modulus, coprime to the first. -/
  n : ℕ
  /-- The two moduli are coprime, so the Chinese Remainder Theorem applies. -/
  hco : Nat.Coprime m n

/-- Pack a pair of residues into a single residue modulo `m * n` via the CRT. -/
def CRTPair.pack (s : CRTPair) (a : ZMod s.m) (b : ZMod s.n) : ZMod (s.m * s.n) :=
  (ZMod.chineseRemainder s.hco).symm (a, b)

/-- Unpack a residue modulo `m * n` into its two CRT components. -/
def CRTPair.unpack (s : CRTPair) (x : ZMod (s.m * s.n)) : ZMod s.m × ZMod s.n :=
  ZMod.chineseRemainder s.hco x

/-- **CRT round-trip (unpack ∘ pack).** -/
theorem CRTPair.unpack_pack (s : CRTPair) (a : ZMod s.m) (b : ZMod s.n) :
    s.unpack (s.pack a b) = (a, b) :=
  (ZMod.chineseRemainder s.hco).apply_symm_apply (a, b)

/-- **CRT round-trip (pack ∘ unpack).** -/
theorem CRTPair.pack_unpack (s : CRTPair) (x : ZMod (s.m * s.n)) :
    s.pack (s.unpack x).1 (s.unpack x).2 = x :=
  (ZMod.chineseRemainder s.hco).symm_apply_apply x

/-- Pack two integer slot invariants (reduced modulo the two moduli) into a single
CRT-encoded residue. -/
def CRTPair.packInvariants (s : CRTPair) (x y : ℤ) : ZMod (s.m * s.n) :=
  s.pack (x : ZMod s.m) (y : ZMod s.n)

/-- **Reconstruction of the first invariant** from its CRT packing. -/
theorem CRTPair.reconstruct_fst (s : CRTPair) (x y : ℤ) :
    (s.unpack (s.packInvariants x y)).1 = (x : ZMod s.m) :=
  congr_arg Prod.fst (CRTPair.unpack_pack s _ _)

/-- **Reconstruction of the second invariant** from its CRT packing. -/
theorem CRTPair.reconstruct_snd (s : CRTPair) (x y : ℤ) :
    (s.unpack (s.packInvariants x y)).2 = (y : ZMod s.n) :=
  congr_arg Prod.snd (CRTPair.unpack_pack s _ _)

/-! ## 3. Simulation API

A small boundary that an external UI can call: feed in a `Phase` (symmetry data plus a
spatial dimension); read back its class, classifying group, slot, and Clifford data. -/

/-- A phase of the simulation: non-spatial symmetry data together with a spatial
dimension. -/
structure Phase where
  /-- The non-spatial symmetry data `(T², C², S)`. -/
  sym : SymData
  /-- The spatial dimension. -/
  dim : ℕ
deriving Repr

/-- The AZ class of a phase, if its symmetry data is admissible. -/
def Phase.cls (p : Phase) : Option Class := SymData.classOf p.sym

/-- The classifying group of a phase, if its symmetry data is admissible. -/
def Phase.kGroup (p : Phase) : Option KGroup :=
  (p.cls).map (fun c => classify c p.dim)

/-- The slot of a phase, if its symmetry data is admissible. -/
def Phase.slot (p : Phase) : Option Slot :=
  (p.cls).map (fun c => ⟨c, p.dim⟩)

/-- The class, Clifford index and governing spectrum of a phase, if admissible. -/
def Phase.clifford (p : Phase) : Option (Class × ClIndex × Spectrum) :=
  match p.cls with
  | some c => some (c, clIndexOfClass c, spectrumOfClass c)
  | none => none

/-- The phase's classifying group can equally be computed through the Clifford /
K-theory front-end. -/
theorem Phase.kGroup_eq_clifford (p : Phase) :
    p.kGroup = (p.cls).map (fun c => classifyViaClifford c p.dim) := by
  unfold Phase.kGroup
  cases p.cls <;> simp [classify_eq_classifyViaClifford]

/-- A valid phase always receives a class, a classifying group, a slot and Clifford
data. -/
theorem Phase.isSome_of_valid (p : Phase) (h : SymData.Valid p.sym) :
    p.cls.isSome ∧ p.kGroup.isSome ∧ p.slot.isSome ∧ p.clifford.isSome := by
  have hc : p.cls.isSome := (SymData.isSome_classOf_iff_valid p.sym).2 h
  refine ⟨hc, ?_, ?_, ?_⟩ <;>
    simp only [Phase.kGroup, Phase.slot, Phase.clifford] <;>
    cases hcl : p.cls <;> simp_all

end AZ
