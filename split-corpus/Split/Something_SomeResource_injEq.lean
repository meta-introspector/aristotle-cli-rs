import Mathlib

-- spec: theorem Something.SomeResource.injEq : forall (res : String) (res_1 : String), Eq.{1} Prop (Eq.{1} Something (Something.SomeResource res) (Something.SomeResource res_1)) (Eq.{1} String res res_1)
theorem Something.SomeResource.injEq : forall (res : String) (res_1 : String), Eq.{1} Prop (Eq.{1} Something (Something.SomeResource res) (Something.SomeResource res_1)) (Eq.{1} String res res_1) :=
  fun (res : String) (res_1 : String) => Eq.propIntro (Eq.{1} Something (Something.SomeResource res) (Something.SomeResource res_1)) (Eq.{1} String res res_1) (Something.SomeResource.inj res res_1) (Eq.ndrec.{0, 1} String res (fun (res_1 : String) => Eq.{1} Something (Something.SomeResource res) (Something.SomeResource res_1)) (Eq.refl.{1} Something (Something.SomeResource res)) res_1)
