import RequestProject.Gvcs.Wasm.Compile

/-!
# The code generator is correct

`RequestProject/Wasm/Compile.lean` compiles the integer rule book of
`RequestProject/Runtime.lean` into a WebAssembly module.  This file proves that
the compilation is faithful: run on a memory that *represents* a position of
the game, the generated `enabled` and `apply` functions answer exactly what
`Runtime.rstep` answers, and `apply` leaves behind a memory that represents the
position `rstep` lands on.

* `Rep s mem` — the memory `mem` holds the position `s`: the constant tables
  are in place (`Tables`) and every cell of the state region agrees with `s`.
* `Runs L mem mem' e v` — the block `e` leaves `v` on the stack and turns the
  memory `mem` into `mem'`.  It generalises the `Computes` of
  `RequestProject/Wasm/Ir.lean` (which is the case `mem' = mem`) to the blocks
  that store, and it composes the same way.
* `enabled_correct`, `apply_correct` — the theorems.

Chained with `Runtime.rstep_refines`, this says that the code the extractor
writes plays the game of `RequestProject/Game.lean`.

The aliasing argument is uniform and cheap: every cell the generated code
writes lies below address 1024, every constant table lies at or above it, and
the state cells are pairwise distinct because `idxM` and `idxP` are injective.
-/

namespace LifeTrac
namespace Wasm

open Build Runtime

/-! ## Blocks that compute a value and store -/

/-- `e` leaves `v` on top of the stack and turns the memory `mem` into `mem'`.
`Computes L mem e v` is by definition `Runs L mem mem e v`. -/
def Runs (L : List Int) (mem mem' : Int → Int) (e : List Instr) (v : Int) : Prop :=
  ∀ s : List Int, execs ⟨s, L, mem⟩ e = ⟨v :: s, L, mem'⟩

namespace Runs

variable {L : List Int} {mem mem' : Int → Int}

theorem of_computes {e : List Instr} {v : Int} (h : Computes L mem e v) :
    Runs L mem mem e v := h

/-- A conditional whose arms both compute and store. -/
theorem ifte {c t e : List Instr} {p : Bool} {v : Int}
    (hc : Computes L mem c (ofBool p))
    (ht : p = true → Runs L mem mem' t v) (he : p = false → Runs L mem mem' e v) :
    Runs L mem mem' (c ++ [.ifte t e]) v := by
  intro s
  rw [execs_append, hc]
  cases p with
  | false => simpa [exec, ofBool] using he rfl s
  | true => simpa [exec, ofBool] using ht rfl s

/-- The shape of every entry point: a guard, then either the effect and `1`, or
`0`. -/
theorem guarded {c t : List Instr} {p : Bool} (hc : Computes L mem c (ofBool p))
    (ht : p = true → Effects L mem mem' t) (hm : p = false → mem' = mem) :
    Runs L mem mem' (c ++ [.ifte (t ++ [.const 1]) [.const 0]]) (ofBool p) :=
  computes_guarded hc ht hm

/-- One arm of the dispatch on the kind of move. -/
theorem arm {f : Nat → List Instr} {j : Nat} {rest : List Instr} {v : Int}
    (hhit : L.getD KIND 0 = (j : Int) → Runs L mem mem' (f j) v)
    (hmiss : L.getD KIND 0 ≠ (j : Int) → Runs L mem mem' rest v) :
    Runs L mem mem' (eqE [.localGet KIND] (constE (j : Int)) ++ [.ifte (f j) rest]) v := by
  refine ifte (p := decide (L.getD KIND 0 = (j : Int)))
    (Computes.eq (Computes.localGet KIND) (Computes.const _)) ?_ ?_
  · intro hp; exact hhit (of_decide_eq_true hp)
  · intro hp; exact hmiss (of_decide_eq_false hp)

end Runs

/-- The dispatch picks the arm named by local `KIND`. -/
theorem runs_dispatch {L : List Int} {mem mem' : Int → Int} {f : Nat → List Instr}
    {k : Nat} {v : Int} (hk : k ≤ 5) (hL : L.getD KIND 0 = (k : Int))
    (h : Runs L mem mem' (f k) v) : Runs L mem mem' (dispatch f) v := by
  have hit : ∀ rest : List Instr,
      Runs L mem mem' (eqE [.localGet KIND] (constE (k : Int)) ++ [.ifte (f k) rest]) v :=
    fun _ => Runs.arm (fun _ => h) (fun hne => absurd hL hne)
  have miss : ∀ (j : Nat) (rest : List Instr), j ≠ k → Runs L mem mem' rest v →
      Runs L mem mem' (eqE [.localGet KIND] (constE (j : Int)) ++ [.ifte (f j) rest]) v := by
    intro j rest hj hr
    refine Runs.arm (fun hh => absurd ?_ hj) (fun _ => hr)
    have : (k : Int) = (j : Int) := by rw [← hL, hh]
    exact (by exact_mod_cast this : k = j).symm
  simp only [dispatch]
  interval_cases k
  · exact hit _
  · exact miss 0 _ (by decide) (hit _)
  · exact miss 0 _ (by decide) (miss 1 _ (by decide) (hit _))
  · exact miss 0 _ (by decide) (miss 1 _ (by decide) (miss 2 _ (by decide) (hit _)))
  · exact miss 0 _ (by decide) (miss 1 _ (by decide) (miss 2 _ (by decide)
      (miss 3 _ (by decide) (hit _))))
  · exact miss 0 _ (by decide) (miss 1 _ (by decide) (miss 2 _ (by decide)
      (miss 3 _ (by decide) (miss 4 _ (by decide) (hit _)))))

/-! ## What a memory has to hold -/

/-- The constant tables of the game are in place. -/
structure Tables (mem : Int → Int) : Prop where
  /-- The catalogue price of every material. -/
  cost : ∀ m : Material, mem (COST + 8 * idxM m) = costM m
  /-- The salvage price of every material. -/
  salv : ∀ m : Material, mem (SALV + 8 * idxM m) = salvageM m
  /-- The bill of materials of every assembly. -/
  req : ∀ (a : RPart) (m : Material), mem (REQ + 192 * idxP a + 8 * idxM m) = a.req m
  /-- The material cost of every assembly. -/
  pcost : ∀ a : RPart, mem (PCOST + 8 * idxP a) = a.cost
  /-- The wage bill of every assembly. -/
  plab : ∀ a : RPart, mem (PLAB + 8 * idxP a) = a.laborCost
  /-- The build time of every assembly. -/
  pday : ∀ a : RPart, mem (PDAY + 8 * idxP a) = a.days
  /-- The seed cost of every crop. -/
  cseed : ∀ c : RCrop, mem (CSEED + 8 * idxC c) = c.seed
  /-- The revenue of every crop. -/
  crev : ∀ c : RCrop, mem (CREV + 8 * idxC c) = c.revenue
  /-- The fuel a hectare of every crop takes. -/
  cfuel : ∀ c : RCrop, mem (CFUEL + 8 * idxC c) = c.fuelHa
  /-- The working time a hectare of every crop takes. -/
  cday : ∀ c : RCrop, mem (CDAY + 8 * idxC c) = c.daysHa

/-- The memory `mem` holds the position `s`. -/
structure Rep (s : RState) (mem : Int → Int) : Prop where
  /-- The constant tables are in place. -/
  tables : Tables mem
  /-- The cash cell. -/
  cash : mem CASH = s.cash
  /-- The fuel cell. -/
  fuel : mem FUEL = s.fuel
  /-- The calendar cell. -/
  day : mem DAY = s.day
  /-- The hectares cell. -/
  hect : mem HECT = s.hect
  /-- The shelf. -/
  stock : ∀ m : Material, mem (STOCK + 8 * idxM m) = s.stock m
  /-- The counters of what has been built. -/
  built : ∀ a : RPart, mem (BUILT + 8 * idxP a) = (s.built.count a : Int)

/-! ## Reading the arguments -/

theorem getD_kind (a : RAction) : (argsOf a).getD KIND 0 = (kindOf a : Int) := by
  cases a <;> rfl

theorem kindOf_le (a : RAction) : kindOf a ≤ 5 := by cases a <;> simp [kindOf]

theorem computes_theIdx {L : List Int} {mem : Int → Int} {v : Int} (h : L.getD IDX 0 = v) :
    Computes L mem theIdx v := h ▸ Computes.localGet IDX

theorem computes_theArg {L : List Int} {mem : Int → Int} {v : Int} (h : L.getD ARG 0 = v) :
    Computes L mem theArg v := h ▸ Computes.localGet ARG

/-! ## The state region and the table region are disjoint -/

theorem stock_addr_lt (m : Material) : STOCK + 8 * idxM m < 1024 := by
  have := (idxM_bounds m).2; simp only [STOCK]; omega

theorem built_addr_lt (a : RPart) : BUILT + 8 * idxP a < 1024 := by
  have := (idxP_bounds a).2; simp only [BUILT]; omega

theorem cash_lt : (CASH : Int) < 1024 := by decide
theorem fuel_lt : (FUEL : Int) < 1024 := by decide
theorem day_lt : (DAY : Int) < 1024 := by decide
theorem hect_lt : (HECT : Int) < 1024 := by decide

/-- Writing anywhere in the state region leaves the constant tables alone. -/
theorem Tables.store {mem : Int → Int} (h : Tables mem) {a v : Int} (ha : a < 1024) :
    Tables (store1 mem a v) where
  cost m := by
    rw [store1_other (by have := (idxM_bounds m).1; simp only [COST]; omega)]; exact h.cost m
  salv m := by
    rw [store1_other (by have := (idxM_bounds m).1; simp only [SALV]; omega)]; exact h.salv m
  req p m := by
    rw [store1_other (by
      have := (idxM_bounds m).1; have := (idxP_bounds p).1; simp only [REQ]; omega)]
    exact h.req p m
  pcost p := by
    rw [store1_other (by have := (idxP_bounds p).1; simp only [PCOST]; omega)]; exact h.pcost p
  plab p := by
    rw [store1_other (by have := (idxP_bounds p).1; simp only [PLAB]; omega)]; exact h.plab p
  pday p := by
    rw [store1_other (by have := (idxP_bounds p).1; simp only [PDAY]; omega)]; exact h.pday p
  cseed c := by
    rw [store1_other (by rw [idxC_bounds c]; simp only [CSEED]; omega)]; exact h.cseed c
  crev c := by
    rw [store1_other (by rw [idxC_bounds c]; simp only [CREV]; omega)]; exact h.crev c
  cfuel c := by
    rw [store1_other (by rw [idxC_bounds c]; simp only [CFUEL]; omega)]; exact h.cfuel c
  cday c := by
    rw [store1_other (by rw [idxC_bounds c]; simp only [CDAY]; omega)]; exact h.cday c

/-! ## The state cells are pairwise distinct -/

theorem cash_ne_fuel : (CASH : Int) ≠ FUEL := by decide
theorem cash_ne_day : (CASH : Int) ≠ DAY := by decide
theorem cash_ne_hect : (CASH : Int) ≠ HECT := by decide
theorem fuel_ne_day : (FUEL : Int) ≠ DAY := by decide
theorem fuel_ne_hect : (FUEL : Int) ≠ HECT := by decide
theorem day_ne_hect : (DAY : Int) ≠ HECT := by decide

theorem cash_ne_stock (m : Material) : (CASH : Int) ≠ STOCK + 8 * idxM m := by
  have := (idxM_bounds m).1; simp only [CASH, STOCK]; omega
theorem fuel_ne_stock (m : Material) : (FUEL : Int) ≠ STOCK + 8 * idxM m := by
  have := (idxM_bounds m).1; simp only [FUEL, STOCK]; omega
theorem day_ne_stock (m : Material) : (DAY : Int) ≠ STOCK + 8 * idxM m := by
  have := (idxM_bounds m).1; simp only [DAY, STOCK]; omega
theorem hect_ne_stock (m : Material) : (HECT : Int) ≠ STOCK + 8 * idxM m := by
  have := (idxM_bounds m).1; simp only [HECT, STOCK]; omega

theorem cash_ne_built (a : RPart) : (CASH : Int) ≠ BUILT + 8 * idxP a := by
  have := (idxP_bounds a).1; simp only [CASH, BUILT]; omega
theorem fuel_ne_built (a : RPart) : (FUEL : Int) ≠ BUILT + 8 * idxP a := by
  have := (idxP_bounds a).1; simp only [FUEL, BUILT]; omega
theorem day_ne_built (a : RPart) : (DAY : Int) ≠ BUILT + 8 * idxP a := by
  have := (idxP_bounds a).1; simp only [DAY, BUILT]; omega
theorem hect_ne_built (a : RPart) : (HECT : Int) ≠ BUILT + 8 * idxP a := by
  have := (idxP_bounds a).1; simp only [HECT, BUILT]; omega

theorem stock_ne_built (m : Material) (a : RPart) :
    STOCK + 8 * idxM m ≠ BUILT + 8 * idxP a := by
  have := (idxM_bounds m).2; have := (idxP_bounds a).1; simp only [STOCK, BUILT]; omega

theorem stock_ne_stock {x m : Material} (h : x ≠ m) :
    STOCK + 8 * idxM x ≠ STOCK + 8 * idxM m := fun hEq => h (idxM_inj (by omega))

theorem built_ne_built {a b : RPart} (h : a ≠ b) :
    BUILT + 8 * idxP a ≠ BUILT + 8 * idxP b := fun hEq => h (idxP_inj (by omega))

/-! ## The cells the rule book never writes

The compiled rule book writes only to the state region: cash, fuel, calendar,
hectares, the shelf and the build counters.  Everything else in memory — the
screen cell the shell keeps at address 32, and the whole constant-table region
from 1024 up — it leaves exactly as it found it.  `Frozen` names those
addresses, and the `frozen_ne_*` lemmas say a frozen address is none of the
cells a move writes. -/

/-- The addresses the compiled rule book never writes: the screen cell and the
constant-table region. -/
def Frozen (x : Int) : Prop := x = SCREEN ∨ 1024 ≤ x

theorem frozen_ne_cash {x : Int} (h : Frozen x) : x ≠ CASH := by
  simp only [Frozen, SCREEN] at h; simp only [CASH]; omega

theorem frozen_ne_fuel {x : Int} (h : Frozen x) : x ≠ FUEL := by
  simp only [Frozen, SCREEN] at h; simp only [FUEL]; omega

theorem frozen_ne_day {x : Int} (h : Frozen x) : x ≠ DAY := by
  simp only [Frozen, SCREEN] at h; simp only [DAY]; omega

theorem frozen_ne_hect {x : Int} (h : Frozen x) : x ≠ HECT := by
  simp only [Frozen, SCREEN] at h; simp only [HECT]; omega

theorem frozen_ne_stock {x : Int} (h : Frozen x) (m : Material) :
    x ≠ STOCK + 8 * idxM m := by
  have hb := idxM_bounds m
  simp only [Frozen, SCREEN] at h; simp only [STOCK]; omega

theorem frozen_ne_built {x : Int} (h : Frozen x) (a : RPart) :
    x ≠ BUILT + 8 * idxP a := by
  have hb := idxP_bounds a
  simp only [Frozen, SCREEN] at h; simp only [BUILT]; omega

theorem frozen_ne_stockRange {x : Int} (h : Frozen x) :
    ∀ i ∈ List.range 24, x ≠ STOCK + 8 * (i : Int) := by
  intro i hi
  simp only [List.mem_range] at hi
  simp only [Frozen, SCREEN] at h; simp only [STOCK]; omega

/-! ## The combinators compute what they say -/

section Combinators

variable {L : List Int} {mem : Int → Int}

theorem computes_get (a : Int) : Computes L mem (get a) (mem a) :=
  Computes.load (Computes.const a)

theorem computes_cellAddr {i : List Instr} {v : Int} (base : Int) (h : Computes L mem i v) :
    Computes L mem (cellAddr base i) (base + 8 * v) := by
  have h' := Computes.add (Computes.const base) (Computes.mul h (Computes.const 8))
  rwa [show base + v * 8 = base + 8 * v by ring] at h'

theorem computes_loadCell {i : List Instr} {v : Int} (base : Int) (h : Computes L mem i v) :
    Computes L mem (loadCell base i) (mem (base + 8 * v)) :=
  Computes.load (computes_cellAddr base h)

end Combinators

/-! ## Buy -/

section Buy

variable {mem : Int → Int} {s : RState} (h : Rep s mem) (m : Material) (q : Int)

private theorem buy_arg : (argsOf (RAction.buy m q)).getD ARG 0 = q := rfl
private theorem buy_idx : (argsOf (RAction.buy m q)).getD IDX 0 = idxM m := rfl

include h

theorem guard_buy :
    Computes (argsOf (RAction.buy m q)) mem (guardOf 0)
      (ofBool (decide (0 ≤ q ∧ q * costM m ≤ s.cash))) := by
  have hArg : Computes (argsOf (RAction.buy m q)) mem theArg q := computes_theArg (buy_arg m q)
  have hcost : Computes (argsOf (RAction.buy m q)) mem (loadCell COST theIdx) (costM m) := by
    have h' := computes_loadCell (mem := mem) COST (computes_theIdx (buy_idx m q))
    rwa [h.tables.cost m] at h'
  have h1 : Computes (argsOf (RAction.buy m q)) mem (leE (constE 0) theArg)
      (ofBool (decide ((0 : Int) ≤ q))) := Computes.le (Computes.const 0) hArg
  have h2 : Computes (argsOf (RAction.buy m q)) mem
      (leE (mulE theArg (loadCell COST theIdx)) (get CASH))
      (ofBool (decide (q * costM m ≤ s.cash))) := by
    have h' := Computes.le (Computes.mul hArg hcost)
      (computes_get (L := argsOf (RAction.buy m q)) (mem := mem) CASH)
    rwa [h.cash] at h'
  have h3 := Computes.and' h1 h2
  rwa [← Bool.decide_and] at h3

theorem step_buy :
    ∃ mem', Runs (argsOf (RAction.buy m q)) mem mem'
        (guardOf 0 ++ [.ifte (effectOf 0 ++ [.const 1]) [.const 0]])
        (ofBool (rstep s (RAction.buy m q)).isSome) ∧
      (∀ t, rstep s (RAction.buy m q) = some t → Rep t mem') ∧
      (rstep s (RAction.buy m q) = none → mem' = mem) ∧
      (∀ x : Int, Frozen x → mem' x = mem x) := by
  have hval : (rstep s (RAction.buy m q)).isSome = decide (0 ≤ q ∧ q * costM m ≤ s.cash) := by
    simp only [rstep]; split <;> simp_all
  by_cases hc : 0 ≤ q ∧ q * costM m ≤ s.cash
  · refine ⟨store1 (store1 mem CASH (s.cash - q * costM m)) (STOCK + 8 * idxM m)
      (s.stock m + q * SCALE), ?_, ?_, ?_, ?_⟩
    · rw [hval]
      refine Runs.guarded (guard_buy h m q) (fun _ => ?_) (by simp [hc])
      have hArg : Computes (argsOf (RAction.buy m q)) mem theArg q := computes_theArg (buy_arg m q)
      have hcost : Computes (argsOf (RAction.buy m q)) mem (loadCell COST theIdx) (costM m) := by
        have h' := computes_loadCell (mem := mem) COST (computes_theIdx (buy_idx m q))
        rwa [h.tables.cost m] at h'
      have e1 : Effects (argsOf (RAction.buy m q)) mem (store1 mem CASH (s.cash - q * costM m))
          (put CASH (subE (get CASH) (mulE theArg (loadCell COST theIdx)))) := by
        have h' := Effects.put (a := CASH)
          (Computes.sub (computes_get (L := argsOf (RAction.buy m q)) (mem := mem) CASH)
            (Computes.mul hArg hcost))
        rwa [h.cash] at h'
      have hmem1 : (store1 mem CASH (s.cash - q * costM m)) (STOCK + 8 * idxM m) = s.stock m := by
        rw [store1_other (Ne.symm (cash_ne_stock m))]; exact h.stock m
      have hIdx1 : Computes (argsOf (RAction.buy m q))
          (store1 mem CASH (s.cash - q * costM m)) theIdx (idxM m) := computes_theIdx (buy_idx m q)
      have hArg1 : Computes (argsOf (RAction.buy m q))
          (store1 mem CASH (s.cash - q * costM m)) theArg q := computes_theArg (buy_arg m q)
      have e2 : Effects (argsOf (RAction.buy m q)) (store1 mem CASH (s.cash - q * costM m))
          (store1 (store1 mem CASH (s.cash - q * costM m)) (STOCK + 8 * idxM m)
            (s.stock m + q * SCALE))
          (putCell STOCK theIdx (addE (loadCell STOCK theIdx) (mulE theArg (constE SCALE)))) := by
        have h' := Effects.putAt (computes_cellAddr STOCK hIdx1)
          (Computes.add (computes_loadCell STOCK hIdx1) (Computes.mul hArg1 (Computes.const SCALE)))
        rwa [hmem1] at h'
      exact Effects.trans e1 e2
    · intro t ht
      rw [rstep, if_pos hc] at ht
      cases ht
      refine ⟨(h.tables.store cash_lt).store (stock_addr_lt m), ?_, ?_, ?_, ?_, ?_, ?_⟩
      · rw [store1_other (cash_ne_stock m), store1_same]
      · rw [store1_other (fuel_ne_stock m), store1_other cash_ne_fuel.symm]; exact h.fuel
      · rw [store1_other (day_ne_stock m), store1_other cash_ne_day.symm]; exact h.day
      · rw [store1_other (hect_ne_stock m), store1_other cash_ne_hect.symm]; exact h.hect
      · intro x
        by_cases hx : x = m
        · subst hx; rw [store1_same]; simp
        · rw [store1_other (stock_ne_stock hx), store1_other (cash_ne_stock x).symm]
          simp [h.stock x, hx]
      · intro a
        rw [store1_other (stock_ne_built m a).symm, store1_other (cash_ne_built a).symm]
        exact h.built a
    · intro hn; rw [rstep, if_pos hc] at hn; exact absurd hn (by simp)
    · intro x hx
      rw [store1_other (frozen_ne_stock hx m), store1_other (frozen_ne_cash hx)]
  · refine ⟨mem, ?_, ?_, ?_, ?_⟩
    · rw [hval]
      exact Runs.guarded (guard_buy h m q) (by simp [hc]) (fun _ => rfl)
    · intro t ht; rw [rstep, if_neg hc] at ht; exact absurd ht (by simp)
    · intro _; rfl
    · intro x _; rfl

end Buy

/-! ## Sell -/

section Sell

variable {mem : Int → Int} {s : RState} (h : Rep s mem) (m : Material) (q : Int)

private theorem sell_arg : (argsOf (RAction.sell m q)).getD ARG 0 = q := rfl
private theorem sell_idx : (argsOf (RAction.sell m q)).getD IDX 0 = idxM m := rfl

include h

theorem guard_sell :
    Computes (argsOf (RAction.sell m q)) mem (guardOf 2)
      (ofBool (decide (0 ≤ q ∧ q * SCALE ≤ s.stock m))) := by
  have hArg : Computes (argsOf (RAction.sell m q)) mem theArg q := computes_theArg (sell_arg m q)
  have hstock : Computes (argsOf (RAction.sell m q)) mem (loadCell STOCK theIdx) (s.stock m) := by
    have h' := computes_loadCell (mem := mem) STOCK (computes_theIdx (sell_idx m q))
    rwa [h.stock m] at h'
  have h1 : Computes (argsOf (RAction.sell m q)) mem (leE (constE 0) theArg)
      (ofBool (decide ((0 : Int) ≤ q))) := Computes.le (Computes.const 0) hArg
  have h2 := Computes.le (Computes.mul hArg (Computes.const SCALE)) hstock
  have h3 := Computes.and' h1 h2
  rwa [← Bool.decide_and] at h3

theorem step_sell :
    ∃ mem', Runs (argsOf (RAction.sell m q)) mem mem'
        (guardOf 2 ++ [.ifte (effectOf 2 ++ [.const 1]) [.const 0]])
        (ofBool (rstep s (RAction.sell m q)).isSome) ∧
      (∀ t, rstep s (RAction.sell m q) = some t → Rep t mem') ∧
      (rstep s (RAction.sell m q) = none → mem' = mem) ∧
      (∀ x : Int, Frozen x → mem' x = mem x) := by
  have hval : (rstep s (RAction.sell m q)).isSome = decide (0 ≤ q ∧ q * SCALE ≤ s.stock m) := by
    simp only [rstep]; split <;> simp_all
  by_cases hc : 0 ≤ q ∧ q * SCALE ≤ s.stock m
  · refine ⟨store1 (store1 mem CASH (s.cash + q * salvageM m)) (STOCK + 8 * idxM m)
      (s.stock m - q * SCALE), ?_, ?_, ?_, ?_⟩
    · rw [hval]
      refine Runs.guarded (guard_sell h m q) (fun _ => ?_) (by simp [hc])
      have hArg : Computes (argsOf (RAction.sell m q)) mem theArg q := computes_theArg (sell_arg m q)
      have hsalv : Computes (argsOf (RAction.sell m q)) mem (loadCell SALV theIdx)
          (salvageM m) := by
        have h' := computes_loadCell (mem := mem) SALV (computes_theIdx (sell_idx m q))
        rwa [h.tables.salv m] at h'
      have e1 : Effects (argsOf (RAction.sell m q)) mem (store1 mem CASH (s.cash + q * salvageM m))
          (put CASH (addE (get CASH) (mulE theArg (loadCell SALV theIdx)))) := by
        have h' := Effects.put (a := CASH)
          (Computes.add (computes_get (L := argsOf (RAction.sell m q)) (mem := mem) CASH)
            (Computes.mul hArg hsalv))
        rwa [h.cash] at h'
      have hmem1 : (store1 mem CASH (s.cash + q * salvageM m)) (STOCK + 8 * idxM m)
          = s.stock m := by
        rw [store1_other (Ne.symm (cash_ne_stock m))]; exact h.stock m
      have hIdx1 : Computes (argsOf (RAction.sell m q))
          (store1 mem CASH (s.cash + q * salvageM m)) theIdx (idxM m) :=
        computes_theIdx (sell_idx m q)
      have hArg1 : Computes (argsOf (RAction.sell m q))
          (store1 mem CASH (s.cash + q * salvageM m)) theArg q := computes_theArg (sell_arg m q)
      have e2 : Effects (argsOf (RAction.sell m q)) (store1 mem CASH (s.cash + q * salvageM m))
          (store1 (store1 mem CASH (s.cash + q * salvageM m)) (STOCK + 8 * idxM m)
            (s.stock m - q * SCALE))
          (putCell STOCK theIdx (subE (loadCell STOCK theIdx) (mulE theArg (constE SCALE)))) := by
        have h' := Effects.putAt (computes_cellAddr STOCK hIdx1)
          (Computes.sub (computes_loadCell STOCK hIdx1) (Computes.mul hArg1 (Computes.const SCALE)))
        rwa [hmem1] at h'
      exact Effects.trans e1 e2
    · intro t ht
      rw [rstep, if_pos hc] at ht
      cases ht
      refine ⟨(h.tables.store cash_lt).store (stock_addr_lt m), ?_, ?_, ?_, ?_, ?_, ?_⟩
      · rw [store1_other (cash_ne_stock m), store1_same]
      · rw [store1_other (fuel_ne_stock m), store1_other cash_ne_fuel.symm]; exact h.fuel
      · rw [store1_other (day_ne_stock m), store1_other cash_ne_day.symm]; exact h.day
      · rw [store1_other (hect_ne_stock m), store1_other cash_ne_hect.symm]; exact h.hect
      · intro x
        by_cases hx : x = m
        · subst hx; rw [store1_same]; simp
        · rw [store1_other (stock_ne_stock hx), store1_other (cash_ne_stock x).symm]
          simp [h.stock x, hx]
      · intro a
        rw [store1_other (stock_ne_built m a).symm, store1_other (cash_ne_built a).symm]
        exact h.built a
    · intro hn; rw [rstep, if_pos hc] at hn; exact absurd hn (by simp)
    · intro x hx
      rw [store1_other (frozen_ne_stock hx m), store1_other (frozen_ne_cash hx)]
  · refine ⟨mem, ?_, ?_, ?_, ?_⟩
    · rw [hval]
      exact Runs.guarded (guard_sell h m q) (by simp [hc]) (fun _ => rfl)
    · intro t ht; rw [rstep, if_neg hc] at ht; exact absurd ht (by simp)
    · intro _; rfl
    · intro x _; rfl

end Sell

/-! ## Refuel -/

section Refuel

variable {mem : Int → Int} {s : RState} (h : Rep s mem) (l : Int)

private theorem refuel_arg : (argsOf (RAction.refuel l)).getD ARG 0 = l := rfl

include h

theorem guard_refuel :
    Computes (argsOf (RAction.refuel l)) mem (guardOf 4)
      (ofBool (decide (0 ≤ l ∧ l * fuelPriceM ≤ s.cash))) := by
  have hArg : Computes (argsOf (RAction.refuel l)) mem theArg l := computes_theArg (refuel_arg l)
  have h1 : Computes (argsOf (RAction.refuel l)) mem (leE (constE 0) theArg)
      (ofBool (decide ((0 : Int) ≤ l))) := Computes.le (Computes.const 0) hArg
  have h2 : Computes (argsOf (RAction.refuel l)) mem
      (leE (mulE theArg (constE fuelPriceM)) (get CASH))
      (ofBool (decide (l * fuelPriceM ≤ s.cash))) := by
    have h' := Computes.le (Computes.mul hArg (Computes.const fuelPriceM))
      (computes_get (L := argsOf (RAction.refuel l)) (mem := mem) CASH)
    rwa [h.cash] at h'
  have h3 := Computes.and' h1 h2
  rwa [← Bool.decide_and] at h3

theorem step_refuel :
    ∃ mem', Runs (argsOf (RAction.refuel l)) mem mem'
        (guardOf 4 ++ [.ifte (effectOf 4 ++ [.const 1]) [.const 0]])
        (ofBool (rstep s (RAction.refuel l)).isSome) ∧
      (∀ t, rstep s (RAction.refuel l) = some t → Rep t mem') ∧
      (rstep s (RAction.refuel l) = none → mem' = mem) ∧
      (∀ x : Int, Frozen x → mem' x = mem x) := by
  have hval : (rstep s (RAction.refuel l)).isSome = decide (0 ≤ l ∧ l * fuelPriceM ≤ s.cash) := by
    simp only [rstep]; split <;> simp_all
  by_cases hc : 0 ≤ l ∧ l * fuelPriceM ≤ s.cash
  · refine ⟨store1 (store1 mem CASH (s.cash - l * fuelPriceM)) FUEL (s.fuel + l * SCALE),
      ?_, ?_, ?_, ?_⟩
    · rw [hval]
      refine Runs.guarded (guard_refuel h l) (fun _ => ?_) (by simp [hc])
      have hArg : Computes (argsOf (RAction.refuel l)) mem theArg l := computes_theArg (refuel_arg l)
      have e1 : Effects (argsOf (RAction.refuel l)) mem (store1 mem CASH (s.cash - l * fuelPriceM))
          (put CASH (subE (get CASH) (mulE theArg (constE fuelPriceM)))) := by
        have h' := Effects.put (a := CASH)
          (Computes.sub (computes_get (L := argsOf (RAction.refuel l)) (mem := mem) CASH)
            (Computes.mul hArg (Computes.const fuelPriceM)))
        rwa [h.cash] at h'
      have hArg1 : Computes (argsOf (RAction.refuel l))
          (store1 mem CASH (s.cash - l * fuelPriceM)) theArg l := computes_theArg (refuel_arg l)
      have hfuel1 : (store1 mem CASH (s.cash - l * fuelPriceM)) FUEL = s.fuel := by
        rw [store1_other cash_ne_fuel.symm]; exact h.fuel
      have e2 : Effects (argsOf (RAction.refuel l)) (store1 mem CASH (s.cash - l * fuelPriceM))
          (store1 (store1 mem CASH (s.cash - l * fuelPriceM)) FUEL (s.fuel + l * SCALE))
          (put FUEL (addE (get FUEL) (mulE theArg (constE SCALE)))) := by
        have h' := Effects.put (a := FUEL)
          (Computes.add (computes_get (L := argsOf (RAction.refuel l))
            (mem := store1 mem CASH (s.cash - l * fuelPriceM)) FUEL)
            (Computes.mul hArg1 (Computes.const SCALE)))
        rwa [hfuel1] at h'
      exact Effects.trans e1 e2
    · intro t ht
      rw [rstep, if_pos hc] at ht
      cases ht
      refine ⟨(h.tables.store cash_lt).store fuel_lt, ?_, ?_, ?_, ?_, ?_, ?_⟩
      · rw [store1_other cash_ne_fuel, store1_same]
      · rw [store1_same]
      · rw [store1_other fuel_ne_day.symm, store1_other cash_ne_day.symm]; exact h.day
      · rw [store1_other fuel_ne_hect.symm, store1_other cash_ne_hect.symm]; exact h.hect
      · intro x
        rw [store1_other (fuel_ne_stock x).symm, store1_other (cash_ne_stock x).symm]
        exact h.stock x
      · intro a
        rw [store1_other (fuel_ne_built a).symm, store1_other (cash_ne_built a).symm]
        exact h.built a
    · intro hn; rw [rstep, if_pos hc] at hn; exact absurd hn (by simp)
    · intro x hx
      rw [store1_other (frozen_ne_fuel hx), store1_other (frozen_ne_cash hx)]
  · refine ⟨mem, ?_, ?_, ?_, ?_⟩
    · rw [hval]
      exact Runs.guarded (guard_refuel h l) (by simp [hc]) (fun _ => rfl)
    · intro t ht; rw [rstep, if_neg hc] at ht; exact absurd ht (by simp)
    · intro _; rfl
    · intro x _; rfl

end Refuel

/-! ## Farm -/

/-- The counter in memory says what the list of built assemblies says: the yard
holds a machine exactly when the `lifeTrac` counter has reached one. -/
theorem hasTractor_iff (s : RState) :
    (1 : Int) ≤ (s.built.count RPart.lifeTrac : Int) ↔ s.hasTractor = true := by
  rw [RState.hasTractor, List.any_eq_true]
  constructor
  · intro hle
    have hpos : 0 < s.built.count RPart.lifeTrac := by exact_mod_cast hle
    exact ⟨RPart.lifeTrac, List.count_pos_iff.mp hpos, by simp⟩
  · rintro ⟨x, hx, hxe⟩
    have hxl : x = RPart.lifeTrac := by simpa using hxe
    subst hxl
    have hpos : 0 < s.built.count RPart.lifeTrac := List.count_pos_iff.mpr hx
    exact_mod_cast hpos

/-- The same, as the boolean the generated comparison leaves on the stack. -/
theorem decide_hasTractor (s : RState) :
    decide ((1 : Int) ≤ (s.built.count RPart.lifeTrac : Int)) = s.hasTractor := by
  cases hh : s.hasTractor
  · simp only [decide_eq_false_iff_not]
    intro hle
    simp [(hasTractor_iff s).mp hle] at hh
  · simp only [decide_eq_true_eq]
    exact (hasTractor_iff s).mpr hh

section Farm

variable {mem : Int → Int} {s : RState} (h : Rep s mem) (c : RCrop) (area : Int)

private theorem farm_arg : (argsOf (RAction.farm c area)).getD ARG 0 = area := rfl
private theorem farm_idx : (argsOf (RAction.farm c area)).getD IDX 0 = idxC c := rfl

include h

theorem guard_farm :
    Computes (argsOf (RAction.farm c area)) mem (guardOf 5)
      (ofBool (decide (s.hasTractor = true ∧ 0 ≤ area ∧ area * c.fuelHa ≤ s.fuel ∧
        area * c.seed ≤ s.cash))) := by
  have hArg : Computes (argsOf (RAction.farm c area)) mem theArg area :=
    computes_theArg (farm_arg c area)
  have hIdx : Computes (argsOf (RAction.farm c area)) mem theIdx (idxC c) :=
    computes_theIdx (farm_idx c area)
  have hA : Computes (argsOf (RAction.farm c area)) mem
      (leE (constE 1) (get (BUILT + 8 * idxP RPart.lifeTrac))) (ofBool s.hasTractor) := by
    have h' := Computes.le (Computes.const 1)
      (computes_get (L := argsOf (RAction.farm c area)) (mem := mem)
        (BUILT + 8 * idxP RPart.lifeTrac))
    rw [h.built RPart.lifeTrac] at h'
    rwa [decide_hasTractor s] at h'
  have hB : Computes (argsOf (RAction.farm c area)) mem (leE (constE 0) theArg)
      (ofBool (decide ((0 : Int) ≤ area))) := Computes.le (Computes.const 0) hArg
  have hC : Computes (argsOf (RAction.farm c area)) mem
      (leE (mulE theArg (loadCell CFUEL theIdx)) (get FUEL))
      (ofBool (decide (area * c.fuelHa ≤ s.fuel))) := by
    have hf : Computes (argsOf (RAction.farm c area)) mem (loadCell CFUEL theIdx) c.fuelHa := by
      have h' := computes_loadCell (mem := mem) CFUEL hIdx
      rwa [h.tables.cfuel c] at h'
    have h' := Computes.le (Computes.mul hArg hf)
      (computes_get (L := argsOf (RAction.farm c area)) (mem := mem) FUEL)
    rwa [h.fuel] at h'
  have hD : Computes (argsOf (RAction.farm c area)) mem
      (leE (mulE theArg (loadCell CSEED theIdx)) (get CASH))
      (ofBool (decide (area * c.seed ≤ s.cash))) := by
    have hf : Computes (argsOf (RAction.farm c area)) mem (loadCell CSEED theIdx) c.seed := by
      have h' := computes_loadCell (mem := mem) CSEED hIdx
      rwa [h.tables.cseed c] at h'
    have h' := Computes.le (Computes.mul hArg hf)
      (computes_get (L := argsOf (RAction.farm c area)) (mem := mem) CASH)
    rwa [h.cash] at h'
  have hall := Computes.and' (Computes.and' (Computes.and' hA hB) hC) hD
  have : (((s.hasTractor && decide ((0 : Int) ≤ area)) && decide (area * c.fuelHa ≤ s.fuel)) &&
      decide (area * c.seed ≤ s.cash))
      = decide (s.hasTractor = true ∧ 0 ≤ area ∧ area * c.fuelHa ≤ s.fuel ∧
        area * c.seed ≤ s.cash) := by
    simp [Bool.and_assoc]
  rwa [this] at hall

theorem step_farm :
    ∃ mem', Runs (argsOf (RAction.farm c area)) mem mem'
        (guardOf 5 ++ [.ifte (effectOf 5 ++ [.const 1]) [.const 0]])
        (ofBool (rstep s (RAction.farm c area)).isSome) ∧
      (∀ t, rstep s (RAction.farm c area) = some t → Rep t mem') ∧
      (rstep s (RAction.farm c area) = none → mem' = mem) ∧
      (∀ x : Int, Frozen x → mem' x = mem x) := by
  have hval : (rstep s (RAction.farm c area)).isSome =
      decide (s.hasTractor = true ∧ 0 ≤ area ∧ area * c.fuelHa ≤ s.fuel ∧
        area * c.seed ≤ s.cash) := by
    simp only [rstep]; split <;> simp_all
  by_cases hc : s.hasTractor = true ∧ 0 ≤ area ∧ area * c.fuelHa ≤ s.fuel ∧
      area * c.seed ≤ s.cash
  · refine ⟨store1 (store1 (store1 (store1 mem CASH (s.cash + area * c.revenue - area * c.seed))
      FUEL (s.fuel - area * c.fuelHa)) DAY (s.day + area * c.daysHa))
      HECT (s.hect + area * SCALE), ?_, ?_, ?_, ?_⟩
    · rw [hval]
      refine Runs.guarded (guard_farm h c area) (fun _ => ?_) (by simp [hc])
      set m1 := store1 mem CASH (s.cash + area * c.revenue - area * c.seed) with hm1
      set m2 := store1 m1 FUEL (s.fuel - area * c.fuelHa) with hm2
      set m3 := store1 m2 DAY (s.day + area * c.daysHa) with hm3
      have t1 : Tables m1 := h.tables.store cash_lt
      have t2 : Tables m2 := t1.store fuel_lt
      have t3 : Tables m3 := t2.store day_lt
      have e1 : Effects (argsOf (RAction.farm c area)) mem m1
          (put CASH (subE (addE (get CASH) (mulE theArg (loadCell CREV theIdx)))
            (mulE theArg (loadCell CSEED theIdx)))) := by
        have hrev : Computes (argsOf (RAction.farm c area)) mem (loadCell CREV theIdx)
            c.revenue := by
          have h' := computes_loadCell (mem := mem) CREV (computes_theIdx (farm_idx c area))
          rwa [h.tables.crev c] at h'
        have hseed : Computes (argsOf (RAction.farm c area)) mem (loadCell CSEED theIdx)
            c.seed := by
          have h' := computes_loadCell (mem := mem) CSEED (computes_theIdx (farm_idx c area))
          rwa [h.tables.cseed c] at h'
        have h' := Effects.put (a := CASH)
          (Computes.sub
            (Computes.add (computes_get (L := argsOf (RAction.farm c area)) (mem := mem) CASH)
              (Computes.mul (computes_theArg (farm_arg c area)) hrev))
            (Computes.mul (computes_theArg (farm_arg c area)) hseed))
        rwa [h.cash] at h'
      have e2 : Effects (argsOf (RAction.farm c area)) m1 m2
          (put FUEL (subE (get FUEL) (mulE theArg (loadCell CFUEL theIdx)))) := by
        have hfuel : Computes (argsOf (RAction.farm c area)) m1 (loadCell CFUEL theIdx)
            c.fuelHa := by
          have h' := computes_loadCell (mem := m1) CFUEL (computes_theIdx (farm_idx c area))
          rwa [t1.cfuel c] at h'
        have hm : m1 FUEL = s.fuel := by rw [hm1, store1_other cash_ne_fuel.symm]; exact h.fuel
        have h' := Effects.put (a := FUEL)
          (Computes.sub (computes_get (L := argsOf (RAction.farm c area)) (mem := m1) FUEL)
            (Computes.mul (computes_theArg (farm_arg c area)) hfuel))
        rwa [hm] at h'
      have e3 : Effects (argsOf (RAction.farm c area)) m2 m3
          (put DAY (addE (get DAY) (mulE theArg (loadCell CDAY theIdx)))) := by
        have hday : Computes (argsOf (RAction.farm c area)) m2 (loadCell CDAY theIdx)
            c.daysHa := by
          have h' := computes_loadCell (mem := m2) CDAY (computes_theIdx (farm_idx c area))
          rwa [t2.cday c] at h'
        have hm : m2 DAY = s.day := by
          rw [hm2, store1_other fuel_ne_day.symm, hm1, store1_other cash_ne_day.symm]
          exact h.day
        have h' := Effects.put (a := DAY)
          (Computes.add (computes_get (L := argsOf (RAction.farm c area)) (mem := m2) DAY)
            (Computes.mul (computes_theArg (farm_arg c area)) hday))
        rwa [hm] at h'
      have e4 : Effects (argsOf (RAction.farm c area)) m3
          (store1 m3 HECT (s.hect + area * SCALE))
          (put HECT (addE (get HECT) (mulE theArg (constE SCALE)))) := by
        have hm : m3 HECT = s.hect := by
          rw [hm3, store1_other day_ne_hect.symm, hm2, store1_other fuel_ne_hect.symm, hm1,
            store1_other cash_ne_hect.symm]
          exact h.hect
        have h' := Effects.put (a := HECT)
          (Computes.add (computes_get (L := argsOf (RAction.farm c area)) (mem := m3) HECT)
            (Computes.mul (computes_theArg (farm_arg c area)) (Computes.const SCALE)))
        rwa [hm] at h'
      exact Effects.trans (Effects.trans (Effects.trans e1 e2) e3) e4
    · intro t ht
      rw [rstep, if_pos hc] at ht
      cases ht
      refine ⟨((((h.tables.store cash_lt).store fuel_lt).store day_lt).store hect_lt),
        ?_, ?_, ?_, ?_, ?_, ?_⟩
      · rw [store1_other cash_ne_hect, store1_other cash_ne_day, store1_other cash_ne_fuel,
          store1_same]
      · rw [store1_other fuel_ne_hect, store1_other fuel_ne_day, store1_same]
      · rw [store1_other day_ne_hect, store1_same]
      · rw [store1_same]
      · intro x
        rw [store1_other (hect_ne_stock x).symm, store1_other (day_ne_stock x).symm,
          store1_other (fuel_ne_stock x).symm, store1_other (cash_ne_stock x).symm]
        exact h.stock x
      · intro a
        rw [store1_other (hect_ne_built a).symm, store1_other (day_ne_built a).symm,
          store1_other (fuel_ne_built a).symm, store1_other (cash_ne_built a).symm]
        exact h.built a
    · intro hn; rw [rstep, if_pos hc] at hn; exact absurd hn (by simp)
    · intro x hx
      rw [store1_other (frozen_ne_hect hx), store1_other (frozen_ne_day hx),
        store1_other (frozen_ne_fuel hx), store1_other (frozen_ne_cash hx)]
  · refine ⟨mem, ?_, ?_, ?_, ?_⟩
    · rw [hval]
      exact Runs.guarded (guard_farm h c area) (by simp [hc]) (fun _ => rfl)
    · intro t ht; rw [rstep, if_neg hc] at ht; exact absurd ht (by simp)
    · intro _; rfl
    · intro x _; rfl

end Farm

/-! ## The bill-of-materials pass

`order` and `fabricate` walk the whole shelf, adding or subtracting the bill of
materials of the assembly cell by cell.  One induction over the list of
material positions covers both. -/

theorem cash_ne_stockRange : ∀ i ∈ List.range 24, (CASH : Int) ≠ STOCK + 8 * (i : Int) := by
  intro i hi; simp only [List.mem_range] at hi; simp only [CASH, STOCK]; omega

theorem fuel_ne_stockRange : ∀ i ∈ List.range 24, (FUEL : Int) ≠ STOCK + 8 * (i : Int) := by
  intro i hi; simp only [List.mem_range] at hi; simp only [FUEL, STOCK]; omega

theorem day_ne_stockRange : ∀ i ∈ List.range 24, (DAY : Int) ≠ STOCK + 8 * (i : Int) := by
  intro i hi; simp only [List.mem_range] at hi; simp only [DAY, STOCK]; omega

theorem hect_ne_stockRange : ∀ i ∈ List.range 24, (HECT : Int) ≠ STOCK + 8 * (i : Int) := by
  intro i hi; simp only [List.mem_range] at hi; simp only [HECT, STOCK]; omega

theorem built_ne_stockRange (b : RPart) :
    ∀ i ∈ List.range 24, BUILT + 8 * idxP b ≠ STOCK + 8 * (i : Int) := by
  intro i hi
  simp only [List.mem_range] at hi
  have := (idxP_bounds b).1
  simp only [BUILT, STOCK]; omega

/-- Walking the shelf with `op` writes `f (old stock) (bill of materials)` into
every cell named in `l`, and touches nothing else. -/
theorem stockPass_effects {L : List Int} {a : RPart} (hidx : L.getD IDX 0 = idxP a)
    {op : Instr} {f : Int → Int → Int}
    (hcomb : ∀ (m : Int → Int) (e₁ e₂ : List Instr) (x y : Int),
      Computes L m e₁ x → Computes L m e₂ y → Computes L m (e₁ ++ e₂ ++ [op]) (f x y)) :
    ∀ (l : List Nat), (∀ i ∈ l, i ≤ 23) → l.Nodup → ∀ mem : Int → Int, Tables mem →
      ∃ mem', Effects L mem mem' (stockPass op l) ∧ Tables mem' ∧
        (∀ i ∈ l, mem' (STOCK + 8 * (i : Int))
          = f (mem (STOCK + 8 * (i : Int))) (a.req (matOf i))) ∧
        (∀ x : Int, (∀ i ∈ l, x ≠ STOCK + 8 * (i : Int)) → mem' x = mem x) := by
  intro l
  induction l with
  | nil => intro _ _ mem htab; exact ⟨mem, Effects.nil mem, htab, by simp, fun x _ => rfl⟩
  | cons i l ih =>
      intro hl hnd mem htab
      have hi : i ≤ 23 := hl i (by simp)
      have hlt : STOCK + 8 * (i : Int) < 1024 := by simp only [STOCK]; omega
      have hnotin : i ∉ l := (List.nodup_cons.mp hnd).1
      have hreq : Computes L mem (reqCell i) (a.req (matOf i)) := by
        have h2 := Computes.load (Computes.add
          (computes_cellAddr REQ (Computes.mul (computes_theIdx (mem := mem) hidx)
            (Computes.const 24)))
          (Computes.const (8 * (i : Int))))
        rwa [show REQ + 8 * (idxP a * 24) + 8 * (i : Int)
              = REQ + 192 * idxP a + 8 * idxM (matOf i) by rw [idxM_matOf hi]; ring,
          htab.req a (matOf i)] at h2
      have e1 : Effects L mem
          (store1 mem (STOCK + 8 * (i : Int))
            (f (mem (STOCK + 8 * (i : Int))) (a.req (matOf i))))
          (put (STOCK + 8 * (i : Int)) (stockCell i ++ reqCell i ++ [op])) :=
        Effects.put (hcomb mem _ _ _ _ (computes_get _) hreq)
      obtain ⟨mem', he, ht', hv, hu⟩ := ih (fun j hj => hl j (by simp [hj]))
        (List.nodup_cons.mp hnd).2 _ (htab.store hlt)
      refine ⟨mem', ?_, ht', ?_, ?_⟩
      · rw [show stockPass op (i :: l)
            = put (STOCK + 8 * (i : Int)) (stockCell i ++ reqCell i ++ [op]) ++ stockPass op l from
          rfl]
        exact Effects.trans e1 he
      · intro j hj
        rcases List.mem_cons.mp hj with rfl | hjl
        · rw [hu _ (fun k hk => by
            have : k ≠ j := fun hkj => hnotin (hkj ▸ hk)
            simp only [STOCK]; omega), store1_same]
        · rw [hv j hjl, store1_other (by
            have : j ≠ i := fun hji => hnotin (hji ▸ hjl)
            simp only [STOCK]; omega)]
      · intro x hx
        rw [hu x (fun k hk => hx k (by simp [hk])), store1_other (hx i (by simp))]

/-! ## Order -/

section Order

variable {mem : Int → Int} {s : RState} (h : Rep s mem) (a : RPart)

private theorem order_idx : (argsOf (RAction.order a)).getD IDX 0 = idxP a := rfl

include h

theorem guard_order :
    Computes (argsOf (RAction.order a)) mem (guardOf 1) (ofBool (decide (a.cost ≤ s.cash))) := by
  have hp : Computes (argsOf (RAction.order a)) mem (loadCell PCOST theIdx) a.cost := by
    have h' := computes_loadCell (mem := mem) PCOST (computes_theIdx (order_idx a))
    rwa [h.tables.pcost a] at h'
  have h' := Computes.le hp (computes_get (L := argsOf (RAction.order a)) (mem := mem) CASH)
  rwa [h.cash] at h'

theorem step_order :
    ∃ mem', Runs (argsOf (RAction.order a)) mem mem'
        (guardOf 1 ++ [.ifte (effectOf 1 ++ [.const 1]) [.const 0]])
        (ofBool (rstep s (RAction.order a)).isSome) ∧
      (∀ t, rstep s (RAction.order a) = some t → Rep t mem') ∧
      (rstep s (RAction.order a) = none → mem' = mem) ∧
      (∀ x : Int, Frozen x → mem' x = mem x) := by
  have hval : (rstep s (RAction.order a)).isSome = decide (a.cost ≤ s.cash) := by
    simp only [rstep]; split <;> simp_all
  by_cases hc : a.cost ≤ s.cash
  · have t1 : Tables (store1 mem CASH (s.cash - a.cost)) := h.tables.store cash_lt
    obtain ⟨m2, he2, ht2, hv2, hu2⟩ :=
      stockPass_effects (L := argsOf (RAction.order a)) (order_idx a)
        (op := Instr.add) (f := fun x y => x + y)
        (fun _ _ _ _ _ h₁ h₂ => Computes.add h₁ h₂)
        (List.range 24) (by intro i hi; simp only [List.mem_range] at hi; omega)
        (List.nodup_range) _ t1
    have hcash2 : m2 CASH = s.cash - a.cost := by
      rw [hu2 CASH cash_ne_stockRange, store1_same]
    have hstock2 : ∀ x : Material, m2 (STOCK + 8 * idxM x) = s.stock x + a.req x := by
      intro x
      have hb := idxM_bounds x
      have hcast : (((idxM x).toNat : Nat) : Int) = idxM x := Int.toNat_of_nonneg hb.1
      have hmem : ((idxM x).toNat) ∈ List.range 24 := by
        simp only [List.mem_range]; omega
      have := hv2 ((idxM x).toNat) hmem
      rw [hcast, matOf_idxM] at this
      rw [this, store1_other (Ne.symm (cash_ne_stock x)), h.stock x]
    refine ⟨m2, ?_, ?_, ?_, ?_⟩
    · rw [hval]
      refine Runs.guarded (guard_order h a) (fun _ => ?_) (by simp [hc])
      have e1 : Effects (argsOf (RAction.order a)) mem (store1 mem CASH (s.cash - a.cost))
          (put CASH (subE (get CASH) (loadCell PCOST theIdx))) := by
        have hp : Computes (argsOf (RAction.order a)) mem (loadCell PCOST theIdx) a.cost := by
          have h' := computes_loadCell (mem := mem) PCOST (computes_theIdx (order_idx a))
          rwa [h.tables.pcost a] at h'
        have h' := Effects.put (a := CASH)
          (Computes.sub (computes_get (L := argsOf (RAction.order a)) (mem := mem) CASH) hp)
        rwa [h.cash] at h'
      exact Effects.trans e1 he2
    · intro t ht
      rw [rstep, if_pos hc] at ht
      cases ht
      exact ⟨ht2, hcash2, by
          rw [hu2 FUEL fuel_ne_stockRange, store1_other cash_ne_fuel.symm]; exact h.fuel, by
          rw [hu2 DAY day_ne_stockRange, store1_other cash_ne_day.symm]; exact h.day, by
          rw [hu2 HECT hect_ne_stockRange, store1_other cash_ne_hect.symm]; exact h.hect,
        hstock2, fun b => by
          rw [hu2 _ (built_ne_stockRange b), store1_other (cash_ne_built b).symm]
          exact h.built b⟩
    · intro hn; rw [rstep, if_pos hc] at hn; exact absurd hn (by simp)
    · intro x hx
      rw [hu2 x (frozen_ne_stockRange hx), store1_other (frozen_ne_cash hx)]
  · refine ⟨mem, ?_, ?_, ?_, ?_⟩
    · rw [hval]
      exact Runs.guarded (guard_order h a) (by simp [hc]) (fun _ => rfl)
    · intro t ht; rw [rstep, if_neg hc] at ht; exact absurd ht (by simp)
    · intro _; rfl
    · intro x _; rfl

end Order

/-! ## Fabricate -/

/-- A `foldl` of conjunctions computes the conjunction. -/
theorem computes_foldl_and {L : List Int} {mem : Int → Int} {g : Nat → List Instr}
    {q : Nat → Bool} :
    ∀ (l : List Nat), (∀ i ∈ l, Computes L mem (g i) (ofBool (q i))) →
      ∀ (base : List Instr) (p : Bool), Computes L mem base (ofBool p) →
        Computes L mem (l.foldl (fun acc i => andE acc (g i)) base) (ofBool (p && l.all q)) := by
  intro l
  induction l with
  | nil => intro _ base p hb; simpa using hb
  | cons i l ih =>
      intro hg base p hb
      have h' := ih (fun j hj => hg j (by simp [hj])) (andE base (g i)) (p && q i)
        (Computes.and' hb (hg i (by simp)))
      simpa [List.all_cons, Bool.and_assoc] using h'

/-- A property of every material is a property of every table position. -/
theorem all_range24 (P : Material → Prop) [DecidablePred P] :
    ((List.range 24).all fun i => decide (P (matOf i))) = decide (∀ m, P m) := by
  rw [Bool.eq_iff_iff]
  simp only [List.all_eq_true, decide_eq_true_eq, List.mem_range]
  constructor
  · intro hall m
    have hb := idxM_bounds m
    have := hall ((idxM m).toNat) (by omega)
    rwa [matOf_idxM] at this
  · intro hall i _; exact hall _

section Fabricate

variable {mem : Int → Int} {s : RState} (h : Rep s mem) (a : RPart)

private theorem fab_idx : (argsOf (RAction.fabricate a)).getD IDX 0 = idxP a := rfl

include h

/-- The shelf cell and the bill-of-materials cell of position `i`. -/
theorem computes_reqCell {i : Nat} (hi : i ≤ 23) :
    Computes (argsOf (RAction.fabricate a)) mem (reqCell i) (a.req (matOf i)) := by
  have h2 := Computes.load (Computes.add
    (computes_cellAddr REQ (Computes.mul (computes_theIdx (mem := mem) (fab_idx a))
      (Computes.const 24)))
    (Computes.const (8 * (i : Int))))
  rwa [show REQ + 8 * (idxP a * 24) + 8 * (i : Int)
        = REQ + 192 * idxP a + 8 * idxM (matOf i) by rw [idxM_matOf hi]; ring,
    h.tables.req a (matOf i)] at h2

theorem computes_stockCell {i : Nat} (hi : i ≤ 23) :
    Computes (argsOf (RAction.fabricate a)) mem (stockCell i) (s.stock (matOf i)) := by
  have h2 := computes_get (L := argsOf (RAction.fabricate a)) (mem := mem)
    (STOCK + 8 * (i : Int))
  rwa [show mem (STOCK + 8 * (i : Int)) = s.stock (matOf i) from by
    rw [show STOCK + 8 * (i : Int) = STOCK + 8 * idxM (matOf i) by rw [idxM_matOf hi]]
    exact h.stock (matOf i)] at h2

theorem guard_fabricate :
    Computes (argsOf (RAction.fabricate a)) mem (guardOf 3)
      (ofBool (decide ((∀ m, a.req m ≤ s.stock m) ∧ a.laborCost ≤ s.cash))) := by
  have hbase : Computes (argsOf (RAction.fabricate a)) mem
      (leE (loadCell PLAB theIdx) (get CASH)) (ofBool (decide (a.laborCost ≤ s.cash))) := by
    have hp : Computes (argsOf (RAction.fabricate a)) mem (loadCell PLAB theIdx) a.laborCost := by
      have h' := computes_loadCell (mem := mem) PLAB (computes_theIdx (fab_idx a))
      rwa [h.tables.plab a] at h'
    have h' := Computes.le hp (computes_get (L := argsOf (RAction.fabricate a)) (mem := mem) CASH)
    rwa [h.cash] at h'
  have hall := computes_foldl_and (g := fun i => leE (reqCell i) (stockCell i))
    (q := fun i => decide (a.req (matOf i) ≤ s.stock (matOf i)))
    (List.range 24)
    (fun i hi => by
      simp only [List.mem_range] at hi
      exact Computes.le (computes_reqCell h a (by omega)) (computes_stockCell h a (by omega)))
    _ _ hbase
  rw [all_range24 (fun m => a.req m ≤ s.stock m), Bool.and_comm, ← Bool.decide_and] at hall
  exact hall

theorem step_fabricate :
    ∃ mem', Runs (argsOf (RAction.fabricate a)) mem mem'
        (guardOf 3 ++ [.ifte (effectOf 3 ++ [.const 1]) [.const 0]])
        (ofBool (rstep s (RAction.fabricate a)).isSome) ∧
      (∀ t, rstep s (RAction.fabricate a) = some t → Rep t mem') ∧
      (rstep s (RAction.fabricate a) = none → mem' = mem) ∧
      (∀ x : Int, Frozen x → mem' x = mem x) := by
  have hval : (rstep s (RAction.fabricate a)).isSome =
      decide ((∀ m, a.req m ≤ s.stock m) ∧ a.laborCost ≤ s.cash) := by
    simp only [rstep]; split <;> simp_all
  by_cases hc : (∀ m, a.req m ≤ s.stock m) ∧ a.laborCost ≤ s.cash
  · have t1 : Tables (store1 mem CASH (s.cash - a.laborCost)) := h.tables.store cash_lt
    obtain ⟨m2, he2, ht2, hv2, hu2⟩ :=
      stockPass_effects (L := argsOf (RAction.fabricate a)) (fab_idx a)
        (op := Instr.sub) (f := fun x y => x - y)
        (fun _ _ _ _ _ h₁ h₂ => Computes.sub h₁ h₂)
        (List.range 24) (by intro i hi; simp only [List.mem_range] at hi; omega)
        (List.nodup_range) _ t1
    have hcash2 : m2 CASH = s.cash - a.laborCost := by
      rw [hu2 CASH cash_ne_stockRange, store1_same]
    have hday2 : m2 DAY = s.day := by
      rw [hu2 DAY day_ne_stockRange, store1_other cash_ne_day.symm]; exact h.day
    have hbuilt2 : ∀ b : RPart, m2 (BUILT + 8 * idxP b) = (s.built.count b : Int) := by
      intro b
      rw [hu2 _ (built_ne_stockRange b), store1_other (cash_ne_built b).symm]
      exact h.built b
    have hstock2 : ∀ x : Material, m2 (STOCK + 8 * idxM x) = s.stock x - a.req x := by
      intro x
      have hb := idxM_bounds x
      have hcast : (((idxM x).toNat : Nat) : Int) = idxM x := Int.toNat_of_nonneg hb.1
      have hmem : ((idxM x).toNat) ∈ List.range 24 := by simp only [List.mem_range]; omega
      have h' := hv2 ((idxM x).toNat) hmem
      rw [hcast, matOf_idxM] at h'
      rw [h', store1_other (Ne.symm (cash_ne_stock x)), h.stock x]
    set m3 := store1 m2 (BUILT + 8 * idxP a) ((s.built.count a : Int) + 1) with hm3
    have ht3 : Tables m3 := ht2.store (built_addr_lt a)
    refine ⟨store1 m3 DAY (s.day + a.days), ?_, ?_, ?_, ?_⟩
    · rw [hval]
      refine Runs.guarded (guard_fabricate h a) (fun _ => ?_) (by simp [hc])
      have e1 : Effects (argsOf (RAction.fabricate a)) mem (store1 mem CASH (s.cash - a.laborCost))
          (put CASH (subE (get CASH) (loadCell PLAB theIdx))) := by
        have hp : Computes (argsOf (RAction.fabricate a)) mem (loadCell PLAB theIdx)
            a.laborCost := by
          have h' := computes_loadCell (mem := mem) PLAB (computes_theIdx (fab_idx a))
          rwa [h.tables.plab a] at h'
        have h' := Effects.put (a := CASH)
          (Computes.sub (computes_get (L := argsOf (RAction.fabricate a)) (mem := mem) CASH) hp)
        rwa [h.cash] at h'
      have e3 : Effects (argsOf (RAction.fabricate a)) m2 m3
          (putCell BUILT theIdx (addE (loadCell BUILT theIdx) (constE 1))) := by
        have hIdx : Computes (argsOf (RAction.fabricate a)) m2 theIdx (idxP a) :=
          computes_theIdx (fab_idx a)
        have h' := Effects.putAt (computes_cellAddr BUILT hIdx)
          (Computes.add (computes_loadCell BUILT hIdx) (Computes.const 1))
        rwa [hbuilt2 a] at h'
      have e4 : Effects (argsOf (RAction.fabricate a)) m3 (store1 m3 DAY (s.day + a.days))
          (put DAY (addE (get DAY) (loadCell PDAY theIdx))) := by
        have hp : Computes (argsOf (RAction.fabricate a)) m3 (loadCell PDAY theIdx) a.days := by
          have h' := computes_loadCell (mem := m3) PDAY (computes_theIdx (fab_idx a))
          rwa [ht3.pday a] at h'
        have hm : m3 DAY = s.day := by
          rw [hm3, store1_other (day_ne_built a)]; exact hday2
        have h' := Effects.put (a := DAY)
          (Computes.add (computes_get (L := argsOf (RAction.fabricate a)) (mem := m3) DAY) hp)
        rwa [hm] at h'
      exact Effects.trans (Effects.trans (Effects.trans e1 he2) e3) e4
    · intro t ht
      rw [rstep, if_pos hc] at ht
      cases ht
      refine ⟨ht3.store day_lt, ?_, ?_, ?_, ?_, ?_, ?_⟩
      · rw [store1_other cash_ne_day, hm3, store1_other (cash_ne_built a)]; exact hcash2
      · rw [store1_other fuel_ne_day, hm3, store1_other (fuel_ne_built a),
          hu2 FUEL fuel_ne_stockRange, store1_other cash_ne_fuel.symm]
        exact h.fuel
      · rw [store1_same]
      · rw [store1_other day_ne_hect.symm, hm3, store1_other (hect_ne_built a),
          hu2 HECT hect_ne_stockRange, store1_other cash_ne_hect.symm]
        exact h.hect
      · intro x
        rw [store1_other (day_ne_stock x).symm, hm3,
          store1_other (stock_ne_built x a)]
        exact hstock2 x
      · intro b
        rw [store1_other (day_ne_built b).symm]
        by_cases hb : b = a
        · subst hb
          rw [hm3, store1_same, List.count_cons]
          simp
        · rw [hm3, store1_other (built_ne_built hb), hbuilt2 b, List.count_cons]
          simp [Ne.symm hb]
    · intro hn; rw [rstep, if_pos hc] at hn; exact absurd hn (by simp)
    · intro x hx
      rw [store1_other (frozen_ne_day hx), hm3, store1_other (frozen_ne_built hx a),
        hu2 x (frozen_ne_stockRange hx), store1_other (frozen_ne_cash hx)]
  · refine ⟨mem, ?_, ?_, ?_, ?_⟩
    · rw [hval]
      exact Runs.guarded (guard_fabricate h a) (by simp [hc]) (fun _ => rfl)
    · intro t ht; rw [rstep, if_neg hc] at ht; exact absurd ht (by simp)
    · intro _; rfl
    · intro x _; rfl

end Fabricate

/-! ## The entry points

`enabled` and `apply` are the two functions the shell calls for every click.
Both are `dispatch`es on the kind of move, so the six cases above assemble into
one theorem each. -/

theorem runFun_argsOf {body : List Instr} {L : List Int} {mem mem' : Int → Int} {v : Int}
    (h : Runs L mem mem' body v) : runFun body L 0 mem = (v, mem') := by
  have h0 : L ++ List.replicate 0 (0 : Int) = L := by simp
  simp only [runFun, h0, h []]
  rfl

/-- **The generated `enabled` is the rule book's `isSome`.**  A button is live
in the compiled module exactly when `Runtime.rstep` would accept the move. -/
theorem enabled_correct {mem : Int → Int} {s : RState} (h : Rep s mem) (a : RAction) :
    callFun enabledBody (argsOf a) 0 mem = ofBool (rstep s a).isSome := by
  have key : Runs (argsOf a) mem mem enabledBody (ofBool (rstep s a).isSome) := by
    refine runs_dispatch (kindOf_le a) (getD_kind a) ?_
    cases a with
    | buy m q =>
        have hv : (rstep s (RAction.buy m q)).isSome = decide (0 ≤ q ∧ q * costM m ≤ s.cash) := by
          simp only [rstep]; split <;> simp_all
        rw [hv]; exact Runs.of_computes (guard_buy h m q)
    | order p =>
        have hv : (rstep s (RAction.order p)).isSome = decide (p.cost ≤ s.cash) := by
          simp only [rstep]; split <;> simp_all
        rw [hv]; exact Runs.of_computes (guard_order h p)
    | sell m q =>
        have hv : (rstep s (RAction.sell m q)).isSome = decide (0 ≤ q ∧ q * SCALE ≤ s.stock m) := by
          simp only [rstep]; split <;> simp_all
        rw [hv]; exact Runs.of_computes (guard_sell h m q)
    | fabricate p =>
        have hv : (rstep s (RAction.fabricate p)).isSome =
            decide ((∀ m, p.req m ≤ s.stock m) ∧ p.laborCost ≤ s.cash) := by
          simp only [rstep]; split <;> simp_all
        rw [hv]; exact Runs.of_computes (guard_fabricate h p)
    | refuel l =>
        have hv : (rstep s (RAction.refuel l)).isSome =
            decide (0 ≤ l ∧ l * fuelPriceM ≤ s.cash) := by
          simp only [rstep]; split <;> simp_all
        rw [hv]; exact Runs.of_computes (guard_refuel h l)
    | farm c area =>
        have hv : (rstep s (RAction.farm c area)).isSome =
            decide (s.hasTractor = true ∧ 0 ≤ area ∧ area * c.fuelHa ≤ s.fuel ∧
              area * c.seed ≤ s.cash) := by
          simp only [rstep]; split <;> simp_all
        rw [hv]; exact Runs.of_computes (guard_farm h c area)
  simp [callFun, runFun_argsOf key]

/-- The body of `apply`, as a block: the six cases of the dispatch assembled
into one statement about `Runs`, which is what a caller that embeds `apply` in
a larger block (such as `commit`) needs. -/
theorem apply_runs {mem : Int → Int} {s : RState} (h : Rep s mem) (a : RAction) :
    ∃ mem', Runs (argsOf a) mem mem' applyBody (ofBool (rstep s a).isSome) ∧
      (∀ t, rstep s a = some t → Rep t mem') ∧ (rstep s a = none → mem' = mem) ∧
      (∀ x : Int, Frozen x → mem' x = mem x) := by
  have gen : ∀ (mem' : Int → Int),
      Runs (argsOf a) mem mem'
        (guardOf (kindOf a) ++
          [.ifte (effectOf (kindOf a) ++ [.const 1]) [.const 0]])
        (ofBool (rstep s a).isSome) →
      Runs (argsOf a) mem mem' applyBody (ofBool (rstep s a).isSome) :=
    fun _ hr => runs_dispatch (kindOf_le a) (getD_kind a) hr
  cases a with
  | buy m q =>
      obtain ⟨mem', hr, h1, h2, h3⟩ := step_buy h m q
      exact ⟨mem', gen _ hr, h1, h2, h3⟩
  | order p =>
      obtain ⟨mem', hr, h1, h2, h3⟩ := step_order h p
      exact ⟨mem', gen _ hr, h1, h2, h3⟩
  | sell m q =>
      obtain ⟨mem', hr, h1, h2, h3⟩ := step_sell h m q
      exact ⟨mem', gen _ hr, h1, h2, h3⟩
  | fabricate p =>
      obtain ⟨mem', hr, h1, h2, h3⟩ := step_fabricate h p
      exact ⟨mem', gen _ hr, h1, h2, h3⟩
  | refuel l =>
      obtain ⟨mem', hr, h1, h2, h3⟩ := step_refuel h l
      exact ⟨mem', gen _ hr, h1, h2, h3⟩
  | farm c area =>
      obtain ⟨mem', hr, h1, h2, h3⟩ := step_farm h c area
      exact ⟨mem', gen _ hr, h1, h2, h3⟩

/-- **The generated `apply` is the rule book.**  It answers `1` exactly when
`Runtime.rstep` accepts the move, it leaves behind a memory holding the
position `rstep` lands on, and when it refuses it changes nothing.  It also
leaves the frozen cells — the screen and the constant tables — alone. -/
theorem apply_correct {mem : Int → Int} {s : RState} (h : Rep s mem) (a : RAction) :
    ∃ mem', runFun applyBody (argsOf a) 0 mem = (ofBool (rstep s a).isSome, mem') ∧
      (∀ t, rstep s a = some t → Rep t mem') ∧ (rstep s a = none → mem' = mem) ∧
      (∀ x : Int, Frozen x → mem' x = mem x) := by
  obtain ⟨mem', hr, h1, h2, h3⟩ := apply_runs h a
  exact ⟨mem', runFun_argsOf hr, h1, h2, h3⟩

/-! ## The memory the module starts from -/

set_option maxHeartbeats 2000000 in
/-- The constant tables are laid down correctly by the data segment. -/
theorem tables_startMem : Tables startMem where
  cost m := by cases m <;> rfl
  salv m := by cases m <;> rfl
  req a m := by cases a <;> cases m <;> rfl
  pcost a := by cases a <;> rfl
  plab a := by cases a <;> rfl
  pday a := by cases a <;> rfl
  cseed c := by cases c; rfl
  crev c := by cases c; rfl
  cfuel c := by cases c; rfl
  cday c := by cases c; rfl

/-- **The module starts on the opening position.**  The data segment the
extractor writes is a memory holding `Runtime.rstart`, so `apply_correct`
applies from the first click. -/
theorem rep_startMem : Rep rstart startMem where
  tables := tables_startMem
  cash := rfl
  fuel := rfl
  day := rfl
  hect := rfl
  stock m := by cases m <;> rfl
  built a := by cases a <;> rfl

/-- **The compiled module plays the game of `Game.lean`.**  Chaining
`apply_correct` with `Runtime.rstep_refines`: the answer the module gives is
the answer the rational rule book gives, and the memory it leaves behind holds
a position standing for the position the rule book lands on. -/
theorem apply_plays_the_game {mem : Int → Int} {s : RState} (h : Rep s mem) (a : RAction) :
    ∃ mem', runFun applyBody (argsOf a) 0 mem =
        (ofBool (step homestead (absState s) (absAction a)).isSome, mem') ∧
      (∀ t, rstep s a = some t →
        Rep t mem' ∧ step homestead (absState s) (absAction a) = some (absState t)) := by
  obtain ⟨mem', hrun, hsome, -, -⟩ := apply_correct h a
  refine ⟨mem', ?_, fun t ht => ⟨hsome t ht, ?_⟩⟩
  · rw [hrun, ← rstep_refines s a]
    cases hr : rstep s a <;> simp
  · rw [← rstep_refines s a, ht]; rfl

/-! ## Whole scripts -/

/-- Playing a script of moves through the generated `apply`. -/
def applyAll (mem : Int → Int) : List RAction → (Int → Int)
  | [] => mem
  | a :: as => applyAll (memAfter applyBody (argsOf a) 0 mem) as

/-- **A whole playthrough lands where the rule book says.**  If the runtime
accepts the script, the memory the module is left in after the same clicks
holds the position the runtime reached. -/
theorem applyAll_correct : ∀ (script : List RAction) (s : RState) (mem : Int → Int),
    Rep s mem → ∀ t, rrun s script = some t → Rep t (applyAll mem script) := by
  intro script
  induction script with
  | nil => intro s mem h t ht; cases ht; exact h
  | cons a as ih =>
      intro s mem h t ht
      obtain ⟨mem', hrun, hsome, -, -⟩ := apply_correct h a
      cases hstep : rstep s a with
      | none => rw [rrun, hstep] at ht; exact absurd ht (by simp)
      | some u =>
          have hmem : memAfter applyBody (argsOf a) 0 mem = mem' := by
            rw [memAfter, hrun]
          rw [rrun, hstep] at ht
          exact ih u _ (hmem ▸ hsome u hstep) t (by simpa using ht)

/-- **A move never touches the shell's cells.**  Whatever the click, the screen
cell and the constant tables come out of `apply` exactly as they went in. -/
theorem apply_frozen {mem : Int → Int} {s : RState} (h : Rep s mem) (a : RAction) :
    ∀ x : Int, Frozen x → memAfter applyBody (argsOf a) 0 mem x = mem x := by
  obtain ⟨mem', hrun, -, -, hfr⟩ := apply_correct h a
  intro x hx
  rw [memAfter, hrun]
  exact hfr x hx

/-- **A whole script never touches the shell's cells** either — refused moves
included. -/
theorem applyAll_frozen : ∀ (script : List RAction) (s : RState) (mem : Int → Int),
    Rep s mem → ∀ x : Int, Frozen x → applyAll mem script x = mem x := by
  intro script
  induction script with
  | nil => intro _ _ _ _ _; rfl
  | cons a as ih =>
      intro s mem h x hx
      obtain ⟨mem', hrun, hsome, hnone, hfr⟩ := apply_correct h a
      have hmem : memAfter applyBody (argsOf a) 0 mem = mem' := by rw [memAfter, hrun]
      cases hstep : rstep s a with
      | none =>
          have hEq : mem' = mem := hnone hstep
          rw [applyAll, hmem, hEq]
          exact ih s mem h x hx
      | some u =>
          rw [applyAll, hmem, ih u mem' (hsome u hstep) x hx]
          exact hfr x hx

/-- **The verified playthrough, in the module's memory.**  Starting from the
data segment the extractor writes and clicking the four moves of the season of
`Tycoon.lean`, the module's cash, fuel, calendar and hectare cells hold 18 449,
40 litres, 17.125 days and 20 hectares. -/
theorem firstSeason_memory :
    (applyAll startMem rFirstSeason) CASH = 18449 * SCALE ∧
      (applyAll startMem rFirstSeason) FUEL = 40 * SCALE ∧
      (applyAll startMem rFirstSeason) DAY = 17125000 ∧
      (applyAll startMem rFirstSeason) HECT = 20 * SCALE := by
  obtain ⟨t, hrun, hc, hf, hd, hh, -⟩ := runtime_firstSeason
  have hrep := applyAll_correct rFirstSeason rstart startMem rep_startMem t hrun
  exact ⟨by rw [hrep.cash, hc], by rw [hrep.fuel, hf], by rw [hrep.day, hd],
    by rw [hrep.hect, hh]⟩

end Wasm
end LifeTrac
