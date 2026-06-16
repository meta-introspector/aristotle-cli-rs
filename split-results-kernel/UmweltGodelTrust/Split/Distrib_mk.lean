import Split.HMul_hMul
import Split.Mul
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Distrib
import Split.Eq
import Split.Add
import Split.instHMul

-- Distrib.mk from environment
-- constructor Distrib.mk : forall {R : Type.{u_1}} [toMul : Mul.{u_1} R] [toAdd : Add.{u_1} R], (forall (a : R) (b : R) (c : R), Eq.{succ u_1} R (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R toMul) a (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R toAdd) b c)) (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R toAdd) (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R toMul) a b) (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R toMul) a c))) -> (forall (a : R) (b : R) (c : R), Eq.{succ u_1} R (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R toMul) (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R toAdd) a b) c) (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R toAdd) (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R toMul) a c) (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R toMul) b c))) -> (Distrib.{u_1} R)

-- Stub: this file represents the declaration `Distrib.mk`.
-- In a full split, the body would be extracted from the environment.
