import Mathlib

-- spec: theorem Something.SomeFile.injEq : forall (content : String) (content_1 : String), Eq.{1} Prop (Eq.{1} Something (Something.SomeFile content) (Something.SomeFile content_1)) (Eq.{1} String content content_1)
theorem Something.SomeFile.injEq : forall (content : String) (content_1 : String), Eq.{1} Prop (Eq.{1} Something (Something.SomeFile content) (Something.SomeFile content_1)) (Eq.{1} String content content_1) :=
  fun (content : String) (content_1 : String) => Eq.propIntro (Eq.{1} Something (Something.SomeFile content) (Something.SomeFile content_1)) (Eq.{1} String content content_1) (Something.SomeFile.inj content content_1) (Eq.ndrec.{0, 1} String content (fun (content_1 : String) => Eq.{1} Something (Something.SomeFile content) (Something.SomeFile content_1)) (Eq.refl.{1} Something (Something.SomeFile content)) content_1)
