/-
# SPermGeneric — Dimension-Parametric Signed Permutation Infrastructure

Extracts the reusable engine from CL8: signed permutation representations
parameterized by matrix dimension N, with generic trace computation,
monomial construction, and Gram verification.

## Overview

The CL8 proof used SPerm16 as a one-off. This file generalizes:
- `SPerm N`: signed permutation of Fin N (was SPerm16)
- `SPermRep n N`: a Clifford representation with n generators of size N
- `sPermTraceProd`: trace(Aᵀ·B) for signed permutations
- `sPermMonomial`: monomial products indexed by BitVec
- `sPermGramBlock`: batched Gram verification
-/

import Mathlib

/-! ## §1. Generic Signed Permutation Type -/

/-- A signed permutation of Fin N: a permutation σ with a sign (±1) at each position.
    Represents the matrix M where M[i, σ(i)] = ±1, all other entries 0. -/
structure SPerm (N : ℕ) where
  perm : Fin N → Fin N
  sign : Fin N → Bool
deriving DecidableEq

instance {N : ℕ} : Inhabited (SPerm N) where
  default := { perm := id, sign := fun _ => true }

/-- Multiplication: compose permutations, XOR signs with transport. -/
instance {N : ℕ} : Mul (SPerm N) where
  mul a b := {
    perm := fun i => b.perm (a.perm i)
    sign := fun i => !(xor (a.sign i) (b.sign (a.perm i)))
  }

/-- Identity signed permutation: id with all positive signs. -/
instance {N : ℕ} : One (SPerm N) where
  one := { perm := id, sign := fun _ => true }

/-- Negation: flip all signs. -/
def SPerm.neg {N : ℕ} (a : SPerm N) : SPerm N where
  perm := a.perm
  sign := fun i => !a.sign i

instance {N : ℕ} : Neg (SPerm N) where
  neg := SPerm.neg

/-! ## §2. Conversion to Integer Matrix -/

/-- Convert a signed permutation to an integer matrix. -/
def SPerm.toMatrix {N : ℕ} (sp : SPerm N) : Matrix (Fin N) (Fin N) ℤ :=
  Matrix.of fun i j => if sp.perm i = j then (if sp.sign i then 1 else -1) else 0

/-! ## §3. Generic Trace Computation -/

/-- Trace of A^T · B for signed permutations, computed without materializing matrices.
    trace(Aᵀ·B) = Σᵢ [σ_A(i) = σ_B(i)] · sign_A(i) · sign_B(i) -/
def sPermTraceProd {N : ℕ} (a b : SPerm N) : ℤ :=
  Finset.univ.sum fun (i : Fin N) =>
    if a.perm i = b.perm i then
      (if a.sign i == b.sign i then 1 else -1)
    else 0

/-! ## §4. Representation Structure -/

/-- A Clifford representation via signed permutations: n generators of size N×N. -/
structure SPermRep (n N : ℕ) where
  /-- The n generator matrices as signed permutations -/
  generators : Fin n → SPerm N
  /-- Each generator is a genuine permutation -/
  gen_bijective : ∀ i, Function.Bijective (generators i).perm

/-! ## §5. Monomial Products -/

/-- Monomial indexed by natural number: bit k set means multiply by generator k.
    For an n-generator system with matrix size N. -/
def sPermMonomial {n N : ℕ} (rep : SPermRep n N) (idx : ℕ) : SPerm N :=
  (List.range n).foldl
    (fun acc k =>
      if hk : k < n then
        if idx.testBit k then acc * rep.generators ⟨k, hk⟩ else acc
      else acc)
    1

/-! ## §6. Gram Block Checker -/

/-- Check Gram orthogonality for a block of rows against all columns.
    Verifies trace(Mᵢᵀ·Mⱼ) = N·δᵢⱼ for the specified row range. -/
def sPermGramBlock {n N : ℕ} (rep : SPermRep n N) (rowStart rowCount : ℕ) : Bool :=
  (List.range rowCount).all fun di =>
    let i := rowStart + di
    let mi := sPermMonomial rep i
    (List.range (2^n)).all fun j =>
      let mj := sPermMonomial rep j
      let tr := sPermTraceProd mi mj
      if i == j then tr == (N : ℤ) else tr == 0

/-! ## §7. Generator Relation Checkers -/

/-- Check that generator k squares to -I (negative identity permutation). -/
def sPermCheckSqNegId {n N : ℕ} (rep : SPermRep n N) (k : Fin n) : Prop :=
  let sq := rep.generators k * rep.generators k
  sq.perm = id ∧ ∀ i : Fin N, sq.sign i = false

/-- Check all generators square to -I. -/
def sPermCheckAllSqNegId {n N : ℕ} (rep : SPermRep n N) : Prop :=
  ∀ k : Fin n, sPermCheckSqNegId rep k

/-- Check that generators i and j anticommute: Γᵢ Γⱼ + Γⱼ Γᵢ = 0. -/
def sPermCheckAnticommute {n N : ℕ} (rep : SPermRep n N)
    (i j : Fin n) : Prop :=
  let ab := rep.generators i * rep.generators j
  let ba := rep.generators j * rep.generators i
  ∀ k : Fin N, ab.perm k = ba.perm k ∧ ab.sign k ≠ ba.sign k

/-- Check all distinct pairs anticommute. -/
def sPermCheckAllAnticommute {n N : ℕ} (rep : SPermRep n N) : Prop :=
  ∀ i j : Fin n, i ≠ j → sPermCheckAnticommute rep i j

/-! ## §8. Block Kronecker Construction

Given an n-generator system of size N, construct an (n+1)-generator system
of size 2N using the standard Kronecker doubling:
  Γᵢ' = diag(Γᵢ, -Γᵢ)  for i < n
  Γₙ' = [[0, I_N], [-I_N, 0]]
-/

/-- Embed a signed permutation of size N into a block-diagonal of size 2N.
    diag(M, -M) as a signed permutation. -/
def SPerm.blockDiag {N : ℕ} (sp : SPerm N) : SPerm (2 * N) where
  perm := fun i =>
    if h : i.val < N then
      ⟨(sp.perm ⟨i.val, h⟩).val, by have := (sp.perm ⟨i.val, h⟩).isLt; omega⟩
    else
      ⟨(sp.perm ⟨i.val - N, by omega⟩).val + N, by
        have := (sp.perm ⟨i.val - N, by omega⟩).isLt; omega⟩
  sign := fun i =>
    if h : i.val < N then
      sp.sign ⟨i.val, h⟩
    else
      !(sp.sign ⟨i.val - N, by omega⟩)

/-- The off-diagonal block [[0, I_N], [-I_N, 0]] as a signed permutation of size 2N. -/
def SPerm.offDiagId (N : ℕ) : SPerm (2 * N) where
  perm := fun i =>
    if h : i.val < N then
      ⟨i.val + N, by omega⟩
    else
      ⟨i.val - N, by omega⟩
  sign := fun i =>
    if i.val < N then
      true   -- upper-right block is +I
    else
      false  -- lower-left block is -I

/-- Kronecker-double an SPermRep: adds one generator via the block construction.
    Γᵢ' = diag(Γᵢ, -Γᵢ) for i < n, Γₙ' = offDiagId. -/
def SPermRep.kroneckerDouble {n N : ℕ} (rep : SPermRep n N)
    (h_gen_perm : ∀ i, Function.Bijective (SPerm.blockDiag (rep.generators i)).perm)
    (h_new_perm : Function.Bijective (SPerm.offDiagId N).perm) :
    SPermRep (n + 1) (2 * N) where
  generators := fun i =>
    if h : i.val < n then
      SPerm.blockDiag (rep.generators ⟨i.val, h⟩)
    else
      SPerm.offDiagId N
  gen_bijective := fun i => by
    show Function.Bijective (if h : i.val < n then
      SPerm.blockDiag (rep.generators ⟨i.val, h⟩)
    else
      SPerm.offDiagId N).perm
    split_ifs with h
    · exact h_gen_perm _
    · exact h_new_perm
