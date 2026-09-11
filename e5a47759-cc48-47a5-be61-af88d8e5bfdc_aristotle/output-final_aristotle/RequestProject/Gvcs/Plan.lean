import RequestProject.Gvcs.Process

/-!
# Production plans: running the workflows against a stock

`RequestProject/Process.lean` says what a production system *is* and what an
order consumes.  This file says what it means to actually *work through* it.

A **plan** is a list of production runs, each a pair `(i, q)`: "make `q` units
of `i`".  A plan is run against a **stock** — how much of each item is on the
shelf.  A run is admissible only if the items it consumes are on the shelf and
the tools it needs are in the shop; it then removes what it consumes and adds
what it makes.

The main result, `plan_spec`, is that the plan produced by `Plant.plan` — make
the inputs, then make the thing — really works: starting from a shop that has
the tools and a yard holding exactly the raw-material demand of the order
(`Plant.rawDemand`), every step in turn is admissible, and the plan ends with
the ordered quantity on the shelf.  Nothing is missing and nothing has to be
bought in halfway through.

The one structural assumption is `ToolsNotConsumed`: an item used as a tool is
never eaten as an input.  (The LifeTrac system satisfies it — a lathe is not
melted down to make bar stock.)
-/

namespace LifeTrac
namespace Workflow

namespace Plant

variable {Item : Type} [DecidableEq Item] (P : Plant Item)

/-- What one order of size `q` for the recipe `r` takes off the shelf at the
item `x`. -/
def usedQty (r : Recipe Item) (q : ℚ) (x : Item) : ℚ :=
  (r.inputs.map (fun p => if x = p.1 then q * p.2 / r.batch else 0)).sum

/-- The stock after making `q` units of `i`: the inputs come off the shelf and
the output goes on it. -/
def step (P : Plant Item) (i : Item) (q : ℚ) (s : Item → ℚ) : Item → ℚ :=
  match P.recipe i with
  | none => s
  | some r => fun x => s x - usedQty r q x + (if x = i then q else 0)

/-- A production run is admissible when the shelf holds everything it
consumes and the shop holds every tool it needs. -/
def StepOK (P : Plant Item) (i : Item) (q : ℚ) (s : Item → ℚ) : Prop :=
  match P.recipe i with
  | none => False
  | some r => (∀ p ∈ r.inputs, q * p.2 / r.batch ≤ s p.1) ∧ (∀ t ∈ r.tools, 1 ≤ s t)

/-- The stock after working through a plan. -/
def runPlan (P : Plant Item) : List (Item × ℚ) → (Item → ℚ) → (Item → ℚ)
  | [], s => s
  | (i, q) :: l, s => P.runPlan l (P.step i q s)

/-- A plan is admissible when each of its runs is admissible in the stock
left by the runs before it. -/
def PlanOK (P : Plant Item) : List (Item × ℚ) → (Item → ℚ) → Prop
  | [], _ => True
  | (i, q) :: l, s => P.StepOK i q s ∧ P.PlanOK l (P.step i q s)

/-- An item that some workflow uses as a tool. -/
def IsTool (P : Plant Item) (t : Item) : Prop := ∃ j r, P.recipe j = some r ∧ t ∈ r.tools

/-- The standing assumption: nothing that is used as a tool is consumed as an
input anywhere in the system. -/
def ToolsNotConsumed (P : Plant Item) : Prop :=
  ∀ t, P.IsTool t → ∀ j r, P.recipe j = some r → ∀ p ∈ r.inputs, p.1 ≠ t

@[simp] theorem runPlan_nil (s : Item → ℚ) : P.runPlan [] s = s := rfl

@[simp] theorem runPlan_cons (i : Item) (q : ℚ) (l : List (Item × ℚ)) (s : Item → ℚ) :
    P.runPlan ((i, q) :: l) s = P.runPlan l (P.step i q s) := rfl

@[simp] theorem planOK_nil (s : Item → ℚ) : P.PlanOK [] s := trivial

@[simp] theorem planOK_cons (i : Item) (q : ℚ) (l : List (Item × ℚ)) (s : Item → ℚ) :
    P.PlanOK ((i, q) :: l) s ↔ P.StepOK i q s ∧ P.PlanOK l (P.step i q s) := Iff.rfl

theorem step_base {i : Item} (h : P.recipe i = none) (q : ℚ) (s : Item → ℚ) :
    P.step i q s = s := by rw [Plant.step, h]

theorem step_recipe {i : Item} {r : Recipe Item} (h : P.recipe i = some r) (q : ℚ)
    (s : Item → ℚ) :
    P.step i q s = fun x => s x - usedQty r q x + (if x = i then q else 0) := by
  rw [Plant.step, h]

omit [DecidableEq Item] in
theorem stepOK_recipe {i : Item} {r : Recipe Item} (h : P.recipe i = some r) (q : ℚ)
    (s : Item → ℚ) :
    P.StepOK i q s ↔
      ((∀ p ∈ r.inputs, q * p.2 / r.batch ≤ s p.1) ∧ (∀ t ∈ r.tools, 1 ≤ s t)) := by
  rw [Plant.StepOK, h]

/-! ## The frame rule: extra stock never hurts -/

theorem step_add (i : Item) (q : ℚ) (s d : Item → ℚ) :
    P.step i q (fun x => s x + d x) = fun x => P.step i q s x + d x := by
  cases h : P.recipe i with
  | none => rw [P.step_base h, P.step_base h]
  | some r => rw [P.step_recipe h, P.step_recipe h]; funext x; ring

theorem runPlan_add (l : List (Item × ℚ)) (s d : Item → ℚ) :
    P.runPlan l (fun x => s x + d x) = fun x => P.runPlan l s x + d x := by
  induction l generalizing s with
  | nil => rfl
  | cons a t ih => obtain ⟨i, q⟩ := a; rw [runPlan_cons, runPlan_cons, P.step_add, ih]

omit [DecidableEq Item] in
theorem stepOK_mono {i : Item} {q : ℚ} {s s' : Item → ℚ} (h : P.StepOK i q s)
    (hs : ∀ x, s x ≤ s' x) : P.StepOK i q s' := by
  cases hr : P.recipe i with
  | none => rw [Plant.StepOK, hr] at h; exact h.elim
  | some r =>
      rw [P.stepOK_recipe hr] at h ⊢
      exact ⟨fun p hp => (h.1 p hp).trans (hs p.1), fun t ht => (h.2 t ht).trans (hs t)⟩

theorem step_mono (i : Item) (q : ℚ) {s s' : Item → ℚ} (hs : ∀ x, s x ≤ s' x) (x : Item) :
    P.step i q s x ≤ P.step i q s' x := by
  cases hr : P.recipe i with
  | none => rw [P.step_base hr, P.step_base hr]; exact hs x
  | some r => rw [P.step_recipe hr, P.step_recipe hr]; simpa using hs x

theorem runPlan_mono (l : List (Item × ℚ)) {s s' : Item → ℚ} (hs : ∀ x, s x ≤ s' x) (x : Item) :
    P.runPlan l s x ≤ P.runPlan l s' x := by
  induction l generalizing s s' with
  | nil => exact hs x
  | cons a t ih =>
      obtain ⟨i, q⟩ := a
      exact ih (fun y => P.step_mono i q hs y)

theorem planOK_mono {l : List (Item × ℚ)} {s s' : Item → ℚ} (h : P.PlanOK l s)
    (hs : ∀ x, s x ≤ s' x) : P.PlanOK l s' := by
  induction l generalizing s s' with
  | nil => trivial
  | cons a t ih =>
      obtain ⟨i, q⟩ := a
      exact ⟨P.stepOK_mono h.1 hs, ih h.2 (fun y => P.step_mono i q hs y)⟩

theorem runPlan_append (l₁ l₂ : List (Item × ℚ)) (s : Item → ℚ) :
    P.runPlan (l₁ ++ l₂) s = P.runPlan l₂ (P.runPlan l₁ s) := by
  induction l₁ generalizing s with
  | nil => rfl
  | cons a t ih => obtain ⟨i, q⟩ := a; simpa using ih (P.step i q s)

theorem planOK_append {l₁ l₂ : List (Item × ℚ)} {s : Item → ℚ} (h₁ : P.PlanOK l₁ s)
    (h₂ : P.PlanOK l₂ (P.runPlan l₁ s)) : P.PlanOK (l₁ ++ l₂) s := by
  induction l₁ generalizing s with
  | nil => simpa using h₂
  | cons a t ih =>
      obtain ⟨i, q⟩ := a
      exact ⟨h₁.1, ih h₁.2 (by simpa using h₂)⟩

/-! ## Tools are never used up -/

theorem le_step_of_isTool (hT : P.ToolsNotConsumed) {t : Item} (ht : P.IsTool t)
    (i : Item) {q : ℚ} (hq : 0 ≤ q) (s : Item → ℚ) : s t ≤ P.step i q s t := by
  cases hr : P.recipe i with
  | none => rw [P.step_base hr]
  | some r =>
      have hstep : P.step i q s t = s t - usedQty r q t + (if t = i then q else 0) := by
        rw [P.step_recipe hr]
      have hzero : usedQty r q t = 0 := by
        refine List.sum_eq_zero ?_
        intro y hy
        obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hy
        have hne : t ≠ p.1 := fun h => hT t ht i r hr p hp h.symm
        simp [hne]
      rw [hstep, hzero]
      rcases eq_or_ne t i with rfl | hti
      · simp; linarith
      · simp [hti]

theorem le_runPlan_of_isTool (hT : P.ToolsNotConsumed) {t : Item} (ht : P.IsTool t)
    (l : List (Item × ℚ)) (hl : ∀ p ∈ l, 0 ≤ p.2) (s : Item → ℚ) :
    s t ≤ P.runPlan l s t := by
  induction l generalizing s with
  | nil => exact le_rfl
  | cons a u ih =>
      obtain ⟨i, q⟩ := a
      refine (P.le_step_of_isTool hT ht i (hl (i, q) (List.mem_cons_self ..)) s).trans ?_
      exact ih (fun p hp => hl p (List.mem_cons_of_mem _ hp)) (P.step i q s)

/-! ## The plan of an order, and the proof that it works -/

/-- The plan for an order: make everything the workflow consumes first (each
by its own plan), then run the workflow itself.  Base items need no work. -/
def plan (P : Plant Item) (i : Item) (q : ℚ) : List (Item × ℚ) :=
  match _h : P.recipe i with
  | none => []
  | some r =>
      (r.inputs.attach.map (fun p => P.plan p.1.1 (q * p.1.2 / r.batch))).flatten ++ [(i, q)]
termination_by P.rank i
decreasing_by exact P.rank_input i r _h _ p.2

omit [DecidableEq Item] in
@[simp] theorem plan_base {i : Item} (h : P.recipe i = none) (q : ℚ) : P.plan i q = [] := by
  rw [Plant.plan.eq_def, h]

omit [DecidableEq Item] in
theorem plan_recipe {i : Item} {r : Recipe Item} (h : P.recipe i = some r) (q : ℚ) :
    P.plan i q =
      (r.inputs.map (fun p => P.plan p.1 (q * p.2 / r.batch))).flatten ++ [(i, q)] := by
  rw [Plant.plan.eq_def, h]
  simp only []
  rw [List.map_attach_eq_pmap]
  simp [List.pmap_eq_map]

omit [DecidableEq Item] in
/-- Every production run in a plan is for a non-negative quantity. -/
theorem plan_qty_nonneg : ∀ (i : Item) (q : ℚ), 0 ≤ q → ∀ p ∈ P.plan i q, 0 ≤ p.2 := by
  refine P.rankInduction (M := fun i => ∀ q : ℚ, 0 ≤ q → ∀ p ∈ P.plan i q, 0 ≤ p.2) ?_
  intro i ih q hq p hp
  cases hr : P.recipe i with
  | none => rw [P.plan_base hr] at hp; simp at hp
  | some r =>
      rw [P.plan_recipe hr] at hp
      rcases List.mem_append.1 hp with h | h
      · obtain ⟨l, hl, hpl⟩ := List.mem_flatten.1 h
        obtain ⟨u, hu, rfl⟩ := List.mem_map.1 hl
        exact ih u.1 ⟨r, hr, Or.inl ⟨u.2, by simpa using hu⟩⟩ _
          (div_nonneg (mul_nonneg hq (P.qty_nonneg i r hr u hu)) (P.batch_pos i r hr).le) p hpl
      · rw [List.mem_singleton.1 h]
        exact hq

/-- The statement proved of every item by `plan_spec`: from a stock holding
the raw-material demand of the order and the tools, the plan is admissible and
leaves the order on the shelf, having consumed no more than the raw-material
demand. -/
def PlanWorks (P : Plant Item) (i : Item) (q : ℚ) : Prop :=
  ∀ s : Item → ℚ, (∀ x, P.rawDemand i q x ≤ s x) → (∀ t, P.IsTool t → 1 ≤ s t) →
    P.PlanOK (P.plan i q) s ∧
      ∀ x, s x - P.rawDemand i q x + (if x = i then q else 0) ≤ P.runPlan (P.plan i q) s x

/-- The list version: a batch of orders, each planned separately and run one
after another. -/
theorem plans_work (hT : P.ToolsNotConsumed) (ps : List (Item × ℚ))
    (hq : ∀ p ∈ ps, 0 ≤ p.2) (ih : ∀ p ∈ ps, P.PlanWorks p.1 p.2) :
    ∀ s : Item → ℚ,
      (∀ x, (ps.map (fun p => P.rawDemand p.1 p.2 x)).sum ≤ s x) →
      (∀ t, P.IsTool t → 1 ≤ s t) →
      P.PlanOK ((ps.map (fun p => P.plan p.1 p.2)).flatten) s ∧
        ∀ x, s x - (ps.map (fun p => P.rawDemand p.1 p.2 x)).sum
              + (ps.map (fun p => if x = p.1 then p.2 else 0)).sum
            ≤ P.runPlan ((ps.map (fun p => P.plan p.1 p.2)).flatten) s x := by
  induction ps with
  | nil => intro s _ _; exact ⟨trivial, fun x => by simp⟩
  | cons a t ihl =>
      intro s hs htool
      have haq : 0 ≤ a.2 := hq a (List.mem_cons_self ..)
      have hat : ∀ p ∈ t, 0 ≤ p.2 := fun p hp => hq p (List.mem_cons_of_mem _ hp)
      have hrest_nonneg : ∀ x, 0 ≤ (t.map (fun p => P.rawDemand p.1 p.2 x)).sum := by
        intro x
        refine List.sum_nonneg ?_
        intro y hy
        obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hy
        exact P.rawDemand_nonneg (hat p hp) x
      have ha_nonneg : ∀ x, 0 ≤ P.rawDemand a.1 a.2 x := fun x => P.rawDemand_nonneg haq x
      -- the head order can be met
      have hcov : ∀ x, P.rawDemand a.1 a.2 x ≤ s x := by
        intro x
        have := hs x
        simp only [List.map_cons, List.sum_cons] at this
        have := hrest_nonneg x
        linarith [hs x, hrest_nonneg x]
      obtain ⟨hokA, hafterA⟩ := ih a (List.mem_cons_self ..) s hcov htool
      set s' := P.runPlan (P.plan a.1 a.2) s with hs'
      -- the stock after the head order still covers the rest
      have hcov' : ∀ x, (t.map (fun p => P.rawDemand p.1 p.2 x)).sum ≤ s' x := by
        intro x
        have h1 := hafterA x
        have h2 := hs x
        simp only [List.map_cons, List.sum_cons] at h2
        have hite : (0:ℚ) ≤ (if x = a.1 then a.2 else 0) := by
          by_cases hx : x = a.1 <;> simp [hx, haq]
        linarith
      have htool' : ∀ u, P.IsTool u → 1 ≤ s' u := by
        intro u hu
        exact (htool u hu).trans
          (P.le_runPlan_of_isTool hT hu _ (P.plan_qty_nonneg a.1 a.2 haq) s)
      obtain ⟨hokT, hafterT⟩ := ihl hat (fun p hp => ih p (List.mem_cons_of_mem _ hp)) s' hcov' htool'
      constructor
      · simp only [List.map_cons, List.flatten_cons]
        exact P.planOK_append hokA (by rw [← hs']; exact hokT)
      · intro x
        have h1 := hafterA x
        have h2 := hafterT x
        simp only [List.map_cons, List.flatten_cons, List.sum_cons]
        rw [P.runPlan_append]
        rw [← hs']
        by_cases hx : x = a.1 <;> simp only [hx, if_pos] at h1 h2 ⊢ <;> linarith

/-- **The plan works.**  Given a shop with the tools and a yard holding the
raw-material demand of the order, the plan for an order of `q` units of `i` is
admissible step by step, and when it has been worked through there are `q`
units of `i` on the shelf. -/
theorem plan_spec (hT : P.ToolsNotConsumed) (i : Item) {q : ℚ} (hq : 0 ≤ q) :
    P.PlanWorks i q := by
  refine P.rankInduction (M := fun i => ∀ q : ℚ, 0 ≤ q → P.PlanWorks i q) (fun i ihr q hq => ?_) i q hq
  intro s hs htool
  cases hr : P.recipe i with
  | none =>
      refine ⟨by simp [P.plan_base hr], fun x => ?_⟩
      rw [P.plan_base hr, runPlan_nil, P.rawDemand_base hr]
      by_cases hx : x = i <;> simp [hx]
  | some r =>
      have hb : 0 < r.batch := P.batch_pos i r hr
      set ps := r.inputs.map (fun p => (p.1, q * p.2 / r.batch)) with hps
      have hqs : ∀ p ∈ ps, 0 ≤ p.2 := by
        intro p hp
        obtain ⟨u, hu, rfl⟩ := List.mem_map.1 hp
        exact div_nonneg (mul_nonneg hq (P.qty_nonneg i r hr u hu)) hb.le
      have hih : ∀ p ∈ ps, P.PlanWorks p.1 p.2 := by
        intro p hp
        obtain ⟨u, hu, rfl⟩ := List.mem_map.1 hp
        exact ihr u.1 ⟨r, hr, Or.inl ⟨u.2, by simpa using hu⟩⟩ _
          (div_nonneg (mul_nonneg hq (P.qty_nonneg i r hr u hu)) hb.le)
      -- the raw demand of the order is exactly the raw demand of its inputs
      have hraw : ∀ x, P.rawDemand i q x = (ps.map (fun p => P.rawDemand p.1 p.2 x)).sum := by
        intro x
        rw [P.rawDemand_recipe hr, hps]
        simp [Function.comp_def]
      have hs' : ∀ x, (ps.map (fun p => P.rawDemand p.1 p.2 x)).sum ≤ s x := by
        intro x; rw [← hraw x]; exact hs x
      obtain ⟨hok, hafter⟩ := P.plans_work hT ps hqs hih s hs' htool
      have hplan : P.plan i q = (ps.map (fun p => P.plan p.1 p.2)).flatten ++ [(i, q)] := by
        rw [P.plan_recipe hr, hps]; simp [Function.comp_def]
      set s₁ := P.runPlan ((ps.map (fun p => P.plan p.1 p.2)).flatten) s with hs₁
      -- what the inputs have produced is exactly what the final run consumes
      have hprod : ∀ x, usedQty r q x = (ps.map (fun p => if x = p.1 then p.2 else 0)).sum := by
        intro x
        rw [usedQty, hps]
        simp [Function.comp_def]
      have hstock : ∀ x, s x - P.rawDemand i q x + usedQty r q x ≤ s₁ x := by
        intro x
        rw [hraw x, hprod x]
        exact hafter x
      have hfinal : P.StepOK i q s₁ := by
        rw [P.stepOK_recipe hr]
        refine ⟨fun p hp => ?_, fun u hu => ?_⟩
        · have h1 := hstock p.1
          have h2 : P.rawDemand i q p.1 ≤ s p.1 := hs p.1
          have h3 : q * p.2 / r.batch ≤ usedQty r q p.1 := by
            rw [usedQty]
            refine List.single_le_sum ?_ _ (List.mem_map.2 ⟨p, hp, by simp⟩)
            · intro y hy
              obtain ⟨u, hu, rfl⟩ := List.mem_map.1 hy
              by_cases hx : p.1 = u.1
              · simp only [hx, if_pos]
                exact div_nonneg (mul_nonneg hq (P.qty_nonneg i r hr u hu)) hb.le
              · simp [hx]
          linarith
        · have h1 := htool u ⟨i, r, hr, hu⟩
          have hflat : ∀ z ∈ (ps.map (fun p => P.plan p.1 p.2)).flatten, 0 ≤ z.2 := by
            intro z hz
            obtain ⟨l, hl, hzl⟩ := List.mem_flatten.1 hz
            obtain ⟨o, ho, rfl⟩ := List.mem_map.1 hl
            exact P.plan_qty_nonneg o.1 o.2 (hqs o ho) z hzl
          have h2 := P.le_runPlan_of_isTool hT ⟨i, r, hr, hu⟩
            ((ps.map (fun p => P.plan p.1 p.2)).flatten) hflat s
          linarith
      refine ⟨?_, fun x => ?_⟩
      · rw [hplan]
        exact P.planOK_append hok (by rw [← hs₁]; exact ⟨hfinal, trivial⟩)
      · rw [hplan, P.runPlan_append, ← hs₁]
        simp only [runPlan_cons, runPlan_nil]
        rw [P.step_recipe hr]
        have hst := hstock x
        rcases eq_or_ne x i with rfl | hx
        · simp only [if_pos]
          linarith
        · simp only [if_neg hx]
          linarith

/-- Read off the headline: after the plan, the ordered quantity is on the
shelf. -/
theorem plan_produces (hT : P.ToolsNotConsumed) (i : Item) {q : ℚ} (hq : 0 ≤ q)
    (s : Item → ℚ) (hs : ∀ x, P.rawDemand i q x ≤ s x) (htool : ∀ t, P.IsTool t → 1 ≤ s t) :
    P.PlanOK (P.plan i q) s ∧ s i - P.rawDemand i q i + q ≤ P.runPlan (P.plan i q) s i := by
  obtain ⟨h1, h2⟩ := P.plan_spec hT i hq s hs htool
  exact ⟨h1, by simpa using h2 i⟩

end Plant
end Workflow
end LifeTrac
