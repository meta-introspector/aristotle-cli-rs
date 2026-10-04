import Mathlib

set_option pp.all true
-- spec: GetElem.getElem : forall {coll : Type.{u}} {idx : Type.{v}} {elem : outParam.{succ (succ w)} Type.{w}} {valid : outParam.{max (succ u) (succ v)} (coll -> idx -> Prop)} [self : GetElem.{u, v, w} coll idx elem valid] (xs : coll) (i : idx), (valid xs i) -> elem
def GetElem.getElem : forall {coll : Type.{u}} {idx : Type.{v}} {elem : outParam.{succ (succ w)} Type.{w}} {valid : outParam.{max (succ u) (succ v)} (coll -> idx -> Prop)} [self : GetElem.{u, v, w} coll idx elem valid] (xs : coll) (i : idx), (valid xs i) -> elem :=
  fun (coll : Type.{u}) (idx : Type.{v}) {elem : outParam.{succ (succ w)} Type.{w}} {valid : outParam.{max (succ u) (succ v)} (coll -> idx -> Prop)} [self : GetElem.{u, v, w} coll idx elem valid] => self.1
