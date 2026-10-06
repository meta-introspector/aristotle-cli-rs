import Mathlib

-- spec: recursor Lean.LocalDeclKind.rec : forall {motive : Lean.LocalDeclKind -> Sort.{u}}, (motive Lean.LocalDeclKind.default) -> (motive Lean.LocalDeclKind.implDetail) -> (motive Lean.LocalDeclKind.auxDecl) -> (forall (t : Lean.LocalDeclKind), motive t)
