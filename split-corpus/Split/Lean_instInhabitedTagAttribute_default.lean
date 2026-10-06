import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedTagAttribute.default : Lean.TagAttribute
def Lean.instInhabitedTagAttribute.default : Lean.TagAttribute :=
  Lean.TagAttribute.mk (Inhabited.default.{1} Lean.AttributeImpl Lean.instInhabitedAttributeImpl) (Inhabited.default.{1} (Lean.PersistentEnvExtension Lean.Name Lean.Name Lean.NameSet) (Lean.instInhabitedPersistentEnvExtension Lean.Name Lean.Name Lean.NameSet Lean.NameSet.instInhabited))
