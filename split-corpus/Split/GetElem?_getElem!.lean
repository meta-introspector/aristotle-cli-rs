import Mathlib

set_option pp.all true
-- spec: GetElem?.getElem! : forall {coll : Type.{u}} {idx : Type.{v}} {elem : outParam.{succ (succ w)} Type.{w}} {valid : outParam.{max (succ u) (succ v)} (coll -> idx -> Prop)} [self : GetElem?.{u, v, w} coll idx elem valid] [inst._@.Init.GetElem.365082188._hygCtx._hyg.28 : Inhabited.{succ w} elem], coll -> idx -> elem
def GetElem?.getElem! : forall {coll : Type.{u}} {idx : Type.{v}} {elem : outParam.{succ (succ w)} Type.{w}} {valid : outParam.{max (succ u) (succ v)} (coll -> idx -> Prop)} [self : GetElem?.{u, v, w} coll idx elem valid] [inst._@.Init.GetElem.365082188._hygCtx._hyg.28 : Inhabited.{succ w} elem], coll -> idx -> elem :=
  fun (coll : Type.{u}) (idx : Type.{v}) {elem : outParam.{succ (succ w)} Type.{w}} {valid : outParam.{max (succ u) (succ v)} (coll -> idx -> Prop)} [self : GetElem?.{u, v, w} coll idx elem valid] => self.3
