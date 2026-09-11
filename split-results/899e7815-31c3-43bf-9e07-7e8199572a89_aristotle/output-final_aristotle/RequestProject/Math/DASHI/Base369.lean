/-
  Base369.lean

  Port of Base369.agda: Core truth-value universes and primitive operators
  (rotations and XOR-like composition) for triadic, hexadic, and nonary dialects.

  Key results:
    • rotateTri³ = id (3-periodicity)
    • triXor left identity
    • triXor associativity
    • rotateHex⁶ = id (6-periodicity)
    • rotateNonary⁹ = id (9-periodicity)
-/
import Mathlib

/-! ## §1. Utility: repeated rotation (spin) -/

def spin {α : Type*} : ℕ → (α → α) → α → α
  | 0, _, x => x
  | n + 1, rot, x => rot (spin n rot x)

/-! ## §2. Triadic truth values -/

inductive TriTruth : Type where
  | low  : TriTruth
  | mid  : TriTruth
  | high : TriTruth
  deriving DecidableEq, Repr

namespace TriTruth

def index : TriTruth → ℕ
  | low => 0
  | mid => 1
  | high => 2

def rotate : TriTruth → TriTruth
  | low  => mid
  | mid  => high
  | high => low

def xor (carrier target : TriTruth) : TriTruth :=
  spin (carrier.index) rotate target

theorem rotate_period_3 (t : TriTruth) : t.rotate.rotate.rotate = t := by
  cases t <;> rfl

theorem xor_left_identity (t : TriTruth) : xor low t = t := by rfl

theorem xor_assoc (a b c : TriTruth) :
    xor a (xor b c) = xor (xor a b) c := by
  cases a <;> cases b <;> cases c <;> simp [xor, index, spin, rotate]
  all_goals (first | rfl | (simp [rotate_period_3]))

theorem xor_comm (a b : TriTruth) : xor a b = xor b a := by
  cases a <;> cases b <;> rfl

end TriTruth

/-! ## §3. Hexadic truth values -/

inductive HexTruth : Type where
  | h0 | h1 | h2 | h3 | h4 | h5 : HexTruth
  deriving DecidableEq, Repr

namespace HexTruth

def index : HexTruth → ℕ
  | h0 => 0 | h1 => 1 | h2 => 2 | h3 => 3 | h4 => 4 | h5 => 5

def rotate : HexTruth → HexTruth
  | h0 => h1 | h1 => h2 | h2 => h3 | h3 => h4 | h4 => h5 | h5 => h0

def xor (carrier target : HexTruth) : HexTruth :=
  spin (carrier.index) rotate target

theorem rotate_period_6 (h : HexTruth) : spin 6 rotate h = h := by
  cases h <;> rfl

theorem xor_left_identity (h : HexTruth) : xor h0 h = h := by rfl

end HexTruth

/-! ## §4. Nonary truth values -/

inductive NonaryTruth : Type where
  | n0 | n1 | n2 | n3 | n4 | n5 | n6 | n7 | n8 : NonaryTruth
  deriving DecidableEq, Repr

namespace NonaryTruth

def index : NonaryTruth → ℕ
  | n0 => 0 | n1 => 1 | n2 => 2 | n3 => 3 | n4 => 4
  | n5 => 5 | n6 => 6 | n7 => 7 | n8 => 8

def rotate : NonaryTruth → NonaryTruth
  | n0 => n1 | n1 => n2 | n2 => n3 | n3 => n4 | n4 => n5
  | n5 => n6 | n6 => n7 | n7 => n8 | n8 => n0

def xor (carrier target : NonaryTruth) : NonaryTruth :=
  spin (carrier.index) rotate target

theorem rotate_period_9 (n : NonaryTruth) : spin 9 rotate n = n := by
  cases n <;> rfl

theorem xor_left_identity (n : NonaryTruth) : xor n0 n = n := by rfl

end NonaryTruth
