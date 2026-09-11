/-
  Overflow.lean — Port of Overflow.agda: Voxel threshold guards.
-/
import Mathlib

namespace DASHI

inductive Voxel : Type where
  | grounded | plateau | ascended
  deriving DecidableEq, Repr

inductive VoxelGuard (threshold value : ℕ) : Type where
  | stay   : value < threshold → VoxelGuard threshold value
  | pivot  : threshold = value → VoxelGuard threshold value
  | ascend : threshold < value → VoxelGuard threshold value

namespace VoxelGuard

def toVoxel {t v : ℕ} : VoxelGuard t v → Voxel
  | stay _   => .grounded
  | pivot _  => .plateau
  | ascend _ => .ascended

def enforce (threshold value : ℕ) : VoxelGuard threshold value :=
  if h : threshold < value then ascend h
  else if h : threshold = value then pivot h
  else stay (by omega)

theorem only_if {t v : ℕ} (h : (enforce t v).toVoxel = .ascended) : t < v := by
  unfold enforce at h
  split at h
  · assumption
  · split at h
    · simp [toVoxel] at h
    · simp [toVoxel] at h

end VoxelGuard

end DASHI
