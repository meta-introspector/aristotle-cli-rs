/-
  Cohomology.lean — the obstruction is a cohomology class.

  `ConformalEmbedding.lean` showed that a conformal field on the web is
  solvable exactly when its holonomy is path-independent, and that moving a
  single scale factor destroys solvability.  This module explains *why* in the
  proper language: an assignment of weights to the hyphae is a 1-cochain, an
  assignment of levels to the strands is a 0-cochain, and solvability is the
  statement that the 1-cochain is a coboundary.  The obstruction is therefore a
  class in the first cohomology group of the web, and that group is computed.

  Contents.

  * `Step`, `Walk` — the *undirected* paths of the web: a hypha may be crossed
    forwards or backwards.  This is what cohomology needs; the directed
    lineages of `HyphaCategory.lean` are not enough, because a web with no
    directed cycle at all (the continuum is one) can still carry a nontrivial
    class.
  * `wsum` — the signed sum of a cochain along a walk; additive in the cochain,
    additive along concatenation, negated by reversal.
  * `IsCoboundary` — the cochain comes from a potential on the strands.
  * `Spanning` — a choice of walk from a root to every strand, and the
    associated potential `pot` and `defect`.  `coboundary_iff_defect_zero` is
    the computational heart: a cochain is a coboundary iff its defect vanishes
    on every hypha, and the defect is linear in the cochain.
  * `coboundaries`, `H1` — the coboundaries form a subgroup of the 1-cochains
    and `H1 w G` is the quotient: the first cohomology of the web with
    coefficients in `G`.  `H1_eq_zero_iff` identifies the vanishing of a class
    with solvability.
  * `padic_coboundary_of_embedding` — the bridge: whenever a positive conformal
    field admits a nowhere-zero embedding, its `p`-adic valuation is a
    coboundary.  So a nonzero cohomology class obstructs embeddings.
  * The recorded continuum, with an explicit spanning tree: twelve tree hyphae
    and six chords.  `continuum_coboundary_iff` reduces solvability to six
    explicit linear equations; the constant cochain fails them (`the web has no
    global clock`); the 2-adic valuation of the conformal field satisfies them;
    the perturbed field does not.  Finally `continuum_H1_equiv` computes
    `H¹(continuum; ℤ) ≃+ ℤ⁶`: the web carries exactly six independent
    obstructions, one per chord.
-/
import RequestProject.Solfunmeme.Signal.ConformalEmbedding
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.GroupTheory.QuotientGroup.Basic

namespace Mycelium

variable {S : Type} {G : Type} [AddCommGroup G] {w : Web S}

/-! ## Undirected walks -/

/-- A step of a walk: a hypha of the web crossed forwards or backwards. -/
inductive Step (w : Web S) : S → S → Type where
  /-- Cross a hypha in the direction it points. -/
  | fwd {a b : S} : Arrow w a b → Step w a b
  /-- Cross a hypha against the direction it points. -/
  | bwd {a b : S} : Arrow w a b → Step w b a

/-- A walk: a finite sequence of steps.  Unlike a lineage, a walk may go
    against the grain of the web. -/
inductive Walk (w : Web S) : S → S → Type where
  /-- The empty walk. -/
  | nil {a : S} : Walk w a a
  /-- Prefix a step to a walk. -/
  | cons {a b c : S} : Step w a b → Walk w b c → Walk w a c

namespace Walk

variable {w : Web S}

/-- The one-step walk. -/
def one {a b : S} (s : Step w a b) : Walk w a b := .cons s .nil

/-- Concatenation of walks. -/
def append : ∀ {a b c : S}, Walk w a b → Walk w b c → Walk w a c
  | _, _, _, .nil, q => q
  | _, _, _, .cons s p, q => .cons s (append p q)

@[simp] theorem nil_append {a b : S} (p : Walk w a b) : Walk.nil.append p = p := rfl

@[simp] theorem append_nil {a b : S} (p : Walk w a b) : p.append .nil = p := by
  induction p with
  | nil => rfl
  | cons s p ih => simp [append, ih]

/-- Reversal of a walk. -/
def reverse : ∀ {a b : S}, Walk w a b → Walk w b a
  | _, _, .nil => .nil
  | _, _, .cons (.fwd e) p => (reverse p).append (one (.bwd e))
  | _, _, .cons (.bwd e) p => (reverse p).append (one (.fwd e))

/-- Every lineage is a walk. -/
def ofLineage : ∀ {a b : S}, Lineage w a b → Walk w a b
  | _, _, .nil => .nil
  | _, _, .cons e p => .cons (.fwd e) (ofLineage p)

/-- The hyphae crossed by a walk. -/
def hyphaeList : ∀ {a b : S}, Walk w a b → List (Hypha S)
  | _, _, .nil => []
  | _, _, .cons (.fwd e) p => e.hypha :: p.hyphaeList
  | _, _, .cons (.bwd e) p => e.hypha :: p.hyphaeList

end Walk

/-! ## Cochains -/

/-- The signed sum of a 1-cochain along a walk: forwards steps add, backwards
    steps subtract.  This is the discrete line integral. -/
def wsum (ρ : Hypha S → G) : ∀ {a b : S}, Walk w a b → G
  | _, _, .nil => 0
  | _, _, .cons (.fwd e) p => ρ e.hypha + wsum ρ p
  | _, _, .cons (.bwd e) p => -ρ e.hypha + wsum ρ p

@[simp] theorem wsum_nil (ρ : Hypha S → G) {a : S} :
    wsum ρ (Walk.nil : Walk w a a) = 0 := rfl

@[simp] theorem wsum_fwd (ρ : Hypha S → G) {a b c : S} (e : Arrow w a b) (p : Walk w b c) :
    wsum ρ (Walk.cons (.fwd e) p) = ρ e.hypha + wsum ρ p := rfl

@[simp] theorem wsum_bwd (ρ : Hypha S → G) {a b c : S} (e : Arrow w a b) (p : Walk w a c) :
    wsum ρ (Walk.cons (.bwd e) p) = -ρ e.hypha + wsum ρ p := rfl

@[simp] theorem wsum_append (ρ : Hypha S → G) {a b c : S} (p : Walk w a b) (q : Walk w b c) :
    wsum ρ (p.append q) = wsum ρ p + wsum ρ q := by
  induction p with
  | nil => simp [Walk.append]
  | cons s p ih =>
    cases s <;> simp [Walk.append, wsum, ih, add_assoc]

@[simp] theorem wsum_reverse (ρ : Hypha S → G) {a b : S} (p : Walk w a b) :
    wsum ρ p.reverse = -wsum ρ p := by
  induction p with
  | nil => simp [Walk.reverse]
  | cons s p ih =>
    cases s with
    | fwd e => simp [Walk.reverse, Walk.one, wsum, ih]
    | bwd e => simp [Walk.reverse, Walk.one, wsum, ih]

/-- The signed sum is additive in the cochain. -/
theorem wsum_add (ρ σ : Hypha S → G) {a b : S} (p : Walk w a b) :
    wsum (fun h => ρ h + σ h) p = wsum ρ p + wsum σ p := by
  induction p with
  | nil => simp
  | cons s p ih => cases s <;> simp [wsum, ih] <;> abel

theorem wsum_neg (ρ : Hypha S → G) {a b : S} (p : Walk w a b) :
    wsum (fun h => -ρ h) p = -wsum ρ p := by
  induction p with
  | nil => simp
  | cons s p ih => cases s <;> simp [wsum, ih] <;> abel

/-- Cochains that agree on the web's hyphae have the same sums. -/
theorem wsum_congr {ρ σ : Hypha S → G} (h : ∀ g ∈ w.hyphae, ρ g = σ g) {a b : S}
    (p : Walk w a b) : wsum ρ p = wsum σ p := by
  induction p with
  | nil => rfl
  | cons s p ih => cases s with
    | fwd e => simp [wsum, ih, h _ e.mem]
    | bwd e => simp [wsum, ih, h _ e.mem]

/-- A cochain vanishing on every hypha the walk crosses sums to zero. -/
theorem wsum_eq_zero {ρ : Hypha S → G} {a b : S} (p : Walk w a b)
    (h : ∀ g ∈ p.hyphaeList, ρ g = 0) : wsum ρ p = 0 := by
  induction p with
  | nil => rfl
  | cons s p ih => cases s with
    | fwd e =>
      simp [wsum, Walk.hyphaeList] at h ⊢
      simp [h.1, ih h.2]
    | bwd e =>
      simp [wsum, Walk.hyphaeList] at h ⊢
      simp [h.1, ih h.2]

/-! ## Coboundaries -/

/-- The coboundary of a 0-cochain (a potential on the strands). -/
def delta (μ : S → G) : Hypha S → G := fun h => μ h.target - μ h.source

/-- A 1-cochain is a *coboundary* when it is the difference of a potential
    across every hypha of the web. -/
def IsCoboundary (w : Web S) (ρ : Hypha S → G) : Prop :=
  ∃ μ : S → G, ∀ h ∈ w.hyphae, ρ h = μ h.target - μ h.source

/-- Coboundaries telescope: the signed sum of `delta μ` along any walk is the
    difference of the potential at the endpoints. -/
theorem wsum_delta (μ : S → G) {a b : S} (p : Walk w a b) :
    wsum (delta μ) p = μ b - μ a := by
  induction p with
  | nil => simp
  | cons s p ih => cases s with
    | fwd e =>
      simp only [wsum, ih, delta, e.src, e.tgt]
      abel
    | bwd e =>
      simp only [wsum, ih, delta, e.src, e.tgt]
      abel

/-- A coboundary has path-independent sums: the value along a walk depends only
    on the endpoints. -/
theorem wsum_path_independent {ρ : Hypha S → G} (hρ : IsCoboundary w ρ) {a b : S}
    (p q : Walk w a b) : wsum ρ p = wsum ρ q := by
  obtain ⟨μ, hμ⟩ := hρ
  rw [wsum_congr (σ := delta μ) (fun g hg => hμ g hg) p,
    wsum_congr (σ := delta μ) (fun g hg => hμ g hg) q, wsum_delta, wsum_delta]

/-- **Closed walks detect the obstruction.**  Around any closed walk, a
    coboundary sums to zero. -/
theorem wsum_closed_eq_zero {ρ : Hypha S → G} (hρ : IsCoboundary w ρ) {a : S}
    (p : Walk w a a) : wsum ρ p = 0 := by
  have := wsum_path_independent hρ p (Walk.nil : Walk w a a)
  simpa using this

/-! ## Potentials from a spanning choice, and the defect -/

/-- A spanning choice: a walk from the root to every strand.  (For a connected
    web such a choice always exists; a spanning tree is the economical one.) -/
structure Spanning (w : Web S) (root : S) where
  /-- The chosen walk to each strand. -/
  walk : ∀ x : S, Walk w root x

variable {root : S}

/-- The potential a cochain induces along a spanning choice. -/
def Spanning.pot (T : Spanning w root) (ρ : Hypha S → G) (x : S) : G := wsum ρ (T.walk x)

/-- The defect of a cochain at a hypha: by how much the cochain fails to be the
    coboundary of its own induced potential. -/
def Spanning.defect (T : Spanning w root) (ρ : Hypha S → G) (h : Hypha S) : G :=
  ρ h - (T.pot ρ h.target - T.pot ρ h.source)

/-- The defect is additive in the cochain. -/
theorem Spanning.defect_add (T : Spanning w root) (ρ σ : Hypha S → G) (h : Hypha S) :
    T.defect (fun g => ρ g + σ g) h = T.defect ρ h + T.defect σ h := by
  simp only [Spanning.defect, Spanning.pot, wsum_add]
  abel

theorem Spanning.defect_neg (T : Spanning w root) (ρ : Hypha S → G) (h : Hypha S) :
    T.defect (fun g => -ρ g) h = -T.defect ρ h := by
  simp only [Spanning.defect, Spanning.pot, wsum_neg]
  abel

@[simp] theorem Spanning.defect_zero (T : Spanning w root) (h : Hypha S) :
    T.defect (fun _ => (0 : G)) h = 0 := by
  have : ∀ x : S, T.pot (fun _ => (0 : G)) x = 0 := by
    intro x
    exact wsum_eq_zero _ (fun _ _ => rfl)
  simp [Spanning.defect, this]

/-- A coboundary has no defect. -/
theorem Spanning.defect_of_coboundary (T : Spanning w root) {ρ : Hypha S → G}
    (hρ : IsCoboundary w ρ) {h : Hypha S} (hh : h ∈ w.hyphae) : T.defect ρ h = 0 := by
  obtain ⟨μ, hμ⟩ := hρ
  have hpot : ∀ x : S, T.pot ρ x = μ x - μ root := by
    intro x
    rw [Spanning.pot, wsum_congr (σ := delta μ) (fun g hg => hμ g hg), wsum_delta]
  simp only [Spanning.defect, hpot, hμ h hh]
  abel

/-- **The computational criterion.**  A 1-cochain is a coboundary exactly when
    its defect vanishes on every hypha of the web — and then the potential is
    the one the spanning choice induces. -/
theorem Spanning.coboundary_iff_defect_zero (T : Spanning w root) (ρ : Hypha S → G) :
    IsCoboundary w ρ ↔ ∀ h ∈ w.hyphae, T.defect ρ h = 0 := by
  constructor
  · intro hρ h hh
    exact T.defect_of_coboundary hρ hh
  · intro hd
    refine ⟨T.pot ρ, fun h hh => ?_⟩
    have := hd h hh
    simp only [Spanning.defect, sub_eq_zero] at this
    exact this

/-! ## The first cohomology group of a web -/

/-- The coboundaries form a subgroup of the 1-cochains. -/
def coboundaries (w : Web S) (G : Type) [AddCommGroup G] : AddSubgroup (Hypha S → G) where
  carrier := {ρ | IsCoboundary w ρ}
  zero_mem' := ⟨fun _ => 0, fun _ _ => by simp⟩
  add_mem' := by
    rintro ρ σ ⟨μ, hμ⟩ ⟨ν, hν⟩
    exact ⟨fun x => μ x + ν x, fun h hh => by
      simp only [Pi.add_apply, hμ h hh, hν h hh]; abel⟩
  neg_mem' := by
    rintro ρ ⟨μ, hμ⟩
    exact ⟨fun x => -μ x, fun h hh => by
      simp only [Pi.neg_apply, hμ h hh]; abel⟩

/-- The first cohomology of the web with coefficients in `G`: 1-cochains modulo
    coboundaries.  (There are no 2-cells, so every 1-cochain is a cocycle.) -/
abbrev H1 (w : Web S) (G : Type) [AddCommGroup G] := (Hypha S → G) ⧸ coboundaries w G

/-- The class of a cochain. -/
def cls (w : Web S) (ρ : Hypha S → G) : H1 w G := QuotientAddGroup.mk' (coboundaries w G) ρ

/-- **A class vanishes exactly when the cochain is solvable.** -/
theorem cls_eq_zero_iff (ρ : Hypha S → G) : cls w ρ = 0 ↔ IsCoboundary w ρ := by
  rw [cls, QuotientAddGroup.mk'_apply, QuotientAddGroup.eq_zero_iff]
  rfl

/-- Two cochains have the same class exactly when they differ by a coboundary. -/
theorem cls_eq_iff (ρ σ : Hypha S → G) :
    cls w ρ = cls w σ ↔ IsCoboundary w (fun h => ρ h - σ h) := by
  rw [cls, cls, QuotientAddGroup.mk'_apply, QuotientAddGroup.mk'_apply,
    QuotientAddGroup.eq_iff_sub_mem]
  rfl

/-! ## The bridge: valuations turn conformal fields into cochains -/

/-- **Multiplicative to additive.**  If a positive conformal field admits a
    nowhere-zero embedding, then its `p`-adic valuation is a coboundary: the
    valuation of the solution is the potential.  Contrapositively, a nonzero
    class obstructs every nowhere-zero embedding. -/
theorem padic_coboundary_of_embedding {p : ℕ} [hp : Fact p.Prime] {ρ : Hypha S → ℚ}
    {μ : S → ℚ} (hρ : ∀ h, ρ h ≠ 0) (hμ : ∀ x, μ x ≠ 0) (hemb : IsEmbedding w ρ μ) :
    IsCoboundary w (fun h => padicValRat p (ρ h)) := by
  refine ⟨fun x => padicValRat p (μ x), fun h hh => ?_⟩
  show padicValRat p (ρ h) = padicValRat p (μ h.target) - padicValRat p (μ h.source)
  rw [hemb h hh, padicValRat.mul (hρ h) (hμ h.source)]
  abel

/-! ## The recorded continuum: an explicit spanning tree

The continuum has thirteen strands and eighteen hyphae, so a spanning tree uses
twelve of them and leaves six *chords*.  Cohomology is therefore expected to be
`ℤ⁶`, and that is what is proved below. -/

/-- An arrow of the continuum, named by its source, premises and target. -/
def carr (src : Strand) (prem : List Strand) (tgt : Strand)
    (h : hypha src prem tgt ∈ continuum.hyphae := by decide) : Arrow continuum src tgt :=
  ⟨hypha src prem tgt, h, rfl, rfl⟩

/-! ### The twelve tree hyphae -/

/-- root → OWL ontology. -/
def tOwl : Hypha Strand := hypha .gccIntrospector [.gccIntrospector] .owlTreeOntology
/-- OWL ontology → semantic graph store. -/
def tStore : Hypha Strand :=
  hypha .owlTreeOntology [.gccIntrospector, .owlTreeOntology] .semanticGraphStore
/-- semantic graph store → escaped RDFa. -/
def tRDFa : Hypha Strand :=
  hypha .semanticGraphStore [.owlTreeOntology, .semanticGraphStore] .escapedRDFa
/-- escaped RDFa → zk-sharded semantics. -/
def tZk : Hypha Strand := hypha .escapedRDFa [.escapedRDFa] .zkShardedSemantics
/-- root → metameme verses. -/
def tMeta : Hypha Strand := hypha .gccIntrospector [.gccIntrospector] .metamemeVerses
/-- metameme verses → S-combinator rewriting. -/
def tComb : Hypha Strand := hypha .metamemeVerses [.metamemeVerses] .sCombinatorRewriting
/-- S-combinator rewriting → introspective agents. -/
def tAgents : Hypha Strand :=
  hypha .sCombinatorRewriting [.metamemeVerses, .sCombinatorRewriting] .introspectiveAgents
/-- introspective agents → the Lean formal layer. -/
def tLean : Hypha Strand := hypha .introspectiveAgents [.introspectiveAgents] .leanFormalLayer
/-- Lean formal layer → multipolar proof pooling. -/
def tPool : Hypha Strand := hypha .leanFormalLayer [.leanFormalLayer] .multipolarProofPooling
/-- multipolar proof pooling → upper-ontology merge. -/
def tMerge : Hypha Strand :=
  hypha .multipolarProofPooling [.multipolarProofPooling] .upperOntologyMerge
/-- metameme verses → SOLFUNMEME / ZOS. -/
def tZOS : Hypha Strand :=
  hypha .metamemeVerses [.metamemeVerses, .zkShardedSemantics] .solfunmemeZOS
/-- upper-ontology merge → the signal. -/
def tSignal : Hypha Strand :=
  hypha .upperOntologyMerge [.upperOntologyMerge, .multipolarProofPooling] .mycelialContinuum

/-! ### The six chords -/

/-- zk-sharded semantics → the Lean formal layer. -/
def kZkLean : Hypha Strand := hypha .zkShardedSemantics [.zkShardedSemantics] .leanFormalLayer
/-- zk-sharded semantics → SOLFUNMEME / ZOS. -/
def kZkZOS : Hypha Strand :=
  hypha .zkShardedSemantics [.zkShardedSemantics, .metamemeVerses] .solfunmemeZOS
/-- zk-sharded semantics → the signal. -/
def kZkSignal : Hypha Strand :=
  hypha .zkShardedSemantics [.zkShardedSemantics, .escapedRDFa] .mycelialContinuum
/-- SOLFUNMEME / ZOS → the signal. -/
def kZOSSignal : Hypha Strand :=
  hypha .solfunmemeZOS [.solfunmemeZOS, .metamemeVerses] .mycelialContinuum
/-- introspective agents → the signal. -/
def kAgentsSignal : Hypha Strand :=
  hypha .introspectiveAgents [.introspectiveAgents, .metamemeVerses] .mycelialContinuum
/-- semantic graph store → the signal. -/
def kStoreSignal : Hypha Strand :=
  hypha .semanticGraphStore [.semanticGraphStore, .owlTreeOntology] .mycelialContinuum

/-- The tree hyphae and the chords together are exactly the eighteen hyphae of
    the continuum, without repetition. -/
theorem continuum_tree_chord_split :
    continuum.hyphae.length = 18 ∧
    ([tOwl, tStore, tRDFa, tZk, tMeta, tComb, tAgents, tLean, tPool, tMerge, tZOS, tSignal,
      kZkLean, kZkZOS, kZkSignal, kZOSSignal, kAgentsSignal, kStoreSignal] : List (Hypha Strand)).Nodup ∧
    ∀ h ∈ continuum.hyphae, h ∈ ([tOwl, tStore, tRDFa, tZk, tMeta, tComb, tAgents, tLean, tPool,
      tMerge, tZOS, tSignal, kZkLean, kZkZOS, kZkSignal, kZOSSignal, kAgentsSignal,
      kStoreSignal] : List (Hypha Strand)) := by
  refine ⟨by decide, by decide, by decide⟩

/-- A spanning tree has one hypha fewer than there are strands, and the chords
    are the rest: `6 = 18 - 13 + 1`. -/
theorem continuum_tree_chord_count :
    ([tOwl, tStore, tRDFa, tZk, tMeta, tComb, tAgents, tLean, tPool, tMerge, tZOS,
      tSignal] : List (Hypha Strand)).length + 1 = continuum.strands.length ∧
    ([kZkLean, kZkZOS, kZkSignal, kZOSSignal, kAgentsSignal,
      kStoreSignal] : List (Hypha Strand)).length
      = continuum.hyphae.length - continuum.strands.length + 1 := by
  refine ⟨by decide, by decide⟩

/-! ### The tree walks -/

/-- The root's own walk. -/
def wRoot : Walk continuum .gccIntrospector .gccIntrospector := .nil
/-- The tree walk to the OWL ontology. -/
def wOwl : Walk continuum .gccIntrospector .owlTreeOntology :=
  Walk.one (.fwd (carr .gccIntrospector [.gccIntrospector] .owlTreeOntology))
/-- The tree walk to the semantic graph store. -/
def wStore : Walk continuum .gccIntrospector .semanticGraphStore :=
  wOwl.append (Walk.one (.fwd (carr .owlTreeOntology [.gccIntrospector, .owlTreeOntology]
    .semanticGraphStore)))
/-- The tree walk to escaped RDFa. -/
def wRDFa : Walk continuum .gccIntrospector .escapedRDFa :=
  wStore.append (Walk.one (.fwd (carr .semanticGraphStore [.owlTreeOntology, .semanticGraphStore]
    .escapedRDFa)))
/-- The tree walk to the zk-sharded semantics. -/
def wZk : Walk continuum .gccIntrospector .zkShardedSemantics :=
  wRDFa.append (Walk.one (.fwd (carr .escapedRDFa [.escapedRDFa] .zkShardedSemantics)))
/-- The tree walk to the metameme verses. -/
def wMeta : Walk continuum .gccIntrospector .metamemeVerses :=
  Walk.one (.fwd (carr .gccIntrospector [.gccIntrospector] .metamemeVerses))
/-- The tree walk to S-combinator rewriting. -/
def wComb : Walk continuum .gccIntrospector .sCombinatorRewriting :=
  wMeta.append (Walk.one (.fwd (carr .metamemeVerses [.metamemeVerses] .sCombinatorRewriting)))
/-- The tree walk to the introspective agents. -/
def wAgents : Walk continuum .gccIntrospector .introspectiveAgents :=
  wComb.append (Walk.one (.fwd (carr .sCombinatorRewriting
    [.metamemeVerses, .sCombinatorRewriting] .introspectiveAgents)))
/-- The tree walk to the Lean formal layer. -/
def wLean : Walk continuum .gccIntrospector .leanFormalLayer :=
  wAgents.append (Walk.one (.fwd (carr .introspectiveAgents [.introspectiveAgents]
    .leanFormalLayer)))
/-- The tree walk to multipolar proof pooling. -/
def wPool : Walk continuum .gccIntrospector .multipolarProofPooling :=
  wLean.append (Walk.one (.fwd (carr .leanFormalLayer [.leanFormalLayer]
    .multipolarProofPooling)))
/-- The tree walk to the upper-ontology merge. -/
def wMerge : Walk continuum .gccIntrospector .upperOntologyMerge :=
  wPool.append (Walk.one (.fwd (carr .multipolarProofPooling [.multipolarProofPooling]
    .upperOntologyMerge)))
/-- The tree walk to SOLFUNMEME / ZOS. -/
def wZOS : Walk continuum .gccIntrospector .solfunmemeZOS :=
  wMeta.append (Walk.one (.fwd (carr .metamemeVerses [.metamemeVerses, .zkShardedSemantics]
    .solfunmemeZOS)))
/-- The tree walk to the signal. -/
def wSignal : Walk continuum .gccIntrospector .mycelialContinuum :=
  wMerge.append (Walk.one (.fwd (carr .upperOntologyMerge
    [.upperOntologyMerge, .multipolarProofPooling] .mycelialContinuum)))

/-- The spanning tree of the continuum, rooted at the 2002 GCC introspector. -/
def continuumTree : Spanning continuum Strand.gccIntrospector where
  walk x := match x with
    | .gccIntrospector => wRoot
    | .owlTreeOntology => wOwl
    | .semanticGraphStore => wStore
    | .escapedRDFa => wRDFa
    | .zkShardedSemantics => wZk
    | .metamemeVerses => wMeta
    | .sCombinatorRewriting => wComb
    | .introspectiveAgents => wAgents
    | .leanFormalLayer => wLean
    | .multipolarProofPooling => wPool
    | .upperOntologyMerge => wMerge
    | .solfunmemeZOS => wZOS
    | .mycelialContinuum => wSignal

-- Everything needed to evaluate a potential or a defect on the continuum.
attribute [local simp] Spanning.pot Spanning.defect wRoot wOwl wStore wRDFa wZk wMeta wComb
  wAgents wLean wPool wMerge wZOS wSignal Walk.one Walk.append wsum carr hypha
  tOwl tStore tRDFa tZk tMeta tComb tAgents tLean tPool tMerge tZOS tSignal
  kZkLean kZkZOS kZkSignal kZOSSignal kAgentsSignal kStoreSignal continuumTree

/-! ### The six equations -/

/-- The six chord equations: what a weight on the eighteen attachments must
    satisfy to come from a level on the thirteen strands.  Each says that the
    chord's weight equals the difference of the tree potentials at its ends. -/
def ChordEquations (ρ : Hypha Strand → ℤ) : Prop :=
  ρ kZkLean = (ρ tMeta + ρ tComb + ρ tAgents + ρ tLean) - (ρ tOwl + ρ tStore + ρ tRDFa + ρ tZk) ∧
  ρ kZkZOS = (ρ tMeta + ρ tZOS) - (ρ tOwl + ρ tStore + ρ tRDFa + ρ tZk) ∧
  ρ kZkSignal = (ρ tMeta + ρ tComb + ρ tAgents + ρ tLean + ρ tPool + ρ tMerge + ρ tSignal)
      - (ρ tOwl + ρ tStore + ρ tRDFa + ρ tZk) ∧
  ρ kZOSSignal = (ρ tMeta + ρ tComb + ρ tAgents + ρ tLean + ρ tPool + ρ tMerge + ρ tSignal)
      - (ρ tMeta + ρ tZOS) ∧
  ρ kAgentsSignal = (ρ tMeta + ρ tComb + ρ tAgents + ρ tLean + ρ tPool + ρ tMerge + ρ tSignal)
      - (ρ tMeta + ρ tComb + ρ tAgents) ∧
  ρ kStoreSignal = (ρ tMeta + ρ tComb + ρ tAgents + ρ tLean + ρ tPool + ρ tMerge + ρ tSignal)
      - (ρ tOwl + ρ tStore)

/-- **Solvability, explicitly.**  A weight on the continuum's attachments is the
    coboundary of a level on its strands exactly when the six chord equations
    hold: twelve of the eighteen weights are free, the other six are forced. -/
theorem continuum_coboundary_iff (ρ : Hypha Strand → ℤ) :
    IsCoboundary continuum ρ ↔ ChordEquations ρ := by
  rw [continuumTree.coboundary_iff_defect_zero]
  constructor
  · intro hd
    have h0 := hd kZkLean (by decide)
    have h1 := hd kZkZOS (by decide)
    have h2 := hd kZkSignal (by decide)
    have h3 := hd kZOSSignal (by decide)
    have h4 := hd kAgentsSignal (by decide)
    have h5 := hd kStoreSignal (by decide)
    simp only [ChordEquations, tOwl, tStore, tRDFa, tZk, tMeta, tComb, tAgents, tLean, tPool,
      tMerge, tZOS, tSignal, kZkLean, kZkZOS, kZkSignal, kZOSSignal, kAgentsSignal,
      kStoreSignal, hypha]
    simp at h0 h1 h2 h3 h4 h5
    refine ⟨by linarith, by linarith, by linarith, by linarith, by linarith, by linarith⟩
  · rintro ⟨e0, e1, e2, e3, e4, e5⟩ h hh
    simp only [continuum, continuumHyphae, List.mem_cons, List.not_mem_nil, or_false] at hh
    simp only [tOwl, tStore, tRDFa, tZk, tMeta, tComb, tAgents, tLean, tPool, tMerge, tZOS,
      tSignal, kZkLean, kZkZOS, kZkSignal, kZOSSignal, kAgentsSignal, kStoreSignal,
      hypha] at e0 e1 e2 e3 e4 e5
    rcases hh with rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl <;>
      simp <;> linarith

/-! ### No global clock

The simplest cochain of all assigns weight `1` to every attachment.  Its
coboundary condition asks for a *generation number* on the strands advancing by
exactly one across every hypha.  The web does not admit one. -/

/-- **The web has no global clock.**  There is no way to number the strands so
    that every attachment advances the number by exactly one: the two routes
    from the root to the Lean formal layer have different lengths, and the
    obstruction is a nonzero cohomology class. -/
theorem continuum_no_generation_number :
    ¬ ∃ d : Strand → ℤ, ∀ h ∈ continuum.hyphae, d h.target = d h.source + 1 := by
  rintro ⟨d, hd⟩
  have hcob : IsCoboundary continuum (fun _ => (1 : ℤ)) :=
    ⟨d, fun h hh => by rw [hd h hh]; ring⟩
  obtain ⟨e0, -⟩ := (continuum_coboundary_iff _).mp hcob
  norm_num at e0

/-- Equivalently: the constant cochain is not a coboundary, so its class in
    `H¹(continuum; ℤ)` is nonzero. -/
theorem continuum_unit_class_ne_zero : cls continuum (fun _ => (1 : ℤ)) ≠ 0 := by
  rw [Ne, cls_eq_zero_iff]
  intro hcob
  obtain ⟨e0, -⟩ := (continuum_coboundary_iff _).mp hcob
  norm_num at e0

/-! ### The conformal field, additively

The scale factors of `ConformalEmbedding.lean` are products of powers of two and
three.  Their exponents are two integer cochains, and both are coboundaries —
which is exactly the solvability proved there, read through the valuations. -/

/-- The exponent of 2 in the continuum's scale factor. -/
def continuumExp2 (h : Hypha Strand) : ℤ :=
  match h.source, h.target with
  | .gccIntrospector, .owlTreeOntology => 1
  | .owlTreeOntology, .semanticGraphStore => -1
  | .semanticGraphStore, .escapedRDFa => 1
  | .escapedRDFa, .zkShardedSemantics => 1
  | .gccIntrospector, .metamemeVerses => 2
  | .metamemeVerses, .sCombinatorRewriting => 1
  | .sCombinatorRewriting, .introspectiveAgents => 0
  | .introspectiveAgents, .leanFormalLayer => 1
  | .zkShardedSemantics, .leanFormalLayer => 2
  | .leanFormalLayer, .multipolarProofPooling => 1
  | .multipolarProofPooling, .upperOntologyMerge => 1
  | .metamemeVerses, .solfunmemeZOS => 2
  | .zkShardedSemantics, .solfunmemeZOS => 2
  | .upperOntologyMerge, .mycelialContinuum => 1
  | .zkShardedSemantics, .mycelialContinuum => 5
  | .solfunmemeZOS, .mycelialContinuum => 3
  | .introspectiveAgents, .mycelialContinuum => 4
  | .semanticGraphStore, .mycelialContinuum => 7
  | _, _ => 0

/-- The exponent of 3 in the continuum's scale factor. -/
def continuumExp3 (h : Hypha Strand) : ℤ :=
  match h.source, h.target with
  | .owlTreeOntology, .semanticGraphStore => 1
  | .sCombinatorRewriting, .introspectiveAgents => 1
  | .metamemeVerses, .solfunmemeZOS => 2
  | .zkShardedSemantics, .solfunmemeZOS => 1
  | .upperOntologyMerge, .mycelialContinuum => 1
  | .zkShardedSemantics, .mycelialContinuum => 1
  | .introspectiveAgents, .mycelialContinuum => 1
  | .semanticGraphStore, .mycelialContinuum => 1
  | _, _ => 0

/-- Every scale factor of the continuum is `2^a · 3^b`, with `a` and `b` the two
    exponent cochains. -/
theorem continuum_ratio_factors (h : Hypha Strand) (hh : h ∈ continuum.hyphae) :
    continuumRatio h = (2 : ℚ) ^ continuumExp2 h * (3 : ℚ) ^ continuumExp3 h := by
  simp only [continuum, continuumHyphae, List.mem_cons, List.not_mem_nil, or_false] at hh
  rcases hh with rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl <;>
    norm_num [continuumRatio, continuumExp2, continuumExp3]

/-- **The solved field, additively.**  The exponents of 2 are a coboundary. -/
theorem continuumExp2_coboundary : IsCoboundary continuum continuumExp2 :=
  (continuum_coboundary_iff _).mpr (by unfold ChordEquations; decide)

/-- The exponents of 3 are a coboundary too. -/
theorem continuumExp3_coboundary : IsCoboundary continuum continuumExp3 :=
  (continuum_coboundary_iff _).mpr (by unfold ChordEquations; decide)

/-! ### The perturbed field carries a nonzero class -/

/-- The exponents of 2 with the `zk → signal` factor changed from `2⁵·3` to
    `3` — the additive form of the perturbation of `ConformalEmbedding.lean`. -/
def perturbedExp2 (h : Hypha Strand) : ℤ :=
  match h.source, h.target with
  | .zkShardedSemantics, .mycelialContinuum => 0
  | _, _ => continuumExp2 h

/-- **The perturbation is a cohomological obstruction.**  The perturbed
    exponents are not a coboundary: no level on the strands produces them. -/
theorem perturbedExp2_not_coboundary : ¬ IsCoboundary continuum perturbedExp2 := by
  intro hcob
  obtain ⟨-, -, e2, -⟩ := (continuum_coboundary_iff _).mp hcob
  norm_num [perturbedExp2, continuumExp2, tOwl, tStore, tRDFa, tZk, tMeta, tComb, tAgents,
    tLean, tPool, tMerge, tZOS, tSignal, kZkSignal, hypha] at e2

/-- …so its class in `H¹(continuum; ℤ)` is nonzero. -/
theorem perturbedExp2_class_ne_zero : cls continuum perturbedExp2 ≠ 0 := by
  rw [Ne, cls_eq_zero_iff]
  exact perturbedExp2_not_coboundary

/-- The `p`-adic valuation of a power of `q`. -/
theorem padicValRat_zpow {p : ℕ} [Fact p.Prime] {q : ℚ} (hq : q ≠ 0) (k : ℤ) :
    padicValRat p (q ^ k) = k * padicValRat p q := by
  obtain ⟨n, rfl | rfl⟩ := k.eq_nat_or_neg
  · rw [zpow_natCast, padicValRat.pow hq]
  · rw [zpow_neg, zpow_natCast, padicValRat.inv, padicValRat.pow hq]
    ring

/-- Two-adically, `2^a·3^b` has valuation `a`. -/
theorem padicValRat_two_pow_mul (a b : ℤ) :
    padicValRat 2 ((2 : ℚ) ^ a * (3 : ℚ) ^ b) = a := by
  have h3 : padicValRat 2 (3 : ℚ) = 0 := by
    rw [show ((3 : ℚ)) = ((3 : ℕ) : ℚ) by norm_num, padicValRat.of_nat]
    simp [padicValNat.eq_zero_of_not_dvd (by norm_num : ¬ (2 ∣ 3))]
  have h2 : padicValRat 2 (2 : ℚ) = 1 := padicValRat.self (by norm_num)
  rw [padicValRat.mul (by positivity) (by positivity), padicValRat_zpow (by norm_num),
    padicValRat_zpow (by norm_num), h2, h3]
  ring

/-- **A nonzero class forbids a solution.**  For a field of the form `2^a·3^b` on
    any web, if the exponents of 2 are not a coboundary then there is no
    nowhere-zero embedding: the class is a genuine obstruction, not an artefact
    of the particular attempt. -/
theorem no_embedding_of_exp_not_coboundary {w : Web Strand} {e2 e3 : Hypha Strand → ℤ}
    (he : ¬ IsCoboundary w e2) (μ : Strand → ℚ) (hμ : ∀ x, μ x ≠ 0) :
    ¬ IsEmbedding w (fun h => (2 : ℚ) ^ e2 h * (3 : ℚ) ^ e3 h) μ := by
  intro hemb
  have hρ : ∀ h : Hypha Strand, ((2 : ℚ) ^ e2 h * (3 : ℚ) ^ e3 h) ≠ 0 := by
    intro h
    positivity
  obtain ⟨ν, hν⟩ := padic_coboundary_of_embedding (p := 2) hρ hμ hemb
  refine he ⟨ν, fun h hh => ?_⟩
  have hh2 : padicValRat 2 ((2 : ℚ) ^ e2 h * (3 : ℚ) ^ e3 h) = ν h.target - ν h.source :=
    hν h hh
  rwa [padicValRat_two_pow_mul] at hh2

/-- **The obstruction, back in multiplicative form.**  The perturbed conformal
    field — the continuum's own factors with the `zk → signal` factor changed
    from `96` to `3` — admits no nowhere-zero embedding at all.  The reason is
    cohomological: its 2-adic valuation is `perturbedExp2`, whose class does not
    vanish. -/
theorem perturbedPow_no_embedding (μ : Strand → ℚ) (hμ : ∀ x, μ x ≠ 0) :
    ¬ IsEmbedding continuum
      (fun h => (2 : ℚ) ^ perturbedExp2 h * (3 : ℚ) ^ continuumExp3 h) μ :=
  no_embedding_of_exp_not_coboundary perturbedExp2_not_coboundary μ hμ

/-! ### The cohomology group of the continuum is free of rank six

The six defects at the chords are a complete and independent set of invariants
of a cohomology class — for any coefficient group at all. -/

/-- Six coefficients, one per chord. -/
abbrev Six (G : Type) [AddCommGroup G] := G × G × G × G × G × G

/-- The defects of a cochain at the six chords, as a homomorphism. -/
def chordDefect : (Hypha Strand → G) →+ Six G where
  toFun ρ := (continuumTree.defect ρ kZkLean, continuumTree.defect ρ kZkZOS,
    continuumTree.defect ρ kZkSignal, continuumTree.defect ρ kZOSSignal,
    continuumTree.defect ρ kAgentsSignal, continuumTree.defect ρ kStoreSignal)
  map_zero' := by
    have h : ∀ g : Hypha Strand, continuumTree.defect (0 : Hypha Strand → G) g = 0 :=
      fun g => Spanning.defect_zero continuumTree g
    simp only [h]
    rfl
  map_add' ρ σ := by
    have h : ∀ g : Hypha Strand,
        continuumTree.defect (ρ + σ) g = continuumTree.defect ρ g + continuumTree.defect σ g :=
      fun g => Spanning.defect_add continuumTree ρ σ g
    simp only [h]
    rfl

/-- **Six numbers decide solvability, over any coefficients.**  A weighting of
    the continuum's attachments comes from a level on its strands exactly when
    its six chord defects vanish; the twelve tree attachments impose nothing. -/
theorem chordDefect_eq_zero_iff_coboundary (ρ : Hypha Strand → G) :
    chordDefect ρ = 0 ↔ IsCoboundary continuum ρ := by
  rw [continuumTree.coboundary_iff_defect_zero]
  simp only [chordDefect, AddMonoidHom.coe_mk, ZeroHom.coe_mk, Prod.mk_eq_zero]
  constructor
  · rintro ⟨d0, d1, d2, d3, d4, d5⟩ h hh
    simp only [continuum, continuumHyphae, List.mem_cons, List.not_mem_nil, or_false] at hh
    rcases hh with rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl <;>
      first
        | exact d0 | exact d1 | exact d2 | exact d3 | exact d4 | exact d5
        | simp
  · intro hd
    exact ⟨hd _ (by decide), hd _ (by decide), hd _ (by decide), hd _ (by decide),
      hd _ (by decide), hd _ (by decide)⟩

/-- Over the integers, the vanishing of the six defects is the six chord
    equations. -/
theorem chordDefect_eq_zero_iff (ρ : Hypha Strand → ℤ) :
    chordDefect ρ = 0 ↔ ChordEquations ρ := by
  rw [chordDefect_eq_zero_iff_coboundary, continuum_coboundary_iff]

/-- The kernel of the six defects is exactly the coboundaries. -/
theorem ker_chordDefect : (chordDefect (G := G)).ker = coboundaries continuum G := by
  ext ρ
  simp only [AddMonoidHom.mem_ker]
  rw [chordDefect_eq_zero_iff_coboundary]
  rfl

/-- The cochain supported on the chords with prescribed coefficients. -/
def chordCochain (v : Six G) (h : Hypha Strand) : G :=
  if h = kZkLean then v.1
  else if h = kZkZOS then v.2.1
  else if h = kZkSignal then v.2.2.1
  else if h = kZOSSignal then v.2.2.2.1
  else if h = kAgentsSignal then v.2.2.2.2.1
  else if h = kStoreSignal then v.2.2.2.2.2
  else 0

/-- **Every combination of chord defects occurs.**  The spanning tree carries no
    weight from a chord cochain, so its defects are the coefficients
    themselves. -/
theorem chordDefect_chordCochain (v : Six G) : chordDefect (chordCochain v) = v := by
  obtain ⟨a, b, c, d, e, f⟩ := v
  simp only [chordDefect, AddMonoidHom.coe_mk, ZeroHom.coe_mk, Prod.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    simp [chordCochain, kZkLean, kZkZOS, kZkSignal, kZOSSignal, kAgentsSignal, kStoreSignal]

/-- The six defects are onto. -/
theorem chordDefect_surjective : Function.Surjective (chordDefect (G := G)) :=
  fun v => ⟨chordCochain v, chordDefect_chordCochain v⟩

/-- **The cohomology of the recorded continuum.**  `H¹(continuum; G) ≅ G⁶` for
    every abelian group of coefficients: the web carries exactly six independent
    obstructions, one for each attachment outside the spanning tree, and a class
    is determined by its six chord defects.  With `G = ℤ` this is `ℤ⁶`, free of
    rank six. -/
noncomputable def continuum_H1_equiv : H1 continuum G ≃+ Six G :=
  (QuotientAddGroup.quotientAddEquivOfEq (M := coboundaries continuum G)
    (N := (chordDefect (G := G)).ker) ker_chordDefect.symm).trans
    (QuotientAddGroup.quotientKerEquivOfSurjective (chordDefect (G := G)) chordDefect_surjective)

/-- The isomorphism sends a class to the six defects of any representative. -/
theorem continuum_H1_equiv_apply (ρ : Hypha Strand → G) :
    continuum_H1_equiv (cls continuum ρ) = chordDefect ρ := rfl

/-- Two weights on the continuum's attachments differ by a level on its strands
    exactly when they have the same six chord defects. -/
theorem cls_eq_iff_chordDefect (ρ σ : Hypha Strand → G) :
    cls continuum ρ = cls continuum σ ↔ chordDefect ρ = chordDefect σ := by
  constructor
  · intro h
    have := congrArg continuum_H1_equiv h
    rwa [continuum_H1_equiv_apply, continuum_H1_equiv_apply] at this
  · intro h
    have : continuum_H1_equiv (cls continuum ρ) = continuum_H1_equiv (cls continuum σ) := by
      rw [continuum_H1_equiv_apply, continuum_H1_equiv_apply, h]
    exact continuum_H1_equiv.injective this

/-! ## Axiom audit -/

#print axioms wsum_closed_eq_zero
#print axioms Spanning.coboundary_iff_defect_zero
#print axioms cls_eq_zero_iff
#print axioms padic_coboundary_of_embedding
#print axioms continuum_coboundary_iff
#print axioms continuum_no_generation_number
#print axioms continuumExp2_coboundary
#print axioms perturbedExp2_not_coboundary
#print axioms perturbedPow_no_embedding
#print axioms chordDefect_eq_zero_iff_coboundary
#print axioms chordDefect_surjective
#print axioms cls_eq_iff_chordDefect

end Mycelium
