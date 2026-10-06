import Mathlib

set_option pp.all true
-- spec: SProof.noConfusionType : Sort.{u} -> SProof -> SProof -> Sort.{u}
def SProof.noConfusionType : Sort.{u} -> SProof -> SProof -> Sort.{u} :=
  fun (P : Sort.{u}) (t : SProof) (t' : SProof) => SProof.casesOn.{succ u} (fun (t : SProof) => Sort.{u}) t (fun (steps : List.{0} SRewrite) => SProof.casesOn.{succ u} (fun (t : SProof) => Sort.{u}) t' (fun (steps_1 : List.{0} SRewrite) => ((Eq.{1} (List.{0} SRewrite) steps steps_1) -> P) -> P))
