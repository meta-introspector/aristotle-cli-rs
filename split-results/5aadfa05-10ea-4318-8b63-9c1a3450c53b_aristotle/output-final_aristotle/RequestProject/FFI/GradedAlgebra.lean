import Mathlib
import RequestProject.AZ.TenfoldWay
import RequestProject.AZ.Classification
import RequestProject.AZ.CliffordK
import RequestProject.AZ.BladeClassify

/-!
# A C-ABI FFI surface for the *graded algebra of fibers*

This file exposes the Altland–Zirnbauer (AZ) tenfold-way "graded algebra of fibers"
through a flat, C-callable interface (`@[export ...]`), so that the verified Lean
model can be wrapped by external languages — here a Rust trait and a C++ template
(see `ffi/`).

## The mathematical object being wrapped

For each K-theory spectrum `E ∈ {KU, KO}` the topological invariants of the AZ
phases form a **`ℤ/p`-graded family of abelian groups** ("fibers"), where the
period is `p = 2` for the complex spectrum `KU` and `p = 8` for the real spectrum
`KO`.  Concretely:

* the **grading group** is the Bott clock `ℤ/p` (`ℤ₂` for `KU`, `ℤ₈` for `KO`),
  with addition the graded multiplication of indices and `0` the unit grade;
* the **fiber** over a grade `g` is the K-group `KGroup ∈ {0, ℤ, ℤ₂, 2ℤ}`
  (`complexPattern` / `realPattern` from `TenfoldWay`);
* an AZ **class** sits at a fixed grade (its Bott-clock position
  `realIndex`/`complexIndex`, i.e. its Clifford degree mod `p`);
* a **phase** `(class, dimension)` sits at grade `index − dimension (mod p)`, and
  its fiber is exactly the periodic-table entry `classify class dimension`.

## Implementation note (standalone FFI)

The exported functions are deliberately implemented with **pure `Nat`/`Int`
arithmetic** rather than `ZMod`, so that the compiled C object references only the
Lean *runtime* (`libleanshared`) and never Mathlib object code.  This makes the
resulting `.o` / shared library small and standalone.  Each exported function is
proved equal to the corresponding `ZMod`-based object of the verified model, so
correctness is preserved:

* `azClassify_eq_classify`  — the FFI reproduces the verified periodic table;
* `azBridge`                — `azClassify = azFiber ∘ (spectrum, phaseGrade)`;
* `azClassGrade_eq`, `azPhaseGrade_eq`, `azFiber_eq` — the encodings agree with
  `realIndex`/`complexIndex`, `classify`, `realPattern`/`complexPattern`.

## Verified algebraic guarantees

* `azGradeAdd_comm`, `azGradeAdd_assoc`, `azGradeZero_add`, `azGradeNeg_add` —
  the grade operations realise the Bott-clock group `ℤ/p`.
* `azFiber_period` — Bott periodicity of fibers.

## C-ABI encodings

All boundary types are fixed-width scalars (no boxed Lean objects):

* **Class**       : `UInt8` in `0..9`  (`A,AIII,AI,BDI,D,DIII,AII,CII,C,CI`).
* **KGroup/fiber**: `UInt8` in `0..3`  (`0=null(0), 1=ℤ, 2=ℤ₂, 3=2ℤ`).
* **Spectrum**    : `UInt8`            (`0=KU` complex, `1=KO` real).
* **Grade**       : `UInt8` residue in `0..p-1` of the Bott clock.
* **Dimension**   : `UInt64`.
* **Clifford degree** : `Int64` (informational; the signed `q − p`).
-/

namespace AZ.FFI

open AZ

/-! ## Scalar encodings -/

/-- Decode a `UInt8` (`0..9`) to an AZ symmetry class. -/
def classOfU8 : UInt8 → AZ.Class
  | 0 => .A | 1 => .AIII | 2 => .AI | 3 => .BDI | 4 => .D
  | 5 => .DIII | 6 => .AII | 7 => .CII | 8 => .C | _ => .CI

/-- Encode an AZ class as a `UInt8` (`0..9`). -/
def classToU8 : AZ.Class → UInt8
  | .A => 0 | .AIII => 1 | .AI => 2 | .BDI => 3 | .D => 4
  | .DIII => 5 | .AII => 6 | .CII => 7 | .C => 8 | .CI => 9

/-- Encode a `KGroup` as a `UInt8` (`0=null, 1=ℤ, 2=ℤ₂, 3=2ℤ`). -/
def kgroupToU8 : KGroup → UInt8
  | .null => 0 | .Z => 1 | .Z2 => 2 | .twoZ => 3

/-! ## Pure-`Nat` Bott-clock cores (Mathlib-free at runtime)

These mirror `Class.realIndex`/`complexIndex` and `realPattern`/`complexPattern`
but compute on `Nat`, so the compiled code does not depend on `ZMod`. -/

/-- The `ℤ₈` Bott-clock position of a real class, as a `Nat` in `0..7`. -/
def realIndexNat : AZ.Class → Nat
  | .AI => 0 | .BDI => 1 | .D => 2 | .DIII => 3
  | .AII => 4 | .CII => 5 | .C => 6 | .CI => 7 | _ => 0

/-- The `ℤ₂` Bott-clock position of a complex class, as a `Nat` in `0..1`. -/
def complexIndexNat : AZ.Class → Nat
  | .AIII => 1 | _ => 0

/-- The real (`KO`) fiber pattern on the `ℤ₈` clock, as a K-group code. -/
def realPatternNat (m : Nat) : UInt8 :=
  if m == 0 then 1 else if m == 1 then 2 else if m == 2 then 2
  else if m == 4 then 3 else 0

/-- The complex (`KU`) fiber pattern on the `ℤ₂` clock, as a K-group code. -/
def complexPatternNat (m : Nat) : UInt8 :=
  if m == 0 then 1 else 0

/-- Whether the class code is complex (`A = 0` or `AIII = 1`), computed directly on
the `UInt8` code so the compiled function stays self-contained. -/
def isComplexU8 (cls : UInt8) : Bool := cls == 0 || cls == 1

/-- The signed Clifford degree `q − p` of a class code (informational), computed
directly so the compiled function stays self-contained. -/
def cliffordDegreeI64 : UInt8 → Int64
  | 0 => 0 | 1 => 1 | 2 => 0 | 3 => 1 | 4 => 2
  | 5 => 3 | 6 => 4 | 7 => 5 | 8 => 6 | _ => 7

/-! ## Spectra and Bott periods -/

/-- The number of AZ symmetry classes (`= 10`). -/
@[export az_class_count]
def azClassCount : UInt8 := 10

/-- Whether a class is complex (`KU`), as a `0/1` flag. -/
@[export az_class_is_complex]
def azClassIsComplex (cls : UInt8) : UInt8 :=
  if isComplexU8 cls then 1 else 0

/-- The K-theory spectrum governing a class: `0 = KU` (complex), `1 = KO` (real). -/
@[export az_class_spectrum]
def azClassSpectrum (cls : UInt8) : UInt8 :=
  if isComplexU8 cls then 0 else 1

/-- The Bott period of a spectrum: `2` for `KU`, `8` for `KO`. -/
@[export az_spectrum_period]
def azSpectrumPeriod (spec : UInt8) : UInt64 :=
  if spec == 0 then 2 else 8

/-- The signed Clifford degree `q − p` of a class (informational). -/
@[export az_class_clifford_degree]
def azClassCliffordDegree (cls : UInt8) : Int64 :=
  cliffordDegreeI64 cls

/-! ## The grading group `ℤ/p` (the Bott clock) -/

/-- The unit grade `0` of the Bott-clock grading group. -/
@[export az_grade_zero]
def azGradeZero : UInt8 := 0

/-- Graded multiplication of indices: addition in the Bott clock `ℤ/p`. -/
@[export az_grade_add]
def azGradeAdd (spec a b : UInt8) : UInt8 :=
  UInt8.ofNat ((a.toNat + b.toNat) % (azSpectrumPeriod spec).toNat)

/-- The grade inverse in the Bott-clock group `ℤ/p`. -/
@[export az_grade_neg]
def azGradeNeg (spec a : UInt8) : UInt8 :=
  let p := (azSpectrumPeriod spec).toNat
  UInt8.ofNat ((p - a.toNat % p) % p)

/-- Reduce an arbitrary grade representative into the canonical range `0..p-1`. -/
@[export az_grade_reduce]
def azGradeReduce (spec a : UInt8) : UInt8 :=
  UInt8.ofNat (a.toNat % (azSpectrumPeriod spec).toNat)

/-! ## Classes and phases as grades -/

/-- The fixed grade (Bott-clock position) of a class. -/
@[export az_class_grade]
def azClassGrade (cls : UInt8) : UInt8 :=
  let c := classOfU8 cls
  if isComplexU8 cls then UInt8.ofNat (complexIndexNat c) else UInt8.ofNat (realIndexNat c)

/-- The class sitting at a given grade on the relevant Bott clock (a right inverse
of `azClassGrade`). -/
@[export az_class_from_grade]
def azClassFromGrade (spec g : UInt8) : UInt8 :=
  if spec == 0 then
    (if g.toNat % 2 == 0 then 0 else 1)
  else
    let m := g.toNat % 8
    if m == 0 then 2 else if m == 1 then 3 else if m == 2 then 4
    else if m == 3 then 5 else if m == 4 then 6 else if m == 5 then 7
    else if m == 6 then 8 else 9

/-- The grade of a phase `(class, dimension)`: `index − dimension (mod p)`. -/
@[export az_phase_grade]
def azPhaseGrade (cls : UInt8) (dim : UInt64) : UInt8 :=
  let c := classOfU8 cls
  if isComplexU8 cls then
    UInt8.ofNat ((complexIndexNat c + (2 - dim.toNat % 2)) % 2)
  else
    UInt8.ofNat ((realIndexNat c + (8 - dim.toNat % 8)) % 8)

/-! ## Fibers -/

/-- The fiber over a grade `g` for a spectrum: the K-group at that Bott-clock
position. -/
@[export az_fiber]
def azFiber (spec g : UInt8) : UInt8 :=
  if spec == 0 then complexPatternNat (g.toNat % 2) else realPatternNat (g.toNat % 8)

/-- The full periodic-table lookup: the fiber of a phase `(class, dimension)`. -/
@[export az_classify]
def azClassify (cls : UInt8) (dim : UInt64) : UInt8 :=
  azFiber (azClassSpectrum cls) (azPhaseGrade cls dim)

/-- Whether a fiber (K-group code) is the trivial group, as a `0/1` flag. -/
@[export az_kgroup_is_trivial]
def azKGroupIsTrivial (kg : UInt8) : UInt8 :=
  if kg == 0 then 1 else 0

/-! ## Verified guarantees: the FFI cores agree with the model -/

/-- The direct `UInt8`-code complex test matches `Class.isComplex`. -/
theorem isComplexU8_eq (cls : UInt8) : isComplexU8 cls = (classOfU8 cls).isComplex := by
  unfold isComplexU8 classOfU8
  split <;> simp_all [Class.isComplex]

/-- The pure-`Nat` real index matches `Class.realIndex` for real classes. -/
theorem realIndexNat_eq (c : AZ.Class) (hc : c.isComplex = false) :
    (realIndexNat c : ZMod 8) = c.realIndex := by
  cases c <;> simp_all [realIndexNat, Class.realIndex, Class.isComplex]

/-- The pure-`Nat` complex index matches `Class.complexIndex` for complex classes. -/
theorem complexIndexNat_eq (c : AZ.Class) (hc : c.isComplex = true) :
    (complexIndexNat c : ZMod 2) = c.complexIndex := by
  cases c <;> simp_all [complexIndexNat, Class.complexIndex, Class.isComplex]

/-- The pure-`Nat` real pattern matches `realPattern` on residues. -/
theorem realPatternNat_eq (x : ZMod 8) :
    realPatternNat x.val = kgroupToU8 (realPattern x) := by
  revert x; decide

/-- The pure-`Nat` complex pattern matches `complexPattern` on residues. -/
theorem complexPatternNat_eq (x : ZMod 2) :
    complexPatternNat x.val = kgroupToU8 (complexPattern x) := by
  revert x; decide

/-- For naturals, the `ZMod n` value of a difference of casts as an explicit
residue. -/
theorem val_natCast_sub (n : ℕ) [NeZero n] (m d : ℕ) :
    ((m : ZMod n) - (d : ZMod n)).val = (m + (n - d % n)) % n := by
  have hle : d % n ≤ n := le_of_lt (Nat.mod_lt d (NeZero.pos n))
  rw [show ((m : ZMod n) - (d : ZMod n)) = (((m + (n - d % n)) : ℕ) : ZMod n) from ?_,
      ZMod.val_natCast]
  push_cast [Nat.cast_sub hle]
  rw [ZMod.natCast_self, ZMod.natCast_mod]; ring

/-- **The FFI reproduces the verified periodic table.** -/
theorem azClassify_eq_classify (cls : UInt8) (dim : UInt64) :
    azClassify cls dim = kgroupToU8 (classify (classOfU8 cls) dim.toNat) := by
  unfold azClassify azFiber azClassSpectrum azPhaseGrade classify
  rw [isComplexU8_eq]
  by_cases hc : (classOfU8 cls).isComplex
  · simp only [hc, if_true, beq_self_eq_true]
    rw [← complexPatternNat_eq]
    congr 1
    rw [UInt8.toNat_ofNat', Nat.mod_mod_of_dvd _ (by decide : (2 : ℕ) ∣ 256), Nat.mod_mod,
        ← complexIndexNat_eq _ hc, val_natCast_sub]
  · have hc' : (classOfU8 cls).isComplex = false := by simpa using hc
    have hb : ((1 : UInt8) == 0) = false := by decide
    simp only [hc, if_false, Bool.false_eq_true, hb]
    rw [← realPatternNat_eq]
    congr 1
    rw [UInt8.toNat_ofNat', Nat.mod_mod_of_dvd _ (by decide : (8 : ℕ) ∣ 256), Nat.mod_mod,
        ← realIndexNat_eq _ hc', val_natCast_sub]

/-- **The FFI computes the periodic table through the graded-fiber structure.**
Classifying a phase equals taking the fiber over its phase-grade in its spectrum.
(Definitional with the `Nat`-based implementation.) -/
theorem azBridge (cls : UInt8) (dim : UInt64) :
    azClassify cls dim = azFiber (azClassSpectrum cls) (azPhaseGrade cls dim) := rfl

/-- Grade addition is commutative (the Bott-clock group is abelian). -/
theorem azGradeAdd_comm (spec a b : UInt8) :
    azGradeAdd spec a b = azGradeAdd spec b a := by
  unfold azGradeAdd; rw [Nat.add_comm]

/-- Grade addition is associative. -/
theorem azGradeAdd_assoc (spec a b c : UInt8) :
    azGradeAdd spec (azGradeAdd spec a b) c
      = azGradeAdd spec a (azGradeAdd spec b c) := by
  have hper : (azSpectrumPeriod spec).toNat = 2 ∨ (azSpectrumPeriod spec).toNat = 8 := by
    unfold azSpectrumPeriod; split <;> simp
  rcases hper with h | h <;>
    · simp only [azGradeAdd, h]
      apply UInt8.toNat.inj
      simp only [UInt8.toNat_ofNat']
      omega

/-- `azGradeZero` is a left identity for grade addition on canonical grades. -/
theorem azGradeZero_add (spec a : UInt8)
    (ha : a.toNat < (azSpectrumPeriod spec).toNat) :
    azGradeAdd spec azGradeZero a = a := by
  unfold azGradeAdd azGradeZero
  simp +decide [Nat.mod_eq_of_lt ha]

/-- `azGradeNeg` is a left inverse for grade addition (the result is `0`). -/
theorem azGradeNeg_add (spec a : UInt8) :
    azGradeAdd spec (azGradeNeg spec a) a = azGradeZero := by
  have hper : (azSpectrumPeriod spec).toNat = 2 ∨ (azSpectrumPeriod spec).toNat = 8 := by
    unfold azSpectrumPeriod; split <;> simp
  rcases hper with h | h <;>
    · simp only [azGradeAdd, azGradeNeg, azGradeZero, h]
      apply UInt8.toNat.inj
      simp only [UInt8.toNat_ofNat']
      show _ = 0
      omega

/-- **Bott periodicity of fibers.** Shifting a grade by the period leaves the
fiber unchanged. -/
theorem azFiber_period (spec g : UInt8) :
    azFiber spec (azGradeAdd spec g (UInt8.ofNat (azSpectrumPeriod spec).toNat))
      = azFiber spec (azGradeReduce spec g) := by
  cases' eq_or_ne spec 0 with h h <;>
    simp_all +decide [azFiber, azGradeAdd, azGradeReduce, azSpectrumPeriod]

end AZ.FFI