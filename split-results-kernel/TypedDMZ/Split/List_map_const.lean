import Split.Iff_mpr
import Split.List_replicate
import Split.List_map
import Split.Membership_mem
import Split.List_map_eq_replicate_iff
import Split.List
import Split.List_instMembership
import Split.Function_const
import Split.Eq
import Split.List_length
import Split.rfl

-- List.map_const from environment
-- theorem List.map_const : forall {α : Type.{u_1}} {β : Type.{u_2}} {l : List.{u_1} α} {b : β}, Eq.{succ u_2} (List.{u_2} β) (List.map.{u_1, u_2} α β (Function.const.{succ u_2, succ u_1} β α b) l) (List.replicate.{u_2} β (List.length.{u_1} α l) b)

-- Stub: this file represents the declaration `List.map_const`.
-- In a full split, the body would be extracted from the environment.
