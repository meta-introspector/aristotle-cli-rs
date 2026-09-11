/-
# CliffordCl08SPerm — Signed Permutation Infrastructure for Cl(0,8)

Defines SPerm16 (signed permutation matrices on 16 elements),
the 8 Cl(0,8) generator matrices in SPerm16 form, and the Gram block
checker. The actual Gram orthogonality verification is split across
separate files (CliffordCl08GramN.lean) for build parallelism.
-/

import Mathlib

/-! ## §1. Signed Permutation Type -/

/-- A signed permutation of Fin 16: a function σ : Fin 16 → Fin 16
    together with a sign at each position.
    Represents the matrix M where M[i, σ(i)] = ±1, all other entries 0. -/
structure SPerm16 where
  perm : Fin 16 → Fin 16
  sign : Fin 16 → Bool
deriving DecidableEq, Inhabited

instance : Mul SPerm16 where
  mul a b := {
    perm := fun i => b.perm (a.perm i)
    sign := fun i => !(xor (a.sign i) (b.sign (a.perm i)))
  }

instance : One SPerm16 where
  one := { perm := id, sign := fun _ => true }

/-- Trace of the product A^T · B for signed permutation matrices.
    For signed perm matrices, trace(A^T · B) = Σ_i [σ_A(i) = σ_B(i)] · s_A(i) · s_B(i).
    This avoids materializing the transpose or product. -/
def traceProd (a b : SPerm16) : ℤ :=
  let f (i : Fin 16) : ℤ :=
    if a.perm i = b.perm i then
      (if a.sign i == b.sign i then 1 else -1)
    else 0
  f 0 + f 1 + f 2 + f 3 + f 4 + f 5 + f 6 + f 7 +
  f 8 + f 9 + f 10 + f 11 + f 12 + f 13 + f 14 + f 15

/-! ## §2. The 8 Generator Matrices

The 8 generators of Cl(0,8) → M₁₆(ℝ) as signed permutation matrices.

Construction from the Cl(0,6) generators γ₀,...,γ₅ and volume element ω:
- Γᵢ = [[γᵢ, 0], [0, -γᵢ]]   for i = 0,...,5  (block diagonal)
- Γ₆ = [[ω, 0], [0, -ω]]                        (block diagonal, ω = γ₀γ₁γ₂γ₃γ₄γ₅)
- Γ₇ = [[0, I₈], [-I₈, 0]]                      (block anti-diagonal)
-/

def gamSP16 : Fin 8 → SPerm16
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

/-! ## §3. Monomial Products

Each monomial is indexed by a natural number 0 ≤ n < 256 whose bit
decomposition gives the subset S ⊆ {0,...,7}. The monomial is the
ordered product of generators corresponding to set bits. -/

def monomialN (n : Nat) : SPerm16 :=
  let m0 := if n.testBit 0 then gamSP16 0 else 1
  let m1 := if n.testBit 1 then gamSP16 1 else 1
  let m2 := if n.testBit 2 then gamSP16 2 else 1
  let m3 := if n.testBit 3 then gamSP16 3 else 1
  let m4 := if n.testBit 4 then gamSP16 4 else 1
  let m5 := if n.testBit 5 then gamSP16 5 else 1
  let m6 := if n.testBit 6 then gamSP16 6 else 1
  let m7 := if n.testBit 7 then gamSP16 7 else 1
  m0 * m1 * m2 * m3 * m4 * m5 * m6 * m7

/-! ## §4. Gram Block Checker

Checks that the Gram matrix entries trace(M_i^T · M_j) = 16·δ_{i,j}
for a block of rows [rowStart, rowStart + rowCount) against all 256 columns. -/

def gramBlock (rowStart rowCount : Nat) : Bool :=
  (List.range rowCount).all fun di =>
    let i := rowStart + di
    let mi := monomialN i
    (List.range 256).all fun j =>
      let mj := monomialN j
      let tr := traceProd mi mj
      if i == j then tr == 16 else tr == 0

/-! ## §5. Generator Relation Checks -/

/-- Each generator squares to -I₁₆ (identity permutation, all signs negative). -/
theorem gamSP16_sq_neg_id :
    ∀ i : Fin 8, (gamSP16 i * gamSP16 i).perm = id ∧
    (∀ j : Fin 16, (gamSP16 i * gamSP16 i).sign j = false) := by native_decide

/-- Generators anticommute: Γᵢ Γⱼ = -Γⱼ Γᵢ for i ≠ j. -/
theorem gamSP16_anticommute :
    ∀ i j : Fin 8, i ≠ j →
    (∀ k : Fin 16, (gamSP16 i * gamSP16 j).perm k = (gamSP16 j * gamSP16 i).perm k ∧
     (gamSP16 i * gamSP16 j).sign k ≠ (gamSP16 j * gamSP16 i).sign k) := by native_decide

/-- Each generator is a genuine permutation (bijective). -/
theorem gamSP16_is_perm :
    ∀ i : Fin 8, Function.Bijective (gamSP16 i).perm := by native_decide
