import RequestProject.Gvcs.Sneakernet.Sealed
import RequestProject.Gvcs.VoxelGame.Play

/-!
# The sealed patch is a patch of the real site

The 2×2 patch of `Sealed.lean` is not a toy standing beside the game: pick four
voxels of the site and it *is* those four voxels.  A cell of the patch is solid
exactly when the voxel is not air, a patch move is a `SiteAction` (dig, or fill
with subsoil), and:

* `legal_iff_step_isSome` — the patch rule book accepts a move exactly when the
  site's own rule book allows the corresponding action;
* `patchOf_step` — applying the action to the site moves the patch the way
  `Patch.apply` says;
* `verdict_iff_step` — therefore the verdict a relay computes on ciphertexts,
  never seeing the move, decides exactly whether the site allows the dig.

So a player who mails in a sealed move can neither dig air nor fill solid
ground, and the referee learns nothing but one bit.
-/

namespace LifeTrac
namespace Sneakernet
namespace Field

open VoxelGame Voxel

/-- Four voxels of the site, all different: the patch the players share. -/
structure Plot where
  /-- The voxels, in the order the patch numbers them. -/
  vox : Fin 4 → Vox
  /-- No two cells of the patch are the same voxel. -/
  inj : Function.Injective vox

/-- How the site looks as a patch: a cell is solid when its voxel is not air. -/
def patchOf (P : Plot) (S : Site) : Patch.State :=
  fun i => decide (S.ground (P.vox i) ≠ Cell.air)

/-- A patch move as a move of the site: dig the voxel, or fill it with subsoil. -/
def siteAction (P : Plot) (a : Patch.Move) : SiteAction :=
  if a.2 then .dig (P.vox a.1) else .fill (P.vox a.1) Cell.soil

/-- **The two rule books agree**: the patch accepts a move exactly when the
site allows the corresponding dig or fill. -/
theorem legal_iff_step_isSome (P : Plot) (S : Site) (a : Patch.Move) :
    Patch.legal (patchOf P S) a = true ↔ (S.step (siteAction P a)).isSome := by
  obtain ⟨i, d⟩ := a
  cases d with
  | true =>
      simp only [siteAction, patchOf, Patch.legal, if_true]
      by_cases h : S.ground (P.vox i) = Cell.air <;>
        simp [Site.step, h]
  | false =>
      simp only [siteAction, patchOf, Patch.legal]
      by_cases h : S.ground (P.vox i) = Cell.air <;>
        simp [Site.step, h]

/-- **The two moves agree**: what the site does to the ground is what the patch
says it does. -/
theorem patchOf_step (P : Plot) (S T : Site) (a : Patch.Move)
    (h : S.step (siteAction P a) = some T) :
    patchOf P T = Patch.apply (patchOf P S) a := by
  obtain ⟨i, d⟩ := a
  funext j
  have hij : P.vox j = P.vox i ↔ j = i := ⟨fun hv => P.inj hv, fun hv => by rw [hv]⟩
  cases d with
  | true =>
      simp only [siteAction, if_true, Site.step] at h
      by_cases ha : S.ground (P.vox i) = Cell.air
      · simp [ha] at h
      · simp only [ha, if_false, Option.some.injEq] at h
        subst h
        by_cases hj : j = i
        · subst hj
          simp [patchOf, Patch.apply, World.set, Function.update_self]
        · have : P.vox j ≠ P.vox i := fun hv => hj (P.inj hv)
          simp [patchOf, Patch.apply, World.set, this, Function.update_of_ne hj]
  | false =>
      simp only [siteAction, Site.step] at h
      by_cases ha : S.ground (P.vox i) = Cell.air
      · simp only [ha, ne_eq, not_true_eq_false, or_false, reduceCtorEq,
          if_false, Option.some.injEq] at h
        subst h
        by_cases hj : j = i
        · subst hj
          simp [patchOf, Patch.apply, World.set, Function.update_self]
        · have : P.vox j ≠ P.vox i := fun hv => hj (P.inj hv)
          simp [patchOf, Patch.apply, World.set, this, Function.update_of_ne hj]
      · simp [ha] at h

/-- **The sealed verdict decides the site's rule book.**  The relay computes on
ciphertexts alone; the bit the referee decrypts says exactly whether the site
allows the move. -/
theorem verdict_iff_step {p B : ℤ} (P : Plot) (S : Site)
    (a : Patch.Move) {cs : Fin (Patch.game.ns + Patch.game.nm) → ℤ}
    (hcs : ∀ i, Enc p B (Patch.game.bits (patchOf P S) a i) (cs i))
    (hfit : BCirc.bound B Patch.game.circuit < p) :
    dec p (Patch.game.verdictCt cs) = true ↔ (S.step (siteAction P a)).isSome := by
  rw [Patch.game.verdict_correct hcs hfit]
  exact legal_iff_step_isSome P S a

end Field
end Sneakernet
end LifeTrac
