import Split.Iff_mpr
import Split.Option_some
import Split.Option_none
import Split.Iff
import Split.Iff_mp
import Split.Eq_symm
import Split.Eq
import Split.rfl
import Split.Option

-- Option.ext from environment
-- theorem Option.ext : forall {α : Type.{u_1}} {o₁ : Option.{u_1} α} {o₂ : Option.{u_1} α}, (forall (a : α), Iff (Eq.{succ u_1} (Option.{u_1} α) o₁ (Option.some.{u_1} α a)) (Eq.{succ u_1} (Option.{u_1} α) o₂ (Option.some.{u_1} α a))) -> (Eq.{succ u_1} (Option.{u_1} α) o₁ o₂)

-- Stub: this file represents the declaration `Option.ext`.
-- In a full split, the body would be extracted from the environment.
