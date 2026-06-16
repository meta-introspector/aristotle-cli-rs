import Split.congrArg
import Split.Membership_mem
import Split.instOfNatNat
import Split.List_rec
import Split.List_cons
import Split.List_pmap
import Split.List
import Split.instHAdd
import Split.List_instMembership
import Split.HAdd_hAdd
import Split.Nat
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.instAddNat
import Split.Eq_refl
import Split.congrFun'
import Split.OfNat_ofNat
import Split.Eq
import Split.List_length
import Split.Eq_trans
import Split.List_nil

-- List.length_pmap from environment
-- theorem List.length_pmap : forall {α : Type.{u_1}} {β : Type.{u_2}} {p : α -> Prop} {f : forall (a : α), (p a) -> β} {l : List.{u_1} α} {H : forall (a : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l a) -> (p a)}, Eq.{1} Nat (List.length.{u_2} β (List.pmap.{u_1, u_2} α β p f l H)) (List.length.{u_1} α l)

-- Stub: this file represents the declaration `List.length_pmap`.
-- In a full split, the body would be extracted from the environment.
