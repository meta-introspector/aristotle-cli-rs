import Mathlib

-- spec: theorem Something.SomeFile.inj : forall {content : String} {content_1 : String}, (Eq.{1} Something (Something.SomeFile content) (Something.SomeFile content_1)) -> (Eq.{1} String content content_1)
theorem Something.SomeFile.inj : forall {content : String} {content_1 : String}, (Eq.{1} Something (Something.SomeFile content) (Something.SomeFile content_1)) -> (Eq.{1} String content content_1) :=
  fun {content : String} {content_1 : String} (x._@.RequestProject.MetaReflective.3629908809._hygCtx._hyg.75 : Eq.{1} Something (Something.SomeFile content) (Something.SomeFile content_1)) => Something.SomeFile.noConfusion.{0} (Eq.{1} String content content_1) content content_1 x._@.RequestProject.MetaReflective.3629908809._hygCtx._hyg.75 (fun (content_eq._@.RequestProject.MetaReflective.3629908809._hygCtx._hyg.76 : Eq.{1} String content content_1) => content_eq._@.RequestProject.MetaReflective.3629908809._hygCtx._hyg.76)
