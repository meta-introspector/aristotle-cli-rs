import Split.instHSMul
import Split.SMul
import Split.Star
import Split.HSMul_hSMul
import Split.StarModule
import Split.Eq
import Split.Star_star

-- StarModule.mk from environment
-- constructor StarModule.mk : forall {R : Type.{u}} {A : Type.{v}} [inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.6 : Star.{u} R] [inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.9 : Star.{v} A] [inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.12 : SMul.{u, v} R A], (forall (r : R) (a : A), Eq.{succ v} A (Star.star.{v} A inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.9 (HSMul.hSMul.{u, v, v} R A A (instHSMul.{u, v} R A inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.12) r a)) (HSMul.hSMul.{u, v, v} R A A (instHSMul.{u, v} R A inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.12) (Star.star.{u} R inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.6 r) (Star.star.{v} A inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.9 a))) -> (StarModule.{u, v} R A inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.9 inst._@.Mathlib.Algebra.Star.Basic.4239721379._hygCtx._hyg.12)

-- Stub: this file represents the declaration `StarModule.mk`.
-- In a full split, the body would be extracted from the environment.
