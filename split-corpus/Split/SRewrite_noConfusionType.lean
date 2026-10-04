import Mathlib

set_option pp.all true
-- spec: SRewrite.noConfusionType : Sort.{u} -> SRewrite -> SRewrite -> Sort.{u}
def SRewrite.noConfusionType : Sort.{u} -> SRewrite -> SRewrite -> Sort.{u} :=
  fun (P : Sort.{u}) (t : SRewrite) (t' : SRewrite) => SRewrite.casesOn.{succ u} (fun (t : SRewrite) => Sort.{u}) t (fun (fromThing : Something) (how : Something) (via : Option.{0} Something) (toThing : Something) => SRewrite.casesOn.{succ u} (fun (t : SRewrite) => Sort.{u}) t' (fun (fromThing_1 : Something) (how_1 : Something) (via_1 : Option.{0} Something) (toThing_1 : Something) => ((Eq.{1} Something fromThing fromThing_1) -> (Eq.{1} Something how how_1) -> (Eq.{1} (Option.{0} Something) via via_1) -> (Eq.{1} Something toThing toThing_1) -> P) -> P))
