import Mathlib

-- spec: theorem Array.mk.inj : forall {α : Type.{u}} {toList : List.{u} α} {toList_1 : List.{u} α}, (Eq.{succ u} (Array.{u} α) (Array.mk.{u} α toList) (Array.mk.{u} α toList_1)) -> (Eq.{succ u} (List.{u} α) toList toList_1)
theorem Array.mk.inj : forall {α : Type.{u}} {toList : List.{u} α} {toList_1 : List.{u} α}, (Eq.{succ u} (Array.{u} α) (Array.mk.{u} α toList) (Array.mk.{u} α toList_1)) -> (Eq.{succ u} (List.{u} α) toList toList_1) :=
  fun {α : Type.{u}} {toList : List.{u} α} {toList_1 : List.{u} α} (x._@.Init.Core.3362255915._hygCtx._hyg.3 : Eq.{succ u} (Array.{u} α) (Array.mk.{u} α toList) (Array.mk.{u} α toList_1)) => Array.mk.noConfusion.{0, u} α (Eq.{succ u} (List.{u} α) toList toList_1) toList toList_1 x._@.Init.Core.3362255915._hygCtx._hyg.3 (fun (toList_eq._@.Init.Core.3362255915._hygCtx._hyg.4 : HEq.{succ u} (List.{u} α) toList (List.{u} α) toList_1) => eq_of_heq.{succ u} (List.{u} α) toList toList_1 toList_eq._@.Init.Core.3362255915._hygCtx._hyg.4)
