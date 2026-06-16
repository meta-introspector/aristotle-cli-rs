import Split.SetLike
import Split.Set_ext
import Split.Membership_mem
import Split.SetLike_coe_injective
import Split.Iff
import Split.SetLike_coe
import Split.Eq
import Split.SetLike_instMembership

-- SetLike.ext from environment
-- theorem SetLike.ext : forall {A : Type.{u_1}} {B : Type.{u_2}} [i : SetLike.{u_1, u_2} A B] {p : A} {q : A}, (forall (x : B), Iff (Membership.mem.{u_2, u_1} B A (SetLike.instMembership.{u_1, u_2} A B i) p x) (Membership.mem.{u_2, u_1} B A (SetLike.instMembership.{u_1, u_2} A B i) q x)) -> (Eq.{succ u_1} A p q)

-- Stub: this file represents the declaration `SetLike.ext`.
-- In a full split, the body would be extracted from the environment.
