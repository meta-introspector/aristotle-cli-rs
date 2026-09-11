/-
  KernelAlgebra.lean — Port of KernelAlgebra.agda.
-/
import Mathlib

namespace DASHI

inductive Trit : Type where
  | neg | zero | pos
  deriving DecidableEq, Repr

def Trit.inv : Trit → Trit
  | neg  => pos
  | pos  => neg
  | zero => zero

theorem Trit.inv_inv (t : Trit) : t.inv.inv = t := by cases t <;> rfl

/-- State space as an indexed function. -/
abbrev TritState (X : Type*) := X → Trit

/-- Pointwise involution. -/
def tritInvol {X : Type*} (s : TritState X) : TritState X := fun x => (s x).inv

theorem tritInvol_invol {X : Type*} (s : TritState X) : tritInvol (tritInvol s) = s := by
  funext x; simp [tritInvol, Trit.inv_inv]

/-- A kernel operator respects involution. -/
structure KernelOp (X : Type*) where
  K : TritState X → TritState X
  involutive_respecting : ∀ s, K (tritInvol s) = tritInvol (K s)

def KernelOp.idK (X : Type*) : KernelOp X where
  K := id
  involutive_respecting := fun _ => rfl

def KernelOp.negK (X : Type*) : KernelOp X where
  K := tritInvol
  involutive_respecting := fun _ => rfl

theorem KernelOp.neg_twice {X : Type*} (s : TritState X) :
    (KernelOp.negK X).K ((KernelOp.negK X).K s) = s := tritInvol_invol s

/-- No nontrivial 2-cycle. -/
def No2Cycle {X : Type*} (K : TritState X → TritState X) : Prop :=
  ∀ s, K (K s) = s → K s = s

end DASHI
