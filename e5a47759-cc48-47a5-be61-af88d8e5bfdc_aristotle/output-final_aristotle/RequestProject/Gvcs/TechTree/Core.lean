import Mathlib.Tactic

/-!
# The self-hosting logic layer: tech nodes, resources, and validity

This file is the formal core of the greenfield bootstrap: a model of a
tech-tree, and of what it means for a proposed build sequence to be a *valid*
bootstrap from raw materials.

## What this layer is and is not

It models the **dependency and resource-accounting structure** of a bootstrap:
what depends on what, in what order, and whether a claimed sequence is
internally consistent.  It models **no physics at all** — no thermodynamics, no
tolerances, no material stress, no wear, no build time.  A sequence this file
calls valid is *internally consistent*, not *physically realisable*.  Those are
different claims and only the first is proved here; the second is the physical
validation step that comes later.

## The model

* `TechTier` — clockwork, steam, hydraulic: the skill-tree progression, ordered.
* `Tech` — one node.  `inputs` are consumed, `tools` must be present and are
  *not* consumed (a lathe is a tool, a bolt is an input), and `humanStep` is
  mandatory on every node, so no step can silently assume a human.
* `ResourceState` — three parts: `consumables` (a tally), `toolsBuilt` (durable
  equipment handed over free at the start — the bootstrap exceptions), and
  `infrastructure` (standing services, checked by presence, never consumed).
* `stepOk`, `stepRun`, `runSeq`, `validSeq` — an executable checker: run it on
  a candidate sequence and get yes or no.  `ValidSequence` is the `Prop` and it
  is `Decidable` by evaluation.
* `SelfHosting` — the claim: the sequence is resource-valid start to finish, it
  ends holding a complete machine, and every tool it used was either built by
  the sequence itself or is one of the enumerated bootstrap exceptions.

### Two declared extensions to the sketched `Tech`

The sketch in the task has six fields.  Two more are needed to say what the
task itself asks for later, and both are declared here rather than smuggled in:

* `erects : List String` — the standing infrastructure a step brings into
  being.  An observatory is not consumed and is not a stock item; without this
  field there is no way to express "this exists from now on".
* `baseLabor`, `obsDiscount : ℕ` — the labour a step costs, and how much of
  that labour a standing observatory saves.  Labour is charged as a real
  consumable, so a discount is not decoration: it changes what the checker
  accepts.

## The structural theorems

* `qty_stepRun_le` — a step cannot increase the tally of anything it does not
  output: nothing comes from nowhere.
* `tools_survive_their_use` — a tool that is not also an input comes out of the
  step it was used for, which is the point of the tools/inputs distinction.
* `runSeq_append`, `valid_prefix` — validity is prefix-closed.
* `stepOk_mono_infra`, `buildCost_le_baseLabor` — standing infrastructure can
  only ever enable a step or make it cheaper, never block it or cost more.
* `resource_needs_earlier_producer`, `tool_needs_earlier_producer` — **the
  ordering theorem**: anything a step consumes or uses, and which the raw
  materials did not include, was produced by an earlier step.  This is what
  makes ordering constraints such as `press_before_program` structural facts
  rather than accidents of one hand-written list.
-/

namespace LifeTrac
namespace TechTree

/-! ## Tiers -/

/-- The three tiers of the skill tree. -/
inductive TechTier where
  /-- Hand-powered mechanism: levers, gears, screws, treadles. -/
  | clockwork : TechTier
  /-- Fired pressure vessels and the engines they drive. -/
  | steam : TechTier
  /-- Pumped fluid power. -/
  | hydraulic : TechTier
  deriving DecidableEq, Repr, Inhabited

/-- Tiers in order, as a number. -/
def TechTier.rank : TechTier → ℕ
  | .clockwork => 0
  | .steam => 1
  | .hydraulic => 2

instance : LE TechTier := ⟨fun a b => a.rank ≤ b.rank⟩
instance : LT TechTier := ⟨fun a b => a.rank < b.rank⟩

instance (a b : TechTier) : Decidable (a ≤ b) := inferInstanceAs (Decidable (a.rank ≤ b.rank))
instance (a b : TechTier) : Decidable (a < b) := inferInstanceAs (Decidable (a.rank < b.rank))

theorem TechTier.le_def {a b : TechTier} : a ≤ b ↔ a.rank ≤ b.rank := Iff.rfl

theorem TechTier.clockwork_le (a : TechTier) : TechTier.clockwork ≤ a := by
  cases a <;> simp [TechTier.le_def, TechTier.rank]

theorem TechTier.le_rfl (a : TechTier) : a ≤ a := Nat.le_refl _

theorem TechTier.le_trans' {a b c : TechTier} (h₁ : a ≤ b) (h₂ : b ≤ c) : a ≤ c :=
  Nat.le_trans h₁ h₂

theorem TechTier.le_antisymm' {a b : TechTier} (h₁ : a ≤ b) (h₂ : b ≤ a) : a = b := by
  cases a <;> cases b <;> simp_all [TechTier.le_def, TechTier.rank]

/-! ## Nodes -/

/-- One node of the tech tree.

`inputs` are consumed by the step; `tools` must be available when the step runs
and are *not* consumed by it.  `erects` is standing infrastructure the step
brings into being.  `baseLabor` is the labour the step costs and `obsDiscount`
is how much of that a standing observatory saves.  `humanStep` is not optional:
every node declares whether it needs a human. -/
structure Tech where
  /-- The identifier of the step, and of the artefact it is named for. -/
  id : String
  /-- Which tier of the skill tree the step belongs to. -/
  tier : TechTier
  /-- Resources consumed, with quantities. -/
  inputs : List (String × ℕ)
  /-- Resources produced, with quantities. -/
  outputs : List (String × ℕ)
  /-- Equipment that must be available, and which the step does not consume. -/
  tools : List String
  /-- Standing infrastructure this step brings into being; never consumed. -/
  erects : List String
  /-- Labour the step costs with no observatory standing. -/
  baseLabor : ℕ
  /-- Labour a standing observatory saves on this step. -/
  obsDiscount : ℕ
  /-- Does this step require manual human action? -/
  humanStep : Bool
  deriving DecidableEq, Repr, Inhabited

/-- A candidate bootstrap is a list of steps, in order. -/
abbrev BootstrapSeq := List Tech

/-! ## Resource states -/

/-- A tally of consumable stock by name; names not listed stand at zero. -/
abbrev Tally := List (String × ℕ)

/-- What exists. -/
structure ResourceState where
  /-- Stock, by name: consumed by `inputs`, produced by `outputs`. -/
  consumables : Tally
  /-- Durable equipment available from the start — the bootstrap exceptions. -/
  toolsBuilt : List String
  /-- Standing services: present or not, never consumed. -/
  infrastructure : List String
  deriving DecidableEq, Repr, Inhabited

/-- How much of `k` there is. -/
def qty (r : Tally) (k : String) : ℕ :=
  match r with
  | [] => 0
  | (k', n) :: rest => if k' = k then n else qty rest k

/-- Add `n` of `k`. -/
def addRes (r : Tally) (k : String) (n : ℕ) : Tally :=
  match r with
  | [] => [(k, n)]
  | (k', m) :: rest => if k' = k then (k', m + n) :: rest else (k', m) :: addRes rest k n

/-- Remove `n` of `k`, stopping at zero. -/
def subRes (r : Tally) (k : String) (n : ℕ) : Tally :=
  match r with
  | [] => []
  | (k', m) :: rest => if k' = k then (k', m - n) :: rest else (k', m) :: subRes rest k n

@[simp] theorem qty_addRes_same (r : Tally) (k : String) (n : ℕ) :
    qty (addRes r k n) k = qty r k + n := by
  induction r with
  | nil => simp [addRes, qty]
  | cons p rest ih =>
      obtain ⟨k', m⟩ := p
      by_cases h : k' = k <;> simp [addRes, qty, h, ih]

theorem qty_addRes_other (r : Tally) {k j : String} (h : k ≠ j) (n : ℕ) :
    qty (addRes r k n) j = qty r j := by
  induction r with
  | nil => simp [addRes, qty, h]
  | cons p rest ih =>
      obtain ⟨k', m⟩ := p
      by_cases h' : k' = k
      · subst h'
        simp [addRes, qty, h]
      · simp [addRes, qty, h', ih]

theorem qty_subRes_same (r : Tally) (k : String) (n : ℕ) :
    qty (subRes r k n) k = qty r k - n := by
  induction r with
  | nil => simp [subRes, qty]
  | cons p rest ih =>
      obtain ⟨k', m⟩ := p
      by_cases h : k' = k <;> simp [subRes, qty, h, ih]

theorem qty_subRes_other (r : Tally) {k j : String} (h : k ≠ j) (n : ℕ) :
    qty (subRes r k n) j = qty r j := by
  induction r with
  | nil => simp [subRes, qty]
  | cons p rest ih =>
      obtain ⟨k', m⟩ := p
      by_cases h' : k' = k
      · subst h'
        simp [subRes, qty, h]
      · simp [subRes, qty, h', ih]

theorem qty_subRes_le (r : Tally) (k : String) (n : ℕ) (j : String) :
    qty (subRes r k n) j ≤ qty r j := by
  by_cases h : k = j
  · subst h
    simp [qty_subRes_same]
  · simp [qty_subRes_other r h]

/-- Consume a bill of resources. -/
def consume (r : Tally) : List (String × ℕ) → Tally
  | [] => r
  | (k, n) :: rest => consume (subRes r k n) rest

/-- Produce a bill of resources. -/
def produce (r : Tally) : List (String × ℕ) → Tally
  | [] => r
  | (k, n) :: rest => produce (addRes r k n) rest

theorem qty_consume_le : ∀ (bill : List (String × ℕ)) (r : Tally) (j : String),
    qty (consume r bill) j ≤ qty r j
  | [], _, _ => le_refl _
  | (k, n) :: rest, r, j =>
      le_trans (qty_consume_le rest (subRes r k n) j) (qty_subRes_le r k n j)

theorem qty_consume_of_not_mem : ∀ (bill : List (String × ℕ)) (r : Tally) (j : String),
    j ∉ bill.map Prod.fst → qty (consume r bill) j = qty r j
  | [], _, _, _ => rfl
  | (k, n) :: rest, r, j, h => by
      have hk : k ≠ j := fun hkj => h (by simp [hkj])
      have hrest : j ∉ rest.map Prod.fst := fun hm => h (by simp [hm])
      rw [consume, qty_consume_of_not_mem rest _ j hrest, qty_subRes_other r hk]

theorem qty_produce_of_not_mem : ∀ (bill : List (String × ℕ)) (r : Tally) (j : String),
    j ∉ bill.map Prod.fst → qty (produce r bill) j = qty r j
  | [], _, _, _ => rfl
  | (k, n) :: rest, r, j, h => by
      have hk : k ≠ j := fun hkj => h (by simp [hkj])
      have hrest : j ∉ rest.map Prod.fst := fun hm => h (by simp [hm])
      rw [produce, qty_produce_of_not_mem rest _ j hrest, qty_addRes_other r hk]

theorem qty_produce_ge : ∀ (bill : List (String × ℕ)) (r : Tally) (j : String),
    qty r j ≤ qty (produce r bill) j
  | [], _, _ => le_refl _
  | (k, n) :: rest, r, j =>
      le_trans
        (by
          by_cases h : k = j
          · subst h; simp
          · simp [qty_addRes_other r h])
        (qty_produce_ge rest (addRes r k n) j)

/-! ## Availability and cost -/

/-- Is `k` available as a tool: in stock, or free equipment, or a standing
service? -/
def Avail (r : ResourceState) (k : String) : Prop :=
  1 ≤ qty r.consumables k ∨ k ∈ r.toolsBuilt ∨ k ∈ r.infrastructure

instance (r : ResourceState) (k : String) : Decidable (Avail r k) :=
  inferInstanceAs (Decidable (_ ∨ _ ∨ _))

/-- The name of the standing observatory service. -/
def observatoryId : String := "observatory"

/-- The labour a step costs: its base labour, less the observatory discount
when an observatory is standing (§3a.2). -/
def buildCost (t : Tech) (infra : List String) : ℕ :=
  if observatoryId ∈ infra then t.baseLabor - t.obsDiscount else t.baseLabor

/-- **A standing observatory never costs more labour than none.** -/
theorem buildCost_le_baseLabor (t : Tech) (infra : List String) :
    buildCost t infra ≤ t.baseLabor := by
  unfold buildCost
  split <;> omega

/-- **The discount is monotone in the infrastructure**: adding the observatory
can only make a step cheaper. -/
theorem buildCost_le_of_subset {t : Tech} {infra infra' : List String}
    (h : ∀ x ∈ infra, x ∈ infra') : buildCost t infra' ≤ buildCost t infra := by
  unfold buildCost
  by_cases hi : observatoryId ∈ infra
  · simp [hi, h _ hi]
  · simp only [hi, if_false]
    split <;> omega

/-- The full bill a step consumes: its inputs, plus its labour. -/
def stepBill (t : Tech) (infra : List String) : List (String × ℕ) :=
  ("labor", buildCost t infra) :: t.inputs

/-! ## Running a step -/

/-- Is the step runnable in this state?  Every tool available, every input in
stock, and the labour paid for. -/
def stepOk (r : ResourceState) (t : Tech) : Bool :=
  t.tools.all (fun tool => decide (Avail r tool)) &&
    (stepBill t r.infrastructure).all (fun p => p.2 ≤ qty r.consumables p.1)

/-- The state after the step: bill consumed, outputs produced, tools untouched,
infrastructure extended. -/
def stepRun (r : ResourceState) (t : Tech) : ResourceState :=
  { consumables := produce (consume r.consumables (stepBill t r.infrastructure)) t.outputs
    toolsBuilt := r.toolsBuilt
    infrastructure := r.infrastructure ++ t.erects }

@[simp] theorem stepRun_toolsBuilt (r : ResourceState) (t : Tech) :
    (stepRun r t).toolsBuilt = r.toolsBuilt := rfl

@[simp] theorem stepRun_infrastructure (r : ResourceState) (t : Tech) :
    (stepRun r t).infrastructure = r.infrastructure ++ t.erects := rfl

/-- **Nothing comes from nowhere.**  A step cannot increase the tally of
anything it does not output. -/
theorem qty_stepRun_le {r : ResourceState} {t : Tech} {j : String}
    (h : j ∉ t.outputs.map Prod.fst) :
    qty (stepRun r t).consumables j ≤ qty r.consumables j := by
  show qty (produce (consume r.consumables (stepBill t r.infrastructure)) t.outputs) j ≤ _
  rw [qty_produce_of_not_mem _ _ _ h]
  exact qty_consume_le _ _ _

/-- **Tools survive the step they are used for.**  A tool that is not also
listed as an input, and is not labour, comes out of the step at no less than it
went in. -/
theorem tools_survive_their_use {r : ResourceState} {t : Tech} {tool : String}
    (hin : tool ∉ t.inputs.map Prod.fst) (hlab : tool ≠ "labor") :
    qty r.consumables tool ≤ qty (stepRun r t).consumables tool := by
  have hbill : tool ∉ (stepBill t r.infrastructure).map Prod.fst := by
    simp only [stepBill, List.map_cons, List.mem_cons]
    rintro (h | h)
    · exact hlab h
    · exact hin h
  show _ ≤ qty (produce (consume r.consumables (stepBill t r.infrastructure)) t.outputs) tool
  rw [← qty_consume_of_not_mem _ r.consumables tool hbill]
  exact qty_produce_ge _ _ _

/-- **Standing infrastructure never blocks a step.**  If a step can run, it can
still run with more services standing: the extra infrastructure keeps every
tool available and can only lower the labour bill. -/
theorem stepOk_mono_infra {r : ResourceState} {t : Tech} {extra : List String}
    (h : stepOk r t = true) :
    stepOk { r with infrastructure := r.infrastructure ++ extra } t = true := by
  set r' : ResourceState := { r with infrastructure := r.infrastructure ++ extra } with hr'
  simp only [stepOk, Bool.and_eq_true, List.all_eq_true, decide_eq_true_eq] at h ⊢
  obtain ⟨htools, hbill⟩ := h
  constructor
  · intro tool ht
    rcases htools tool ht with h1 | h1 | h1
    · exact Or.inl h1
    · exact Or.inr (Or.inl h1)
    · exact Or.inr (Or.inr (by simp [hr', h1]))
  · intro p hp
    have hsub : ∀ x ∈ r.infrastructure, x ∈ r'.infrastructure := by
      intro x hx; simp [hr', hx]
    have hcost : buildCost t r'.infrastructure ≤ buildCost t r.infrastructure :=
      buildCost_le_of_subset hsub
    simp only [stepBill, List.mem_cons] at hp ⊢
    rcases hp with rfl | hp
    · have := hbill ("labor", buildCost t r.infrastructure) (by simp [stepBill])
      simpa using le_trans hcost (by simpa using this)
    · exact hbill p (by simp [stepBill, hp])

/-! ## Running a sequence -/

/-- Run a sequence from a starting state, or fail at the first step that cannot
run. -/
def runSeq (r : ResourceState) : BootstrapSeq → Option ResourceState
  | [] => some r
  | t :: rest => if stepOk r t then runSeq (stepRun r t) rest else none

/-- The resources available after the first `i` steps — the fold the task's
sketch calls `resourcesAvailable`, as a total function that stops at the first
step that cannot run. -/
def resourcesAvailable (raw : ResourceState) (seq : BootstrapSeq) (i : ℕ) : Option ResourceState :=
  runSeq raw (seq.take i)

/-- The executable validity checker. -/
def validSeq (raw : ResourceState) (seq : BootstrapSeq) : Bool := (runSeq raw seq).isSome

/-- A sequence is valid from `raw` when every step can run in turn. -/
def ValidSequence (seq : BootstrapSeq) (raw : ResourceState) : Prop :=
  validSeq raw seq = true

instance (seq : BootstrapSeq) (raw : ResourceState) : Decidable (ValidSequence seq raw) :=
  inferInstanceAs (Decidable (_ = true))

/-- The state a valid sequence ends in. -/
def finalState (raw : ResourceState) (seq : BootstrapSeq) : ResourceState :=
  (runSeq raw seq).getD raw

theorem runSeq_append : ∀ (seq₁ seq₂ : BootstrapSeq) (r : ResourceState),
    runSeq r (seq₁ ++ seq₂) = (runSeq r seq₁).bind (fun s => runSeq s seq₂)
  | [], _, _ => rfl
  | t :: rest, seq₂, r => by
      by_cases h : stepOk r t
      · simp [runSeq, h, runSeq_append rest seq₂ (stepRun r t)]
      · simp [runSeq, h]

/-- **Validity is prefix-closed.** -/
theorem valid_prefix {seq₁ seq₂ : BootstrapSeq} {raw : ResourceState}
    (h : ValidSequence (seq₁ ++ seq₂) raw) : ValidSequence seq₁ raw := by
  unfold ValidSequence validSeq at h ⊢
  rw [runSeq_append] at h
  cases hr : runSeq raw seq₁ with
  | none => rw [hr] at h; simp at h
  | some s => simp

/-! ## What a sequence produces and uses -/

/-- Everything any step of the sequence outputs or erects. -/
def producedIds (seq : BootstrapSeq) : List String :=
  seq.flatMap (fun t => t.outputs.map Prod.fst ++ t.erects)

/-- Every tool any step of the sequence uses. -/
def toolsUsed (seq : BootstrapSeq) : List String := seq.flatMap Tech.tools

/-- The steps that need a human, by name. -/
def humanSteps (seq : BootstrapSeq) : List String :=
  (seq.filter (fun t => t.humanStep)).map Tech.id

/-- The labour a sequence spends, given the infrastructure standing at each
step. -/
def totalLabor (raw : ResourceState) : BootstrapSeq → ℕ
  | [] => 0
  | t :: rest =>
      buildCost t raw.infrastructure +
        totalLabor { raw with infrastructure := raw.infrastructure ++ t.erects } rest

/-! ## The ordering theorem -/

/-- If no step of a prefix produces `k`, the stock of `k` has not risen. -/
theorem qty_le_of_no_producer :
    ∀ (seq : BootstrapSeq) (raw : ResourceState) (j : String),
      (∀ t ∈ seq, j ∉ t.outputs.map Prod.fst) →
        ∀ s, runSeq raw seq = some s → qty s.consumables j ≤ qty raw.consumables j
  | [], raw, j, _, s, h => by
      rw [runSeq] at h
      cases h
      exact le_refl _
  | t :: rest, raw, j, hno, s, h => by
      rw [runSeq] at h
      by_cases hok : stepOk raw t
      · rw [if_pos hok] at h
        exact le_trans
          (qty_le_of_no_producer rest _ j (fun u hu => hno u (by simp [hu])) s h)
          (qty_stepRun_le (hno t (by simp)))
      · rw [if_neg hok] at h
        exact absurd h (by simp)

/-- If no step of a prefix erects `k`, no service `k` has appeared. -/
theorem infra_of_no_erector :
    ∀ (seq : BootstrapSeq) (raw : ResourceState) (j : String),
      (∀ t ∈ seq, j ∉ t.erects) →
        ∀ s, runSeq raw seq = some s → j ∈ s.infrastructure → j ∈ raw.infrastructure
  | [], raw, j, _, s, h, hj => by
      rw [runSeq] at h
      cases h
      exact hj
  | t :: rest, raw, j, hno, s, h, hj => by
      rw [runSeq] at h
      by_cases hok : stepOk raw t
      · rw [if_pos hok] at h
        have := infra_of_no_erector rest _ j (fun u hu => hno u (by simp [hu])) s h hj
        simp only [stepRun_infrastructure, List.mem_append] at this
        rcases this with h1 | h1
        · exact h1
        · exact absurd h1 (hno t (by simp))
      · rw [if_neg hok] at h
        exact absurd h (by simp)

/-- Tools handed over at the start never change. -/
theorem toolsBuilt_runSeq :
    ∀ (seq : BootstrapSeq) (raw : ResourceState) (s : ResourceState),
      runSeq raw seq = some s → s.toolsBuilt = raw.toolsBuilt
  | [], raw, s, h => by rw [runSeq] at h; cases h; rfl
  | t :: rest, raw, s, h => by
      rw [runSeq] at h
      by_cases hok : stepOk raw t
      · rw [if_pos hok] at h
        simpa using toolsBuilt_runSeq rest _ s h
      · rw [if_neg hok] at h
        exact absurd h (by simp)

/-- **Nothing is available from nowhere.**  If no step of a prefix produces or
erects `k`, and `k` was not available in the raw state, it is still not
available. -/
theorem not_avail_of_no_producer (seq : BootstrapSeq) (raw : ResourceState) (k : String)
    (hno : ∀ t ∈ seq, k ∉ t.outputs.map Prod.fst ∧ k ∉ t.erects)
    (hraw : ¬ Avail raw k) (s : ResourceState) (h : runSeq raw seq = some s) :
    ¬ Avail s k := by
  rintro (h1 | h1 | h1)
  · have := qty_le_of_no_producer seq raw k (fun t ht => (hno t ht).1) s h
    exact hraw (Or.inl (le_trans h1 this))
  · rw [toolsBuilt_runSeq seq raw s h] at h1
    exact hraw (Or.inr (Or.inl h1))
  · exact hraw (Or.inr (Or.inr
      (infra_of_no_erector seq raw k (fun t ht => (hno t ht).2) s h h1)))

/-- **The ordering theorem for consumed resources.**  In a valid sequence, a
step that consumes a resource the raw materials did not include is preceded by
a step that produces it. -/
theorem resource_needs_earlier_producer
    {before : BootstrapSeq} {t : Tech} {after : BootstrapSeq} {raw : ResourceState}
    (hvalid : ValidSequence (before ++ t :: after) raw)
    {k : String} {n : ℕ} (hk : (k, n) ∈ t.inputs) (hn : 0 < n)
    (hraw : qty raw.consumables k = 0) :
    ∃ u ∈ before, k ∈ u.outputs.map Prod.fst := by
  by_contra hcon
  push_neg at hcon
  unfold ValidSequence validSeq at hvalid
  rw [runSeq_append] at hvalid
  cases hr : runSeq raw before with
  | none => rw [hr] at hvalid; simp at hvalid
  | some s =>
      have hs : qty s.consumables k ≤ qty raw.consumables k :=
        qty_le_of_no_producer before raw k (fun u hu => hcon u hu) s hr
      rw [hraw] at hs
      have hsk : qty s.consumables k = 0 := Nat.le_zero.1 hs
      rw [hr] at hvalid
      simp only [Option.bind_some] at hvalid
      rw [runSeq] at hvalid
      by_cases hok : stepOk s t
      · unfold stepOk at hok
        have hb := (List.all_eq_true.1 (Bool.and_elim_right hok)) (k, n)
          (by simp [stepBill, hk])
        simp only [decide_eq_true_eq] at hb
        omega
      · rw [if_neg hok] at hvalid
        simp at hvalid

/-- **The ordering theorem for tools.**  In a valid sequence, a step that uses
a tool that was not available at the start is preceded by a step that produces
or erects it — so tool dependencies are earned, not assumed. -/
theorem tool_needs_earlier_producer
    {before : BootstrapSeq} {t : Tech} {after : BootstrapSeq} {raw : ResourceState}
    (hvalid : ValidSequence (before ++ t :: after) raw)
    {tool : String} (htool : tool ∈ t.tools) (hraw : ¬ Avail raw tool) :
    ∃ u ∈ before, tool ∈ u.outputs.map Prod.fst ∨ tool ∈ u.erects := by
  by_contra hcon
  push_neg at hcon
  unfold ValidSequence validSeq at hvalid
  rw [runSeq_append] at hvalid
  cases hr : runSeq raw before with
  | none => rw [hr] at hvalid; simp at hvalid
  | some s =>
      have hno : ∀ u ∈ before, tool ∉ u.outputs.map Prod.fst ∧ tool ∉ u.erects := by
        intro u hu
        exact ⟨fun h => (hcon u hu).1 h, fun h => (hcon u hu).2 h⟩
      have hns : ¬ Avail s tool := not_avail_of_no_producer before raw tool hno hraw s hr
      rw [hr] at hvalid
      simp only [Option.bind_some] at hvalid
      rw [runSeq] at hvalid
      by_cases hok : stepOk s t
      · unfold stepOk at hok
        have := (List.all_eq_true.1 (Bool.and_elim_left hok)) tool htool
        simp only [decide_eq_true_eq] at this
        exact hns this
      · rw [if_neg hok] at hvalid
        simp at hvalid

/-! ## Self-hosting -/

/-- The self-hosting property.  The sequence runs; it ends holding a complete
machine; and every tool it used was either built by the sequence itself or is
one of the declared bootstrap exceptions. -/
def SelfHosting (seq : BootstrapSeq) (raw : ResourceState) (exceptions : List String) : Prop :=
  ValidSequence seq raw ∧
    1 ≤ qty (finalState raw seq).consumables "complete_machine" ∧
    ∀ tool ∈ toolsUsed seq, tool ∈ producedIds seq ∨ tool ∈ exceptions

/-- The same thing as a Boolean check, so it can be run. -/
def selfHostingCheck (seq : BootstrapSeq) (raw : ResourceState) (exceptions : List String) : Bool :=
  validSeq raw seq && decide (1 ≤ qty (finalState raw seq).consumables "complete_machine") &&
    (toolsUsed seq).all
      (fun tool => (producedIds seq).contains tool || exceptions.contains tool)

/-- The checker decides the property. -/
theorem selfHosting_iff (seq : BootstrapSeq) (raw : ResourceState) (exceptions : List String) :
    SelfHosting seq raw exceptions ↔ selfHostingCheck seq raw exceptions = true := by
  unfold SelfHosting selfHostingCheck ValidSequence
  simp only [Bool.and_eq_true, decide_eq_true_eq, List.all_eq_true, Bool.or_eq_true,
    List.contains_iff_mem, and_assoc]

instance (seq : BootstrapSeq) (raw : ResourceState) (exceptions : List String) :
    Decidable (SelfHosting seq raw exceptions) :=
  decidable_of_iff _ (selfHosting_iff seq raw exceptions).symm

end TechTree
end LifeTrac
