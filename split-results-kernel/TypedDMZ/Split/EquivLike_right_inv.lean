import Split.outParam
import Split.EquivLike
import Split.Function_RightInverse
import Split.EquivLike_inv
import Split.EquivLike_coe

-- EquivLike.right_inv from environment
-- theorem EquivLike.right_inv : forall {E : Sort.{u_1}} {α : outParam.{succ u_2} Sort.{u_2}} {β : outParam.{succ u_3} Sort.{u_3}} [self : EquivLike.{u_1, u_2, u_3} E α β] (e : E), Function.RightInverse.{u_2, u_3} α β (EquivLike.inv.{u_1, u_2, u_3} E α β self e) (EquivLike.coe.{u_1, u_2, u_3} E α β self e)

-- Stub: this file represents the declaration `EquivLike.right_inv`.
-- In a full split, the body would be extracted from the environment.
