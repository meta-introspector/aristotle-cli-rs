import Mathlib

set_option pp.all true
-- spec: Lean.profileitM : forall {m : Type -> Type} (ε : Type) [inst._@.Lean.Util.Profile.225897603._hygCtx._hyg.6 : MonadFunctorT.{0, 0, 0} (EIO ε) m] {α : Type}, String -> Lean.Options -> (m α) -> (optParam.{1} Lean.Name Lean.Name.anonymous) -> (m α)
def Lean.profileitM : forall {m : Type -> Type} (ε : Type) [inst._@.Lean.Util.Profile.225897603._hygCtx._hyg.6 : MonadFunctorT.{0, 0, 0} (EIO ε) m] {α : Type}, String -> Lean.Options -> (m α) -> (optParam.{1} Lean.Name Lean.Name.anonymous) -> (m α) :=
  fun {m : Type -> Type} (ε : Type) [inst._@.Lean.Util.Profile.225897603._hygCtx._hyg.6 : MonadFunctorT.{0, 0, 0} (EIO ε) m] {α : Type} (category : String) (opts : Lean.Options) (act : m α) (decl : Lean.Name) => MonadFunctorT.monadMap.{0, 0, 0} (EIO ε) m inst._@.Lean.Util.Profile.225897603._hygCtx._hyg.6 α (fun {β : Type} (act : EIO ε β) => Lean.profileitIO ε β category opts act decl) act
