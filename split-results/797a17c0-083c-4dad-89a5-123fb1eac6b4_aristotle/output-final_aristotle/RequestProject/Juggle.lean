import RequestProject.DescriptionLogic
import RequestProject.Expressivity
import Mathlib

/-!
# Juggling the model: functorial recoloring of description-logic knowledge bases

This file takes the description-logic model of `RequestProject.DescriptionLogic` as an
*Entwurf* (a blueprint) and develops the machinery to **transform, copy and recombine** it.
Read informally:

* *"take our model as an Entwurf and juggle it through, catch and spin"* — we relabel
  ("juggle/spin") the underlying signature of a concept along arbitrary maps on the atomic
  concept, role and individual names (`mapConcept`, `mapKB`), and prove that this is a
  *functor* (`mapConcept_id`, `mapConcept_comp`) which is *natural* with respect to the
  Tarski semantics (`eval_mapConcept`): the meaning of an expression survives the
  transformation once the interpretation is pulled back along the relabeling.  Catching a
  juggled object and finding it unchanged is exactly the content of these laws.

* *"then we can copy it and paint it different colors and add it to the juggle"* — we make
  copies of the Aristotle ontology and **recolor** them by tagging the whole signature with
  a Boolean `color` (`recolor`), then **combine** the colored copies into a single
  knowledge base (`combineKB`, `juggledAristotle`).  We show that every theorem of the
  original blueprint is transported, in each color, into the combined juggle
  (`juggled_solved_justified`, `juggled_search_is_subsystem`).

Everything is built on top of the `DescriptionLogic` namespace and reuses its `eval`,
`models`, `entailsSub` and `entailsCon`.
-/

namespace DescriptionLogic

open DLConcept

/-! ## Recoloring concepts: the functorial relabeling -/

/-- Relabel ("recolor") a concept along a map `f` on atomic-concept names and a map `g` on
role names.  This is the action on objects of the relabeling functor. -/
def mapConcept {NC NR NC' NR' : Type*} (f : NC → NC') (g : NR → NR') :
    DLConcept NC NR → DLConcept NC' NR'
  | .atom A => .atom (f A)
  | .top => .top
  | .bot => .bot
  | .neg C => .neg (mapConcept f g C)
  | .inter C D => .inter (mapConcept f g C) (mapConcept f g D)
  | .union C D => .union (mapConcept f g C) (mapConcept f g D)
  | .ex r C => .ex (g r) (mapConcept f g C)
  | .all r C => .all (g r) (mapConcept f g C)

/-- Functor identity law: recoloring along the identity maps changes nothing. -/
theorem mapConcept_id {NC NR : Type*} (C : DLConcept NC NR) :
    mapConcept id id C = C := by
      induction C <;> simp +decide [ *, mapConcept ]

/-- Functor composition law: recoloring twice equals recoloring along the composites. -/
theorem mapConcept_comp {NC NR NC' NR' NC'' NR'' : Type*}
    (f : NC → NC') (g : NR → NR') (f' : NC' → NC'') (g' : NR' → NR'')
    (C : DLConcept NC NR) :
    mapConcept f' g' (mapConcept f g C) = mapConcept (f' ∘ f) (g' ∘ g) C := by
      induction' C with C D C D C D r C r C;
      all_goals simp_all +decide [ Function.comp, mapConcept ]

/-- Recoloring preserves the structural size of a concept (the shape is untouched, only the
labels change). -/
theorem size_mapConcept {NC NR NC' NR' : Type*} (f : NC → NC') (g : NR → NR')
    (C : DLConcept NC NR) : size (mapConcept f g C) = size C := by
      induction' C with C ih;
      all_goals simp_all +decide [ size, mapConcept ]

/-! ## Pulling back interpretations along a relabeling -/

/-- Pull an interpretation of the *recolored* signature back to an interpretation of the
original signature, by precomposing each piece with the relabeling maps.  This is the
contravariant action on interpretations that makes `eval` natural. -/
def reindexInterp {NC NR NI NC' NR' NI' : Type*}
    (f : NC → NC') (g : NR → NR') (h : NI → NI')
    (I : Interp NC' NR' NI') : Interp NC NR NI where
  Dom := I.Dom
  domNonempty := I.domNonempty
  atomI := fun A => I.atomI (f A)
  roleI := fun r => I.roleI (g r)
  indI := fun a => I.indI (h a)

/-- **Naturality of the semantics.**  Evaluating a recolored concept under an interpretation
of the target signature equals evaluating the original concept under the pulled-back
interpretation.  (Both sides live in `Set I.Dom`, since `reindexInterp` keeps the domain.)
This is the "catch": the juggled object lands with its meaning intact. -/
theorem eval_mapConcept {NC NR NI NC' NR' NI' : Type*}
    (f : NC → NC') (g : NR → NR') (h : NI → NI')
    (I : Interp NC' NR' NI') (C : DLConcept NC NR) :
    eval I (mapConcept f g C) = eval (reindexInterp (NI := NI) f g h I) C := by
      induction' C with C D hC hD;
      all_goals simp_all +decide [ mapConcept, reindexInterp ]

/-! ## Recoloring whole knowledge bases -/

/-- Recolor a general concept inclusion. -/
def mapGCI {NC NR NC' NR' : Type*} (f : NC → NC') (g : NR → NR') (ax : GCI NC NR) :
    GCI NC' NR' := ⟨mapConcept f g ax.lhs, mapConcept f g ax.rhs⟩

/-- Recolor a concept assertion. -/
def mapConAssertion {NC NR NI NC' NR' NI' : Type*}
    (f : NC → NC') (g : NR → NR') (h : NI → NI') (a : ConAssertion NC NR NI) :
    ConAssertion NC' NR' NI' := ⟨h a.ind, mapConcept f g a.concept⟩

/-- Recolor a role assertion. -/
def mapRoleAssertion {NR NI NR' NI' : Type*}
    (g : NR → NR') (h : NI → NI') (a : RoleAssertion NR NI) :
    RoleAssertion NR' NI' := ⟨g a.role, h a.src, h a.tgt⟩

/-- Recolor an entire knowledge base along relabelings of concepts, roles and individuals. -/
def mapKB {NC NR NI NC' NR' NI' : Type*}
    (f : NC → NC') (g : NR → NR') (h : NI → NI') (kb : KB NC NR NI) :
    KB NC' NR' NI' where
  tbox := kb.tbox.map (mapGCI f g)
  conAssertions := kb.conAssertions.map (mapConAssertion f g h)
  roleAssertions := kb.roleAssertions.map (mapRoleAssertion g h)

/-- A model of a recolored knowledge base pulls back, along the same relabeling, to a model
of the original knowledge base. -/
theorem models_reindex_of_mapKB {NC NR NI NC' NR' NI' : Type*}
    (f : NC → NC') (g : NR → NR') (h : NI → NI')
    (I : Interp NC' NR' NI') (kb : KB NC NR NI)
    (hI : models I (mapKB f g h kb)) :
    models (reindexInterp (NI := NI) f g h I) kb := by
      refine' ⟨ fun ax hax => _, fun a ha => _, fun a ha => _ ⟩;
      · convert hI.1 _ ( List.mem_map.mpr ⟨ ax, hax, rfl ⟩ ) using 1;
        unfold satisfiesGCI mapGCI;
        rw [ ← eval_mapConcept, ← eval_mapConcept ];
      · have := hI.2.1 ⟨ h a.ind, mapConcept f g a.concept ⟩ ( List.mem_map.mpr ⟨ a, ha, rfl ⟩ ) ;
        rw [ eval_mapConcept ] at this ; exact this;
      · convert hI.2.2 ( mapRoleAssertion g h a ) _ using 1;
        exact List.mem_map_of_mem ha

/-- **Transport of entailed subsumption.**  Every subsumption entailed by the blueprint is,
after recoloring, entailed by the recolored knowledge base.  Theorems survive the juggle. -/
theorem entailsSub_mapKB {NC NR NI NC' NR' NI' : Type*}
    (f : NC → NC') (g : NR → NR') (h : NI → NI')
    {kb : KB NC NR NI} {C D : DLConcept NC NR} (hCD : entailsSub kb C D) :
    entailsSub (mapKB f g h kb) (mapConcept f g C) (mapConcept f g D) := by
      intro I hI;
      rw [eval_mapConcept, eval_mapConcept];
      exact hCD _ ( models_reindex_of_mapKB f g h I kb hI )

/-- **Transport of entailed assertions.**  Every instance assertion entailed by the
blueprint is, after recoloring, entailed by the recolored knowledge base. -/
theorem entailsCon_mapKB {NC NR NI NC' NR' NI' : Type*}
    (f : NC → NC') (g : NR → NR') (h : NI → NI')
    {kb : KB NC NR NI} {a : NI} {C : DLConcept NC NR} (hC : entailsCon kb a C) :
    entailsCon (mapKB f g h kb) (h a) (mapConcept f g C) := by
      intro I hI
      apply eval_mapConcept f g h I C ▸ hC (reindexInterp f g h I) (models_reindex_of_mapKB f g h I kb hI)

/-! ## Combining knowledge bases: adding a copy to the juggle -/

/-- Combine two knowledge bases over the same signature by concatenating their TBoxes and
ABoxes.  This is how a fresh, recolored copy is *added to the juggle*. -/
def combineKB {NC NR NI : Type*} (kb1 kb2 : KB NC NR NI) : KB NC NR NI where
  tbox := kb1.tbox ++ kb2.tbox
  conAssertions := kb1.conAssertions ++ kb2.conAssertions
  roleAssertions := kb1.roleAssertions ++ kb2.roleAssertions

/-- An interpretation models the combination of two knowledge bases iff it models each. -/
theorem models_combineKB {NC NR NI : Type*} (I : Interp NC NR NI)
    (kb1 kb2 : KB NC NR NI) :
    models I (combineKB kb1 kb2) ↔ models I kb1 ∧ models I kb2 := by
      unfold models combineKB;
      grind

/-- Adding more axioms only strengthens entailment: a subsumption entailed by the first
component is entailed by the combination. -/
theorem entailsSub_combine_left {NC NR NI : Type*} (kb1 kb2 : KB NC NR NI)
    {C D : DLConcept NC NR} (h : entailsSub kb1 C D) :
    entailsSub (combineKB kb1 kb2) C D := by
      intro I hI;
      exact h I ( models_combineKB I kb1 kb2 |>.mp hI |>.1 )

/-- Symmetrically, a subsumption entailed by the second component is entailed by the
combination. -/
theorem entailsSub_combine_right {NC NR NI : Type*} (kb1 kb2 : KB NC NR NI)
    {C D : DLConcept NC NR} (h : entailsSub kb2 C D) :
    entailsSub (combineKB kb1 kb2) C D := by
      intro I hI; exact h I (models_combineKB I kb1 kb2 |>.mp hI |>.2)

/-! ## The juggled Aristotle ontology: copies painted in two colors -/

/-- The recolored concept signature: each Aristotle concept tagged with a Boolean color. -/
abbrev CCon := Bool × ACon
/-- The recolored role signature. -/
abbrev CRole := Bool × ARole
/-- The recolored individual signature. -/
abbrev CInd := Bool × AInd

/-- A color-`b` copy of the Aristotle knowledge base: the blueprint with every name tagged
by the color `b`. -/
def recolor (b : Bool) : KB CCon CRole CInd :=
  mapKB (Prod.mk b) (Prod.mk b) (Prod.mk b) aristotleKB

/-- The **juggled Aristotle ontology**: two copies of the blueprint, painted in colors
`false` and `true`, added together into one knowledge base. -/
def juggledAristotle : KB CCon CRole CInd :=
  combineKB (recolor false) (recolor true)

/-- In each color, the recolored "solved problem" is still justified by a recolored formal
proof inside the juggled ontology: the soundness theorem of the blueprint survives copying,
recoloring and recombination. -/
theorem juggled_solved_justified (b : Bool) :
    entailsSub juggledAristotle
      (mapConcept (Prod.mk b) (Prod.mk b) (cpt .SolvedProblem))
      (mapConcept (Prod.mk b) (Prod.mk b) (.ex .justifiedBy (cpt .FormalProof))) := by
  have base := entailsSub_mapKB (Prod.mk b) (Prod.mk b) (Prod.mk b)
    (kb := aristotleKB) solved_justified_by_formal
  cases b with
  | false => exact entailsSub_combine_left _ _ base
  | true => exact entailsSub_combine_right _ _ base

/-- In each color, the recolored search algorithm is still a recolored subsystem inside the
juggled ontology. -/
theorem juggled_search_is_subsystem (b : Bool) :
    entailsSub juggledAristotle
      (mapConcept (Prod.mk b) (Prod.mk b) (cpt .SearchAlgorithm))
      (mapConcept (Prod.mk b) (Prod.mk b) (cpt .Subsystem)) := by
  have base := entailsSub_mapKB (Prod.mk b) (Prod.mk b) (Prod.mk b)
    (kb := aristotleKB) aristotle_search_is_subsystem
  cases b with
  | false => exact entailsSub_combine_left _ _ base
  | true => exact entailsSub_combine_right _ _ base

end DescriptionLogic