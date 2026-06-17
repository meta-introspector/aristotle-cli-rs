import Split.Function_LeftInverse
import Split.outParam
import Split.EquivLike
import Split.Function_RightInverse
import Split.Eq

-- EquivLike.mk from environment
-- constructor EquivLike.mk : forall {E : Sort.{u_1}} {α : outParam.{succ u_2} Sort.{u_2}} {β : outParam.{succ u_3} Sort.{u_3}} (coe : E -> α -> β) (inv : E -> β -> α), (forall (e : E), Function.LeftInverse.{u_2, u_3} α β (inv e) (coe e)) -> (forall (e : E), Function.RightInverse.{u_2, u_3} α β (inv e) (coe e)) -> (forall (e : E) (g : E), (Eq.{imax u_2 u_3} (α -> β) (coe e) (coe g)) -> (Eq.{imax u_3 u_2} (β -> α) (inv e) (inv g)) -> (Eq.{u_1} E e g)) -> (EquivLike.{u_1, u_2, u_3} E α β)

-- Stub: this file represents the declaration `EquivLike.mk`.
-- In a full split, the body would be extracted from the environment.
