import Mathlib

/-!
# Production workflows: a general theory

The other build-side module of this project (`RequestProject/Materials.lean`)
takes the stock catalogue — tube, plate, hose, an engine — as *given* and
explodes the tractor into it.  This module goes the other way and asks where
the stock itself comes from: it models a whole production system in which
every item is either made by a **workflow** out of other items, or is a
**base** item that the system does not make and must be supplied with.

A workflow (`Recipe`) says: one run of this process consumes such-and-such
quantities of such-and-such items, needs such-and-such tools (which it does
*not* consume), takes so many hours of labour, and yields `batch` units of its
output.  A `Plant` is a whole catalogue of workflows, one per item, together
with a `rank` that certifies the catalogue is not circular: whatever a process
consumes, and whatever tool it uses, is strictly simpler than what it makes.

The main results are:

* `Plant.rankInduction` — the induction principle the rank certificate buys.
* `Plant.producible` — *everything the plant makes can be made from base items
  alone*: the production system bottoms out in raw materials and a seed
  toolkit.
* `Plant.rawDemand` — the base-item demand of a production order, proved to be
  supported on base items (`Plant.rawDemand_eq_zero_of_made`), non-negative and
  exactly proportional to the size of the order.
* `Plant.laborFor` — the labour in the whole chain, likewise proportional.
* `Plant.toolClosure` — every tool used anywhere in the chain; proved to
  consist of strictly simpler items, so no machine is needed in order to build
  itself.
* `Plant.chainCost_eq` — the cost of anything is the cost of the base material
  in it plus the wage bill of all the labour in its chain.
-/

namespace LifeTrac
namespace Workflow

/-- A single production workflow: one run consumes `inputs`, occupies `tools`
(which survive the run), takes `labor` hours, and produces `batch` units of the
item it is the recipe for. -/
structure Recipe (Item : Type) where
  /-- Units of output produced by one run of the process. -/
  batch : ℚ
  /-- The items consumed by one run, with their quantities. -/
  inputs : List (Item × ℚ)
  /-- The tools and machines the process needs; they are not consumed. -/
  tools : List Item
  /-- Hours of labour for one run. -/
  labor : ℚ
  deriving Inhabited

/-- A production system: a workflow for some of the items, and a `rank`
certifying that the system is not circular — everything a process consumes or
uses as a tool is of strictly smaller rank than its output.  Items with no
workflow (`recipe i = none`) are the **base**: raw materials the system digs
up or buys, and the seed tools it starts with. -/
structure Plant (Item : Type) where
  /-- The workflow that makes an item, if the system makes it at all. -/
  recipe : Item → Option (Recipe Item)
  /-- The certificate of non-circularity. -/
  rank : Item → ℕ
  /-- One run of a process makes a positive number of units. -/
  batch_pos : ∀ i r, recipe i = some r → 0 < r.batch
  /-- No process consumes a negative quantity. -/
  qty_nonneg : ∀ i r, recipe i = some r → ∀ p ∈ r.inputs, 0 ≤ p.2
  /-- No process takes negative time. -/
  labor_nonneg : ∀ i r, recipe i = some r → 0 ≤ r.labor
  /-- Inputs are strictly simpler than the output. -/
  rank_input : ∀ i r, recipe i = some r → ∀ p ∈ r.inputs, rank p.1 < rank i
  /-- Tools are strictly simpler than what they are used to make. -/
  rank_tool : ∀ i r, recipe i = some r → ∀ t ∈ r.tools, rank t < rank i

namespace Plant

variable {Item : Type} (P : Plant Item)

/-- An item the system does not make: a raw material or a seed tool. -/
def Base (i : Item) : Prop := P.recipe i = none

/-- `Requires i j` : making `i` calls directly for `j`, either as an input or
as a tool. -/
def Requires (i j : Item) : Prop :=
  ∃ r, P.recipe i = some r ∧ ((∃ q, (j, q) ∈ r.inputs) ∨ j ∈ r.tools)

theorem rank_lt_of_requires {i j : Item} (h : P.Requires i j) : P.rank j < P.rank i := by
  obtain ⟨r, hr, hj | hj⟩ := h
  · obtain ⟨q, hq⟩ := hj
    exact P.rank_input i r hr (j, q) hq
  · exact P.rank_tool i r hr j hj

/-- The dependency relation of a plant is well founded: nothing depends,
however indirectly, on itself. -/
theorem requires_wf : WellFounded (fun j i => P.Requires i j) :=
  Subrelation.wf (fun h => P.rank_lt_of_requires h)
    (InvImage.wf P.rank (wellFounded_lt (α := ℕ)))

/-- Nothing is needed in order to make itself. -/
theorem not_requires_self (i : Item) : ¬ P.Requires i i := fun h =>
  absurd (P.rank_lt_of_requires h) (lt_irrefl _)

/-- The induction principle a plant supports: to prove a statement of every
item it is enough to prove it of an item whenever it holds of everything that
item directly requires. -/
theorem rankInduction {M : Item → Prop}
    (h : ∀ i, (∀ j, P.Requires i j → M j) → M i) : ∀ i, M i := by
  have key : ∀ n i, P.rank i < n → M i := by
    intro n
    induction n with
    | zero => intro i hi; exact absurd hi (Nat.not_lt_zero _)
    | succ n ih =>
        intro i hi
        refine h i fun j hj => ih j ?_
        have := P.rank_lt_of_requires hj
        omega
  intro i
  exact key (P.rank i + 1) i (Nat.lt_succ_self _)

/-! ## Everything bottoms out in the base -/

/-- `Producible i` : `i` can be brought into existence given a supply of base
items — either it *is* a base item, or its workflow's inputs and tools are all
producible. -/
inductive Producible : Item → Prop
  | base {i : Item} : P.recipe i = none → Producible i
  | make {i : Item} {r : Recipe Item} : P.recipe i = some r →
      (∀ p ∈ r.inputs, Producible p.1) → (∀ t ∈ r.tools, Producible t) → Producible i

/-- **The system is grounded in raw materials.**  Every item of a plant,
including every tool the plant uses and every tool needed to build those
tools, can be produced from base items alone. -/
theorem producible (i : Item) : P.Producible i := by
  refine P.rankInduction (M := P.Producible) (fun i ih => ?_) i
  cases hr : P.recipe i with
  | none => exact .base hr
  | some r =>
      refine .make hr (fun p hp => ih p.1 ⟨r, hr, Or.inl ⟨p.2, ?_⟩⟩)
        (fun t ht => ih t ⟨r, hr, Or.inr ht⟩)
      simpa using hp

/-- A set of items that contains every base item and is closed under the
workflows contains everything: the base is a *sufficient* starting stock. -/
theorem mem_of_base_subset {S : Set Item} (hbase : ∀ i, P.recipe i = none → i ∈ S)
    (hclosed : ∀ i r, P.recipe i = some r → (∀ p ∈ r.inputs, p.1 ∈ S) →
      (∀ t ∈ r.tools, t ∈ S) → i ∈ S) (i : Item) : i ∈ S := by
  refine P.rankInduction (M := fun i => i ∈ S) (fun i ih => ?_) i
  cases hr : P.recipe i with
  | none => exact hbase i hr
  | some r =>
      refine hclosed i r hr (fun p hp => ih p.1 ⟨r, hr, Or.inl ⟨p.2, ?_⟩⟩)
        (fun t ht => ih t ⟨r, hr, Or.inr ht⟩)
      simpa using hp

/-! ## The base-material demand of an order -/

/-- `P.rawDemand i q` is the quantity of each base item consumed, over the
whole chain of workflows, by an order for `q` units of `i`. -/
def rawDemand [DecidableEq Item] (P : Plant Item) (i : Item) (q : ℚ) : Item → ℚ :=
  match _h : P.recipe i with
  | none => fun x => if x = i then q else 0
  | some r => fun x =>
      ((r.inputs.attach.map (fun p => P.rawDemand p.1.1 (q * p.1.2 / r.batch) x)).sum)
termination_by P.rank i
decreasing_by exact P.rank_input i r _h _ p.2

@[simp] theorem rawDemand_base [DecidableEq Item] {i : Item} (h : P.recipe i = none) (q : ℚ) :
    P.rawDemand i q = fun x => if x = i then q else 0 := by
  rw [Plant.rawDemand.eq_def, h]

theorem rawDemand_recipe [DecidableEq Item] {i : Item} {r : Recipe Item} (h : P.recipe i = some r) (q : ℚ) :
    P.rawDemand i q =
      fun x => ((r.inputs.map (fun p => P.rawDemand p.1 (q * p.2 / r.batch) x)).sum) := by
  rw [Plant.rawDemand.eq_def, h]
  funext x
  simp only []
  rw [List.map_attach_eq_pmap]
  simp [List.pmap_eq_map]

/-- A single unfolding step of `rawDemand`, in a form `simp` can apply
repeatedly: it computes the demand of an order from the recipe of the item. -/
theorem rawDemand_eq [DecidableEq Item] (i : Item) (q : ℚ) :
    P.rawDemand i q = fun x =>
      match P.recipe i with
      | none => if x = i then q else 0
      | some r => (r.inputs.map (fun p => P.rawDemand p.1 (q * p.2 / r.batch) x)).sum := by
  cases h : P.recipe i with
  | none => rw [P.rawDemand_base h]
  | some r => rw [P.rawDemand_recipe h]

/-- Nothing the plant knows how to make appears in the base-material demand:
the demand is expressed purely in raw materials. -/
theorem rawDemand_eq_zero_of_made [DecidableEq Item] {x : Item} (hx : P.recipe x ≠ none) :
    ∀ i q, P.rawDemand i q x = 0 := by
  refine P.rankInduction (M := fun i => ∀ q, P.rawDemand i q x = 0) (fun i ih q => ?_)
  cases hr : P.recipe i with
  | none =>
      rw [P.rawDemand_base hr]
      have : x ≠ i := by rintro rfl; exact hx hr
      simp [this]
  | some r =>
      rw [P.rawDemand_recipe hr]
      refine List.sum_eq_zero ?_
      intro y hy
      obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hy
      exact ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩ _

/-- An order for nothing consumes nothing. -/
@[simp] theorem rawDemand_zero [DecidableEq Item] (i : Item) : P.rawDemand i 0 = fun _ => 0 := by
  refine P.rankInduction (M := fun i => P.rawDemand i 0 = fun _ => 0) (fun i ih => ?_) i
  cases hr : P.recipe i with
  | none => rw [P.rawDemand_base hr]; funext x; simp
  | some r =>
      rw [P.rawDemand_recipe hr]
      funext x
      refine List.sum_eq_zero ?_
      intro y hy
      obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hy
      have := ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩
      simp [this]

/-- **Demand is proportional to the order.**  Twice the tractors, twice the
ore. -/
theorem rawDemand_smul [DecidableEq Item] (i : Item) (c q : ℚ) :
    P.rawDemand i (c * q) = fun x => c * P.rawDemand i q x := by
  refine P.rankInduction
    (M := fun i => ∀ q, P.rawDemand i (c * q) = fun x => c * P.rawDemand i q x)
    (fun i ih q => ?_) i q
  cases hr : P.recipe i with
  | none => rw [P.rawDemand_base hr, P.rawDemand_base hr]; funext x; by_cases h : x = i <;> simp [h]
  | some r =>
      rw [P.rawDemand_recipe hr, P.rawDemand_recipe hr]
      funext x
      rw [← List.sum_map_mul_left]
      refine congrArg List.sum (List.map_congr_left ?_)
      intro p hp
      have hcalc : c * q * p.2 / r.batch = c * (q * p.2 / r.batch) := by ring
      rw [hcalc, ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩]

/-- The demand of an order of size `q` is `q` times the demand of a single
unit. -/
theorem rawDemand_eq_smul_one [DecidableEq Item] (i : Item) (q : ℚ) :
    P.rawDemand i q = fun x => q * P.rawDemand i 1 x := by
  simpa using P.rawDemand_smul i q 1

theorem rawDemand_nonneg [DecidableEq Item] {i : Item} {q : ℚ} (hq : 0 ≤ q) (x : Item) :
    0 ≤ P.rawDemand i q x := by
  refine P.rankInduction (M := fun i => ∀ q, 0 ≤ q → 0 ≤ P.rawDemand i q x)
    (fun i ih q hq => ?_) i q hq
  cases hr : P.recipe i with
  | none => rw [P.rawDemand_base hr]; by_cases h : x = i <;> simp [h, hq]
  | some r =>
      rw [P.rawDemand_recipe hr]
      refine List.sum_nonneg ?_
      intro y hy
      obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hy
      have hmem : p ∈ r.inputs := hp
      have h2 : 0 ≤ p.2 := P.qty_nonneg i r hr p hmem
      have hb : 0 < r.batch := P.batch_pos i r hr
      exact ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩ _
        (div_nonneg (mul_nonneg hq h2) hb.le)

/-- A base item is its own demand. -/
theorem rawDemand_self_of_base [DecidableEq Item] {i : Item} (h : P.recipe i = none) (q : ℚ) :
    P.rawDemand i q i = q := by
  rw [P.rawDemand_base h]; simp

/-! ## Labour -/

/-- The total labour, in hours, in the whole chain of workflows behind an
order for `q` units of `i` — assuming the tools are already on hand. -/
def laborFor (P : Plant Item) (i : Item) (q : ℚ) : ℚ :=
  match _h : P.recipe i with
  | none => 0
  | some r =>
      q / r.batch * r.labor +
        (r.inputs.attach.map (fun p => P.laborFor p.1.1 (q * p.1.2 / r.batch))).sum
termination_by P.rank i
decreasing_by exact P.rank_input i r _h _ p.2

@[simp] theorem laborFor_base {i : Item} (h : P.recipe i = none) (q : ℚ) :
    P.laborFor i q = 0 := by
  rw [Plant.laborFor.eq_def, h]

theorem laborFor_recipe {i : Item} {r : Recipe Item} (h : P.recipe i = some r) (q : ℚ) :
    P.laborFor i q =
      q / r.batch * r.labor + (r.inputs.map (fun p => P.laborFor p.1 (q * p.2 / r.batch))).sum := by
  rw [Plant.laborFor.eq_def, h]
  simp only []
  rw [List.map_attach_eq_pmap]
  simp [List.pmap_eq_map]

/-- A single unfolding step of `laborFor`, in a form `simp` can apply
repeatedly. -/
theorem laborFor_eq (i : Item) (q : ℚ) :
    P.laborFor i q =
      match P.recipe i with
      | none => 0
      | some r => q / r.batch * r.labor +
          (r.inputs.map (fun p => P.laborFor p.1 (q * p.2 / r.batch))).sum := by
  cases h : P.recipe i with
  | none => rw [P.laborFor_base h]
  | some r => rw [P.laborFor_recipe h]

theorem laborFor_nonneg {i : Item} {q : ℚ} (hq : 0 ≤ q) : 0 ≤ P.laborFor i q := by
  refine P.rankInduction (M := fun i => ∀ q, 0 ≤ q → 0 ≤ P.laborFor i q) (fun i ih q hq => ?_) i q hq
  cases hr : P.recipe i with
  | none => simp [P.laborFor_base hr]
  | some r =>
      rw [P.laborFor_recipe hr]
      have hb : 0 < r.batch := P.batch_pos i r hr
      have hl : 0 ≤ r.labor := P.labor_nonneg i r hr
      have h1 : 0 ≤ q / r.batch * r.labor := mul_nonneg (div_nonneg hq hb.le) hl
      have h2 : 0 ≤ (r.inputs.map (fun p => P.laborFor p.1 (q * p.2 / r.batch))).sum := by
        refine List.sum_nonneg ?_
        intro y hy
        obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hy
        exact ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩ _
          (div_nonneg (mul_nonneg hq (P.qty_nonneg i r hr p hp)) hb.le)
      linarith

/-- The labour in an order is proportional to its size. -/
theorem laborFor_smul (i : Item) (c q : ℚ) : P.laborFor i (c * q) = c * P.laborFor i q := by
  refine P.rankInduction (M := fun i => ∀ q, P.laborFor i (c * q) = c * P.laborFor i q)
    (fun i ih q => ?_) i q
  cases hr : P.recipe i with
  | none => simp [P.laborFor_base hr]
  | some r =>
      rw [P.laborFor_recipe hr, P.laborFor_recipe hr, mul_add, ← List.sum_map_mul_left]
      congr 1
      · ring
      · refine congrArg List.sum (List.map_congr_left ?_)
        intro p hp
        have hcalc : c * q * p.2 / r.batch = c * (q * p.2 / r.batch) := by ring
        rw [hcalc, ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩]

theorem laborFor_eq_smul_one (i : Item) (q : ℚ) : P.laborFor i q = q * P.laborFor i 1 := by
  simpa using P.laborFor_smul i q 1

/-! ## The tooling: what the workshop must contain -/

/-- Every tool used anywhere in the chain that makes `i`: the tools of its own
workflow, the tools needed to make *those* tools, and the tools used further
down the chain. -/
def toolClosure (P : Plant Item) (i : Item) : List Item :=
  match _h : P.recipe i with
  | none => []
  | some r =>
      r.tools ++ (r.tools.attach.map (fun t => P.toolClosure t.1)).flatten
        ++ (r.inputs.attach.map (fun p => P.toolClosure p.1.1)).flatten
termination_by P.rank i
decreasing_by
  · exact P.rank_tool i r _h _ t.2
  · exact P.rank_input i r _h _ p.2

@[simp] theorem toolClosure_base {i : Item} (h : P.recipe i = none) :
    P.toolClosure i = [] := by
  rw [Plant.toolClosure.eq_def, h]

theorem toolClosure_recipe {i : Item} {r : Recipe Item} (h : P.recipe i = some r) :
    P.toolClosure i =
      r.tools ++ (r.tools.map (fun t => P.toolClosure t)).flatten
        ++ (r.inputs.map (fun p => P.toolClosure p.1)).flatten := by
  rw [Plant.toolClosure.eq_def, h]
  simp only []
  rw [List.map_attach_eq_pmap, List.map_attach_eq_pmap]
  simp [List.pmap_eq_map]

/-- A single unfolding step of `toolClosure`, in a form `simp` can apply
repeatedly. -/
theorem toolClosure_eq (i : Item) :
    P.toolClosure i =
      match P.recipe i with
      | none => []
      | some r => r.tools ++ (r.tools.map (fun t => P.toolClosure t)).flatten
          ++ (r.inputs.map (fun p => P.toolClosure p.1)).flatten := by
  cases h : P.recipe i with
  | none => rw [P.toolClosure_base h]
  | some r => rw [P.toolClosure_recipe h]

/-- **No machine is needed in order to build itself.**  Every tool anywhere in
the chain behind an item is strictly simpler than that item; in particular the
tooling of the workshop can be bootstrapped in order of rank. -/
theorem rank_lt_of_mem_toolClosure {i t : Item} (h : t ∈ P.toolClosure i) :
    P.rank t < P.rank i := by
  refine P.rankInduction (M := fun i => ∀ t ∈ P.toolClosure i, P.rank t < P.rank i)
    (fun i ih t ht => ?_) i t h
  cases hr : P.recipe i with
  | none => rw [P.toolClosure_base hr] at ht; simp at ht
  | some r =>
      rw [P.toolClosure_recipe hr] at ht
      rcases List.mem_append.1 ht with ht' | ht'
      · rcases List.mem_append.1 ht' with ht'' | ht''
        · exact P.rank_tool i r hr t ht''
        · obtain ⟨l, hl, htl⟩ := List.mem_flatten.1 ht''
          obtain ⟨u, hu, rfl⟩ := List.mem_map.1 hl
          exact lt_trans (ih u ⟨r, hr, Or.inr hu⟩ t htl) (P.rank_tool i r hr u hu)
      · obtain ⟨l, hl, htl⟩ := List.mem_flatten.1 ht'
        obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hl
        exact lt_trans (ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩ t htl)
          (P.rank_input i r hr p hp)

/-- Nothing is in its own tool closure. -/
theorem not_mem_toolClosure_self (i : Item) : i ∉ P.toolClosure i := fun h =>
  absurd (P.rank_lt_of_mem_toolClosure h) (lt_irrefl _)

/-- The tools of an item's own workflow are part of its tool closure. -/
theorem tools_subset_toolClosure {i : Item} {r : Recipe Item} (h : P.recipe i = some r) :
    ∀ t ∈ r.tools, t ∈ P.toolClosure i := by
  intro t ht
  rw [P.toolClosure_recipe h]
  exact List.mem_append.2 (Or.inl (List.mem_append.2 (Or.inl ht)))

/-- The tool closure is closed: whatever is needed to build a tool in it is
also in it. -/
theorem toolClosure_trans {i t u : Item} (ht : t ∈ P.toolClosure i)
    (hu : u ∈ P.toolClosure t) : u ∈ P.toolClosure i := by
  refine P.rankInduction
    (M := fun i => ∀ t u, t ∈ P.toolClosure i → u ∈ P.toolClosure t → u ∈ P.toolClosure i)
    (fun i ih t u ht hu => ?_) i t u ht hu
  cases hr : P.recipe i with
  | none => rw [P.toolClosure_base hr] at ht; simp at ht
  | some r =>
      rw [P.toolClosure_recipe hr] at ht ⊢
      rcases List.mem_append.1 ht with ht' | ht'
      · rcases List.mem_append.1 ht' with ht'' | ht''
        · exact List.mem_append.2 (Or.inl (List.mem_append.2 (Or.inr
            (List.mem_flatten.2 ⟨P.toolClosure t, List.mem_map.2 ⟨t, ht'', rfl⟩, hu⟩))))
        · obtain ⟨l, hl, htl⟩ := List.mem_flatten.1 ht''
          obtain ⟨w, hw, rfl⟩ := List.mem_map.1 hl
          have := ih w ⟨r, hr, Or.inr hw⟩ t u htl hu
          exact List.mem_append.2 (Or.inl (List.mem_append.2 (Or.inr
            (List.mem_flatten.2 ⟨P.toolClosure w, List.mem_map.2 ⟨w, hw, rfl⟩, this⟩))))
      · obtain ⟨l, hl, htl⟩ := List.mem_flatten.1 ht'
        obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hl
        have := ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩ t u htl hu
        exact List.mem_append.2 (Or.inr
          (List.mem_flatten.2 ⟨P.toolClosure p.1, List.mem_map.2 ⟨p, hp, rfl⟩, this⟩))

/-! ## Cost accounting -/

variable [Fintype Item]

/-- The purchase value of a quantity vector at given base prices. -/
def valueAt (price : Item → ℚ) (f : Item → ℚ) : ℚ := ∑ x, f x * price x

theorem valueAt_listSum (price : Item → ℚ) {α : Type} (l : List α) (g : α → Item → ℚ) :
    valueAt price (fun x => (l.map (fun a => g a x)).sum) = (l.map (fun a => valueAt price (g a))).sum := by
  induction l with
  | nil => simp [valueAt]
  | cons a t ih =>
      simp only [List.map_cons, List.sum_cons]
      rw [← ih]
      simp [valueAt, add_mul, Finset.sum_add_distrib]

/-- The cost of an order, worked out step by step: base items cost their
price, and every process adds its wage bill to the cost of its inputs. -/
def chainCost (P : Plant Item) (price : Item → ℚ) (wage : ℚ) (i : Item) (q : ℚ) : ℚ :=
  match _h : P.recipe i with
  | none => q * price i
  | some r =>
      wage * (q / r.batch * r.labor) +
        (r.inputs.attach.map (fun p => P.chainCost price wage p.1.1 (q * p.1.2 / r.batch))).sum
termination_by P.rank i
decreasing_by exact P.rank_input i r _h _ p.2

omit [Fintype Item] in
@[simp] theorem chainCost_base (price : Item → ℚ) (wage : ℚ) {i : Item}
    (h : P.recipe i = none) (q : ℚ) : P.chainCost price wage i q = q * price i := by
  rw [Plant.chainCost.eq_def, h]

omit [Fintype Item] in
theorem chainCost_recipe (price : Item → ℚ) (wage : ℚ) {i : Item} {r : Recipe Item}
    (h : P.recipe i = some r) (q : ℚ) :
    P.chainCost price wage i q =
      wage * (q / r.batch * r.labor) +
        (r.inputs.map (fun p => P.chainCost price wage p.1 (q * p.2 / r.batch))).sum := by
  rw [Plant.chainCost.eq_def, h]
  simp only []
  rw [List.map_attach_eq_pmap]
  simp [List.pmap_eq_map]

/-- **The cost decomposition.**  Whatever the depth of the production chain,
the cost of an order is exactly the cost of the raw materials that go into it
plus the wage bill of all the labour in the chain. -/
theorem chainCost_eq [DecidableEq Item] (price : Item → ℚ) (wage : ℚ) (i : Item) (q : ℚ) :
    P.chainCost price wage i q =
      valueAt price (P.rawDemand i q) + wage * P.laborFor i q := by
  refine P.rankInduction
    (M := fun i => ∀ q, P.chainCost price wage i q =
      valueAt price (P.rawDemand i q) + wage * P.laborFor i q) (fun i ih q => ?_) i q
  cases hr : P.recipe i with
  | none =>
      rw [P.chainCost_base price wage hr, P.rawDemand_base hr, P.laborFor_base hr]
      simp [valueAt]
  | some r =>
      rw [P.chainCost_recipe price wage hr, P.rawDemand_recipe hr, P.laborFor_recipe hr,
        valueAt_listSum price r.inputs
          (fun p x => P.rawDemand p.1 (q * p.2 / r.batch) x)]
      have hmap : (r.inputs.map (fun p => P.chainCost price wage p.1 (q * p.2 / r.batch))) =
          r.inputs.map (fun p => valueAt price (P.rawDemand p.1 (q * p.2 / r.batch))
            + wage * P.laborFor p.1 (q * p.2 / r.batch)) := by
        refine List.map_congr_left ?_
        intro p hp
        exact ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩ _
      rw [hmap]
      have hsplit : ∀ (f g : Item × ℚ → ℚ),
          (r.inputs.map (fun p => f p + g p)).sum = (r.inputs.map f).sum + (r.inputs.map g).sum := by
        intro f g
        induction r.inputs with
        | nil => simp
        | cons a t iht => simp only [List.map_cons, List.sum_cons, iht]; ring
      rw [hsplit (fun p => valueAt price (P.rawDemand p.1 (q * p.2 / r.batch)))
        (fun p => wage * P.laborFor p.1 (q * p.2 / r.batch))]
      have hmul : (r.inputs.map (fun p => wage * P.laborFor p.1 (q * p.2 / r.batch))).sum
          = wage * (r.inputs.map (fun p => P.laborFor p.1 (q * p.2 / r.batch))).sum :=
        List.sum_map_mul_left r.inputs (fun p => P.laborFor p.1 (q * p.2 / r.batch)) wage
      rw [hmul]
      ring

/-- Doing the work yourself (wage `0`) costs exactly the raw materials. -/
theorem chainCost_zero_wage [DecidableEq Item] (price : Item → ℚ) (i : Item) (q : ℚ) :
    P.chainCost price 0 i q = valueAt price (P.rawDemand i q) := by
  rw [P.chainCost_eq price 0 i q]; ring

end Plant
end Workflow
end LifeTrac
