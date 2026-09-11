import Lean

/-!
# Stage 1 — Bootstrap Kernel Object

Establish a compilable artifact and a named object in the environment.
-/

open Lean

def stage1 : String :=
  "Meta bootstrap alive"

#check stage1
