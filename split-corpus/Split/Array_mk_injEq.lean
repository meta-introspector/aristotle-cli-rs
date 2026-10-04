import Mathlib

-- spec: theorem Array.mk.injEq : forall {α : Type.{u}} (toList : List.{u} α) (toList_1 : List.{u} α), Eq.{1} Prop (Eq.{succ u} (Array.{u} α) (Array.mk.{u} α toList) (Array.mk.{u} α toList_1)) (Eq.{succ u} (List.{u} α) toList toList_1)
theorem Array.mk.injEq : forall {α : Type.{u}} (toList : List.{u} α) (toList_1 : List.{u} α), Eq.{1} Prop (Eq.{succ u} (Array.{u} α) (Array.mk.{u} α toList) (Array.mk.{u} α toList_1)) (Eq.{succ u} (List.{u} α) toList toList_1) :=
  fun {α : Type.{u}} (toList : List.{u} α) (toList_1 : List.{u} α) => Eq.propIntro (Eq.{succ u} (Array.{u} α) (Array.mk.{u} α toList) (Array.mk.{u} α toList_1)) (Eq.{succ u} (List.{u} α) toList toList_1) (Array.mk.inj.{u} α toList toList_1) (Eq.ndrec.{0, succ u} (List.{u} α) toList (fun (toList_1 : List.{u} α) => Eq.{succ u} (Array.{u} α) (Array.mk.{u} α toList) (Array.mk.{u} α toList_1)) (Eq.refl.{succ u} (Array.{u} α) (Array.mk.{u} α toList)) toList_1)
