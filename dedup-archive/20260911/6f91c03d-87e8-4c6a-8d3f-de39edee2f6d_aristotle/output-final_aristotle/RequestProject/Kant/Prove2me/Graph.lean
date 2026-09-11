/-
# Prove2me §9 — decompositions and missions

A decomposition is a directed edge from a parent theorem to children,
justified by a reduction submission.  The source specification says only
`ProofByImportedChildren` should affect formal resolution; here that is a
theorem rather than a convention.

Resolution is defined with an explicit fuel, so it is total and
computable, and the fuel is what makes the well-foundedness argument
sayable: a parent is resolved when there is *some* finite derivation of
it, and a reduction that needs the parent itself never produces one.

Proved here:

* `resolvedFuel_mono` — more fuel never loses a resolution, so
  `Resolved` (∃ fuel) is the right notion;
* `parent_resolved_of_children` and `resolved_succ_iff` — a parent
  resolves exactly when it is directly proved, or some importing edge has
  an accepted reduction and all of its children resolve;
* `only_imported_children_resolve` — `SuggestedReduction` and
  `InformalDependency` edges are inert: deleting them changes nothing;
* `no_self_justification` — if every edge for a theorem needs that
  theorem among its children, the theorem is never resolved, at any fuel.
  A cycle of reductions cannot justify itself;
* `mem_openLeaves_iff` — the open work of a mission is exactly its
  unresolved milestones;
* `competing_missions_distinct` — two curators publishing different views
  of the same theorem graph produce two artifacts, neither overwriting
  the other.
-/
import RequestProject.Kant.Prove2me.Policy

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Prove2me

open Kant Kant.Text

/-! ## Decomposition edges -/

/-- What a decomposition edge claims. -/
inductive Relation where
  /-- The parent is proved by a submission that imports the children.
  The only relation with formal force. -/
  | proofByImportedChildren
  /-- A suggestion that this split might work.  No formal force. -/
  | suggestedReduction
  /-- A note that the parent depends on the children informally. -/
  | informalDependency
deriving DecidableEq, Repr

/-- A decomposition edge. -/
structure Edge where
  /-- The theorem being reduced. -/
  parent : Cid
  /-- The theorems it is reduced to. -/
  children : List Cid
  /-- The submission proving parent-from-children. -/
  reduction : Cid
  /-- What is claimed. -/
  relation : Relation
deriving DecidableEq, Repr

/-- Only one relation resolves anything. -/
def Edge.isResolving (ed : Edge) : Bool := ed.relation == Relation.proofByImportedChildren

/-! ## Resolution -/

/-- Is a theorem resolved within `n` reduction steps?  `accThm` says
which theorems have an accepted direct proof, `accSub` which submissions
the peer accepts (both computed by `Kant.Prove2me.Policy` from local
data). -/
def resolvedFuel (accThm accSub : Cid → Bool) (edges : List Edge) : Nat → Cid → Bool
  | 0, c => accThm c
  | n + 1, c =>
      accThm c ||
        edges.any (fun ed =>
          (ed.parent == c) && ed.isResolving && accSub ed.reduction &&
            ed.children.all (resolvedFuel accThm accSub edges n))

/-- A theorem is resolved when some finite derivation resolves it. -/
def Resolved (accThm accSub : Cid → Bool) (edges : List Edge) (c : Cid) : Prop :=
  ∃ n, resolvedFuel accThm accSub edges n c = true

theorem resolvedFuel_succ {accThm accSub : Cid → Bool} {edges : List Edge}
    {n : Nat} {c : Cid} (h : resolvedFuel accThm accSub edges n c = true) :
    resolvedFuel accThm accSub edges (n + 1) c = true := by
  induction n generalizing c with
  | zero =>
      simp only [resolvedFuel] at h ⊢
      simp [h]
  | succ n ih =>
      simp only [resolvedFuel, Bool.or_eq_true, List.any_eq_true] at h ⊢
      rcases h with h | ⟨ed, hed, hcond⟩
      · exact Or.inl h
      · refine Or.inr ⟨ed, hed, ?_⟩
        simp only [Bool.and_eq_true, List.all_eq_true] at hcond ⊢
        refine ⟨hcond.1, ?_⟩
        intro x hx
        exact ih (hcond.2 x hx)

/-- More fuel never loses a resolution. -/
theorem resolvedFuel_mono {accThm accSub : Cid → Bool} {edges : List Edge}
    {n m : Nat} {c : Cid} (hnm : n ≤ m)
    (h : resolvedFuel accThm accSub edges n c = true) :
    resolvedFuel accThm accSub edges m c = true := by
  induction m with
  | zero =>
      have : n = 0 := Nat.le_zero.mp hnm
      subst this
      exact h
  | succ m ih =>
      rcases Nat.lt_or_ge n (m + 1) with hlt | hge
      · exact resolvedFuel_succ (ih (Nat.lt_succ_iff.mp hlt))
      · have : n = m + 1 := Nat.le_antisymm hnm hge
        subst this
        exact h

/-- A directly proved theorem is resolved. -/
theorem resolved_of_direct {accThm accSub : Cid → Bool} {edges : List Edge} {c : Cid}
    (h : accThm c = true) : Resolved accThm accSub edges c :=
  ⟨0, h⟩

/-- One step of resolution, spelled out. -/
theorem resolved_succ_iff {accThm accSub : Cid → Bool} {edges : List Edge} {n : Nat} {c : Cid} :
    resolvedFuel accThm accSub edges (n + 1) c = true ↔
      (accThm c = true ∨
        ∃ ed ∈ edges, ed.parent = c ∧ ed.relation = Relation.proofByImportedChildren ∧
          accSub ed.reduction = true ∧
          ∀ x ∈ ed.children, resolvedFuel accThm accSub edges n x = true) := by
  simp only [resolvedFuel, Bool.or_eq_true, List.any_eq_true, Bool.and_eq_true,
    List.all_eq_true, beq_iff_eq, Edge.isResolving]
  constructor
  · rintro (h | ⟨ed, hed, ⟨⟨⟨hp, hr⟩, hs⟩, hch⟩⟩)
    · exact Or.inl h
    · exact Or.inr ⟨ed, hed, hp, by simpa using hr, hs, hch⟩
  · rintro (h | ⟨ed, hed, hp, hr, hs, hch⟩)
    · exact Or.inl h
    · exact Or.inr ⟨ed, hed, ⟨⟨⟨hp, by simp [hr]⟩, hs⟩, hch⟩⟩

/-- **A parent resolves through an accepted reduction and resolved
children.** -/
theorem parent_resolved_of_children {accThm accSub : Cid → Bool} {edges : List Edge}
    {ed : Edge} {n : Nat} (hed : ed ∈ edges)
    (hrel : ed.relation = Relation.proofByImportedChildren)
    (hred : accSub ed.reduction = true)
    (hch : ∀ x ∈ ed.children, resolvedFuel accThm accSub edges n x = true) :
    Resolved accThm accSub edges ed.parent :=
  ⟨n + 1, resolved_succ_iff.mpr (Or.inr ⟨ed, hed, rfl, hrel, hred, hch⟩)⟩

/-! ## Only importing reductions count -/

theorem any_filter_of_imp {α : Type} {p f : α → Bool} (himp : ∀ x, f x = true → p x = true)
    (l : List α) : (l.filter p).any f = l.any f := by
  induction l with
  | nil => simp
  | cons a t ih =>
      cases hp : p a with
      | true => simp [hp, ih]
      | false =>
          have hf : f a = false := by
            cases hfa : f a with
            | true => rw [himp a hfa] at hp; exact absurd hp (by simp)
            | false => rfl
          simp [hp, hf, ih]

/-- **Non-importing edges are inert.**  A suggested reduction or an
informal dependency can be published by anybody and changes no
resolution: deleting every such edge leaves the resolved set exactly as
it was. -/
theorem only_imported_children_resolve (accThm accSub : Cid → Bool) (edges : List Edge) :
    ∀ (n : Nat) (c : Cid),
      resolvedFuel accThm accSub (edges.filter Edge.isResolving) n c
        = resolvedFuel accThm accSub edges n c := by
  intro n
  induction n with
  | zero => intro c; rfl
  | succ n ih =>
      intro c
      simp only [resolvedFuel]
      have hfun : (fun ed : Edge =>
            (ed.parent == c) && ed.isResolving && accSub ed.reduction &&
              ed.children.all (resolvedFuel accThm accSub (edges.filter Edge.isResolving) n))
          = (fun ed : Edge =>
            (ed.parent == c) && ed.isResolving && accSub ed.reduction &&
              ed.children.all (resolvedFuel accThm accSub edges n)) := by
        funext ed
        have heq : resolvedFuel accThm accSub (edges.filter Edge.isResolving) n
            = resolvedFuel accThm accSub edges n := funext ih
        rw [heq]
      rw [hfun, any_filter_of_imp]
      intro ed hed
      simp only [Bool.and_eq_true] at hed
      exact hed.1.1.2

/-! ## No self-justification -/

/-- **A reduction cannot justify itself.**  If every edge that claims to
reduce `c` has `c` among its own children, then `c` is unresolved at
every fuel: circular reductions produce nothing. -/
theorem no_self_justification {accThm accSub : Cid → Bool} {edges : List Edge} {c : Cid}
    (hdirect : accThm c = false)
    (hcycle : ∀ ed ∈ edges, ed.parent = c → c ∈ ed.children) :
    ∀ n, resolvedFuel accThm accSub edges n c = false := by
  intro n
  induction n with
  | zero => exact hdirect
  | succ n ih =>
      cases hres : resolvedFuel accThm accSub edges (n + 1) c with
      | false => rfl
      | true =>
          rcases resolved_succ_iff.mp hres with h | ⟨ed, hed, hp, _, _, hch⟩
          · rw [hdirect] at h; exact absurd h (by simp)
          · have hmem : c ∈ ed.children := hcycle ed hed hp
            have := hch c hmem
            rw [ih] at this
            exact absurd this (by simp)

/-- Consequently such a theorem is not `Resolved` either. -/
theorem not_resolved_of_cycle {accThm accSub : Cid → Bool} {edges : List Edge} {c : Cid}
    (hdirect : accThm c = false)
    (hcycle : ∀ ed ∈ edges, ed.parent = c → c ∈ ed.children) :
    ¬ Resolved accThm accSub edges c := by
  rintro ⟨n, hn⟩
  rw [no_self_justification hdirect hcycle n] at hn
  exact absurd hn (by simp)

/-! ## Missions as signed collections -/

/-- A curated view of the theorem graph.  A mission is an ordinary
artifact published by a curator, not a privileged record: competing
curations coexist. -/
structure Mission where
  /-- Display title. -/
  title : Str
  /-- Description. -/
  description : Str
  /-- Where the mission starts. -/
  roots : List Cid
  /-- The theorems whose resolution the mission tracks. -/
  milestones : List Cid
  /-- Who curates it. -/
  curator : Key
deriving DecidableEq, Repr

/-- A mission is transmissible when its text is printable. -/
structure Mission.Wire (m : Mission) : Prop where
  /-- The title is printable. -/
  title : IsAscii m.title
  /-- The description is printable. -/
  description : IsAscii m.description
  /-- Every root address is printable. -/
  roots : ∀ c ∈ m.roots, IsAscii c
  /-- Every milestone address is printable. -/
  milestones : ∀ c ∈ m.milestones, IsAscii c
  /-- The curator key is printable. -/
  curator : IsAscii m.curator

/-- The content of a mission artifact. -/
def Mission.content (m : Mission) : Content :=
  ⟨.mission, [m.title, m.description, packText m.roots, packText m.milestones, m.curator]⟩

theorem Mission.content_wire {m : Mission} (h : m.Wire) : m.content.Wire := by
  intro f hf
  simp only [Mission.content, List.mem_cons] at hf
  rcases hf with rfl | rfl | rfl | rfl | hf
  · exact h.title
  · exact h.description
  · exact isAscii_packText _
  · exact isAscii_packText _
  · rcases hf with rfl | hf
    · exact h.curator
    · cases hf

/-- The address of a mission. -/
def missionId (A : Addressing) (m : Mission) : Cid := idOf A m.content

/-- **Competing curations coexist.**  Two missions over the same
theorems, curated by different keys, are two artifacts with two
addresses; neither replaces the other. -/
theorem competing_missions_distinct (A : Addressing) {m m' : Mission}
    (hw : m.Wire) (hw' : m'.Wire) (hne : m.curator ≠ m'.curator) :
    missionId A m ≠ missionId A m' := by
  intro heq
  have hc := idOf_inj A (Mission.content_wire hw) (Mission.content_wire hw') heq
  simp only [Mission.content, Content.mk.injEq, List.cons.injEq, and_true, true_and] at hc
  exact hne hc.2.2.2.2

/-- The open work of a mission: its unresolved milestones. -/
def openLeaves (resolvedP : Cid → Bool) (m : Mission) : List Cid :=
  m.milestones.filter (fun c => !resolvedP c)

/-- The open work is exactly the unresolved milestones — no more, no
less. -/
theorem mem_openLeaves_iff {resolvedP : Cid → Bool} {m : Mission} {c : Cid} :
    c ∈ openLeaves resolvedP m ↔ (c ∈ m.milestones ∧ resolvedP c = false) := by
  simp [openLeaves, List.mem_filter]

/-- Resolving a milestone removes it from the open work, and touches
nothing else. -/
theorem openLeaves_shrinks {resolvedP resolvedP' : Cid → Bool} {m : Mission}
    (hmono : ∀ c, resolvedP c = true → resolvedP' c = true) :
    ∀ c ∈ openLeaves resolvedP' m, c ∈ openLeaves resolvedP m := by
  intro c hc
  obtain ⟨hmem, hres⟩ := mem_openLeaves_iff.mp hc
  refine mem_openLeaves_iff.mpr ⟨hmem, ?_⟩
  cases h : resolvedP c with
  | false => rfl
  | true => rw [hmono c h] at hres; exact absurd hres (by simp)

end Kant.Prove2me
