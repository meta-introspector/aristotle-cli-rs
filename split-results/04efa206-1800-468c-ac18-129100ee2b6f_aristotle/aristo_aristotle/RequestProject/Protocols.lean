/-
  Protocol and state machine types.
  Translation of the Coq Protocol_type class and StateMachine types.
-/
-- Protocol typeclass
class ProtocolType (t_state_machine : Type) where
  state_machine : Unit → t_state_machine
-- Generic Protocols wrapper
inductive Protocols (t_state_machine : Type) : Type where
  | pt_state_machine (x : t_state_machine)
-- Concrete state machine
inductive StateMachine : Type where
  | st_start
  | st_step
  | st_end
-- Protocols2 using the concrete StateMachine
inductive Protocols2 : Type where
  | pt_state_machine2 (c : StateMachine)
def newstate : StateMachine := StateMachine.st_start
def newstate2 : Unit → Protocols2 := fun _ => Protocols2.pt_state_machine2 StateMachine.st_start
def newstate3 (u : Unit) : Protocols2 :=
  match u with
  | () => Protocols2.pt_state_machine2 StateMachine.st_start
instance : ProtocolType Protocols2 where
  state_machine := newstate3
