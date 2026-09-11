import RequestProject.Gvcs.Plan

/-!
# Lower bounds: how few steps, and how little material, a bootstrap can take

`RequestProject/Plan.lean` shows that a particular plan *works*.  This file
asks the opposite question, the one a bootstrapper actually cares about: what
is the **least** a plan can possibly get away with?  Two bounds are proved,
both for an arbitrary production system and an arbitrary plan, so neither can
be evaded by being clever about the order of work.

* **Steps.**  Starting from a greenfield stock — a yard holding nothing the
  system knows how to make, only raw materials and whatever seed tools it was
  given — any plan that ends with a unit of the target must contain a
  production run for *every* item the target needs, however indirectly, as an
  input or as a tool (`steps_lower_bound`).  The proof is a positivity
  invariant: stock can only appear at an item that some run in the plan makes,
  and a run can only be admissible if the things it consumes and the tools it
  uses were themselves already positive.

* **Material.**  Weigh a stock by the raw-material content of everything in it
  (`rawContent`).  This quantity is *exactly conserved* by every production run
  (`rawContent_step`) — a workflow only ever re-packages the ore already in its
  inputs.  So a plan that ends holding a tractor must have started holding at
  least the tractor's raw-material demand (`rawContent_lower_bound`), and on a
  greenfield yard that says the raw materials must be there at the start, to
  the kilogram (`greenfield_material_lower_bound`).

The file also provides a Boolean admissibility checker (`planOKb`) with its
soundness proof, so that a concrete plan can be certified by computation.
-/

namespace LifeTrac
namespace Workflow
namespace Plant

variable {Item : Type} [DecidableEq Item]

/-! ## A Boolean admissibility checker -/

/-- Decision procedure for `StepOK`. -/
def stepOKb (P : Plant Item) (i : Item) (q : ℚ) (s : Item → ℚ) : Bool :=
  match P.recipe i with
  | none => false
  | some r => (r.inputs.all fun p => decide (q * p.2 / r.batch ≤ s p.1)) &&
      (r.tools.all fun t => decide (1 ≤ s t))

/-- Decision procedure for `PlanOK`. -/
def planOKb (P : Plant Item) : List (Item × ℚ) → (Item → ℚ) → Bool
  | [], _ => true
  | (i, q) :: l, s => stepOKb P i q s && planOKb P l (P.step i q s)

variable (P : Plant Item)

omit [DecidableEq Item] in
theorem stepOKb_sound {i : Item} {q : ℚ} {s : Item → ℚ} (h : P.stepOKb i q s = true) :
    P.StepOK i q s := by
  cases hr : P.recipe i with
  | none => rw [stepOKb, hr] at h; simp at h
  | some r =>
      rw [stepOKb, hr] at h
      rw [P.stepOK_recipe hr]
      simp only [Bool.and_eq_true, List.all_eq_true, decide_eq_true_eq] at h
      exact ⟨fun p hp => h.1 p hp, fun t ht => h.2 t ht⟩

/-- **The checker is sound.**  If the Boolean test passes, the plan really is
admissible step by step. -/
theorem planOKb_sound : ∀ (l : List (Item × ℚ)) (s : Item → ℚ), P.planOKb l s = true →
    P.PlanOK l s := by
  intro l
  induction l with
  | nil => intro s _; trivial
  | cons a t ih =>
      obtain ⟨i, q⟩ := a
      intro s h
      rw [planOKb, Bool.and_eq_true] at h
      exact ⟨P.stepOKb_sound h.1, ih _ h.2⟩

/-! ## The positivity invariant -/

theorem usedQty_nonneg {i : Item} {r : Recipe Item} (hr : P.recipe i = some r) {q : ℚ}
    (hq : 0 ≤ q) (x : Item) : 0 ≤ usedQty r q x := by
  refine List.sum_nonneg ?_
  intro y hy
  obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hy
  by_cases hx : x = p.1
  · simp only [hx, if_pos]
    exact div_nonneg (mul_nonneg hq (P.qty_nonneg i r hr p hp)) (P.batch_pos i r hr).le
  · simp [hx]

/-- Stock can only appear where a process in the plan puts it.  `S` is any set
of items closed under the processes the plan actually runs; if the starting
stock is positive only inside `S`, so is the finishing stock. -/
theorem pos_runPlan_mem (S : Item → Prop) (L : Item → Prop)
    (hclosed : ∀ i r, P.recipe i = some r → L i → (∀ p ∈ r.inputs, 0 < p.2 → S p.1) →
      (∀ t ∈ r.tools, S t) → S i) :
    ∀ (l : List (Item × ℚ)) (s : Item → ℚ), (∀ p ∈ l, 0 ≤ p.2) → P.PlanOK l s →
      (∀ p ∈ l, L p.1) → (∀ x, 0 < s x → S x) → ∀ x, 0 < P.runPlan l s x → S x := by
  intro l
  induction l with
  | nil => intro s _ _ _ hs x hx; exact hs x hx
  | cons a t ih =>
      obtain ⟨i, q⟩ := a
      intro s hq hOK hL hs x hx
      have hq0 : 0 ≤ q := hq (i, q) (List.mem_cons_self ..)
      refine ih (P.step i q s) (fun p hp => hq p (List.mem_cons_of_mem _ hp)) hOK.2
        (fun p hp => hL p (List.mem_cons_of_mem _ hp)) ?_ x hx
      -- the stock after the first run is still positive only inside `S`
      intro y hy
      cases hr : P.recipe i with
      | none =>
          rw [P.step_base hr] at hy; exact hs y hy
      | some r =>
          rw [P.step_recipe hr] at hy
          simp only at hy
          have hused := P.usedQty_nonneg hr hq0 y
          by_cases hyi : y = i
          · rw [if_pos hyi] at hy
            by_cases hpos : 0 < s y
            · exact hs y hpos
            · -- the run itself must be a positive one, so its inputs and tools were present
              have hspos : s y ≤ 0 := not_lt.1 hpos
              have hqpos : 0 < q := by linarith
              have hstep := (P.stepOK_recipe hr q s).1 hOK.1
              have hSi : S i := by
                refine hclosed i r hr (hL (i, q) (List.mem_cons_self ..)) ?_ ?_
                · intro p hp hp2
                  refine hs p.1 ?_
                  have h1 := hstep.1 p hp
                  have h2 : 0 < q * p.2 / r.batch :=
                    div_pos (mul_pos hqpos hp2) (P.batch_pos i r hr)
                  linarith
                · intro u hu
                  exact hs u (lt_of_lt_of_le zero_lt_one (hstep.2 u hu))
              rw [hyi]; exact hSi
          · rw [if_neg hyi, add_zero] at hy
            exact hs y (by linarith)

/-! ## What a target needs -/

/-- `NeedsPos i j`: making `i` calls directly for `j`, either as an input in a
positive quantity or as a tool. -/
def NeedsPos (i j : Item) : Prop :=
  ∃ r, P.recipe i = some r ∧ ((∃ q, 0 < q ∧ (j, q) ∈ r.inputs) ∨ j ∈ r.tools)

/-- The transitive closure: everything `i` needs, however indirectly. -/
def Needs : Item → Item → Prop := Relation.TransGen P.NeedsPos

/-- The items whose presence the plan can account for: either the plan was
handed them at the start (`Sup`), or it makes them itself with one of its own
runs (`L`). -/
inductive Reachable (Sup L : Item → Prop) : Item → Prop
  | start {x : Item} : Sup x → Reachable Sup L x
  | make {i : Item} {r : Recipe Item} : L i → P.recipe i = some r →
      (∀ p ∈ r.inputs, 0 < p.2 → Reachable Sup L p.1) →
      (∀ t ∈ r.tools, Reachable Sup L t) → Reachable Sup L i

variable {P}

omit [DecidableEq Item] in
theorem reachable_of_needsPos {Sup L : Item → Prop} (hSup : ∀ x, Sup x → P.recipe x = none)
    {i j : Item} (hi : P.Reachable Sup L i) (hij : P.NeedsPos i j) : P.Reachable Sup L j := by
  obtain ⟨r, hr, hj⟩ := hij
  cases hi with
  | start hx => rw [hSup _ hx] at hr; exact absurd hr (by simp)
  | @make i' r' hL hr' hin htool =>
      have hrr : r' = r := Option.some.inj (hr'.symm.trans hr)
      subst hrr
      rcases hj with ⟨q, hq, hqm⟩ | ht
      · exact hin (j, q) hqm hq
      · exact htool j ht

omit [DecidableEq Item] in
theorem reachable_of_needs {Sup L : Item → Prop} (hSup : ∀ x, Sup x → P.recipe x = none)
    {i j : Item} (hi : P.Reachable Sup L i) (hij : P.Needs i j) : P.Reachable Sup L j := by
  induction hij with
  | single h => exact reachable_of_needsPos hSup hi h
  | tail _ h ih => exact reachable_of_needsPos hSup ih h

omit [DecidableEq Item] in
theorem sup_or_L_of_reachable {Sup L : Item → Prop} {x : Item} (h : P.Reachable Sup L x) :
    Sup x ∨ L x := by
  cases h with
  | start hx => exact Or.inl hx
  | make hL _ _ _ => exact Or.inr hL

/-! ## The step bound -/

variable (P)

/-- The items a workflow calls for directly, in positive quantity or as a
tool. -/
def depsOf (P : Plant Item) (i : Item) : List Item :=
  match P.recipe i with
  | none => []
  | some r => (r.inputs.filterMap fun p => if 0 < p.2 then some p.1 else none) ++ r.tools

omit [DecidableEq Item] in
theorem depsOf_some {i : Item} {r : Recipe Item} (h : P.recipe i = some r) :
    P.depsOf i = (r.inputs.filterMap fun p => if 0 < p.2 then some p.1 else none) ++ r.tools := by
  rw [depsOf, h]

omit [DecidableEq Item] in
theorem depsOf_none {i : Item} (h : P.recipe i = none) : P.depsOf i = [] := by
  rw [depsOf, h]

omit [DecidableEq Item] in
theorem needsPos_of_mem_depsOf {i j : Item} (h : j ∈ P.depsOf i) : P.NeedsPos i j := by
  cases hr : P.recipe i with
  | none => rw [P.depsOf_none hr] at h; simp at h
  | some r =>
      rw [P.depsOf_some hr] at h
      refine ⟨r, hr, ?_⟩
      rcases List.mem_append.1 h with h' | h'
      · obtain ⟨p, hp, hp'⟩ := List.mem_filterMap.1 h'
        by_cases hq : 0 < p.2
        · rw [if_pos hq] at hp'
          have hpj : p.1 = j := Option.some.inj hp'
          subst hpj
          exact Or.inl ⟨p.2, hq, by simpa using hp⟩
        · rw [if_neg hq] at hp'; exact absurd hp' (by simp)
      · exact Or.inr h'

/-- One round of expansion: everything on the list, together with everything
those items call for. -/
def expandDeps (P : Plant Item) (S : List Item) : List Item :=
  (S ++ (S.map P.depsOf).flatten).dedup

/-- The dependency closure of an item, computed by `n` rounds of expansion. -/
def reachDeps (P : Plant Item) : ℕ → Item → List Item
  | 0, i => [i]
  | n + 1, i => expandDeps P (reachDeps P n i)

theorem mem_reachDeps {i : Item} : ∀ (n : ℕ) (x : Item), x ∈ P.reachDeps n i →
    x = i ∨ P.Needs i x := by
  intro n
  induction n with
  | zero => intro x hx; simp [reachDeps] at hx; exact Or.inl hx
  | succ n ih =>
      intro x hx
      rw [reachDeps, expandDeps] at hx
      simp only [List.mem_dedup, List.mem_append] at hx
      rcases hx with h | h
      · exact ih x h
      · obtain ⟨l, hl, hxl⟩ := List.mem_flatten.1 h
        obtain ⟨y, hy, rfl⟩ := List.mem_map.1 hl
        have hyx : P.NeedsPos y x := P.needsPos_of_mem_depsOf hxl
        rcases ih y hy with rfl | hiy
        · exact Or.inr (Relation.TransGen.single hyx)
        · exact Or.inr (hiy.tail hyx)

/-- **The step bound.**  Take any list of items, all of them made by the
system and each of them either the target itself or something the target
needs, however indirectly.  Then any
admissible plan that starts on a greenfield yard — nothing on the shelf that
the system knows how to make — and finishes with some of the target on it must
be at least that long: each of those items has to be produced by a run of its
own. -/
theorem steps_lower_bound (target : Item) (need : List Item) (hnd : need.Nodup)
    (hneed : ∀ j ∈ need, j = target ∨ P.Needs target j) (hnb : ∀ j ∈ need, P.recipe j ≠ none)
    (l : List (Item × ℚ)) (s : Item → ℚ) (hq : ∀ p ∈ l, 0 ≤ p.2) (hOK : P.PlanOK l s)
    (hs : ∀ x, 0 < s x → P.recipe x = none) (hprod : 0 < P.runPlan l s target) :
    need.length ≤ l.length := by
  set Sup : Item → Prop := fun x => P.recipe x = none with hSupdef
  set L : Item → Prop := fun x => x ∈ l.map Prod.fst with hLdef
  have hreach : P.Reachable Sup L target := by
    refine P.pos_runPlan_mem (P.Reachable Sup L) L ?_ l s hq hOK ?_ ?_ target hprod
    · intro i r hr hL hin htool
      exact Reachable.make hL hr hin htool
    · intro p hp
      exact List.mem_map.2 ⟨p, hp, rfl⟩
    · intro x hx
      exact Reachable.start (hs x hx)
  have hsub : need ⊆ l.map Prod.fst := by
    intro j hj
    have h1 : P.Reachable Sup L j := by
      rcases hneed j hj with rfl | h
      · exact hreach
      · exact reachable_of_needs (fun x hx => hx) hreach h
    rcases sup_or_L_of_reachable h1 with h | h
    · exact absurd h (hnb j hj)
    · exact h
  calc need.length ≤ (l.map Prod.fst).length := (hnd.subperm hsub).length_le
    _ = l.length := by simp

/-- **The step bound for several targets at once.**  The same argument when
the plan has to finish with *all* of a list of targets on the shelf: every
item needed by any of them must get a run of its own. -/
theorem steps_lower_bound_multi (targets need : List Item) (hnd : need.Nodup)
    (hneed : ∀ j ∈ need, ∃ t ∈ targets, j = t ∨ P.Needs t j)
    (hnb : ∀ j ∈ need, P.recipe j ≠ none)
    (l : List (Item × ℚ)) (s : Item → ℚ) (hq : ∀ p ∈ l, 0 ≤ p.2) (hOK : P.PlanOK l s)
    (hs : ∀ x, 0 < s x → P.recipe x = none) (hprod : ∀ t ∈ targets, 0 < P.runPlan l s t) :
    need.length ≤ l.length := by
  set Sup : Item → Prop := fun x => P.recipe x = none with hSupdef
  set L : Item → Prop := fun x => x ∈ l.map Prod.fst with hLdef
  have hreach : ∀ t ∈ targets, P.Reachable Sup L t := by
    intro t ht
    refine P.pos_runPlan_mem (P.Reachable Sup L) L ?_ l s hq hOK ?_ ?_ t (hprod t ht)
    · intro i r hr hL hin htool
      exact Reachable.make hL hr hin htool
    · intro p hp
      exact List.mem_map.2 ⟨p, hp, rfl⟩
    · intro x hx
      exact Reachable.start (hs x hx)
  have hsub : need ⊆ l.map Prod.fst := by
    intro j hj
    obtain ⟨t, ht, hjt⟩ := hneed j hj
    have h1 : P.Reachable Sup L j := by
      rcases hjt with rfl | h
      · exact hreach _ ht
      · exact reachable_of_needs (fun x hx => hx) (hreach t ht) h
    rcases sup_or_L_of_reachable h1 with h | h
    · exact absurd h (hnb j hj)
    · exact h
  calc need.length ≤ (l.map Prod.fst).length := (hnd.subperm hsub).length_le
    _ = l.length := by simp

/-! ## Propagating a demand backwards through the build order -/

/-- One backwards step: whatever is demanded of `i` is passed on to `i`'s
inputs, in the proportions its workflow calls for. -/
def bumpDemand (P : Plant Item) (d : Item → ℚ) (i : Item) : Item → ℚ :=
  match P.recipe i with
  | none => d
  | some r =>
      fun x => d x + (r.inputs.map (fun p => if x = p.1 then d i * p.2 / r.batch else 0)).sum

/-- The total quantity of every item an order `init` calls for, obtained by
walking a build order backwards and passing each demand on to its inputs. -/
def demandOf (P : Plant Item) (order : List Item) (init : Item → ℚ) : Item → ℚ :=
  order.reverse.foldl P.bumpDemand init

/-! ## The material bound -/

variable [Fintype Item]

/-- The raw-material content of a stock: how much of the base item `b` is
embodied in everything on the shelf. -/
def rawContent (b : Item) (s : Item → ℚ) : ℚ := ∑ x, s x * P.rawDemand x 1 b

theorem rawContent_add (b : Item) (s d : Item → ℚ) :
    P.rawContent b (fun x => s x + d x) = P.rawContent b s + P.rawContent b d := by
  simp [rawContent, add_mul, Finset.sum_add_distrib]

theorem rawContent_sub (b : Item) (s d : Item → ℚ) :
    P.rawContent b (fun x => s x - d x) = P.rawContent b s - P.rawContent b d := by
  simp [rawContent, sub_mul, Finset.sum_sub_distrib]

@[simp] theorem rawContent_zero (b : Item) : P.rawContent b (fun _ => 0) = 0 := by
  simp [rawContent]

/-- The raw-material content of a single item on an otherwise empty shelf. -/
theorem rawContent_single (b x : Item) (q : ℚ) :
    P.rawContent b (fun y => if y = x then q else 0) = q * P.rawDemand x 1 b := by
  rw [rawContent, Finset.sum_eq_single x]
  · simp
  · intro y _ hy; simp [hy]
  · intro h; exact absurd (Finset.mem_univ x) h

/-- **Raw material is conserved.**  A production run neither creates nor
destroys raw-material content: what comes off the shelf carries exactly the ore
that goes back on it. -/
theorem rawContent_step (b : Item) {i : Item} {q : ℚ} (s : Item → ℚ) :
    P.rawContent b (P.step i q s) = P.rawContent b s := by
  cases hr : P.recipe i with
  | none => rw [P.step_base hr]
  | some r =>
      rw [P.step_recipe hr]
      have hused : ∑ x, usedQty r q x * P.rawDemand x 1 b
          = (r.inputs.map fun p => (q * p.2 / r.batch) * P.rawDemand p.1 1 b).sum := by
        have hval := valueAt_listSum (Item := Item) (fun x => P.rawDemand x 1 b) r.inputs
          (fun p x => if x = p.1 then q * p.2 / r.batch else 0)
        simp only [valueAt] at hval
        rw [show (∑ x, usedQty r q x * P.rawDemand x 1 b)
            = ∑ x, (r.inputs.map fun p => if x = p.1 then q * p.2 / r.batch else 0).sum
                * P.rawDemand x 1 b from rfl, hval]
        refine congrArg List.sum (List.map_congr_left ?_)
        intro p _
        rw [Finset.sum_eq_single p.1]
        · simp
        · intro y _ hy; simp [hy]
        · intro h; exact absurd (Finset.mem_univ p.1) h
      have hdemand : P.rawDemand i q b
          = (r.inputs.map fun p => (q * p.2 / r.batch) * P.rawDemand p.1 1 b).sum := by
        rw [P.rawDemand_recipe hr]
        simp only
        refine congrArg List.sum (List.map_congr_left ?_)
        intro p _
        exact congrFun (P.rawDemand_eq_smul_one p.1 (q * p.2 / r.batch)) b
      have hq1 : P.rawDemand i q b = q * P.rawDemand i 1 b :=
        congrFun (P.rawDemand_eq_smul_one i q) b
      have hlast : ∑ x, (if x = i then q else 0) * P.rawDemand x 1 b = q * P.rawDemand i 1 b := by
        rw [Finset.sum_eq_single i]
        · simp
        · intro y _ hy; simp [hy]
        · intro h; exact absurd (Finset.mem_univ i) h
      simp only [rawContent, sub_mul, add_mul, Finset.sum_add_distrib, Finset.sum_sub_distrib]
      rw [hused, ← hdemand, hq1, hlast]
      ring

theorem rawContent_runPlan (b : Item) : ∀ (l : List (Item × ℚ)) (s : Item → ℚ),
    P.rawContent b (P.runPlan l s) = P.rawContent b s := by
  intro l
  induction l with
  | nil => intro s; rfl
  | cons a t ih =>
      obtain ⟨i, q⟩ := a
      intro s
      rw [runPlan_cons, ih _, P.rawContent_step b s]

/-! ### The stock never goes negative -/

/-- No workflow lists the same input twice. -/
def InputsNodup : Prop :=
  ∀ i r, P.recipe i = some r → (r.inputs.map Prod.fst).Nodup

omit [Fintype Item] in
theorem usedQty_le (hnd : P.InputsNodup) {i : Item} {r : Recipe Item} (hr : P.recipe i = some r)
    {s : Item → ℚ} (hs : ∀ x, 0 ≤ s x) {q : ℚ} (hOK : P.StepOK i q s) (x : Item) :
    usedQty r q x ≤ s x := by
  have hstep := (P.stepOK_recipe hr q s).1 hOK
  have hnd' := hnd i r hr
  have key : ∀ L : List (Item × ℚ), (L.map Prod.fst).Nodup → (∀ p ∈ L, p ∈ r.inputs) →
      (L.map fun p => if x = p.1 then q * p.2 / r.batch else 0).sum ≤ s x := by
    intro L
    induction L with
    | nil => intro _ _; simpa using hs x
    | cons a t ih =>
        intro hnodup hmem
        simp only [List.map_cons, List.sum_cons]
        by_cases hxa : x = a.1
        · have hrest : (t.map fun p => if x = p.1 then q * p.2 / r.batch else 0).sum = 0 := by
            refine List.sum_eq_zero ?_
            intro y hy
            obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hy
            have hne : x ≠ p.1 := by
              rintro rfl
              simp only [List.map_cons, List.nodup_cons] at hnodup
              exact hnodup.1 (List.mem_map.2 ⟨p, hp, hxa⟩)
            simp [hne]
          rw [hrest, if_pos hxa, add_zero, hxa]
          exact hstep.1 a (hmem a (List.mem_cons_self ..))
        · rw [if_neg hxa, zero_add]
          simp only [List.map_cons, List.nodup_cons] at hnodup
          exact ih hnodup.2 (fun p hp => hmem p (List.mem_cons_of_mem _ hp))
  exact key r.inputs hnd' (fun p hp => hp)

omit [Fintype Item] in
theorem step_nonneg (hnd : P.InputsNodup) {i : Item} {q : ℚ} (hq : 0 ≤ q) {s : Item → ℚ}
    (hs : ∀ x, 0 ≤ s x) (hOK : P.StepOK i q s) (x : Item) : 0 ≤ P.step i q s x := by
  cases hr : P.recipe i with
  | none => rw [P.step_base hr]; exact hs x
  | some r =>
      rw [P.step_recipe hr]
      simp only
      have h1 := P.usedQty_le hnd hr hs hOK x
      by_cases hx : x = i
      · rw [if_pos hx]
        linarith
      · rw [if_neg hx, add_zero]
        linarith

omit [Fintype Item] in
theorem runPlan_nonneg (hnd : P.InputsNodup) : ∀ (l : List (Item × ℚ)) (s : Item → ℚ),
    (∀ p ∈ l, 0 ≤ p.2) → P.PlanOK l s → (∀ x, 0 ≤ s x) → ∀ x, 0 ≤ P.runPlan l s x := by
  intro l
  induction l with
  | nil => intro s _ _ hs; exact hs
  | cons a t ih =>
      obtain ⟨i, q⟩ := a
      intro s hq hOK hs
      exact ih _ (fun p hp => hq p (List.mem_cons_of_mem _ hp)) hOK.2
        (P.step_nonneg hnd (hq (i, q) (List.mem_cons_self ..)) hs hOK.1)

/-! ### The bound itself -/

/-- **The material bound.**  Whatever the plan, the raw-material content of the
yard you start with is at least the raw-material demand of what you finish
with. -/
theorem rawContent_lower_bound (hnd : P.InputsNodup) (b target : Item)
    (l : List (Item × ℚ)) (s : Item → ℚ) (hq : ∀ p ∈ l, 0 ≤ p.2) (hOK : P.PlanOK l s)
    (hs : ∀ x, 0 ≤ s x) (hfin : 1 ≤ P.runPlan l s target) :
    P.rawDemand target 1 b ≤ P.rawContent b s := by
  have hnn := P.runPlan_nonneg hnd l s hq hOK hs
  have hcons : P.rawContent b (P.runPlan l s) = P.rawContent b s := P.rawContent_runPlan b l s
  have hterm : ∀ x ∈ (Finset.univ : Finset Item), 0 ≤ P.runPlan l s x * P.rawDemand x 1 b :=
    fun x _ => mul_nonneg (hnn x) (P.rawDemand_nonneg zero_le_one b)
  have hsingle : P.runPlan l s target * P.rawDemand target 1 b ≤ P.rawContent b (P.runPlan l s) :=
    Finset.single_le_sum hterm (Finset.mem_univ target)
  have hrd : (0:ℚ) ≤ P.rawDemand target 1 b := P.rawDemand_nonneg zero_le_one b
  nlinarith [hcons, hsingle, hrd, hfin]

/-- **The greenfield material bound.**  If the yard holds nothing the system
knows how to make, then for every raw material it must hold at least the
raw-material demand of the target — there is no cheaper route. -/
theorem greenfield_material_lower_bound (hnd : P.InputsNodup) {b : Item}
    (hb : P.recipe b = none) (target : Item)
    (l : List (Item × ℚ)) (s : Item → ℚ) (hq : ∀ p ∈ l, 0 ≤ p.2) (hOK : P.PlanOK l s)
    (hs : ∀ x, 0 ≤ s x) (hmade : ∀ x, P.recipe x ≠ none → s x = 0)
    (hfin : 1 ≤ P.runPlan l s target) :
    P.rawDemand target 1 b ≤ s b := by
  have h := P.rawContent_lower_bound hnd b target l s hq hOK hs hfin
  have heq : P.rawContent b s = s b := by
    rw [rawContent, Finset.sum_eq_single b]
    · rw [P.rawDemand_base hb]; simp
    · intro y _ hy
      by_cases hyb : P.recipe y = none
      · rw [P.rawDemand_base hyb]
        simp [Ne.symm hy]
      · rw [hmade y hyb]; ring
    · intro h'; exact absurd (Finset.mem_univ b) h'
  rw [heq] at h
  exact h

/-- The material bound for an order of `q` units rather than one. -/
theorem rawContent_lower_bound_qty (hnd : P.InputsNodup) (b target : Item) (q : ℚ)
    (l : List (Item × ℚ)) (s : Item → ℚ) (hq : ∀ p ∈ l, 0 ≤ p.2) (hOK : P.PlanOK l s)
    (hs : ∀ x, 0 ≤ s x) (hfin : q ≤ P.runPlan l s target) :
    q * P.rawDemand target 1 b ≤ P.rawContent b s := by
  have hnn := P.runPlan_nonneg hnd l s hq hOK hs
  have hcons : P.rawContent b (P.runPlan l s) = P.rawContent b s := P.rawContent_runPlan b l s
  have hterm : ∀ x ∈ (Finset.univ : Finset Item), 0 ≤ P.runPlan l s x * P.rawDemand x 1 b :=
    fun x _ => mul_nonneg (hnn x) (P.rawDemand_nonneg zero_le_one b)
  have hsingle : P.runPlan l s target * P.rawDemand target 1 b ≤ P.rawContent b (P.runPlan l s) :=
    Finset.single_le_sum hterm (Finset.mem_univ target)
  have hrd : (0:ℚ) ≤ P.rawDemand target 1 b := P.rawDemand_nonneg zero_le_one b
  nlinarith [hcons, hsingle, hrd, hfin]

/-- The raw-material content of a greenfield yard is just what is on its
shelves: nothing on it embodies anything else. -/
theorem rawContent_greenfield {b : Item} (hb : P.recipe b = none) (s : Item → ℚ)
    (hmade : ∀ x, P.recipe x ≠ none → s x = 0) : P.rawContent b s = s b := by
  rw [rawContent, Finset.sum_eq_single b]
  · rw [P.rawDemand_base hb]; simp
  · intro y _ hy
    by_cases hyb : P.recipe y = none
    · rw [P.rawDemand_base hyb]
      simp [Ne.symm hy]
    · rw [hmade y hyb]; ring
  · intro h'; exact absurd (Finset.mem_univ b) h'

/-- **The greenfield material bound, for an order of `q` units.** -/
theorem greenfield_material_lower_bound_qty (hnd : P.InputsNodup) {b : Item}
    (hb : P.recipe b = none) (target : Item) (q : ℚ)
    (l : List (Item × ℚ)) (s : Item → ℚ) (hq : ∀ p ∈ l, 0 ≤ p.2) (hOK : P.PlanOK l s)
    (hs : ∀ x, 0 ≤ s x) (hmade : ∀ x, P.recipe x ≠ none → s x = 0)
    (hfin : q ≤ P.runPlan l s target) :
    q * P.rawDemand target 1 b ≤ s b := by
  have h := P.rawContent_lower_bound_qty hnd b target q l s hq hOK hs hfin
  rwa [P.rawContent_greenfield hb s hmade] at h

end Plant
end Workflow
end LifeTrac
