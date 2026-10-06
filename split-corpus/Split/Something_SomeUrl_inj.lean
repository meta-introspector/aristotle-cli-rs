import Mathlib

-- spec: theorem Something.SomeUrl.inj : forall {url : String} {url_1 : String}, (Eq.{1} Something (Something.SomeUrl url) (Something.SomeUrl url_1)) -> (Eq.{1} String url url_1)
theorem Something.SomeUrl.inj : forall {url : String} {url_1 : String}, (Eq.{1} Something (Something.SomeUrl url) (Something.SomeUrl url_1)) -> (Eq.{1} String url url_1) :=
  fun {url : String} {url_1 : String} (x._@.RequestProject.MetaReflective.3629908809._hygCtx._hyg.73 : Eq.{1} Something (Something.SomeUrl url) (Something.SomeUrl url_1)) => Something.SomeUrl.noConfusion.{0} (Eq.{1} String url url_1) url url_1 x._@.RequestProject.MetaReflective.3629908809._hygCtx._hyg.73 (fun (url_eq._@.RequestProject.MetaReflective.3629908809._hygCtx._hyg.74 : Eq.{1} String url url_1) => url_eq._@.RequestProject.MetaReflective.3629908809._hygCtx._hyg.74)
