import Mathlib

-- spec: theorem Something.SomeResource.inj : forall {res : String} {res_1 : String}, (Eq.{1} Something (Something.SomeResource res) (Something.SomeResource res_1)) -> (Eq.{1} String res res_1)
theorem Something.SomeResource.inj : forall {res : String} {res_1 : String}, (Eq.{1} Something (Something.SomeResource res) (Something.SomeResource res_1)) -> (Eq.{1} String res res_1) :=
  fun {res : String} {res_1 : String} (x._@.RequestProject.MetaReflective.3629908809._hygCtx._hyg.77 : Eq.{1} Something (Something.SomeResource res) (Something.SomeResource res_1)) => Something.SomeResource.noConfusion.{0} (Eq.{1} String res res_1) res res_1 x._@.RequestProject.MetaReflective.3629908809._hygCtx._hyg.77 (fun (res_eq._@.RequestProject.MetaReflective.3629908809._hygCtx._hyg.78 : Eq.{1} String res res_1) => res_eq._@.RequestProject.MetaReflective.3629908809._hygCtx._hyg.78)
