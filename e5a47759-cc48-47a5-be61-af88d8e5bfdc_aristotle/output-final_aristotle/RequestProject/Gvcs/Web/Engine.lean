import RequestProject.Gvcs.Web.Pack

/-!
# The engine the packs are played on

`RequestProject/Web/Pack.lean` says what a pack *is*; this file says what a
pack *does*.  The catalogue in force is a `World` — the items of every loaded
pack, later packs overriding earlier ones by key — and the position of a game
is a `St`: cash, elapsed days and a shelf of quantities.  Four moves change it:
buying, selling, fabricating and working the land.

Quantities live in millionths of a unit, as everywhere else in this
development, while the numbers a player types (how many tubes, how many
hectares) are whole, so nothing here ever divides.

An item's bill of materials does double duty: a **positive** quantity is
consumed by the move, a **negative** one is a *tool*, which must be standing in
the yard but is not used up.  That one convention is what lets a pack add a
machine that unlocks work without the engine knowing anything about machines.

What is proved:

* `qty_put_self`, `qty_put_other` — the shelf behaves like a finite map;
* `cash_nonneg` — in a priced world no move puts a player into debt;
* `stock_nonneg` — and none leaves a negative quantity on the shelf;
* `day_le` — the clock never runs backwards.
-/

namespace LifeTrac
namespace Modular

/-- One unit is a million of the engine's units. -/
def SCALE : Int := 1000000

/-! ## Positions -/

/-- A position of the game: money in hand, days elapsed, and the shelf. -/
structure St where
  /-- Cash, in micro-money. -/
  cash : Int
  /-- Days elapsed, in micro-days. -/
  day : Int
  /-- The shelf: quantities in micro-units, by item key. -/
  stock : List (String × Int)
  deriving DecidableEq, Repr, Inhabited

namespace St

/-- How much of an item is on the shelf. -/
def qty (s : St) (id : String) : Int :=
  match s.stock.find? (fun p => p.1 == id) with
  | some p => p.2
  | none => 0

/-- Set a quantity. -/
def put (s : St) (id : String) (v : Int) : St :=
  { s with stock := s.stock.filter (fun p => p.1 != id) ++ [(id, v)] }

/-- Change a quantity. -/
def add (s : St) (id : String) (d : Int) : St := s.put id (s.qty id + d)

/-- Move the clock. -/
def withDay (s : St) (d : Int) : St := { s with day := d }

/-- Set the cash. -/
def withCash (s : St) (c : Int) : St := { s with cash := c }

@[simp] theorem qty_withDay (s : St) (d : Int) (id : String) :
    (s.withDay d).qty id = s.qty id := rfl
@[simp] theorem qty_withCash (s : St) (c : Int) (id : String) :
    (s.withCash c).qty id = s.qty id := rfl
@[simp] theorem cash_withCash (s : St) (c : Int) : (s.withCash c).cash = c := rfl
@[simp] theorem day_withDay (s : St) (d : Int) : (s.withDay d).day = d := rfl
@[simp] theorem cash_withDay (s : St) (d : Int) : (s.withDay d).cash = s.cash := rfl
@[simp] theorem day_withCash (s : St) (c : Int) : (s.withCash c).day = s.day := rfl

@[simp] theorem cash_put (s : St) (id : String) (v : Int) : (s.put id v).cash = s.cash := rfl
@[simp] theorem day_put (s : St) (id : String) (v : Int) : (s.put id v).day = s.day := rfl
@[simp] theorem cash_add (s : St) (id : String) (d : Int) : (s.add id d).cash = s.cash := rfl
@[simp] theorem day_add (s : St) (id : String) (d : Int) : (s.add id d).day = s.day := rfl

theorem find?_append_of_none {α : Type} {p : α → Bool} {l r : List α}
    (h : l.find? p = none) : (l ++ r).find? p = r.find? p := by
  rw [List.find?_append, h, Option.none_or]

@[simp] theorem qty_put_self (s : St) (id : String) (v : Int) : (s.put id v).qty id = v := by
  have hnone : (s.stock.filter (fun p => p.1 != id)).find? (fun p => p.1 == id) = none := by
    rw [List.find?_eq_none]
    intro x hx
    have := (List.mem_filter.mp hx).2
    simp only [bne_iff_ne, ne_eq, beq_iff_eq] at this ⊢
    exact this
  simp [qty, put, find?_append_of_none hnone]

/-- Filtering out one key does not disturb the entry of another. -/
theorem find?_filter_ne {l : List (String × Int)} {id j : String} (h : j ≠ id) :
    (l.filter (fun p => p.1 != id)).find? (fun p => p.1 == j) =
      l.find? (fun p => p.1 == j) := by
  induction l with
  | nil => rfl
  | cons a t ih =>
      by_cases ha : a.1 = id
      · have hj : ¬ a.1 = j := by rw [ha]; exact fun h' => h h'.symm
        rw [List.filter_cons_of_neg (by simp [ha]), ih, List.find?_cons_of_neg (by simp [hj])]
      · rw [List.filter_cons_of_pos (by simp [ha])]
        by_cases hj : a.1 = j
        · rw [List.find?_cons_of_pos (by simp [hj]), List.find?_cons_of_pos (by simp [hj])]
        · rw [List.find?_cons_of_neg (by simp [hj]), List.find?_cons_of_neg (by simp [hj]), ih]

theorem qty_put_other (s : St) {id j : String} (h : j ≠ id) (v : Int) :
    (s.put id v).qty j = s.qty j := by
  simp only [qty, put]
  rw [List.find?_append, find?_filter_ne h]
  cases hf : s.stock.find? (fun p => p.1 == j) with
  | some x => simp
  | none =>
      have hne : (id == j) = false := by simpa using fun h' : id = j => h h'.symm
      simp [List.find?, hne]

theorem qty_add_self (s : St) (id : String) (d : Int) : (s.add id d).qty id = s.qty id + d := by
  simp [add]

theorem qty_add_other (s : St) {id j : String} (h : j ≠ id) (d : Int) :
    (s.add id d).qty j = s.qty j := by
  simp [add, qty_put_other s h]

end St

/-! ## Worlds -/

/-- The catalogue in force. -/
abbrev World := List Item

/-- Look an item up by key. -/
def findItem (w : World) (id : String) : Option Item := w.find? (fun i => i.id == id)

/-- Load a pack on top of a world: an item with a key already present replaces
the one that was there, so a pack can retune the base game as well as extend
it. -/
def loadPack (w : World) (p : Pack) : World :=
  w.filter (fun i => !(p.items.any (fun j => j.id == i.id))) ++ p.items

/-- The world a list of packs makes, in order. -/
def worldOf (ps : List Pack) : World := ps.foldl loadPack []

/-! ## Moves -/

/-- A move. -/
inductive Act where
  /-- Buy whole units of a material. -/
  | buy : String → Int → Act
  /-- Sell whole units back to the dealer. -/
  | sell : String → Int → Act
  /-- Fabricate one of an assembly. -/
  | make : String → Act
  /-- Work whole units of land with a crop. -/
  | work : String → Int → Act
  deriving DecidableEq, Repr, Inhabited

/-- What `n` of an item consumes of a key: the positive entries of its bill of
materials, summed, so a key that appears twice is charged twice. -/
def need (i : Item) (n : Int) (id : String) : Int :=
  (i.inputs.filter (fun p => p.1 == id && decide (0 < p.2))).foldl (fun a p => a + n * p.2) 0

/-- Whether the shelf can pay for `n` of an item: enough of everything it
consumes, and one of every tool it needs. -/
def affords (s : St) (i : Item) (n : Int) : Bool :=
  i.inputs.all (fun p =>
    if 0 < p.2 then decide (need i n p.1 ≤ s.qty p.1) else decide (-p.2 ≤ s.qty p.1))

/-- Take the bill of materials off the shelf. -/
def payInputs (s : St) (i : Item) (n : Int) : St :=
  { s with stock := s.stock.map (fun p => (p.1, p.2 - need i n p.1)) }

/-- The rule book: what a move does, and when it is refused. -/
def step (w : World) (s : St) : Act → Option St
  | .buy id q =>
      match findItem w id with
      | none => none
      | some i =>
          if 0 < q ∧ i.kind = Kind.material ∧ q * i.price ≤ s.cash then
            some ((s.withCash (s.cash - q * i.price)).add id (q * SCALE))
          else none
  | .sell id q =>
      match findItem w id with
      | none => none
      | some i =>
          if 0 < q ∧ q * SCALE ≤ s.qty id then
            some ((s.withCash (s.cash + q * i.salvage)).add id (-(q * SCALE)))
          else none
  | .make id =>
      match findItem w id with
      | none => none
      | some i =>
          if i.kind = Kind.part ∧ affords s i 1 = true then
            some (((payInputs s i 1).add id SCALE) |>.withDay (s.day + i.days)
              |>.withCash (s.cash + i.revenue))
          else none
  | .work id q =>
      match findItem w id with
      | none => none
      | some i =>
          if 0 < q ∧ i.kind = Kind.crop ∧ affords s i q = true then
            some (((payInputs s i q).add id (q * SCALE)) |>.withDay (s.day + q * i.days)
              |>.withCash (s.cash + q * i.revenue))
          else none

/-- Run a script of moves; the first refusal stops it. -/
def run (w : World) (s : St) : List Act → Option St
  | [] => some s
  | a :: as => match step w s a with
      | some t => run w t as
      | none => none

/-! ## Invariants -/

/-- A world in which nothing has a negative price, salvage, labour or yield. -/
def Priced (w : World) : Bool :=
  w.all (fun i => decide (0 ≤ i.price) && decide (0 ≤ i.salvage) && decide (0 ≤ i.days) &&
    decide (0 ≤ i.revenue))

/-- Every quantity on the shelf is non-negative. -/
def StockOk (s : St) : Prop := ∀ id, 0 ≤ s.qty id

theorem priced_of_find {w : World} {id : String} {i : Item} (h : Priced w = true)
    (hf : findItem w id = some i) :
    0 ≤ i.price ∧ 0 ≤ i.salvage ∧ 0 ≤ i.days ∧ 0 ≤ i.revenue := by
  have hmem : i ∈ w := List.mem_of_find?_eq_some hf
  have := (List.all_eq_true.mp h) i hmem
  simp only [Bool.and_eq_true, decide_eq_true_eq] at this
  exact ⟨this.1.1.1, this.1.1.2, this.1.2, this.2⟩

theorem need_nonneg {i : Item} {n : Int} (hn : 0 ≤ n) (id : String) : 0 ≤ need i n id := by
  unfold need
  have key : ∀ (l : List (String × Int)) (a : Int), 0 ≤ a →
      (∀ p ∈ l, 0 < p.2) → 0 ≤ l.foldl (fun a p => a + n * p.2) a := by
    intro l
    induction l with
    | nil => intro a ha _; exact ha
    | cons x t ih =>
        intro a ha hpos
        refine ih _ ?_ (fun p hp => hpos p (by simp [hp]))
        have hx : 0 < x.2 := hpos x (by simp)
        have hnx : 0 ≤ n * x.2 := mul_nonneg hn hx.le
        show 0 ≤ a + n * x.2
        omega
  refine key _ 0 le_rfl ?_
  intro p hp
  have := (List.mem_filter.mp hp).2
  simp only [Bool.and_eq_true, decide_eq_true_eq] at this
  exact this.2

theorem need_eq_zero {i : Item} {n : Int} {id : String}
    (h : ∀ p ∈ i.inputs, ¬(p.1 = id ∧ 0 < p.2)) : need i n id = 0 := by
  have : i.inputs.filter (fun p => p.1 == id && decide (0 < p.2)) = [] := by
    rw [List.filter_eq_nil_iff]
    intro p hp
    simp only [Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq, not_and]
    intro h1 h2
    exact h p hp ⟨h1, h2⟩
  simp [need, this]

/-- A shelf that affords a move has enough of every key the move consumes. -/
theorem affords_need {s : St} {i : Item} {n : Int} (hs : StockOk s)
    (ha : affords s i n = true) (id : String) : need i n id ≤ s.qty id := by
  by_cases hex : ∃ p ∈ i.inputs, p.1 = id ∧ 0 < p.2
  · obtain ⟨p, hp, hp1, hp2⟩ := hex
    have hall := (List.all_eq_true.mp ha) p hp
    rw [if_pos hp2] at hall
    simp only [decide_eq_true_eq] at hall
    rw [← hp1]
    exact hall
  · push_neg at hex
    rw [need_eq_zero (fun p hp hc => absurd hc.2 (by simpa [hc.1] using hex p hp))]
    exact hs id

/-- Rewriting the shelf by a function that keeps the keys keeps the lookup. -/
theorem find?_map_key (f : String × Int → String × Int) (hf : ∀ p, (f p).1 = p.1)
    (id : String) : ∀ (l : List (String × Int)),
      (l.map f).find? (fun p => p.1 == id) = (l.find? (fun p => p.1 == id)).map f
  | [] => rfl
  | a :: t => by
      by_cases ha : a.1 = id
      · rw [List.map_cons, List.find?_cons_of_pos (by simp [hf a, ha]),
          List.find?_cons_of_pos (by simp [ha])]
        simp
      · rw [List.map_cons, List.find?_cons_of_neg (by simp [hf a, ha]),
          List.find?_cons_of_neg (by simp [ha]), find?_map_key f hf id t]

theorem qty_payInputs (s : St) (i : Item) (n : Int) (id : String) :
    (payInputs s i n).qty id = s.qty id - need i n id ∨ (payInputs s i n).qty id = 0 := by
  simp only [payInputs, St.qty]
  rw [find?_map_key (fun p => (p.1, p.2 - need i n p.1)) (fun _ => rfl) id]
  cases hf : s.stock.find? (fun p => p.1 == id) with
  | none => right; simp
  | some x =>
      left
      have hx : x.1 = id := by simpa using List.find?_some hf
      simp [hx]

/-! ### What the moves preserve -/

theorem scale_pos : (0 : Int) < SCALE := by norm_num [SCALE]

/-- **No move leaves a negative quantity on the shelf.** -/
theorem stock_nonneg {w : World} {s t : St} {a : Act} (hs : StockOk s)
    (h : step w s a = some t) : StockOk t := by
  intro id
  cases a with
  | buy bid q =>
      cases hfind : findItem w bid with
      | none => simp [step, hfind] at h
      | some i =>
          simp only [step, hfind] at h
          split_ifs at h with hcond
          · obtain rfl := (Option.some.inj h).symm
            by_cases hid : id = bid
            · subst hid
              simp only [St.qty_add_self, St.qty_withCash]
              have h1 : (0 : Int) ≤ q * SCALE := le_of_lt (mul_pos hcond.1 scale_pos)
              have := hs id
              omega
            · rw [St.qty_add_other _ hid]
              simpa using hs id
  | sell sid q =>
      cases hfind : findItem w sid with
      | none => simp [step, hfind] at h
      | some i =>
          simp only [step, hfind] at h
          split_ifs at h with hcond
          · obtain rfl := (Option.some.inj h).symm
            by_cases hid : id = sid
            · subst hid
              simp only [St.qty_add_self, St.qty_withCash]
              have := hcond.2
              omega
            · rw [St.qty_add_other _ hid]
              simpa using hs id
  | make mid =>
      cases hfind : findItem w mid with
      | none => simp [step, hfind] at h
      | some i =>
          simp only [step, hfind] at h
          split_ifs at h with hcond
          · obtain rfl := (Option.some.inj h).symm
            have hneed := affords_need hs hcond.2 id
            by_cases hid : id = mid
            · subst hid
              simp only [St.qty_withCash, St.qty_withDay, St.qty_add_self]
              rcases qty_payInputs s i 1 id with hq | hq <;> rw [hq]
              · have := scale_pos
                omega
              · exact le_of_lt scale_pos
            · simp only [St.qty_withCash, St.qty_withDay]
              rw [St.qty_add_other _ hid]
              rcases qty_payInputs s i 1 id with hq | hq <;> rw [hq]
              · omega
  | work wid q =>
      cases hfind : findItem w wid with
      | none => simp [step, hfind] at h
      | some i =>
          simp only [step, hfind] at h
          split_ifs at h with hcond
          · obtain rfl := (Option.some.inj h).symm
            have hneed := affords_need hs hcond.2.2 id
            have hq0 : (0 : Int) ≤ q * SCALE := le_of_lt (mul_pos hcond.1 scale_pos)
            by_cases hid : id = wid
            · subst hid
              simp only [St.qty_withCash, St.qty_withDay, St.qty_add_self]
              rcases qty_payInputs s i q id with hq | hq <;> rw [hq] <;> omega
            · simp only [St.qty_withCash, St.qty_withDay]
              rw [St.qty_add_other _ hid]
              rcases qty_payInputs s i q id with hq | hq <;> rw [hq]
              · omega

/-- **In a priced world no move puts a player into debt.** -/
theorem cash_nonneg {w : World} {s t : St} {a : Act} (hw : Priced w = true)
    (hs : 0 ≤ s.cash) (h : step w s a = some t) : 0 ≤ t.cash := by
  cases a with
  | buy bid q =>
      cases hfind : findItem w bid with
      | none => simp [step, hfind] at h
      | some i =>
          simp only [step, hfind] at h
          split_ifs at h with hcond
          · obtain rfl := (Option.some.inj h).symm
            have := hcond.2.2
            simpa using by omega
  | sell sid q =>
      cases hfind : findItem w sid with
      | none => simp [step, hfind] at h
      | some i =>
          simp only [step, hfind] at h
          split_ifs at h with hcond
          · obtain rfl := (Option.some.inj h).symm
            have hp := (priced_of_find hw hfind).2.1
            have : 0 ≤ q * i.salvage := mul_nonneg hcond.1.le hp
            simpa using by omega
  | make mid =>
      cases hfind : findItem w mid with
      | none => simp [step, hfind] at h
      | some i =>
          simp only [step, hfind] at h
          split_ifs at h with hcond
          · obtain rfl := (Option.some.inj h).symm
            have hp := (priced_of_find hw hfind).2.2.2
            simpa using by omega
  | work wid q =>
      cases hfind : findItem w wid with
      | none => simp [step, hfind] at h
      | some i =>
          simp only [step, hfind] at h
          split_ifs at h with hcond
          · obtain rfl := (Option.some.inj h).symm
            have hp := (priced_of_find hw hfind).2.2.2
            have : 0 ≤ q * i.revenue := mul_nonneg hcond.1.le hp
            simpa using by omega

/-- **The clock never runs backwards.** -/
theorem day_le {w : World} {s t : St} {a : Act} (hw : Priced w = true)
    (h : step w s a = some t) : s.day ≤ t.day := by
  cases a with
  | buy bid q =>
      cases hfind : findItem w bid with
      | none => simp [step, hfind] at h
      | some i =>
          simp only [step, hfind] at h
          split_ifs at h with hcond
          · obtain rfl := (Option.some.inj h).symm
            simp
  | sell sid q =>
      cases hfind : findItem w sid with
      | none => simp [step, hfind] at h
      | some i =>
          simp only [step, hfind] at h
          split_ifs at h with hcond
          · obtain rfl := (Option.some.inj h).symm
            simp
  | make mid =>
      cases hfind : findItem w mid with
      | none => simp [step, hfind] at h
      | some i =>
          simp only [step, hfind] at h
          split_ifs at h with hcond
          · obtain rfl := (Option.some.inj h).symm
            have hd := (priced_of_find hw hfind).2.2.1
            simpa using by omega
  | work wid q =>
      cases hfind : findItem w wid with
      | none => simp [step, hfind] at h
      | some i =>
          simp only [step, hfind] at h
          split_ifs at h with hcond
          · obtain rfl := (Option.some.inj h).symm
            have hd := (priced_of_find hw hfind).2.2.1
            have : 0 ≤ q * i.days := mul_nonneg hcond.1.le hd
            simpa using by omega

/-! ## Scores and goals -/

/-- The value of a position, in micro-money times a million: cash plus the
dealer's price of everything on the shelf.  (The extra factor of a million is
what keeps the arithmetic exact.) -/
def netWorth (w : World) (s : St) : Int :=
  s.cash * SCALE + w.foldl (fun a i => a + s.qty i.id * i.price) 0

/-- The pack's goal is met: the machine is in the yard and the money is in
hand. -/
def won (p : Pack) (s : St) : Bool :=
  decide (SCALE ≤ s.qty p.goalItem) && decide (p.goalCash ≤ s.cash)

end Modular
end LifeTrac
