/-
  Diagonalization inductive type.
  Translation of the Coq Diagonalization type, which collects various
  type constructors into a single sum type.
-/
import RequestProject.Network
import RequestProject.Protocols
import RequestProject.BasicTypes

-- Note: TNetworkType2 lives in Type 1, and some constructors store Type,
-- so Diagonalization must also live in Type 1.
inductive Diagonalization : Type 1 where
  | network       (a : TNetworkType)
  | network2      (a : TNetworkType2)
  | network3      (a : TNetworkType3)
  | auth          (a : TAuthType)
  | connection    (a : TConnectionType)
  | connection2   (a : TConnectionType2)
  | empty_        (a : Empty)
  | unit_         (u : UU)
  | bool_         (b : UU)
  | coprod        (A : UU) (B : UU)
  | stateMachine1 (a : StateMachine)
  | protocols22   (a : Protocols2)
  | string_       (a : SimpleString)
