/-
  MonsterMask.lean — Port of MonsterMask.agda, MonsterProjection.agda.
-/
import Mathlib
import RequestProject.Math.DASHI.UltrametricSpace

namespace DASHI

def FactorCount : ℕ := 15
abbrev Mask := Fin FactorCount → Bool

def fullMask : Mask := fun _ => true
def emptyMask : Mask := fun _ => false
def maskAnd (m₁ m₂ : Mask) : Mask := fun i => m₁ i && m₂ i
def flipMask (m : Mask) : Mask := fun i => !m i

theorem flipMask_involutive (m : Mask) : flipMask (flipMask m) = m := by
  funext i; simp [flipMask, Bool.not_not]

theorem maskAnd_fullMask (m : Mask) : maskAnd m fullMask = m := by
  funext i; simp [maskAnd, fullMask, Bool.and_true]

theorem maskAnd_emptyMask (m : Mask) : maskAnd m emptyMask = emptyMask := by
  funext i; simp [maskAnd, emptyMask, Bool.and_false]

theorem maskAnd_comm (m₁ m₂ : Mask) : maskAnd m₁ m₂ = maskAnd m₂ m₁ := by
  funext i; simp [maskAnd, Bool.and_comm]

theorem maskAnd_idem (m : Mask) : maskAnd m m = m := by
  funext i; simp [maskAnd, Bool.and_self]

/-- Hamming distance on masks. -/
def maskHammingDist (m₁ m₂ : Mask) : ℕ :=
  Finset.card (Finset.univ.filter fun i => m₁ i ≠ m₂ i)

theorem maskHammingDist_self (m : Mask) : maskHammingDist m m = 0 := by
  simp [maskHammingDist]

theorem maskHammingDist_comm (m₁ m₂ : Mask) : maskHammingDist m₁ m₂ = maskHammingDist m₂ m₁ := by
  simp only [maskHammingDist]; congr 1; ext i; simp [ne_comm]

/-- Project to a fixed target mask. -/
def projectTo (target : Mask) : Mask → Mask := fun _ => target

theorem projectTo_idem (target m : Mask) :
    projectTo target (projectTo target m) = projectTo target m := rfl

theorem projectTo_fixed_unique (target x y : Mask)
    (hx : projectTo target x = x) (hy : projectTo target y = y) : x = y := by
  simp [projectTo] at hx hy; rw [← hx, ← hy]

/-- Walk state: mask + window position. -/
structure WalkState where
  mask : Mask
  window : ℕ
  deriving DecidableEq

structure WalkLens where
  admissible : WalkState → Mask → Bool

def walkChoose (L : WalkLens) (s : WalkState) : List Mask → Mask → Mask
  | [], fallback => fallback
  | m :: ms, fallback => if L.admissible s m then m else walkChoose L s ms fallback

def walkStep (L : WalkLens) (cands : List Mask) (s : WalkState) : WalkState :=
  { mask := walkChoose L s cands s.mask, window := s.window + 1 }

end DASHI
