import Mathlib

-- spec: opaque Lean.MessageData.arrayExpr.toMessageData : (Array.{0} Lean.Expr) -> Nat -> Lean.MessageData -> Lean.MessageData
opaque Lean.MessageData.arrayExpr.toMessageData : (Array.{0} Lean.Expr) -> Nat -> Lean.MessageData -> Lean.MessageData :=
  fun (es : Array.{0} Lean.Expr) (i : Nat) (acc : Lean.MessageData) => let inst : Inhabited.{1} Lean.MessageData := Inhabited.mk.{1} Lean.MessageData acc; Inhabited.default.{1} Lean.MessageData inst
