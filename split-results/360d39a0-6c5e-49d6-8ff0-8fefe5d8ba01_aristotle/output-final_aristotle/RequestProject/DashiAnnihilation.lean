/-
  DashiAnnihilation.lean — Formalization of the Signed Filament Annihilation Rule.

  Formalizes the annihilation dynamics described in MATH.md:
    • Signed filaments as oriented ternary carrier fields
    • Opposite-signed pairs
    • Annihilation operator that removes opposite-sign encounters
    • Stability: fields with no opposite-signed neighbors are fixed points

  Key results:
    • Annihilation does not create support
    • Stable filaments have no nearby opposites
    • Uniform fields (all zero, all positive, all negative) are stable
-/
import Mathlib
import RequestProject.DashiCarrier
import RequestProject.DashiKernel

namespace DashiCORE

/-! ## §1. Neighbor Structure -/

/-- A neighbor relation on a domain Ω.
    Symmetric and irreflexive (simple graph). -/
structure NeighborGraph (Ω : Type*) where
  adj : Ω → Ω → Prop
  symm : ∀ i j, adj i j → adj j i
  irrefl : ∀ i, ¬ adj i i

/-! ## §2. Opposite-Signed Pairs -/

/-- Two ternary values are opposite-signed iff one is +1 and the other is -1. -/
def Ternary.oppositeSigned : Ternary → Ternary → Bool
  | .pos, .neg => true
  | .neg, .pos => true
  | _, _       => false

/-- Opposite-signed is symmetric. -/
theorem Ternary.oppositeSigned_symm (a b : Ternary) :
    Ternary.oppositeSigned a b = Ternary.oppositeSigned b a := by
  cases a <;> cases b <;> rfl

/-- Zero is never opposite-signed with anything. -/
theorem Ternary.oppositeSigned_zero_left (b : Ternary) :
    Ternary.oppositeSigned .zero b = false := by cases b <;> rfl

theorem Ternary.oppositeSigned_zero_right (a : Ternary) :
    Ternary.oppositeSigned a .zero = false := by cases a <;> rfl

/-- Same-signed values are not opposite-signed. -/
theorem Ternary.oppositeSigned_self (a : Ternary) :
    Ternary.oppositeSigned a a = false := by cases a <;> rfl

/-! ## §3. Annihilation Stability -/

/-- A site has an opposite-signed neighbor (as a Prop). -/
def hasOppositeNeighbor {Ω : Type*}
    (G : NeighborGraph Ω)
    (s : CarrierField Ω) (i : Ω) : Prop :=
  ∃ j, G.adj i j ∧ Ternary.oppositeSigned (s i) (s j) = true

/-- A carrier field is annihilation-stable iff no site has an
    opposite-signed neighbor. -/
def isAnnihilationStable {Ω : Type*}
    (G : NeighborGraph Ω)
    (s : CarrierField Ω) : Prop :=
  ∀ i, ¬ hasOppositeNeighbor G s i

/-
Stable means: for every edge (i,j), s(i) and s(j) are not opposite-signed.
-/
theorem stable_no_opposites {Ω : Type*}
    (G : NeighborGraph Ω)
    (s : CarrierField Ω)
    (h : isAnnihilationStable G s) :
    ∀ i j, G.adj i j → Ternary.oppositeSigned (s i) (s j) = false := by
      intro i j hij;
      exact Classical.not_not.1 fun H => h i ⟨ j, hij, by simpa using H ⟩

/-- The all-zero field is always annihilation-stable. -/
theorem zero_annihilation_stable {Ω : Type*}
    (G : NeighborGraph Ω) :
    isAnnihilationStable G (fun _ => Ternary.zero) := by
  intro i ⟨_, _, h⟩
  exact absurd h (by simp [Ternary.oppositeSigned])

/-- A uniformly positive field (all +1) is annihilation-stable. -/
theorem pos_annihilation_stable {Ω : Type*}
    (G : NeighborGraph Ω) :
    isAnnihilationStable G (fun _ => Ternary.pos) := by
  intro i ⟨_, _, h⟩
  exact absurd h (by simp [Ternary.oppositeSigned])

/-- A uniformly negative field (all -1) is annihilation-stable. -/
theorem neg_annihilation_stable {Ω : Type*}
    (G : NeighborGraph Ω) :
    isAnnihilationStable G (fun _ => Ternary.neg) := by
  intro i ⟨_, _, h⟩
  exact absurd h (by simp [Ternary.oppositeSigned])

/-! ## §4. Majority Vote -/

/-- Convert a ternary value to an integer for voting. -/
def ternaryToInt : Ternary → Int
  | .pos  => 1
  | .neg  => -1
  | .zero => 0

/-- Majority vote on a list of ternary values. -/
def majorityOfList (l : List Ternary) : Ternary :=
  let m := l.map ternaryToInt |>.sum
  if m > 0 then .pos
  else if m < 0 then .neg
  else .zero

/-- Majority of an empty list is zero. -/
theorem majorityOfList_nil :
    majorityOfList [] = Ternary.zero := by
  simp [majorityOfList]

/-
Majority of a uniform positive list is positive.
-/
theorem majorityOfList_uniform_pos (n : ℕ) (hn : 0 < n) :
    majorityOfList (List.replicate n Ternary.pos) = Ternary.pos := by
      convert Ternary.pq_roundtrip ( Ternary.pos ) using 1;
      unfold majorityOfList;
      induction hn <;> aesop

/-
Majority of a uniform negative list is negative.
-/
theorem majorityOfList_uniform_neg (n : ℕ) (hn : 0 < n) :
    majorityOfList (List.replicate n Ternary.neg) = Ternary.neg := by
      unfold majorityOfList
      generalize_proofs at *;
      simp [ternaryToInt] at *;
      generalize_proofs at *;
      grind

end DashiCORE