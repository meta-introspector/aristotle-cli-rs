import Mathlib

-- spec: theorem SProof.mk.injEq : forall (steps : List.{0} SRewrite) (steps_1 : List.{0} SRewrite), Eq.{1} Prop (Eq.{1} SProof (SProof.mk steps) (SProof.mk steps_1)) (Eq.{1} (List.{0} SRewrite) steps steps_1)
theorem SProof.mk.injEq : forall (steps : List.{0} SRewrite) (steps_1 : List.{0} SRewrite), Eq.{1} Prop (Eq.{1} SProof (SProof.mk steps) (SProof.mk steps_1)) (Eq.{1} (List.{0} SRewrite) steps steps_1) :=
  fun (steps : List.{0} SRewrite) (steps_1 : List.{0} SRewrite) => Eq.propIntro (Eq.{1} SProof (SProof.mk steps) (SProof.mk steps_1)) (Eq.{1} (List.{0} SRewrite) steps steps_1) (SProof.mk.inj steps steps_1) (Eq.ndrec.{0, 1} (List.{0} SRewrite) steps (fun (steps_1 : List.{0} SRewrite) => Eq.{1} SProof (SProof.mk steps) (SProof.mk steps_1)) (Eq.refl.{1} SProof (SProof.mk steps)) steps_1)
