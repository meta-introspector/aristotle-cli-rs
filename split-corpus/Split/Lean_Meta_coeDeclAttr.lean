import Mathlib

-- spec: opaque Lean.Meta.coeDeclAttr : Lean.TagAttribute
opaque Lean.Meta.coeDeclAttr : Lean.TagAttribute :=
  Inhabited.default.{1} Lean.TagAttribute Lean.instInhabitedTagAttribute
