import Lean

/-!
# Stage 3 — Explicit Proof Object

Expose proof terms directly. The proof object itself becomes inspectable.
The quine has begun reflecting on its own proof structure.
-/

open Lean

def P : Prop := True

def p_proof : P := by
  trivial

#check p_proof
#print p_proof
