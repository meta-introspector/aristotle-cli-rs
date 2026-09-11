/-
# CliffordCl10SPerm — Signed Permutation Infrastructure for Cl(0,10)

Constructs the 10 generators of Cl(0,10) as signed permutations of size 64,
using the Kronecker doubling pattern from the CL9 generators.

## Construction

From the CL9 generators Γ₀,...,Γ₈ (each SPerm 32):
- Γᵢ⁽¹⁰⁾ = diag(Γᵢ⁽⁹⁾, -Γᵢ⁽⁹⁾)  for i = 0,...,8
- Γ₉⁽¹⁰⁾ = [[0, I₃₂], [-I₃₂, 0]]

This gives 10 matrices in SPerm 64 that satisfy:
- Γᵢ² = -I₆₄ for all i
- ΓᵢΓⱼ + ΓⱼΓᵢ = 0 for i ≠ j

The target isomorphism is Cl(0,10) ≅ M₁₆(ℍ) (as ℝ-algebras),
embedded into M₆₄(ℝ) via the standard ℍ → M₄(ℝ) chain.
-/

import Mathlib
import RequestProject.Math.Clifford.SPermGeneric
import RequestProject.Math.Clifford.CliffordCl09SPerm

/-! ## §1. CL10 Generators as SPerm 64

Using the Kronecker doubling:
- Γᵢ' = diag(Γᵢ, -Γᵢ) for i = 0,...,8
- Γ₉' = [[0, I₃₂], [-I₃₂, 0]]
-/

/-- Block-diagonal embedding: diag(M, -M) for SPerm 32 → SPerm 64.
    Upper block: same permutation and sign.
    Lower block: same permutation (shifted by 32), negated sign. -/
def embedBlockDiag32 (sp : SPerm 32) : SPerm 64 where
  perm := fun i =>
    if h : i.val < 32 then
      ⟨(sp.perm ⟨i.val, h⟩).val, by have := (sp.perm ⟨i.val, h⟩).isLt; omega⟩
    else
      ⟨(sp.perm ⟨i.val - 32, by omega⟩).val + 32, by
        have := (sp.perm ⟨i.val - 32, by omega⟩).isLt; omega⟩
  sign := fun i =>
    if h : i.val < 32 then
      sp.sign ⟨i.val, h⟩
    else
      !(sp.sign ⟨i.val - 32, by omega⟩)

/-- The off-diagonal identity block [[0, I₃₂], [-I₃₂, 0]] as SPerm 64. -/
def offDiagId64 : SPerm 64 where
  perm := fun i =>
    if h : i.val < 32 then
      ⟨i.val + 32, by omega⟩
    else
      ⟨i.val - 32, by omega⟩
  sign := fun i =>
    if i.val < 32 then true   -- upper-right: +I
    else false                -- lower-left: -I

/-- The 10 generators of Cl(0,10) as SPerm 64. -/
def gamSP64 : Fin 10 → SPerm 64
  | ⟨k, _hk⟩ =>
    if h : k < 9 then
      embedBlockDiag32 (gamSP32 ⟨k, h⟩)
    else
      offDiagId64

/-! ## §2. Generator Relations (decidable checks) -/

/-- Each CL10 generator squares to -I₆₄. -/
theorem gamSP64_sq_neg_id :
    ∀ i : Fin 10, (gamSP64 i * gamSP64 i).perm = id ∧
    (∀ j : Fin 64, (gamSP64 i * gamSP64 i).sign j = false) := by native_decide

/-- CL10 generators pairwise anticommute. -/
theorem gamSP64_anticommute :
    ∀ i j : Fin 10, i ≠ j →
    (∀ k : Fin 64, (gamSP64 i * gamSP64 j).perm k = (gamSP64 j * gamSP64 i).perm k ∧
     (gamSP64 i * gamSP64 j).sign k ≠ (gamSP64 j * gamSP64 i).sign k) := by native_decide

/-- Each CL10 generator is a genuine permutation. -/
theorem gamSP64_is_perm :
    ∀ i : Fin 10, Function.Bijective (gamSP64 i).perm := by native_decide

/-! ## §3. Monomial Products for CL10

1024 monomials indexed by 10-bit natural numbers. -/

/-- Monomial product for CL10: ordered product of generators for set bits. -/
def monomialN10 (n : Nat) : SPerm 64 :=
  let m0 := if n.testBit 0 then gamSP64 0 else 1
  let m1 := if n.testBit 1 then gamSP64 1 else 1
  let m2 := if n.testBit 2 then gamSP64 2 else 1
  let m3 := if n.testBit 3 then gamSP64 3 else 1
  let m4 := if n.testBit 4 then gamSP64 4 else 1
  let m5 := if n.testBit 5 then gamSP64 5 else 1
  let m6 := if n.testBit 6 then gamSP64 6 else 1
  let m7 := if n.testBit 7 then gamSP64 7 else 1
  let m8 := if n.testBit 8 then gamSP64 8 else 1
  let m9 := if n.testBit 9 then gamSP64 9 else 1
  m0 * m1 * m2 * m3 * m4 * m5 * m6 * m7 * m8 * m9

/-- Trace inner product for SPerm 64. -/
def traceProd64 (a b : SPerm 64) : ℤ :=
  let f (i : Fin 64) : ℤ :=
    if a.perm i = b.perm i then
      (if a.sign i == b.sign i then 1 else -1)
    else 0
  f 0 + f 1 + f 2 + f 3 + f 4 + f 5 + f 6 + f 7 +
  f 8 + f 9 + f 10 + f 11 + f 12 + f 13 + f 14 + f 15 +
  f 16 + f 17 + f 18 + f 19 + f 20 + f 21 + f 22 + f 23 +
  f 24 + f 25 + f 26 + f 27 + f 28 + f 29 + f 30 + f 31 +
  f 32 + f 33 + f 34 + f 35 + f 36 + f 37 + f 38 + f 39 +
  f 40 + f 41 + f 42 + f 43 + f 44 + f 45 + f 46 + f 47 +
  f 48 + f 49 + f 50 + f 51 + f 52 + f 53 + f 54 + f 55 +
  f 56 + f 57 + f 58 + f 59 + f 60 + f 61 + f 62 + f 63

/-! ## §4. Gram Block Checker for CL10

Checks trace(Mᵢᵀ·Mⱼ) = 64·δᵢⱼ for blocks of the 1024×1024 Gram matrix. -/

def gramBlock10 (rowStart rowCount : Nat) : Bool :=
  (List.range rowCount).all fun di =>
    let i := rowStart + di
    let mi := monomialN10 i
    (List.range 1024).all fun j =>
      let mj := monomialN10 j
      let tr := traceProd64 mi mj
      if i == j then tr == 64 else tr == 0
