import RequestProject.Math.UnivalentCore

/-!
# Content-addressing: injective CIDs for blade data

A content-addressed store demands that the **CID** (content identifier) of a
block determines the block: the address map must be injective, so distinct
content can never collide on the same address. We model blade data as a
`List ℕ` and define a CID via Cantor pairing, then prove the address map is
injective — collision-freeness by construction.
-/

namespace RequestProject.Compute.IPLD

/-- The content identifier of a block of blade data, computed by folding the
Cantor pairing. The successor offset distinguishes the empty block from any
nonempty one. -/
def cid : List ℕ → ℕ
  | [] => 0
  | a :: l => Nat.pair a (cid l) + 1

/-- The empty block hashes to `0`. -/
@[simp] theorem cid_nil : cid [] = 0 := rfl

/-- A nonempty block never hashes to `0`: the address space separates the empty
block from all content. -/
theorem cid_cons_ne_zero (a : ℕ) (l : List ℕ) : cid (a :: l) ≠ 0 := by
  simp [cid]

/-- **Collision-freeness.** The CID map is injective: equal addresses force
equal content. -/
theorem cid_injective : Function.Injective cid := by
  intro x
  induction x with
  | nil =>
    intro y hy
    cases y with
    | nil => rfl
    | cons b l => simp [cid] at hy
  | cons a l ih =>
    intro y hy
    cases y with
    | nil => simp [cid] at hy
    | cons b m =>
      simp only [cid, Nat.add_left_inj] at hy
      have h1 := congrArg Nat.unpair hy
      rw [Nat.unpair_pair, Nat.unpair_pair, Prod.mk.injEq] at h1
      obtain ⟨hab, hlm⟩ := h1
      rw [hab, ih hlm]

/-- **Determinism.** Identical content always yields identical CIDs; this is the
defining property of content addressing (immediate from `cid` being a
function). -/
theorem cid_deterministic {x y : List ℕ} (h : x = y) : cid x = cid y := by rw [h]

end RequestProject.Compute.IPLD
