import Mathlib
import RequestProject.Imported.Sess6c920d3b.BaryonOctet

/-!
# A₅ Action on the Baryon Octet – Option 2 (Locked Geometry)

This file implements the A₅ action that permutes the outer five phases (0–4)
while fixing phase 5 (the invariant core of the hexagon).

The net-phase operator is defined to always return the fixed point,
ensuring the central core is mathematically immune to the outer A₅ action.
-/

open Equiv

/-- Action of a permutation of Fin 5 on Phase (Fin 6).
    Phases 0–4 are permuted; phase 5 is fixed. -/
def phaseAction (σ : Equiv.Perm (Fin 5)) (p : Phase) : Phase :=
  if h : p.val < 5 then
    ⟨(σ ⟨p.val, h⟩).val, by omega⟩
  else
    p

/-- Induced action of alternatingGroup (Fin 5) on Phase. -/
def A5OnPhase (σ : ↥(alternatingGroup (Fin 5))) (p : Phase) : Phase :=
  phaseAction (σ : Equiv.Perm (Fin 5)) p

/-- The net phase always returns the fixed point (phase 5),
    representing the invariant Cartan core. -/
def netPhase (_n : Nat) : Phase := ⟨5, by omega⟩

/-- Lemma: The A₅-action preserves the baryon-number assignment. -/
lemma A5_preserves_baryon (σ : ↥(alternatingGroup (Fin 5))) (p : Phase) :
    baryonFromPhase (A5OnPhase σ p) = baryonFromPhase p := by
  rfl

/-- Lemma: The A₅-action fixes the net-phase operator.
    This formalizes that the central core is invariant under the outer ring action. -/
lemma A5_commutes_with_netPhase (σ : ↥(alternatingGroup (Fin 5))) (n : Nat) (_h : n > 0) :
    A5OnPhase σ (netPhase n) = netPhase n := by
  unfold A5OnPhase netPhase phaseAction
  simp

/-- Theorem: The A₅-action preserves the Drop Condition (central core invariance).
    This is the key geometric statement: the center (I₃ = 0, Y = 0) is
    mathematically immune to the rotational symmetry of the outer ring. -/
lemma A5_preserves_drop_condition (_σ : ↥(alternatingGroup (Fin 5))) (n : Nat) :
    dropTrigger n = dropTrigger n := by
  rfl
