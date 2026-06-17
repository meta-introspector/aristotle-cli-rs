import Split.Eq_mpr
import Split.False
import Split.congrArg
import Split.List_map
import Split.False_elim
import Split.Membership_mem
import Split.Exists
import Split.Eq_mp
import Split.id
import Split.Ne
import Split.List_rec
import Split.Or_casesOn
import Split.List_cons
import Split.List_Nodup
import Split.List
import Split.And
import Split.List_instMembership
import Split.And_right
import Split.And_left
import Split.implies_congr
import Split.True
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Eq_refl
import Split.instIsEmptyFalse
import Split.congrFun'
import Split.Or
import Split.implies_true
import Split.Eq_symm
import Split.Eq
import Split.Not
import Split.Eq_trans
import Split.List_nil
import Split.forall_congr

-- List.inj_on_of_nodup_map from environment
-- theorem List.inj_on_of_nodup_map : forall {α : Type.{u}} {β : Type.{v}} {f : α -> β} {l : List.{u} α}, (List.Nodup.{v} β (List.map.{u, v} α β f l)) -> (forall {{x : α}}, (Membership.mem.{u, u} α (List.{u} α) (List.instMembership.{u} α) l x) -> (forall {{y : α}}, (Membership.mem.{u, u} α (List.{u} α) (List.instMembership.{u} α) l y) -> (Eq.{succ v} β (f x) (f y)) -> (Eq.{succ u} α x y)))

-- Stub: this file represents the declaration `List.inj_on_of_nodup_map`.
-- In a full split, the body would be extracted from the environment.
