import Mathlib

-- spec: theorem SProof.mk.inj : forall {steps : List.{0} SRewrite} {steps_1 : List.{0} SRewrite}, (Eq.{1} SProof (SProof.mk steps) (SProof.mk steps_1)) -> (Eq.{1} (List.{0} SRewrite) steps steps_1)
theorem SProof.mk.inj : forall {steps : List.{0} SRewrite} {steps_1 : List.{0} SRewrite}, (Eq.{1} SProof (SProof.mk steps) (SProof.mk steps_1)) -> (Eq.{1} (List.{0} SRewrite) steps steps_1) :=
  fun {steps : List.{0} SRewrite} {steps_1 : List.{0} SRewrite} (x._@.RequestProject.MetaReflective.3262142183._hygCtx._hyg.7 : Eq.{1} SProof (SProof.mk steps) (SProof.mk steps_1)) => SProof.mk.noConfusion.{0} (Eq.{1} (List.{0} SRewrite) steps steps_1) steps steps_1 x._@.RequestProject.MetaReflective.3262142183._hygCtx._hyg.7 (fun (steps_eq._@.RequestProject.MetaReflective.3262142183._hygCtx._hyg.8 : Eq.{1} (List.{0} SRewrite) steps steps_1) => steps_eq._@.RequestProject.MetaReflective.3262142183._hygCtx._hyg.8)
