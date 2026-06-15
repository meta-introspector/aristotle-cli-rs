import Split.Subtype_casesOn
import Split.ForInStep_done
import Split.Subtype
import Split.ForInStep
import Split.Subtype_mk
import Split.ForInStep_casesOn
import Split.ForInStep_yield

-- Std.Rxc.Iterator.instIteratorLoop.loop.match_3 from environment
-- def Std.Rxc.Iterator.instIteratorLoop.loop.match_3 : forall {α : Type.{u_1}} (γ : Type.{u_1}) (Pl : α -> γ -> (ForInStep.{u_1} γ) -> Prop) (next : α) (acc : γ) (motive : (Subtype.{succ u_1} (ForInStep.{u_1} γ) (Pl next acc)) -> Sort.{u_2}) (__do_lift._@.Init.Data.Range.Polymorphic.RangeIterator.59787603._hygCtx.151.0.Init.Data.Range.Polymorphic.RangeIterator.59787603._hygCtx._hyg.204 : Subtype.{succ u_1} (ForInStep.{u_1} γ) (Pl next acc)), (forall (acc' : γ) (h' : Pl next acc (ForInStep.yield.{u_1} γ acc')), motive (Subtype.mk.{succ u_1} (ForInStep.{u_1} γ) (Pl next acc) (ForInStep.yield.{u_1} γ acc') h')) -> (forall (acc' : γ) (property._@.Init.Data.Range.Polymorphic.RangeIterator.59787603._hygCtx._hyg.260 : Pl next acc (ForInStep.done.{u_1} γ acc')), motive (Subtype.mk.{succ u_1} (ForInStep.{u_1} γ) (Pl next acc) (ForInStep.done.{u_1} γ acc') property._@.Init.Data.Range.Polymorphic.RangeIterator.59787603._hygCtx._hyg.260)) -> (motive __do_lift._@.Init.Data.Range.Polymorphic.RangeIterator.59787603._hygCtx.151.0.Init.Data.Range.Polymorphic.RangeIterator.59787603._hygCtx._hyg.204)
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.Rxc.Iterator.instIteratorLoop.loop.match_3`.
-- In a full split, the body would be extracted from the environment.
