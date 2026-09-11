/-
# Software supply chain: `source ?= deployed artifact`, and `artifact ⊨ properties`

Senator Vaicu's report names software supply-chain verification as the niche
where the stack is closest to something sellable, and states the two questions a
customer actually asks:

    source  =?  deployed artifact          artifact ⊨ required properties

This file answers both for an attested build chain.  A chain is a list of steps,
each naming the tool that was run and recording the artifact before and after.
The toolchain says what each tool identifier deterministically does.  A chain is
*valid* when it starts at the source, each step's input is the previous step's
output, and each recorded output really is what the named tool produces.

What is proved: a valid chain's deployed artifact is exactly the rebuild of the
source through the recorded tool list (so the build is reproducible and the
source determines the artifact); any deviation from that rebuild makes the chain
invalid (so tampering is detected); properties preserved by every tool in the
chain survive to the deployed artifact; and, for an injective digest, matching
digests mean matching artifacts.

The trust assumption is stated, not proved: the toolchain `run` is what the
verifier believes each tool identifier does.
-/
import Mathlib

namespace RequestProject.Market

variable {A : Type*}

/-- One recorded build step: which tool was run, and the artifact before and
after. -/
structure Step (A : Type*) where
  /-- Identifier of the tool that was run. -/
  tool : Nat
  /-- The artifact the step consumed. -/
  input : A
  /-- The artifact the step produced. -/
  output : A

/-- The verifier's model of the build tools: a deterministic action of each tool
identifier on artifacts. -/
structure Toolchain (A : Type*) where
  /-- What the named tool does to an artifact. -/
  run : Nat → A → A

/-- Rebuilding: run the listed tools over the source, in order. -/
def Toolchain.rebuild (tc : Toolchain A) (source : A) (tools : List Nat) : A :=
  tools.foldl (fun a t => tc.run t a) source

/-- The artifact a chain deploys: the output of its last step, or the source if
the chain is empty. -/
def deployed (source : A) : List (Step A) → A
  | [] => source
  | s :: rest => deployed s.output rest

/-- A chain is valid from a source when it starts there, is properly linked, and
every recorded output is what the named tool actually produces. -/
def Toolchain.Valid (tc : Toolchain A) (source : A) : List (Step A) → Prop
  | [] => True
  | s :: rest => s.input = source ∧ s.output = tc.run s.tool source ∧ tc.Valid s.output rest

/-! ## `source ?= deployed artifact` -/

/-- **The source and the tool list determine the artifact.**  A valid chain
deploys exactly the rebuild of its source through the tools it names. -/
theorem deployed_eq_rebuild (tc : Toolchain A) (source : A) (steps : List (Step A))
    (h : tc.Valid source steps) :
    deployed source steps = tc.rebuild source (steps.map Step.tool) := by
  induction steps generalizing source with
  | nil => simp [deployed, Toolchain.rebuild]
  | cons s rest ih =>
      obtain ⟨_, hout, hrest⟩ := h
      simp only [deployed, List.map_cons, Toolchain.rebuild, List.foldl_cons]
      rw [ih s.output hrest, ← hout]
      rfl

/-- **Reproducibility.**  Two valid chains from the same source running the same
tools deploy the very same artifact. -/
theorem deployed_unique (tc : Toolchain A) (source : A) (steps steps' : List (Step A))
    (h : tc.Valid source steps) (h' : tc.Valid source steps')
    (htools : steps.map Step.tool = steps'.map Step.tool) :
    deployed source steps = deployed source steps' := by
  rw [deployed_eq_rebuild tc source steps h, deployed_eq_rebuild tc source steps' h', htools]

/-- **Tampering is detected.**  If what was deployed is not the rebuild of the
source through the recorded tools, no valid chain can attest to it. -/
theorem tampering_invalidates_chain (tc : Toolchain A) (source : A) (steps : List (Step A))
    (h : deployed source steps ≠ tc.rebuild source (steps.map Step.tool)) :
    ¬ tc.Valid source steps :=
  fun hv => h (deployed_eq_rebuild tc source steps hv)

/-- Running only tools that change nothing rebuilds the source itself. -/
theorem rebuild_of_identity_tools (tc : Toolchain A) (source : A) (tools : List Nat)
    (hid : ∀ t ∈ tools, ∀ a : A, tc.run t a = a) :
    tc.rebuild source tools = source := by
  unfold Toolchain.rebuild
  induction tools generalizing source with
  | nil => simp
  | cons t rest ih =>
      have ht : tc.run t source = source := hid t (List.mem_cons_self ..) source
      have hrest : ∀ u ∈ rest, ∀ a : A, tc.run u a = a :=
        fun u hu => hid u (List.mem_cons_of_mem _ hu)
      simp [ht, ih source hrest]

/-- A valid chain that changes nothing deploys the source itself. -/
theorem deployed_of_identity_tools (tc : Toolchain A) (source : A) (steps : List (Step A))
    (h : tc.Valid source steps) (hid : ∀ t ∈ steps.map Step.tool, ∀ a : A, tc.run t a = a) :
    deployed source steps = source := by
  rw [deployed_eq_rebuild tc source steps h]
  exact rebuild_of_identity_tools tc source _ hid

/-! ## `artifact ⊨ required properties` -/

/-- **Property preservation along the chain.**  If the source satisfies a
property and every tool in the chain preserves it, the deployed artifact
satisfies it too. -/
theorem deployed_satisfies (tc : Toolchain A) (P : A → Prop) (source : A)
    (steps : List (Step A)) (h : tc.Valid source steps) (hsrc : P source)
    (hpres : ∀ t ∈ steps.map Step.tool, ∀ a : A, P a → P (tc.run t a)) :
    P (deployed source steps) := by
  induction steps generalizing source with
  | nil => simpa [deployed] using hsrc
  | cons s rest ih =>
      obtain ⟨_, hout, hrest⟩ := h
      have hstep : P s.output := by
        rw [hout]
        exact hpres s.tool (by simp) source hsrc
      refine ih s.output hrest hstep ?_
      intro t ht a ha
      exact hpres t (by simp [ht]) a ha

/-- The same, for a whole list of required properties. -/
theorem deployed_satisfies_all (tc : Toolchain A) (Ps : List (A → Prop)) (source : A)
    (steps : List (Step A)) (h : tc.Valid source steps)
    (hsrc : ∀ P ∈ Ps, P source)
    (hpres : ∀ P ∈ Ps, ∀ t ∈ steps.map Step.tool, ∀ a : A, P a → P (tc.run t a)) :
    ∀ P ∈ Ps, P (deployed source steps) :=
  fun P hP => deployed_satisfies tc P source steps h (hsrc P hP) (hpres P hP)

/-! ## Digests -/

/-- **A digest pins the artifact.**  Under an injective digest function, an
artifact whose digest is the attested one is the attested artifact. -/
theorem artifact_of_digest {D : Type*} (digest : A → D) (hinj : Function.Injective digest)
    (attested candidate : A) (h : digest candidate = digest attested) :
    candidate = attested :=
  hinj h

/-- End to end: matching the published digest of a reproducible build means the
deployed artifact is the one the source produces. -/
theorem deployed_of_matching_digest {D : Type*} (tc : Toolchain A) (digest : A → D)
    (hinj : Function.Injective digest) (source : A) (steps : List (Step A))
    (candidate : A)
    (h : tc.Valid source steps)
    (hdig : digest candidate = digest (deployed source steps)) :
    candidate = tc.rebuild source (steps.map Step.tool) := by
  rw [hinj hdig]
  exact deployed_eq_rebuild tc source steps h

end RequestProject.Market
