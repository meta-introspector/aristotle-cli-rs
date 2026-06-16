import Split.instHSMul
import Split.SMul
import Split.HSMul_hSMul
import Split.Eq
import Split.SMulCommClass

-- SMulCommClass.smul_comm from environment
-- theorem SMulCommClass.smul_comm : forall {M : Type.{u_9}} {N : Type.{u_10}} {α : Type.{u_11}} {inst._@.Mathlib.Algebra.Group.Action.Defs.533111421._hygCtx._hyg.21 : SMul.{u_9, u_11} M α} {inst._@.Mathlib.Algebra.Group.Action.Defs.533111421._hygCtx._hyg.25 : SMul.{u_10, u_11} N α} [self : SMulCommClass.{u_9, u_10, u_11} M N α inst._@.Mathlib.Algebra.Group.Action.Defs.533111421._hygCtx._hyg.21 inst._@.Mathlib.Algebra.Group.Action.Defs.533111421._hygCtx._hyg.25] (m : M) (n : N) (a : α), Eq.{succ u_11} α (HSMul.hSMul.{u_9, u_11, u_11} M α α (instHSMul.{u_9, u_11} M α inst._@.Mathlib.Algebra.Group.Action.Defs.533111421._hygCtx._hyg.21) m (HSMul.hSMul.{u_10, u_11, u_11} N α α (instHSMul.{u_10, u_11} N α inst._@.Mathlib.Algebra.Group.Action.Defs.533111421._hygCtx._hyg.25) n a)) (HSMul.hSMul.{u_10, u_11, u_11} N α α (instHSMul.{u_10, u_11} N α inst._@.Mathlib.Algebra.Group.Action.Defs.533111421._hygCtx._hyg.25) n (HSMul.hSMul.{u_9, u_11, u_11} M α α (instHSMul.{u_9, u_11} M α inst._@.Mathlib.Algebra.Group.Action.Defs.533111421._hygCtx._hyg.21) m a))

-- Stub: this file represents the declaration `SMulCommClass.smul_comm`.
-- In a full split, the body would be extracted from the environment.
