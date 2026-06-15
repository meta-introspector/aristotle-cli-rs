import Split.List_map
import Split.List_cons
import Split.instHAppendOfAppend
import Split.List
import Split.eq_self
import Split.of_eq_true
import Split.List_instAppend
import Split.Eq
import Split.HAppend_hAppend
import Split.List_flatMap
import Split.List_flatten

-- List.flatMap_cons from environment
-- theorem List.flatMap_cons : forall {α : Type.{u}} {β : Type.{v}} {x : α} {xs : List.{u} α} {f : α -> (List.{v} β)}, Eq.{succ v} (List.{v} β) (List.flatMap.{u, v} α β f (List.cons.{u} α x xs)) (HAppend.hAppend.{v, v, v} (List.{v} β) (List.{v} β) (List.{v} β) (instHAppendOfAppend.{v} (List.{v} β) (List.instAppend.{v} β)) (f x) (List.flatMap.{u, v} α β f xs))

-- Stub: this file represents the declaration `List.flatMap_cons`.
-- In a full split, the body would be extracted from the environment.
