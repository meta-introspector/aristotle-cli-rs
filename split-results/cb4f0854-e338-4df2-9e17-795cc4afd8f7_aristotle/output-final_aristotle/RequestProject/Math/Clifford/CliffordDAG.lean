/-
# CliffordDAG — Content-Addressed Clifford Algebra via DAG/IPLD Mapping

Maps Clifford algebra monomials to content-addressed identifiers (CIDs),
creating a content-addressed algebraic structure suitable for IPLD integration.

## Overview

Each monomial in Cl(0,n) is uniquely identified by a BitVec n (the subset
of generators). This gives a natural mapping:
  CID(γ_S) := bitvector S

Multiplication becomes DAG rewriting:
  γ_S · γ_T = (-1)^{cross(S,T)} · γ_{S △ T}

where S △ T is the symmetric difference and sign(S,T) is computed from
the commutation structure.
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordBase
import RequestProject.Math.Clifford.CliffordBitBasis

set_option maxHeartbeats 800000

/-! ## §1. Content Identifier for Monomials -/

/-- A content identifier for a Clifford monomial in Cl(0,n). -/
structure CliffordCID (n : ℕ) where
  index : BitVec n
deriving DecidableEq, Repr

instance {n : ℕ} : Inhabited (CliffordCID n) := ⟨⟨0⟩⟩

instance {n : ℕ} : Fintype (CliffordCID n) :=
  Fintype.ofEquiv (BitVec n)
    ⟨CliffordCID.mk, CliffordCID.index, fun _ => rfl, fun ⟨_⟩ => rfl⟩

/-! ## §2. DAG Node Structure -/

/-- A node in the Clifford DAG. -/
inductive CliffordNode (n : ℕ) where
  | unit : CliffordNode n
  | generator : Fin n → CliffordNode n
  | monomial : CliffordCID n → Bool → CliffordNode n
deriving Repr

instance {n : ℕ} : Inhabited (CliffordNode n) := ⟨.unit⟩

/-! ## §3. Multiplication as DAG Rewriting -/

/-- Count crossing pairs: #{(i,j) : i ∈ S, j ∈ T, i > j}. -/
def crossCount {n : ℕ} (s t : BitVec n) : ℕ :=
  (Finset.univ.filter fun (p : Fin n × Fin n) =>
    s.getLsbD p.1.val ∧ t.getLsbD p.2.val ∧ p.1.val > p.2.val).card

/-- Count overlaps: #{i : i ∈ S ∩ T}. -/
def overlapCount {n : ℕ} (s t : BitVec n) : ℕ :=
  (Finset.univ.filter fun (i : Fin n) =>
    s.getLsbD i.val ∧ t.getLsbD i.val).card

/-- Total sign exponent: crossCount + overlapCount. -/
def mulSignExp {n : ℕ} (s t : BitVec n) : ℕ :=
  crossCount s t + overlapCount s t

/-- Product CID: S △ T = S ⊕ T (XOR). -/
def mulCID {n : ℕ} (s t : CliffordCID n) : CliffordCID n :=
  ⟨s.index ^^^ t.index⟩

/-- Sign of product: true = positive. -/
def dagMulSign {n : ℕ} (s t : CliffordCID n) : Bool :=
  (mulSignExp s.index t.index) % 2 == 0

/-! ## §4. DAG Rewrite Rules -/

/-- Multiplication rewrite: γ_S · γ_T ↦ ±γ_{S△T}. -/
def dagMul {n : ℕ} (s t : CliffordCID n) : CliffordCID n × Bool :=
  (mulCID s t, dagMulSign s t)

/-- Multiplication is well-defined on CIDs. -/
theorem dagMul_well_defined {n : ℕ} (s t : CliffordCID n) :
    (dagMul s t).1.index = s.index ^^^ t.index :=
  rfl

/-- Unit is neutral (CID component). -/
theorem dagMul_unit_left {n : ℕ} (s : CliffordCID n) :
    (dagMul ⟨0⟩ s).1 = s := by
  simp [dagMul, mulCID]

theorem dagMul_unit_right {n : ℕ} (s : CliffordCID n) :
    (dagMul s ⟨0⟩).1 = s := by
  simp [dagMul, mulCID]

/-- Self-product maps to unit CID. -/
theorem dagMul_self_cid {n : ℕ} (s : CliffordCID n) :
    (dagMul s s).1 = ⟨0⟩ := by
  simp [dagMul, mulCID]

/-! ## §5. Associativity of CID Multiplication -/

theorem dagMul_assoc_cid {n : ℕ} (a b c : CliffordCID n) :
    (dagMul (dagMul a b).1 c).1 = (dagMul a (dagMul b c).1).1 := by
  simp [dagMul, mulCID, BitVec.xor_assoc]

/-! ## §6. Serialized Clifford Elements -/

/-- A serialized Clifford element: sparse linear combination of CIDs. -/
structure CliffordSerialized (n : ℕ) where
  terms : List (CliffordCID n × ℤ)

/-- Zero element. -/
def CliffordSerialized.zero (n : ℕ) : CliffordSerialized n := ⟨[]⟩

/-- Single monomial. -/
def CliffordSerialized.monomial {n : ℕ} (cid : CliffordCID n) (coeff : ℤ) :
    CliffordSerialized n := ⟨[(cid, coeff)]⟩

/-- Serialize a generator. -/
def CliffordSerialized.generator {n : ℕ} (k : Fin n) : CliffordSerialized n :=
  .monomial ⟨BitVec.ofNat n (1 <<< k.val)⟩ 1

/-! ## §7. Merkle-Style DAG Edges -/

/-- A DAG edge represents multiplication. -/
structure CliffordDAGEdge (n : ℕ) where
  left : CliffordCID n
  right : CliffordCID n
  result : CliffordCID n
  edgeSign : Bool

/-- Construct edge from multiplication. -/
def CliffordDAGEdge.fromMul {n : ℕ} (s t : CliffordCID n) : CliffordDAGEdge n :=
  let (result, sign) := dagMul s t
  ⟨s, t, result, sign⟩

/-- Edges are consistent with dagMul. -/
theorem CliffordDAGEdge.consistent {n : ℕ} (s t : CliffordCID n) :
    (CliffordDAGEdge.fromMul s t).result = (dagMul s t).1 :=
  rfl

/-! ## §8. Bit-Depth Grading -/

/-- Grade of a CID: number of set bits. -/
def CliffordCID.grade {n : ℕ} (cid : CliffordCID n) : ℕ :=
  Finset.card (Finset.univ.filter (fun (i : Fin n) => cid.index.getLsbD i.val = true))

/-- Grade is bounded by n. -/
theorem CliffordCID.grade_le {n : ℕ} (cid : CliffordCID n) :
    cid.grade ≤ n := by
  exact card_finset_fin_le _

/-! ## §9. Group Structure -/

/-- CID multiplication is associative. -/
theorem cid_xor_group {n : ℕ} (a b c : CliffordCID n) :
    mulCID (mulCID a b) c = mulCID a (mulCID b c) := by
  simp [mulCID, BitVec.xor_assoc]

/-- CID multiplication is commutative. -/
theorem cid_mul_comm {n : ℕ} (a b : CliffordCID n) :
    mulCID a b = mulCID b a := by
  simp [mulCID, BitVec.xor_comm]

/-- Self-inverse. -/
theorem cid_self_inverse {n : ℕ} (a : CliffordCID n) :
    mulCID a a = ⟨0⟩ := by
  simp [mulCID]
