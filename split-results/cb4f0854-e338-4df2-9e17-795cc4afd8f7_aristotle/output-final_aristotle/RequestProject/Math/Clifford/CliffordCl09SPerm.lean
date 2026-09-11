/-
# CliffordCl09SPerm — Signed Permutation Infrastructure for Cl(0,9)

Constructs the 9 generators of Cl(0,9) as signed permutations of size 32,
using the Kronecker doubling pattern from the CL8 generators.

## Construction

From the CL8 generators Γ₀,...,Γ₇ (each SPerm 16):
- Γᵢ⁽⁹⁾ = diag(Γᵢ⁽⁸⁾, -Γᵢ⁽⁸⁾)  for i = 0,...,7
- Γ₈⁽⁹⁾ = [[0, I₁₆], [-I₁₆, 0]]

This gives 9 matrices in SPerm 32 that satisfy:
- Γᵢ² = -I₃₂ for all i
- ΓᵢΓⱼ + ΓⱼΓᵢ = 0 for i ≠ j

The target isomorphism is Cl(0,9) ≅ M₁₆(ℂ) (as ℝ-algebras),
but the 32×32 real representation provides a faithful embedding
Cl(0,9) ↪ M₃₂(ℝ) that we use for computational verification.

## Gram Orthogonality

The 512 monomials {Γ_S : S ⊆ {0,...,8}} form a basis verified by:
  trace(Γ_Sᵀ · Γ_T) = 32 · δ_{S,T}

This is split across separate Gram files for build parallelism.
-/

import Mathlib
import RequestProject.Math.Clifford.SPermGeneric

/-! ## §1. CL8 Generators in Generic SPerm 16 Form -/

/-- The 8 CL8 generators as SPerm 16 (same data as gamSP16, in generic form). -/
def cl8GenericGens : Fin 8 → SPerm 16
  | 0 => { perm := ![1,0,3,2,5,4,7,6, 9,8,11,10,13,12,15,14],
            sign := ![false,true,false,true,true,false,true,false,
                       true,false,true,false,false,true,false,true] }
  | 1 => { perm := ![2,3,0,1,6,7,4,5, 10,11,8,9,14,15,12,13],
            sign := ![false,true,true,false,true,false,false,true,
                       true,false,false,true,false,true,true,false] }
  | 2 => { perm := ![3,2,1,0,7,6,5,4, 11,10,9,8,15,14,13,12],
            sign := ![false,false,true,true,true,true,false,false,
                       true,true,false,false,false,false,true,true] }
  | 3 => { perm := ![4,5,6,7,0,1,2,3, 12,13,14,15,8,9,10,11],
            sign := ![true,true,true,true,false,false,false,false,
                       false,false,false,false,true,true,true,true] }
  | 4 => { perm := ![5,4,7,6,1,0,3,2, 13,12,15,14,9,8,11,10],
            sign := ![true,false,false,true,true,false,false,true,
                       false,true,true,false,false,true,true,false] }
  | 5 => { perm := ![6,7,4,5,2,3,0,1, 14,15,12,13,10,11,8,9],
            sign := ![true,true,false,false,true,true,false,false,
                       false,false,true,true,false,false,true,true] }
  | 6 => { perm := ![7,6,5,4,3,2,1,0, 15,14,13,12,11,10,9,8],
            sign := ![false,true,false,true,false,true,false,true,
                       true,false,true,false,true,false,true,false] }
  | 7 => { perm := ![8,9,10,11,12,13,14,15, 0,1,2,3,4,5,6,7],
            sign := ![true,true,true,true,true,true,true,true,
                       false,false,false,false,false,false,false,false] }

/-! ## §2. CL9 Generators as SPerm 32

Using the Kronecker doubling:
- Γᵢ' = diag(Γᵢ, -Γᵢ) for i = 0,...,7
- Γ₈' = [[0, I₁₆], [-I₁₆, 0]]
-/

/-- Block-diagonal embedding: diag(M, -M) for SPerm 16 → SPerm 32.
    Upper block: same permutation and sign.
    Lower block: same permutation (shifted by 16), negated sign. -/
def embedBlockDiag (sp : SPerm 16) : SPerm 32 where
  perm := fun i =>
    if h : i.val < 16 then
      ⟨(sp.perm ⟨i.val, h⟩).val, by have := (sp.perm ⟨i.val, h⟩).isLt; omega⟩
    else
      ⟨(sp.perm ⟨i.val - 16, by omega⟩).val + 16, by
        have := (sp.perm ⟨i.val - 16, by omega⟩).isLt; omega⟩
  sign := fun i =>
    if h : i.val < 16 then
      sp.sign ⟨i.val, h⟩
    else
      !(sp.sign ⟨i.val - 16, by omega⟩)

/-- The off-diagonal identity block [[0, I₁₆], [-I₁₆, 0]] as SPerm 32. -/
def offDiagId32 : SPerm 32 where
  perm := fun i =>
    if h : i.val < 16 then
      ⟨i.val + 16, by omega⟩
    else
      ⟨i.val - 16, by omega⟩
  sign := fun i =>
    if i.val < 16 then true   -- upper-right: +I
    else false                -- lower-left: -I

/-- The 9 generators of Cl(0,9) as SPerm 32. -/
def gamSP32 : Fin 9 → SPerm 32
  | ⟨k, _hk⟩ =>
    if h : k < 8 then
      embedBlockDiag (cl8GenericGens ⟨k, h⟩)
    else
      offDiagId32

/-! ## §3. Generator Relations (decidable checks) -/

/-- Each CL9 generator squares to -I₃₂. -/
theorem gamSP32_sq_neg_id :
    ∀ i : Fin 9, (gamSP32 i * gamSP32 i).perm = id ∧
    (∀ j : Fin 32, (gamSP32 i * gamSP32 i).sign j = false) := by native_decide

/-- CL9 generators pairwise anticommute. -/
theorem gamSP32_anticommute :
    ∀ i j : Fin 9, i ≠ j →
    (∀ k : Fin 32, (gamSP32 i * gamSP32 j).perm k = (gamSP32 j * gamSP32 i).perm k ∧
     (gamSP32 i * gamSP32 j).sign k ≠ (gamSP32 j * gamSP32 i).sign k) := by native_decide

/-- Each CL9 generator is a genuine permutation. -/
theorem gamSP32_is_perm :
    ∀ i : Fin 9, Function.Bijective (gamSP32 i).perm := by native_decide

/-! ## §4. Monomial Products for CL9

512 monomials indexed by 9-bit natural numbers. -/

/-- Monomial product for CL9: ordered product of generators for set bits. -/
def monomialN9 (n : Nat) : SPerm 32 :=
  let m0 := if n.testBit 0 then gamSP32 0 else 1
  let m1 := if n.testBit 1 then gamSP32 1 else 1
  let m2 := if n.testBit 2 then gamSP32 2 else 1
  let m3 := if n.testBit 3 then gamSP32 3 else 1
  let m4 := if n.testBit 4 then gamSP32 4 else 1
  let m5 := if n.testBit 5 then gamSP32 5 else 1
  let m6 := if n.testBit 6 then gamSP32 6 else 1
  let m7 := if n.testBit 7 then gamSP32 7 else 1
  let m8 := if n.testBit 8 then gamSP32 8 else 1
  m0 * m1 * m2 * m3 * m4 * m5 * m6 * m7 * m8

/-- Trace inner product for SPerm 32. -/
def traceProd32 (a b : SPerm 32) : ℤ :=
  let f (i : Fin 32) : ℤ :=
    if a.perm i = b.perm i then
      (if a.sign i == b.sign i then 1 else -1)
    else 0
  f 0 + f 1 + f 2 + f 3 + f 4 + f 5 + f 6 + f 7 +
  f 8 + f 9 + f 10 + f 11 + f 12 + f 13 + f 14 + f 15 +
  f 16 + f 17 + f 18 + f 19 + f 20 + f 21 + f 22 + f 23 +
  f 24 + f 25 + f 26 + f 27 + f 28 + f 29 + f 30 + f 31

/-! ## §5. Gram Block Checker for CL9

Checks trace(Mᵢᵀ·Mⱼ) = 32·δᵢⱼ for blocks of the 512×512 Gram matrix. -/

def gramBlock9 (rowStart rowCount : Nat) : Bool :=
  (List.range rowCount).all fun di =>
    let i := rowStart + di
    let mi := monomialN9 i
    (List.range 512).all fun j =>
      let mj := monomialN9 j
      let tr := traceProd32 mi mj
      if i == j then tr == 32 else tr == 0
