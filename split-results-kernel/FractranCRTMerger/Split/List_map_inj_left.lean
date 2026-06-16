import Split.False
import Split.congrArg
import Split.List_map
import Split.Membership_mem
import Split.List_rec
import Split.false_implies
import Split.List_cons
import Split.List_cons_injEq
import Split.iff_self
import Split.List
import Split.And
import Split.Iff
import Split.List_instMembership
import Split.implies_congr
import Split.congr
import Split.True
import Split.eq_self
import Split.propext
import Split.of_eq_true
import Split.Eq_refl
import Split.Or
import Split.implies_true
import Split.Eq
import Split.Eq_trans
import Split.List_nil
import Split.forall_congr

-- List.map_inj_left from environment
-- theorem List.map_inj_left : forall {α : Type.{u_1}} {β : Type.{u_2}} {l : List.{u_1} α} {f : α -> β} {g : α -> β}, Iff (Eq.{succ u_2} (List.{u_2} β) (List.map.{u_1, u_2} α β f l) (List.map.{u_1, u_2} α β g l)) (forall (a : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l a) -> (Eq.{succ u_2} β (f a) (g a)))

-- Stub: this file represents the declaration `List.map_inj_left`.
-- In a full split, the body would be extracted from the environment.
