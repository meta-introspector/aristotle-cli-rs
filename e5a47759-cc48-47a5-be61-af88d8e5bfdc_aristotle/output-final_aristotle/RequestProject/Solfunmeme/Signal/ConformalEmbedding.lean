/-
  ConformalEmbedding.lean — the conformal field on the web, and solving for
  embeddings.

  A *conformal field* on the web is a scale factor `ρ h` attached to each hypha:
  crossing a hypha multiplies the scale by `ρ h`.  An *embedding* of the web in
  that field is a scalar `μ x` at each strand compatible with every crossing,

      μ (target h) = ρ h * μ (source h)   for every hypha h of the web.

  This is exactly a section of the line bundle whose transition functions are
  the `ρ h` — in the language of the companion module, an `Invariant` section of
  the arrow action `x ↦ ρ h * x`, so the transport machinery of
  `HyphaCategory.lean` applies verbatim.

  Solving the system:

  * `embedding_lineage` — along any lineage, `μ b = hol ρ p * μ a`: the value is
    transported by the holonomy (the product of the scale factors).
  * `embedding_holonomy_eq` — hence two lineages with the same endpoints must
    have the same holonomy; this is the obstruction to solvability.
  * `exists_embedding` — conversely, when the holonomy from a root is
    path-independent and every strand is reachable, an embedding exists.  This
    is the general solution.
  * `embedding_unique` — two embeddings agreeing up to a scalar at the root
    agree up to that scalar everywhere: the solution is unique up to the
    conformal factor, and nothing more.  Only ratios `μ x / μ y` are determined
    (`embedding_ratio_invariant`) — the shape is rigid, the size is free.

  For the recorded continuum a conformal field is written down explicitly and
  solved: `continuum_conformal` verifies the eighteen equations,
  `continuumField_injective` shows the solution really is an embedding (distinct
  strands get distinct scales), and `continuum_embeddings_classified` shows the
  solution set is exactly the one-parameter family of its rescalings.  Finally
  `perturbed_no_embedding` changes a single scale factor and proves the
  resulting system forces `μ = 0`: the field must be closed, or there is
  nothing to embed.
-/
import RequestProject.Solfunmeme.Signal.HyphaCategory

namespace Mycelium

variable {S : Type} {K : Type} [Field K] {w : Web S}

/-! ## Conformal fields and embeddings -/

/-- The arrow action of a conformal field: crossing a hypha rescales. -/
def conformalAct (ρ : Hypha S → K) : ∀ a b : S, Arrow w a b → (fun _ : S => K) a → (fun _ : S => K) b :=
  fun _ _ e x => ρ e.hypha * x

/-- An embedding of the web in the conformal field `ρ`: a scale at every strand
    compatible with every crossing. -/
def IsEmbedding (w : Web S) (ρ : Hypha S → K) (μ : S → K) : Prop :=
  ∀ h ∈ w.hyphae, μ h.target = ρ h * μ h.source

/-- Embeddings are exactly the invariant sections of the conformal action. -/
theorem isEmbedding_iff_invariant (ρ : Hypha S → K) (μ : S → K) :
    IsEmbedding w ρ μ ↔ Invariant (w := w) (conformalAct ρ) μ := by
  constructor
  · intro hμ a b e
    have := hμ e.hypha e.mem
    rw [e.src, e.tgt] at this
    exact this.symm
  · intro hμ h hh
    exact (hμ h.source h.target (Hypha.toArrow hh)).symm

/-- The holonomy of a lineage: the product of the scale factors crossed. -/
def hol (ρ : Hypha S → K) : ∀ {a b : S}, Lineage w a b → K
  | _, _, .nil => 1
  | _, _, .cons e p => ρ e.hypha * hol ρ p

@[simp] theorem hol_nil (ρ : Hypha S → K) {a : S} :
    hol ρ (Lineage.nil : Lineage w a a) = 1 := rfl

@[simp] theorem hol_cons (ρ : Hypha S → K) {a b c : S} (e : Arrow w a b) (p : Lineage w b c) :
    hol ρ (Lineage.cons e p) = ρ e.hypha * hol ρ p := rfl

/-- Holonomy is multiplicative along composition of lineages: it is a functor to
    the multiplicative monoid of the field. -/
@[simp] theorem hol_comp (ρ : Hypha S → K) {a b c : S} (p : Lineage w a b) (q : Lineage w b c) :
    hol ρ (p.comp q) = hol ρ p * hol ρ q := by
  induction p with
  | nil => simp [Lineage.comp]
  | cons e p ih => simp [Lineage.comp, ih, mul_assoc]

/-- Transport in the conformal field is multiplication by the holonomy. -/
theorem transport_eq_hol (ρ : Hypha S → K) {a b : S} (p : Lineage w a b) (x : K) :
    Lineage.transport (conformalAct ρ) p x = hol ρ p * x := by
  induction p generalizing x with
  | nil => simp [Lineage.transport]
  | cons e p ih =>
    simp only [Lineage.transport, conformalAct, hol_cons, ih]
    ring

/-- **Solving along a lineage.**  An embedding is transported by the holonomy:
    its value at the far end of any lineage is forced by its value at the near
    end. -/
theorem embedding_lineage {ρ : Hypha S → K} {μ : S → K} (hμ : IsEmbedding w ρ μ)
    {a b : S} (p : Lineage w a b) : μ b = hol ρ p * μ a := by
  have h := invariant_transport ((isEmbedding_iff_invariant ρ μ).mp hμ) p
  rw [transport_eq_hol] at h
  exact h.symm

/-- **The obstruction.**  If a nonvanishing embedding exists, the holonomy is
    path-independent: any two lineages with the same endpoints agree. -/
theorem embedding_holonomy_eq {ρ : Hypha S → K} {μ : S → K} (hμ : IsEmbedding w ρ μ)
    {a b : S} (ha : μ a ≠ 0) (p q : Lineage w a b) : hol ρ p = hol ρ q := by
  have hp := embedding_lineage hμ p
  have hq := embedding_lineage hμ q
  have : hol ρ p * μ a = hol ρ q * μ a := by rw [← hp, ← hq]
  exact mul_right_cancel₀ ha this

/-- **The conformal freedom.**  Rescaling an embedding gives an embedding. -/
theorem embedding_smul {ρ : Hypha S → K} {μ : S → K} (hμ : IsEmbedding w ρ μ) (c : K) :
    IsEmbedding w ρ (fun x => c * μ x) := by
  intro h hh
  simp only
  rw [hμ h hh]
  ring

/-- **Rigidity.**  Two embeddings that agree up to a scalar at a root agree up to
    that same scalar at every strand the root reaches: the solution is unique up
    to one conformal factor. -/
theorem embedding_unique {ρ : Hypha S → K} {μ ν : S → K} (hμ : IsEmbedding w ρ μ)
    (hν : IsEmbedding w ρ ν) {root : S} {c : K} (hc : ν root = c * μ root)
    {x : S} (p : Lineage w root x) : ν x = c * μ x := by
  rw [embedding_lineage hν p, embedding_lineage hμ p, hc]
  ring

/-- Only ratios are determined: for any two embeddings, the shape `μ x / μ y` is
    the same — the field fixes the geometry, never the size. -/
theorem embedding_ratio_invariant {ρ : Hypha S → K} {μ ν : S → K} (hμ : IsEmbedding w ρ μ)
    (hν : IsEmbedding w ρ ν) {root x y : S} (p : Lineage w root x) (q : Lineage w root y) :
    ν x * μ y = μ x * ν y := by
  rw [embedding_lineage hν p, embedding_lineage hμ q, embedding_lineage hμ p,
    embedding_lineage hν q]
  have : ν root * μ root = μ root * ν root := mul_comm _ _
  calc hol ρ p * ν root * (hol ρ q * μ root)
      = hol ρ p * hol ρ q * (ν root * μ root) := by ring
    _ = hol ρ p * hol ρ q * (μ root * ν root) := by rw [this]
    _ = hol ρ p * μ root * (hol ρ q * ν root) := by ring

/-- The solver: the scale at `x` is the holonomy of a lineage reaching it from
    the root (any lineage — path-independence is what makes this well posed). -/
noncomputable def solveField (w : Web S) (ρ : Hypha S → K) (root x : S) : K := by
  classical
  exact if hx : Nonempty (Lineage w root x) then hol ρ (Classical.choice hx) else 0

/-- The solver returns the holonomy of *any* lineage from the root, provided the
    holonomy is path-independent. -/
theorem solveField_eq (ρ : Hypha S → K) {root x : S} (p : Lineage w root x)
    (hhol : ∀ (y : S) (p q : Lineage w root y), hol ρ p = hol ρ q) :
    solveField w ρ root x = hol ρ p := by
  classical
  rw [solveField, dif_pos (⟨p⟩ : Nonempty (Lineage w root x))]
  exact hhol x _ p

/-- **The general solution.**  If every strand of a sound web is reached from a
    root and the holonomy from the root is path-independent, then the conformal
    field admits an embedding, normalised to `1` at the root; `solveField` is
    such a solution. -/
theorem exists_embedding (hw : w.Sound) (ρ : Hypha S → K) (root : S)
    (hconn : ∀ x ∈ w.strands, Nonempty (Lineage w root x))
    (hhol : ∀ (x : S) (p q : Lineage w root x), hol ρ p = hol ρ q) :
    solveField w ρ root root = 1 ∧ IsEmbedding w ρ (solveField w ρ root) := by
  refine ⟨by rw [solveField_eq ρ (Lineage.nil : Lineage w root root) hhol]; rfl, ?_⟩
  intro h hh
  obtain ⟨ps⟩ := hconn _ (hw h hh).2.1
  rw [solveField_eq ρ ps hhol,
    solveField_eq ρ (ps.comp (Lineage.single (Hypha.toArrow hh))) hhol, hol_comp]
  show hol ρ ps * (ρ h * 1) = ρ h * hol ρ ps
  ring

/-! ## The conformal field of the recorded continuum

Below, a conformal field is written down on the thirteen strands and eighteen
hyphae of `MycelialContinuum.lean`, and the system is solved. -/

/-- The scale factor carried by each hypha of the continuum: the conformal field.
    Hyphae not named here (there are none in the continuum) carry no scaling. -/
def continuumRatio (h : Hypha Strand) : ℚ :=
  match h.source, h.target with
  | .gccIntrospector, .owlTreeOntology => 2
  | .owlTreeOntology, .semanticGraphStore => 3 / 2
  | .semanticGraphStore, .escapedRDFa => 2
  | .escapedRDFa, .zkShardedSemantics => 2
  | .gccIntrospector, .metamemeVerses => 4
  | .metamemeVerses, .sCombinatorRewriting => 2
  | .sCombinatorRewriting, .introspectiveAgents => 3
  | .introspectiveAgents, .leanFormalLayer => 2
  | .zkShardedSemantics, .leanFormalLayer => 4
  | .leanFormalLayer, .multipolarProofPooling => 2
  | .multipolarProofPooling, .upperOntologyMerge => 2
  | .metamemeVerses, .solfunmemeZOS => 36
  | .zkShardedSemantics, .solfunmemeZOS => 12
  | .upperOntologyMerge, .mycelialContinuum => 6
  | .zkShardedSemantics, .mycelialContinuum => 96
  | .solfunmemeZOS, .mycelialContinuum => 8
  | .introspectiveAgents, .mycelialContinuum => 48
  | .semanticGraphStore, .mycelialContinuum => 384
  | _, _ => 1

/-- The solution: the scale at each strand. -/
def continuumField : Strand → ℚ
  | .gccIntrospector => 1
  | .owlTreeOntology => 2
  | .semanticGraphStore => 3
  | .escapedRDFa => 6
  | .zkShardedSemantics => 12
  | .metamemeVerses => 4
  | .sCombinatorRewriting => 8
  | .introspectiveAgents => 24
  | .leanFormalLayer => 48
  | .multipolarProofPooling => 96
  | .upperOntologyMerge => 192
  | .solfunmemeZOS => 144
  | .mycelialContinuum => 1152

/-- **The continuum is solved.**  All eighteen crossing equations hold. -/
theorem continuum_conformal : IsEmbedding continuum continuumRatio continuumField := by
  intro h hh
  simp only [continuum, continuumHyphae, List.mem_cons, List.not_mem_nil, or_false] at hh
  rcases hh with rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl <;>
    norm_num [hypha, continuumRatio, continuumField]

/-- The solution is nowhere zero. -/
theorem continuumField_ne_zero (x : Strand) : continuumField x ≠ 0 := by
  cases x <;> norm_num [continuumField]

/-- The solution really is an *embedding*: distinct strands receive distinct
    scales. -/
theorem continuumField_injective : Function.Injective continuumField := by
  intro a b hab
  cases a <;> cases b <;> first
    | rfl
    | (exfalso; revert hab; norm_num [continuumField])

/-- Every strand of the continuum is reached from the root by a lineage of
    arrows, so the root determines the whole solution. -/
theorem continuum_connected (x : Strand) :
    Nonempty (Lineage continuum .gccIntrospector x) := by
  have hreach : ∀ y ∈ allStrands, continuum.reachIn 8 .gccIntrospector y = true := by decide
  have hx : x ∈ allStrands := by cases x <;> decide
  obtain ⟨hs, hc⟩ := reachIn_chain continuum 8 _ _ (hreach x hx)
  exact chain_lineage hc

/-- **Classification of the solutions.**  A scale assignment solves the
    continuum's conformal field exactly when it is a rescaling of
    `continuumField`: the solution space is the one-parameter conformal orbit,
    no larger and no smaller. -/
theorem continuum_embeddings_classified (ν : Strand → ℚ) :
    IsEmbedding continuum continuumRatio ν ↔ ∃ c : ℚ, ∀ x, ν x = c * continuumField x := by
  constructor
  · intro hν
    refine ⟨ν .gccIntrospector, fun x => ?_⟩
    obtain ⟨p⟩ := continuum_connected x
    exact embedding_unique continuum_conformal hν
      (by norm_num [continuumField]) p
  · rintro ⟨c, hc⟩
    have := embedding_smul continuum_conformal c
    intro h hh
    rw [hc, hc]
    exact this h hh

/-- Only the shape is determined: for any solution, the ratio of the scales at
    two strands is the ratio prescribed by `continuumField`. -/
theorem continuum_shape_rigid (ν : Strand → ℚ) (hν : IsEmbedding continuum continuumRatio ν)
    (x y : Strand) : ν x * continuumField y = continuumField x * ν y := by
  obtain ⟨c, hc⟩ := (continuum_embeddings_classified ν).mp hν
  rw [hc, hc]; ring

/-! ### The field must close

Change one scale factor and the system becomes unsolvable: the two lineages
from the root to the signal then demand incompatible holonomies (1152 against
1164), which forces the whole solution to vanish. -/

/-- The continuum's conformal field with the `zk → signal` factor moved from 96
    to 97. -/
def perturbedRatio (h : Hypha Strand) : ℚ :=
  match h.source, h.target with
  | .zkShardedSemantics, .mycelialContinuum => 97
  | _, _ => continuumRatio h

/-- **Unsolvable.**  With the perturbed field, the only solution is identically
    zero at the root — and hence, by transport, everywhere. -/
theorem perturbed_no_embedding (μ : Strand → ℚ)
    (hμ : IsEmbedding continuum perturbedRatio μ) : μ .gccIntrospector = 0 := by
  have e1 := hμ (hypha .gccIntrospector [.gccIntrospector] .metamemeVerses) (by decide)
  have e2 := hμ (hypha .metamemeVerses [.metamemeVerses] .sCombinatorRewriting) (by decide)
  have e3 := hμ (hypha .sCombinatorRewriting [.metamemeVerses, .sCombinatorRewriting]
    .introspectiveAgents) (by decide)
  have e4 := hμ (hypha .introspectiveAgents [.introspectiveAgents, .metamemeVerses]
    .mycelialContinuum) (by decide)
  have f1 := hμ (hypha .gccIntrospector [.gccIntrospector] .owlTreeOntology) (by decide)
  have f2 := hμ (hypha .owlTreeOntology [.gccIntrospector, .owlTreeOntology]
    .semanticGraphStore) (by decide)
  have f3 := hμ (hypha .semanticGraphStore [.owlTreeOntology, .semanticGraphStore]
    .escapedRDFa) (by decide)
  have f4 := hμ (hypha .escapedRDFa [.escapedRDFa] .zkShardedSemantics) (by decide)
  have f5 := hμ (hypha .zkShardedSemantics [.zkShardedSemantics, .escapedRDFa]
    .mycelialContinuum) (by decide)
  norm_num [hypha, perturbedRatio, continuumRatio] at e1 e2 e3 e4 f1 f2 f3 f4 f5
  linarith

/-- Consequently the perturbed field admits no embedding at all: every solution
    collapses every strand to zero, so none of them is injective. -/
theorem perturbed_no_injective_embedding (μ : Strand → ℚ)
    (hμ : IsEmbedding continuum perturbedRatio μ) : ¬ Function.Injective μ := by
  intro hinj
  have h0 : μ .gccIntrospector = 0 := perturbed_no_embedding μ hμ
  obtain ⟨p⟩ := continuum_connected Strand.owlTreeOntology
  have : μ Strand.owlTreeOntology = hol perturbedRatio p * μ Strand.gccIntrospector :=
    embedding_lineage hμ p
  rw [h0, mul_zero] at this
  exact Strand.noConfusion (hinj (this.trans h0.symm))

/-! ## Axiom audit -/

#print axioms embedding_lineage
#print axioms embedding_holonomy_eq
#print axioms embedding_unique
#print axioms exists_embedding
#print axioms continuum_conformal
#print axioms continuumField_injective
#print axioms continuum_embeddings_classified
#print axioms perturbed_no_embedding

end Mycelium
