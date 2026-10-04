import Mathlib

-- spec: theorem Something.SomeUrl.injEq : forall (url : String) (url_1 : String), Eq.{1} Prop (Eq.{1} Something (Something.SomeUrl url) (Something.SomeUrl url_1)) (Eq.{1} String url url_1)
theorem Something.SomeUrl.injEq : forall (url : String) (url_1 : String), Eq.{1} Prop (Eq.{1} Something (Something.SomeUrl url) (Something.SomeUrl url_1)) (Eq.{1} String url url_1) :=
  fun (url : String) (url_1 : String) => Eq.propIntro (Eq.{1} Something (Something.SomeUrl url) (Something.SomeUrl url_1)) (Eq.{1} String url url_1) (Something.SomeUrl.inj url url_1) (Eq.ndrec.{0, 1} String url (fun (url_1 : String) => Eq.{1} Something (Something.SomeUrl url) (Something.SomeUrl url_1)) (Eq.refl.{1} Something (Something.SomeUrl url)) url_1)
