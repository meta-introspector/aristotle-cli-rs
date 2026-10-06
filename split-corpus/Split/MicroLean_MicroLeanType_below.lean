import Mathlib

set_option pp.all true
-- spec: MicroLean.MicroLeanType.below : forall {motive : MicroLean.MicroLeanType -> Sort.{u}}, MicroLean.MicroLeanType -> Sort.{max 1 u}
def MicroLean.MicroLeanType.below : forall {motive : MicroLean.MicroLeanType -> Sort.{u}}, MicroLean.MicroLeanType -> Sort.{max 1 u} :=
  fun {motive : MicroLean.MicroLeanType -> Sort.{u}} (t : MicroLean.MicroLeanType) => MicroLean.MicroLeanType.rec.{succ (max 1 u)} (fun (t : MicroLean.MicroLeanType) => Sort.{max 1 u}) PUnit.{max 1 u} PUnit.{max 1 u} (fun (domain : MicroLean.MicroLeanType) (codomain : MicroLean.MicroLeanType) (domain_ih : Sort.{max 1 u}) (codomain_ih : Sort.{max 1 u}) => PProd.{max 1 u, max 1 u} (PProd.{u, max 1 u} (motive domain) domain_ih) (PProd.{u, max 1 u} (motive codomain) codomain_ih)) (fun (elem : MicroLean.MicroLeanType) (elem_ih : Sort.{max 1 u}) => PProd.{u, max 1 u} (motive elem) elem_ih) (fun (fst : MicroLean.MicroLeanType) (snd : MicroLean.MicroLeanType) (fst_ih : Sort.{max 1 u}) (snd_ih : Sort.{max 1 u}) => PProd.{max 1 u, max 1 u} (PProd.{u, max 1 u} (motive fst) fst_ih) (PProd.{u, max 1 u} (motive snd) snd_ih)) t
