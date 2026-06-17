import Split.Finset_cons
import Split.Finset
import Split.Membership_mem
import Split.instOfNatNat
import Split.Finset_val
import Split.Multiset_card_cons
import Split.instHAdd
import Split.Finset_instSetLike
import Split.HAdd_hAdd
import Split.Nat
import Split.Finset_card
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Eq
import Split.Not
import Split.SetLike_instMembership

-- Finset.card_cons from environment
-- theorem Finset.card_cons : forall {α : Type.{u_1}} {s : Finset.{u_1} α} {a : α} (h : Not (Membership.mem.{u_1, u_1} α (Finset.{u_1} α) (SetLike.instMembership.{u_1, u_1} (Finset.{u_1} α) α (Finset.instSetLike.{u_1} α)) s a)), Eq.{1} Nat (Finset.card.{u_1} α (Finset.cons.{u_1} α a s h)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Finset.card.{u_1} α s) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))

-- Stub: this file represents the declaration `Finset.card_cons`.
-- In a full split, the body would be extracted from the environment.
