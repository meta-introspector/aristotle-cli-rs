import Mathlib
import RequestProject.Imported.Sess8065bfd8.BaryonOctet

/-!
# A₅ action on the baryon-octet phases

We define the natural action of the alternating group A₅ ≤ S₅ on the six
outer vertices (phases) of the baryon octet. The action permutes phases
0–4 via the standard representation and fixes phase 5 (the "center").

Two key compatibility lemmas are proved:
* the action preserves the baryon-number assignment;
* the action fixes the net-phase operator.
-/

open Equiv

/-- Act by a permutation of `Fin 5` on `Phase = Fin 6`:
    phases 0–4 are permuted; phase 5 is fixed. -/
def phaseAction (σ : Equiv.Perm (Fin 5)) (p : Phase) : Phase :=
  if h : p.val < 5 then
    ⟨(σ ⟨p.val, h⟩).val, by omega⟩
  else
    p

/-- The induced action of `alternatingGroup (Fin 5)` on `Phase`. -/
def A5OnPhase (σ : ↥(alternatingGroup (Fin 5))) (p : Phase) : Phase :=
  phaseAction (σ : Equiv.Perm (Fin 5)).symm p

/-
The A₅-action preserves the baryon assignment (outer vertices).
-/
lemma A5_preserves_baryon (σ : ↥(alternatingGroup (Fin 5))) (p : Phase) :
    baryonFromPhase (A5OnPhase σ p) = baryonFromPhase p := by
  rfl

/-
The A₅-action commutes with (i.e., fixes) the net-phase operator.
-/
lemma A5_commutes_with_netPhase (σ : ↥(alternatingGroup (Fin 5))) (n : Nat) (_h : n > 0) :
    A5OnPhase σ (netPhase n) = netPhase n := by
  unfold A5OnPhase netPhase phaseAction; aesop;