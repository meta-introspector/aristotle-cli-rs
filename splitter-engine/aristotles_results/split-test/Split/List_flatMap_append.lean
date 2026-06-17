import Split.List_append_assoc
import Split.congrArg
import Split.List_rec
import Split.List_cons
import Split.List_flatMap_cons
import Split.instHAppendOfAppend
import Split.List
import Split.congr
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Eq_refl
import Split.congrFun'
import Split.List_instAppend
import Split.Eq
import Split.HAppend_hAppend
import Split.List_flatMap
import Split.Eq_trans
import Split.List_nil

-- List.flatMap_append from environment
-- theorem List.flatMap_append : forall {α : Type.{u}} {β : Type.{v}} {xs : List.{u} α} {ys : List.{u} α} {f : α -> (List.{v} β)}, Eq.{succ v} (List.{v} β) (List.flatMap.{u, v} α β f (HAppend.hAppend.{u, u, u} (List.{u} α) (List.{u} α) (List.{u} α) (instHAppendOfAppend.{u} (List.{u} α) (List.instAppend.{u} α)) xs ys)) (HAppend.hAppend.{v, v, v} (List.{v} β) (List.{v} β) (List.{v} β) (instHAppendOfAppend.{v} (List.{v} β) (List.instAppend.{v} β)) (List.flatMap.{u, v} α β f xs) (List.flatMap.{u, v} α β f ys))

-- Stub: this file represents the declaration `List.flatMap_append`.
-- In a full split, the body would be extracted from the environment.
