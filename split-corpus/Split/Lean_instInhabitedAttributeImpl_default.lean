import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedAttributeImpl.default : Lean.AttributeImpl
def Lean.instInhabitedAttributeImpl.default : Lean.AttributeImpl :=
  Lean.AttributeImpl.mk (Inhabited.default.{1} Lean.AttributeImplCore Lean.instInhabitedAttributeImplCore) (Inhabited.default.{1} (Lean.Name -> Lean.Syntax -> Lean.AttributeKind -> (Lean.AttrM Unit)) (Pi.instInhabited.{1, 1} Lean.Name (fun (decl : Lean.Name) => Lean.Syntax -> Lean.AttributeKind -> (Lean.AttrM Unit)) (fun (a : Lean.Name) => Pi.instInhabited.{1, 1} Lean.Syntax (fun (stx : Lean.Syntax) => Lean.AttributeKind -> (Lean.AttrM Unit)) (fun (a : Lean.Syntax) => Pi.instInhabited.{1, 1} Lean.AttributeKind (fun (kind : Lean.AttributeKind) => Lean.AttrM Unit) (fun (a : Lean.AttributeKind) => Lean.Core.instInhabitedCoreM Unit))))) (Inhabited.default.{1} (Lean.Name -> (Lean.AttrM Unit)) (Pi.instInhabited.{1, 1} Lean.Name (fun (decl : Lean.Name) => Lean.AttrM Unit) (fun (a : Lean.Name) => Lean.Core.instInhabitedCoreM Unit)))
