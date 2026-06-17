import Split.Multiset_foldr
import Split.LeftCommutative
import Split.Quot_inductionOn
import Split.Multiset
import Split.Multiset_cons
import Split.List
import Split.List_isSetoid
import Split.Eq
import Split.rfl
import Split.Setoid_r
import Split.Quot_mk

-- Multiset.foldr_cons from environment
-- theorem Multiset.foldr_cons : forall {α : Type.{u_1}} {β : Type.{v}} (f : α -> β -> β) [inst._@.Mathlib.Data.Multiset.MapFold.4140815533._hygCtx._hyg.10 : LeftCommutative.{succ u_1, succ v} α β f] (b : β) (a : α) (s : Multiset.{u_1} α), Eq.{succ v} β (Multiset.foldr.{v, u_1} α β f inst._@.Mathlib.Data.Multiset.MapFold.4140815533._hygCtx._hyg.10 b (Multiset.cons.{u_1} α a s)) (f a (Multiset.foldr.{v, u_1} α β f inst._@.Mathlib.Data.Multiset.MapFold.4140815533._hygCtx._hyg.10 b s))

-- Stub: this file represents the declaration `Multiset.foldr_cons`.
-- In a full split, the body would be extracted from the environment.
