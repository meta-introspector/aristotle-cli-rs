import Split.GetElem?
import Split.outParam

-- LawfulGetElem from environment
-- inductive LawfulGetElem : forall (cont : Type.{u}) (idx : Type.{v}) (elem : outParam.{succ (succ w)} Type.{w}) (dom : outParam.{max (succ u) (succ v)} (cont -> idx -> Prop)) [ge : GetElem?.{u, v, w} cont idx elem dom], Prop
-- ctors: [LawfulGetElem.mk]

-- Stub: this file represents the declaration `LawfulGetElem`.
-- In a full split, the body would be extracted from the environment.
