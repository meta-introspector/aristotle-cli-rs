import Split.InvOneClass_toOne
import Split.InvOneClass
import Split.Inv_inv
import Split.One_toOfNat1
import Split.InvOneClass_toInv
import Split.OfNat_ofNat
import Split.Eq

-- InvOneClass.inv_one from environment
-- theorem InvOneClass.inv_one : forall {G : Type.{u_2}} [self : InvOneClass.{u_2} G], Eq.{succ u_2} G (Inv.inv.{u_2} G (InvOneClass.toInv.{u_2} G self) (OfNat.ofNat.{u_2} G 1 (One.toOfNat1.{u_2} G (InvOneClass.toOne.{u_2} G self)))) (OfNat.ofNat.{u_2} G 1 (One.toOfNat1.{u_2} G (InvOneClass.toOne.{u_2} G self)))

-- Stub: this file represents the declaration `InvOneClass.inv_one`.
-- In a full split, the body would be extracted from the environment.
