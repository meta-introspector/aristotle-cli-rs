import Lean

/-!
# Stage 2 — Introduce Proposition Carrier

Introduce a proposition-valued object. The kernel verifies `P : Prop` and
that a proof term exists. This is the first "semantic fixed point".
-/

open Lean

def P : Prop := True

#check P
#check (show P from trivial)
