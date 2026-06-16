import Split.HMul_hMul
import Split.Distrib_toAdd
import Split.instHAdd
import Split.Distrib_toMul
import Split.HAdd_hAdd
import Split.Distrib
import Split.Eq
import Split.instHMul

-- Distrib.left_distrib from environment
-- theorem Distrib.left_distrib : forall {R : Type.{u_1}} [self : Distrib.{u_1} R] (a : R) (b : R) (c : R), Eq.{succ u_1} R (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R (Distrib.toMul.{u_1} R self)) a (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R (Distrib.toAdd.{u_1} R self)) b c)) (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R (Distrib.toAdd.{u_1} R self)) (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R (Distrib.toMul.{u_1} R self)) a b) (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R (Distrib.toMul.{u_1} R self)) a c))

-- Stub: this file represents the declaration `Distrib.left_distrib`.
-- In a full split, the body would be extracted from the environment.
