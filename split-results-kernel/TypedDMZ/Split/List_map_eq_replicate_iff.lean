import Split.List_replicate
import Split.congrArg
import Split.List_map
import Split.Membership_mem
import Split.Exists
import Split.iff_self
import Split.List
import Split.And
import Split.Iff
import Split.List_instMembership
import Split.implies_congr
import Split.Nat
import Split.congr
import Split.True
import Split.eq_self
import Split.List_length_map
import Split.of_eq_true
import Split.Eq_refl
import Split.congrFun'
import Split.Eq
import Split.List_length
import Split.true_and
import Split.Eq_trans
import Split.forall_congr

-- List.map_eq_replicate_iff from environment
-- theorem List.map_eq_replicate_iff : forall {α : Type.{u_1}} {β : Type.{u_2}} {l : List.{u_1} α} {f : α -> β} {b : β}, Iff (Eq.{succ u_2} (List.{u_2} β) (List.map.{u_1, u_2} α β f l) (List.replicate.{u_2} β (List.length.{u_1} α l) b)) (forall (x : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l x) -> (Eq.{succ u_2} β (f x) b))

-- Stub: this file represents the declaration `List.map_eq_replicate_iff`.
-- In a full split, the body would be extracted from the environment.
