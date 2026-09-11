import RequestProject.Gvcs.Process

/-!
# Production with parts already on the shelf

`RequestProject/Process.lean` costs a production order as if the shop started
with nothing but raw material: `Plant.rawDemand` follows every workflow down to
the ore, `Plant.laborFor` adds up every hour on the way, and
`Plant.toolClosure` lists every instrument that has to be standing.

Salvage changes the starting point.  If a stepper motor is already on the
bench — pulled out of a scrap printer rather than wound from copper — then the
chain behind it is not walked at all: its ore is not dug, its hours are not
worked, and the machines that would have made it are not needed.

This file is the general theory of that.  Each of the three functions above
gets a variant taking a predicate `onHand : Item → Bool`, the things the shop
already has, and the recursion simply stops at them:

* `Plant.demandGiven` — what an order draws off the shelf (and out of the
  ground), counted in on-hand items and base items;
* `Plant.laborGiven` — the hours still to be worked;
* `Plant.toolClosureGiven` — the instruments still needed.

With `onHand = fun _ => false` each one is the old function
(`laborGiven_false`, `demandGiven_false`, `toolClosureGiven_false`), and in
general each is *no larger* than the old one (`laborGiven_le_laborFor`,
`toolClosureGiven_subset`): having a part in hand never costs more work or
more machinery than not having it.  That is the whole formal content of
salvage, and `RequestProject/Salvage.lean` supplies the parts.
-/

namespace LifeTrac
namespace Workflow
namespace Plant

variable {Item : Type} (P : Plant Item)

/-! ## The hours still to be worked -/

/-- The labour, in hours, still in front of a shop that already owns
everything `onHand` marks: the chain behind an item the shop has is not
walked. -/
def laborGiven (P : Plant Item) (onHand : Item → Bool) (i : Item) (q : ℚ) : ℚ :=
  if onHand i then 0
  else
    match _h : P.recipe i with
    | none => 0
    | some r =>
        q / r.batch * r.labor +
          (r.inputs.attach.map (fun p => P.laborGiven onHand p.1.1 (q * p.1.2 / r.batch))).sum
termination_by P.rank i
decreasing_by exact P.rank_input i r _h _ p.2

variable {P}

@[simp] theorem laborGiven_of_onHand {onHand : Item → Bool} {i : Item} (h : onHand i = true)
    (q : ℚ) : P.laborGiven onHand i q = 0 := by
  rw [Plant.laborGiven.eq_def, if_pos h]

@[simp] theorem laborGiven_base {onHand : Item → Bool} {i : Item} (h : P.recipe i = none)
    (q : ℚ) : P.laborGiven onHand i q = 0 := by
  rw [Plant.laborGiven.eq_def, h]
  split <;> rfl

theorem laborGiven_recipe {onHand : Item → Bool} {i : Item} {r : Recipe Item}
    (hoff : onHand i = false) (h : P.recipe i = some r) (q : ℚ) :
    P.laborGiven onHand i q =
      q / r.batch * r.labor +
        (r.inputs.map (fun p => P.laborGiven onHand p.1 (q * p.2 / r.batch))).sum := by
  rw [Plant.laborGiven.eq_def, if_neg (by simp [hoff]), h]
  simp only []
  rw [List.map_attach_eq_pmap]
  simp [List.pmap_eq_map]

/-- A single unfolding step of `laborGiven`, in a form `simp` can apply
repeatedly. -/
theorem laborGiven_eq (onHand : Item → Bool) (i : Item) (q : ℚ) :
    P.laborGiven onHand i q =
      if onHand i then 0
      else match P.recipe i with
        | none => 0
        | some r => q / r.batch * r.labor +
            (r.inputs.map (fun p => P.laborGiven onHand p.1 (q * p.2 / r.batch))).sum := by
  by_cases hh : onHand i
  · simp [hh]
  · have hoff : onHand i = false := by simpa using hh
    cases hr : P.recipe i with
    | none => simp [laborGiven_base hr, hoff]
    | some r => rw [laborGiven_recipe hoff hr]; simp [hoff]

/-- With nothing on the shelf, the hours still to be worked are all of them. -/
theorem laborGiven_false (i : Item) (q : ℚ) :
    P.laborGiven (fun _ => false) i q = P.laborFor i q := by
  refine P.rankInduction
    (M := fun i => ∀ q, P.laborGiven (fun _ => false) i q = P.laborFor i q) (fun i ih q => ?_) i q
  cases hr : P.recipe i with
  | none => rw [laborGiven_base hr, P.laborFor_base hr]
  | some r =>
      rw [laborGiven_recipe rfl hr, P.laborFor_recipe hr]
      refine congrArg (_ + ·) (congrArg List.sum (List.map_congr_left ?_))
      intro p hp
      exact ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩ _

theorem laborGiven_nonneg {onHand : Item → Bool} {i : Item} {q : ℚ} (hq : 0 ≤ q) :
    0 ≤ P.laborGiven onHand i q := by
  refine P.rankInduction (M := fun i => ∀ q, 0 ≤ q → 0 ≤ P.laborGiven onHand i q)
    (fun i ih q hq => ?_) i q hq
  by_cases hh : onHand i
  · simp [laborGiven_of_onHand hh]
  · have hoff : onHand i = false := by simpa using hh
    cases hr : P.recipe i with
    | none => simp [laborGiven_base hr]
    | some r =>
        rw [laborGiven_recipe hoff hr]
        have hb : 0 < r.batch := P.batch_pos i r hr
        have hl : 0 ≤ r.labor := P.labor_nonneg i r hr
        have h1 : 0 ≤ q / r.batch * r.labor := mul_nonneg (div_nonneg hq hb.le) hl
        have h2 : 0 ≤ (r.inputs.map (fun p => P.laborGiven onHand p.1 (q * p.2 / r.batch))).sum := by
          refine List.sum_nonneg ?_
          intro y hy
          obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hy
          exact ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩ _
            (div_nonneg (mul_nonneg hq (P.qty_nonneg i r hr p hp)) hb.le)
        linarith

/-- **Salvage never costs more work.**  Whatever the shop already has on the
shelf, the hours left to work are at most the hours of building the thing from
raw material. -/
theorem laborGiven_le_laborFor (onHand : Item → Bool) {i : Item} {q : ℚ} (hq : 0 ≤ q) :
    P.laborGiven onHand i q ≤ P.laborFor i q := by
  refine P.rankInduction
    (M := fun i => ∀ q, 0 ≤ q → P.laborGiven onHand i q ≤ P.laborFor i q) (fun i ih q hq => ?_) i q hq
  by_cases hh : onHand i
  · rw [laborGiven_of_onHand hh]
    exact P.laborFor_nonneg hq
  · have hoff : onHand i = false := by simpa using hh
    cases hr : P.recipe i with
    | none => simp [laborGiven_base hr, P.laborFor_base hr]
    | some r =>
        rw [laborGiven_recipe hoff hr, P.laborFor_recipe hr]
        have hb : 0 < r.batch := P.batch_pos i r hr
        have hsum : (r.inputs.map (fun p => P.laborGiven onHand p.1 (q * p.2 / r.batch))).sum ≤
            (r.inputs.map (fun p => P.laborFor p.1 (q * p.2 / r.batch))).sum := by
          refine List.sum_le_sum ?_
          intro p hp
          exact ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩ _
            (div_nonneg (mul_nonneg hq (P.qty_nonneg i r hr p hp)) hb.le)
        linarith

/-! ## What the order draws off the shelf -/

/-- What an order for `q` units of `i` actually consumes when the shop already
owns everything `onHand` marks: the recursion stops at those items and at the
base, so the answer is a bill in salvaged parts and raw materials. -/
def demandGiven [DecidableEq Item] (P : Plant Item) (onHand : Item → Bool) (i : Item) (q : ℚ) :
    Item → ℚ :=
  if onHand i then (fun x => if x = i then q else 0)
  else
    match _h : P.recipe i with
    | none => fun x => if x = i then q else 0
    | some r => fun x =>
        (r.inputs.attach.map (fun p => P.demandGiven onHand p.1.1 (q * p.1.2 / r.batch) x)).sum
termination_by P.rank i
decreasing_by exact P.rank_input i r _h _ p.2

section Demand

variable [DecidableEq Item]

@[simp] theorem demandGiven_of_onHand {onHand : Item → Bool} {i : Item} (h : onHand i = true)
    (q : ℚ) : P.demandGiven onHand i q = fun x => if x = i then q else 0 := by
  rw [Plant.demandGiven.eq_def, if_pos h]

@[simp] theorem demandGiven_base {onHand : Item → Bool} {i : Item} (h : P.recipe i = none)
    (q : ℚ) : P.demandGiven onHand i q = fun x => if x = i then q else 0 := by
  rw [Plant.demandGiven.eq_def, h]
  split <;> rfl

theorem demandGiven_recipe {onHand : Item → Bool} {i : Item} {r : Recipe Item}
    (hoff : onHand i = false) (h : P.recipe i = some r) (q : ℚ) :
    P.demandGiven onHand i q =
      fun x => (r.inputs.map (fun p => P.demandGiven onHand p.1 (q * p.2 / r.batch) x)).sum := by
  rw [Plant.demandGiven.eq_def, if_neg (by simp [hoff]), h]
  funext x
  simp only []
  rw [List.map_attach_eq_pmap]
  simp [List.pmap_eq_map]

/-- A single unfolding step of `demandGiven`. -/
theorem demandGiven_eq (onHand : Item → Bool) (i : Item) (q : ℚ) :
    P.demandGiven onHand i q =
      fun x =>
        if onHand i then (if x = i then q else 0)
        else match P.recipe i with
          | none => if x = i then q else 0
          | some r => (r.inputs.map (fun p => P.demandGiven onHand p.1 (q * p.2 / r.batch) x)).sum := by
  by_cases hh : onHand i
  · simp [hh]
  · have hoff : onHand i = false := by simpa using hh
    cases hr : P.recipe i with
    | none => simp [demandGiven_base hr, hoff]
    | some r => rw [demandGiven_recipe hoff hr]; simp [hoff]

/-- With nothing on the shelf, the bill is the raw-material bill. -/
theorem demandGiven_false (i : Item) (q : ℚ) :
    P.demandGiven (fun _ => false) i q = P.rawDemand i q := by
  refine P.rankInduction
    (M := fun i => ∀ q, P.demandGiven (fun _ => false) i q = P.rawDemand i q) (fun i ih q => ?_) i q
  cases hr : P.recipe i with
  | none => rw [demandGiven_base hr, P.rawDemand_base hr]
  | some r =>
      rw [demandGiven_recipe rfl hr, P.rawDemand_recipe hr]
      funext x
      refine congrArg List.sum (List.map_congr_left ?_)
      intro p hp
      rw [ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩]

theorem demandGiven_nonneg {onHand : Item → Bool} {i : Item} {q : ℚ} (hq : 0 ≤ q) (x : Item) :
    0 ≤ P.demandGiven onHand i q x := by
  refine P.rankInduction (M := fun i => ∀ q, 0 ≤ q → 0 ≤ P.demandGiven onHand i q x)
    (fun i ih q hq => ?_) i q hq
  by_cases hh : onHand i
  · rw [demandGiven_of_onHand hh]; by_cases h : x = i <;> simp [h, hq]
  · have hoff : onHand i = false := by simpa using hh
    cases hr : P.recipe i with
    | none => rw [demandGiven_base hr]; by_cases h : x = i <;> simp [h, hq]
    | some r =>
        rw [demandGiven_recipe hoff hr]
        refine List.sum_nonneg ?_
        intro y hy
        obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hy
        have hb : 0 < r.batch := P.batch_pos i r hr
        exact ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩ _
          (div_nonneg (mul_nonneg hq (P.qty_nonneg i r hr p hp)) hb.le)

/-- **The bill is drawn only on what the shop has and what the ground has.**
Nothing else appears in it: every item with a positive entry is either on hand
or a base item. -/
theorem demandGiven_eq_zero {onHand : Item → Bool} {x : Item} (hx : onHand x = false)
    (hr : P.recipe x ≠ none) : ∀ i q, P.demandGiven onHand i q x = 0 := by
  refine P.rankInduction (M := fun i => ∀ q, P.demandGiven onHand i q x = 0) (fun i ih q => ?_)
  by_cases hh : onHand i
  · rw [demandGiven_of_onHand hh]
    have : x ≠ i := by rintro rfl; simp [hh] at hx
    simp [this]
  · have hoff : onHand i = false := by simpa using hh
    cases hi : P.recipe i with
    | none =>
        rw [demandGiven_base hi]
        have : x ≠ i := by rintro rfl; exact hr hi
        simp [this]
    | some r =>
        rw [demandGiven_recipe hoff hi]
        refine List.sum_eq_zero ?_
        intro y hy
        obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hy
        exact ih p.1 ⟨r, hi, Or.inl ⟨p.2, by simpa using hp⟩⟩ _

end Demand

/-! ## The instruments still needed -/

/-- The instruments a shop must still have standing in order to fill an order,
given that everything `onHand` marks is already made. -/
def toolClosureGiven (P : Plant Item) (onHand : Item → Bool) (i : Item) : List Item :=
  if onHand i then []
  else
    match _h : P.recipe i with
    | none => []
    | some r =>
        r.tools ++ (r.tools.attach.map (fun t => P.toolClosureGiven onHand t.1)).flatten
          ++ (r.inputs.attach.map (fun p => P.toolClosureGiven onHand p.1.1)).flatten
termination_by P.rank i
decreasing_by
  · exact P.rank_tool i r _h _ t.2
  · exact P.rank_input i r _h _ p.2

@[simp] theorem toolClosureGiven_of_onHand {onHand : Item → Bool} {i : Item}
    (h : onHand i = true) : P.toolClosureGiven onHand i = [] := by
  rw [Plant.toolClosureGiven.eq_def, if_pos h]

@[simp] theorem toolClosureGiven_base {onHand : Item → Bool} {i : Item} (h : P.recipe i = none) :
    P.toolClosureGiven onHand i = [] := by
  rw [Plant.toolClosureGiven.eq_def, h]
  split <;> rfl

theorem toolClosureGiven_recipe {onHand : Item → Bool} {i : Item} {r : Recipe Item}
    (hoff : onHand i = false) (h : P.recipe i = some r) :
    P.toolClosureGiven onHand i =
      r.tools ++ (r.tools.map (fun t => P.toolClosureGiven onHand t)).flatten
        ++ (r.inputs.map (fun p => P.toolClosureGiven onHand p.1)).flatten := by
  rw [Plant.toolClosureGiven.eq_def, if_neg (by simp [hoff]), h]
  simp only []
  rw [List.map_attach_eq_pmap, List.map_attach_eq_pmap]
  simp [List.pmap_eq_map]

/-- A single unfolding step of `toolClosureGiven`. -/
theorem toolClosureGiven_eq (onHand : Item → Bool) (i : Item) :
    P.toolClosureGiven onHand i =
      if onHand i then []
      else match P.recipe i with
        | none => []
        | some r => r.tools ++ (r.tools.map (fun t => P.toolClosureGiven onHand t)).flatten
            ++ (r.inputs.map (fun p => P.toolClosureGiven onHand p.1)).flatten := by
  by_cases hh : onHand i
  · simp [hh]
  · have hoff : onHand i = false := by simpa using hh
    cases hr : P.recipe i with
    | none => simp [toolClosureGiven_base hr, hoff]
    | some r => rw [toolClosureGiven_recipe hoff hr]; simp [hoff]

/-- With nothing on the shelf, every instrument of the chain is still
needed. -/
theorem toolClosureGiven_false (i : Item) :
    P.toolClosureGiven (fun _ => false) i = P.toolClosure i := by
  refine P.rankInduction
    (M := fun i => P.toolClosureGiven (fun _ => false) i = P.toolClosure i) (fun i ih => ?_) i
  cases hr : P.recipe i with
  | none => rw [toolClosureGiven_base hr, P.toolClosure_base hr]
  | some r =>
      rw [toolClosureGiven_recipe rfl hr, P.toolClosure_recipe hr]
      congr 1
      · congr 1
        refine congrArg List.flatten (List.map_congr_left ?_)
        intro t ht
        exact ih t ⟨r, hr, Or.inr ht⟩
      · refine congrArg List.flatten (List.map_congr_left ?_)
        intro p hp
        exact ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩

/-- Whatever is needed to make an input is needed to make the thing. -/
theorem toolClosure_input_subset {i j : Item} {r : Recipe Item} (h : P.recipe i = some r)
    {q : ℚ} (hj : (j, q) ∈ r.inputs) : ∀ t ∈ P.toolClosure j, t ∈ P.toolClosure i := by
  intro t ht
  rw [P.toolClosure_recipe h]
  exact List.mem_append.2 (Or.inr
    (List.mem_flatten.2 ⟨P.toolClosure j, List.mem_map.2 ⟨(j, q), hj, rfl⟩, ht⟩))

/-- **Salvage never calls for more machinery.**  Every instrument still needed
when parts are on the shelf was needed when they were not. -/
theorem toolClosureGiven_subset (onHand : Item → Bool) (i : Item) :
    ∀ t ∈ P.toolClosureGiven onHand i, t ∈ P.toolClosure i := by
  refine P.rankInduction
    (M := fun i => ∀ t ∈ P.toolClosureGiven onHand i, t ∈ P.toolClosure i) (fun i ih t ht => ?_) i
  by_cases hh : onHand i
  · rw [toolClosureGiven_of_onHand hh] at ht; simp at ht
  · have hoff : onHand i = false := by simpa using hh
    cases hr : P.recipe i with
    | none => rw [toolClosureGiven_base hr] at ht; simp at ht
    | some r =>
        rw [toolClosureGiven_recipe hoff hr] at ht
        rw [P.toolClosure_recipe hr]
        rcases List.mem_append.1 ht with ht' | ht'
        · rcases List.mem_append.1 ht' with ht'' | ht''
          · exact List.mem_append.2 (Or.inl (List.mem_append.2 (Or.inl ht'')))
          · obtain ⟨l, hl, htl⟩ := List.mem_flatten.1 ht''
            obtain ⟨u, hu, rfl⟩ := List.mem_map.1 hl
            exact List.mem_append.2 (Or.inl (List.mem_append.2 (Or.inr
              (List.mem_flatten.2 ⟨P.toolClosure u, List.mem_map.2 ⟨u, hu, rfl⟩,
                ih u ⟨r, hr, Or.inr hu⟩ t htl⟩))))
        · obtain ⟨l, hl, htl⟩ := List.mem_flatten.1 ht'
          obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hl
          exact List.mem_append.2 (Or.inr
            (List.mem_flatten.2 ⟨P.toolClosure p.1, List.mem_map.2 ⟨p, hp, rfl⟩,
              ih p.1 ⟨r, hr, Or.inl ⟨p.2, by simpa using hp⟩⟩ t htl⟩))

end Plant
end Workflow
end LifeTrac
