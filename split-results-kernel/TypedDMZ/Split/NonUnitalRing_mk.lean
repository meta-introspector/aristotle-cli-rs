import Split.NonUnitalNonAssocRing
import Split.HMul_hMul
import Split.NonUnitalNonAssocRing_toMul
import Split.NonUnitalRing
import Split.Eq
import Split.instHMul

-- NonUnitalRing.mk from environment
-- constructor NonUnitalRing.mk : forall {α : Type.{u_1}} [toNonUnitalNonAssocRing : NonUnitalNonAssocRing.{u_1} α], (forall (a : α) (b : α) (c : α), Eq.{succ u_1} α (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α (NonUnitalNonAssocRing.toMul.{u_1} α toNonUnitalNonAssocRing)) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α (NonUnitalNonAssocRing.toMul.{u_1} α toNonUnitalNonAssocRing)) a b) c) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α (NonUnitalNonAssocRing.toMul.{u_1} α toNonUnitalNonAssocRing)) a (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α (NonUnitalNonAssocRing.toMul.{u_1} α toNonUnitalNonAssocRing)) b c))) -> (NonUnitalRing.{u_1} α)

-- Stub: this file represents the declaration `NonUnitalRing.mk`.
-- In a full split, the body would be extracted from the environment.
