import RequestProject.Nix.NixWars.Shards

/-!
# The market of prices: goods, ports and the circuit of production

The old shard market quoted one price, off a three-beat clock: `47, 59, 71,
47, …`.  A player complained, rightly, that the price was always the same.
This file replaces that clock with a *market*.

* There are five goods (`numGoods`), each with its own base value.
* A price is never posted, it is *read off a warehouse*: the price of good `g`
  where `q` of it is in stock is `price g q = baseValue g * 2 * stockRef /
  (q + stockRef)` — dear where the good is scarce, cheap where it is piled up
  (`price_antitone`), never more than twice base (`price_le`) and never zero
  at any stock a port can hold (`price_pos`).
* There are eight ports (`ports`), each with its own warehouse, so the same
  good has a different price at every one of them (`prices_differ`) and the
  same load of goods is worth different money depending on where you open the
  hold (`cargo_value_differs`).
* Each port runs a *recipe*: it eats one or two goods and makes a third.
  Together the recipes are a circuit — every good is made somewhere and eaten
  somewhere (`every_good_produced`, `every_good_consumed`) and the production
  graph is strongly connected (`circuit_strongly_connected`), so no good is a
  dead end.
* A production round (`tick`) fires every port that can pay for its inputs
  (`portTickStock_needs_inputs`, `portTickStock_fires`), which moves the
  warehouses, and therefore the prices, all by itself (`tick_moves_prices`).
* Trading moves prices too, in the direction it should: buying a unit empties
  the shelf and pushes the price up (`buy_raises_price`), selling pushes it
  down (`sell_lowers_price`).

The warehouses live in the `Economy`, not in the port, so that the whole state
of the market is a list of numbers that can be saved, replayed and sent to
another player; the ports themselves are the fixed geography of the run.
-/

namespace NixWars
namespace Trade

/-! ## Goods -/

/-- How many goods the market trades. -/
def numGoods : Nat := 5

/-- Their names, in index order. -/
def goodNames : List String := ["ORE", "FUEL", "PARTS", "CHIPS", "RELICS"]

/-- The good that is burnt as fuel. -/
def fuelGood : Nat := 1

/-- The base value of each good: the price it fetches when the warehouse holds
exactly `stockRef` of it. -/
def baseValues : List Nat := [13, 19, 29, 47, 71]

/-- The base value of good `g`. -/
def baseValue (g : Nat) : Nat := baseValues.getD g 13

/-- The reference stock: the shelf level at which a good sells for its base
value. -/
def stockRef : Nat := 4

/-- **The price of a good is read off the shelf.**  With `q` units in stock the
price is `baseValue g * 2 * stockRef / (q + stockRef)`: twice base on an empty
shelf, base at `stockRef`, and falling from there. -/
def price (g q : Nat) : Nat := baseValue g * (2 * stockRef) / (q + stockRef)

/-- Base values are between 13 and 71. -/
theorem baseValue_bounds (g : Nat) : 13 ≤ baseValue g ∧ baseValue g ≤ 71 := by
  unfold baseValue baseValues
  match g with
  | 0 => exact ⟨by decide, by decide⟩
  | 1 => exact ⟨by decide, by decide⟩
  | 2 => exact ⟨by decide, by decide⟩
  | 3 => exact ⟨by decide, by decide⟩
  | 4 => exact ⟨by decide, by decide⟩
  | (n + 5) => simp [List.getD]

theorem baseValue_pos (g : Nat) : 0 < baseValue g := by
  have := (baseValue_bounds g).1; omega

/-- **A fuller shelf is a cheaper price.** -/
theorem price_antitone {g q q' : Nat} (h : q ≤ q') : price g q' ≤ price g q := by
  unfold price stockRef
  exact Nat.div_le_div_left (by omega) (by omega)

/-- The price never exceeds twice the base value: the empty-shelf quote. -/
theorem price_le (g q : Nat) : price g q ≤ 2 * baseValue g := by
  have h : price g q ≤ price g 0 := price_antitone (Nat.zero_le q)
  have h0 : price g 0 = 2 * baseValue g := by
    unfold price stockRef
    omega
  omega

/-- The dearest quote on the board. -/
theorem price_le_max (g q : Nat) : price g q ≤ 142 := by
  have h := price_le g q
  have := (baseValue_bounds g).2
  omega

/-- Nothing is ever free: at any stock a port can hold, the price is positive. -/
theorem price_pos {g q : Nat} (h : q ≤ 99) : 0 < price g q := by
  unfold price stockRef
  have hb : 13 ≤ baseValue g := (baseValue_bounds g).1
  have : q + 4 ≤ baseValue g * (2 * 4) := by omega
  exact Nat.div_pos this (by omega)

/-! ## Warehouses -/

/-- The stock of good `g` in a warehouse. -/
def stockOf (st : List Nat) (g : Nat) : Nat := st.getD g 0

/-- Put `n` units of good `g` on the shelf. -/
def addStock (st : List Nat) (g n : Nat) : List Nat := st.set g (stockOf st g + n)

/-- Take `n` units of good `g` off the shelf (never below zero). -/
def subStock (st : List Nat) (g n : Nat) : List Nat := st.set g (stockOf st g - n)

theorem stockOf_add_self {st : List Nat} {g : Nat} (h : g < st.length) (n : Nat) :
    stockOf (addStock st g n) g = stockOf st g + n := by
  simp [stockOf, addStock, List.getD_eq_getElem?_getD, h]

theorem stockOf_sub_self {st : List Nat} {g : Nat} (h : g < st.length) (n : Nat) :
    stockOf (subStock st g n) g = stockOf st g - n := by
  simp [stockOf, subStock, List.getD_eq_getElem?_getD, h]

theorem stockOf_add_other {st : List Nat} {g g' n : Nat} (h : g ≠ g') :
    stockOf (addStock st g n) g' = stockOf st g' := by
  simp [stockOf, addStock, List.getD_eq_getElem?_getD, h]

theorem stockOf_sub_other {st : List Nat} {g g' n : Nat} (h : g ≠ g') :
    stockOf (subStock st g n) g' = stockOf st g' := by
  simp [stockOf, subStock, List.getD_eq_getElem?_getD, h]

theorem addStock_length (st : List Nat) (g n : Nat) : (addStock st g n).length = st.length := by
  simp [addStock]

theorem subStock_length (st : List Nat) (g n : Nat) : (subStock st g n).length = st.length := by
  simp [subStock]

/-- Anything on a shelf after a `set` was either put there or was there
before. -/
theorem mem_of_mem_set {α : Type} : ∀ (l : List α) (i : Nat) (a x : α),
    x ∈ l.set i a → x = a ∨ x ∈ l := by
  intro l
  induction l with
  | nil => intro i a x hx; simp at hx
  | cons b t ih =>
      intro i a x hx
      cases i with
      | zero =>
          simp only [List.set_cons_zero, List.mem_cons] at hx
          rcases hx with h | h
          · exact Or.inl h
          · exact Or.inr (List.mem_cons_of_mem _ h)
      | succ n =>
          simp only [List.set_cons_succ, List.mem_cons] at hx
          rcases hx with h | h
          · exact Or.inr (by simp [h])
          · rcases ih n a x h with h' | h'
            · exact Or.inl h'
            · exact Or.inr (List.mem_cons_of_mem _ h')

/-- Putting one unit on a shelf adds one to the warehouse total. -/
theorem sum_addStock : ∀ (st : List Nat) (g : Nat), g < st.length →
    (addStock st g 1).sum = st.sum + 1 := by
  intro st
  induction st with
  | nil => intro g h; simp at h
  | cons a t ih =>
      intro g h
      cases g with
      | zero => simp [addStock, stockOf, List.getD]; omega
      | succ n =>
          have hn : n < t.length := by simpa using h
          have := ih n hn
          simp only [addStock, stockOf, List.getD_cons_succ, List.set_cons_succ, List.sum_cons]
          simp only [addStock, stockOf] at this
          omega

/-- Taking one unit off a shelf takes one off the warehouse total. -/
theorem sum_subStock : ∀ (st : List Nat) (g : Nat), g < st.length → 1 ≤ stockOf st g →
    (subStock st g 1).sum + 1 = st.sum := by
  intro st
  induction st with
  | nil => intro g h _; simp at h
  | cons a t ih =>
      intro g h h1
      cases g with
      | zero =>
          simp only [subStock, stockOf, List.getD_cons_zero, List.set_cons_zero,
            List.sum_cons] at *
          omega
      | succ n =>
          have hn : n < t.length := by simpa using h
          have h1' : 1 ≤ stockOf t n := by simpa [stockOf] using h1
          have := ih n hn h1'
          simp only [subStock, stockOf, List.getD_cons_succ, List.set_cons_succ, List.sum_cons]
          simp only [subStock, stockOf] at this
          omega

/-! ## Ports -/

/-- A port: a name, the voxel corner it stands on, the warehouse it opens with,
and its recipe — the goods it eats and the good it makes.  A port is fixed
geography; what changes in play is the `Economy` below. -/
structure Port where
  /-- The port's name on the chart. -/
  name : String
  /-- Its corner along the 71-axis, 0 or 1. -/
  cx : Nat
  /-- Its corner along the 59-axis, 0 or 1. -/
  cy : Nat
  /-- Its corner along the 47-axis, 0 or 1. -/
  cz : Nat
  /-- The warehouse it opens with, one shelf per good. -/
  start : List Nat
  /-- The goods the recipe eats. -/
  inputs : List Nat
  /-- The good the recipe makes. -/
  output : Nat
  deriving DecidableEq, Repr, Inhabited

/-- How many units of each input a round eats, and of the output it makes. -/
def rate : Nat := 3

/-- **The eight ports of the run.**  They stand on the eight corners of the
`71 × 59 × 47` box — which are exactly the eight voxels the Monster's character
table occupies at that resolution — and no two of them open the same
warehouse. -/
def ports : List Port :=
  [⟨"MINEHEAD",  0, 0, 0, [30,  6,  2,  1,  0], [1],    0⟩,
   ⟨"REFINERY",  1, 0, 0, [12, 24,  4,  2,  1], [0],    1⟩,
   ⟨"FOUNDRY",   0, 1, 0, [ 8,  9, 21,  3,  0], [0, 1], 2⟩,
   ⟨"FABRICANT", 1, 1, 0, [ 2,  7, 11, 18,  1], [2, 1], 3⟩,
   ⟨"DIGSITE",   0, 0, 1, [ 1,  5,  9,  2, 16], [2],    4⟩,
   ⟨"ASSEMBLY",  1, 0, 1, [14,  4,  6, 10,  3], [3, 2], 0⟩,
   ⟨"EXCHANGE",  0, 1, 1, [ 3, 11,  5, 20,  7], [4],    3⟩,
   ⟨"CROWN",     1, 1, 1, [ 5,  2,  1,  9, 12], [3, 4], 1⟩]

/-- How many ports there are. -/
def numPorts : Nat := 8

/-- The port with index `i`. -/
def portAt (i : Nat) : Port := ports.getD i default

theorem ports_length : ports.length = numPorts := by decide

/-- Every port keeps one shelf per good. -/
theorem ports_stock_length : ∀ p ∈ ports, p.start.length = numGoods := by decide

/-- The eight ports stand on the eight corners of the box. -/
theorem ports_corners : ∀ p ∈ ports, p.cx ≤ 1 ∧ p.cy ≤ 1 ∧ p.cz ≤ 1 := by decide

/-- No two ports stand on the same corner. -/
theorem ports_cells_nodup :
    (ports.map (fun p => (p.cx, p.cy, p.cz))).Nodup := by decide

/-- No two ports carry the same name. -/
theorem ports_names_nodup : (ports.map Port.name).Nodup := by decide

/-- Every recipe eats and makes goods that exist. -/
theorem ports_recipe_range :
    ∀ p ∈ ports, p.output < numGoods ∧ ∀ g ∈ p.inputs, g < numGoods := by decide

/-- No port eats what it makes: every recipe is a genuine conversion. -/
theorem ports_no_self_loop : ∀ p ∈ ports, p.output ∉ p.inputs := by decide

/-! ## The economy -/

/-- The market in play: one warehouse per port, and the number of production
rounds run so far. -/
structure Economy where
  /-- One warehouse per port, in port order. -/
  stocks : List (List Nat)
  /-- How many production rounds have been run. -/
  round : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The economy as it opens: every port's own warehouse, nothing produced
yet. -/
def initialEconomy : Economy := { stocks := ports.map Port.start, round := 0 }

/-- The warehouse of port `i`. -/
def warehouse (e : Economy) (i : Nat) : List Nat := e.stocks.getD i []

/-- The stock of good `g` at port `i`. -/
def stockAt (e : Economy) (i g : Nat) : Nat := stockOf (warehouse e i) g

/-- **The price of good `g` at port `i`**: read off that port's shelf. -/
def priceAt (e : Economy) (i g : Nat) : Nat := price g (stockAt e i g)

/-- The whole price board. -/
def priceBoard (e : Economy) : List (List Nat) :=
  (List.range numPorts).map (fun i => (List.range numGoods).map (priceAt e i))

/-- A well-formed economy: one warehouse per port, one shelf per good. -/
def EconomyOk (e : Economy) : Prop :=
  e.stocks.length = numPorts ∧ ∀ st ∈ e.stocks, st.length = numGoods

instance : DecidablePred EconomyOk := fun e => by unfold EconomyOk; infer_instance

theorem initialEconomy_ok : EconomyOk initialEconomy := by decide

/-- **The price is not always the same.**  Read off the eight opening
warehouses, ORE alone is quoted at eight different prices, and no two ports
post the same board. -/
theorem prices_differ :
    ((List.range numPorts).map (fun i => priceAt initialEconomy i 0)).dedup.length = 8 ∧
      (priceBoard initialEconomy).Nodup := by decide

/-! ## A load of goods is worth different money in different holds -/

/-- What a load is worth at port `i`, valued shelf by shelf. -/
def cargoValue (e : Economy) (i : Nat) (hold : List Nat) : Nat :=
  ((List.range numGoods).map (fun g => stockOf hold g * priceAt e i g)).sum

/-- **Each load of goods has another value.**  One hold of five ORE and two
RELICS is worth a different sum at every one of the eight ports. -/
theorem cargo_value_differs :
    ((List.range numPorts).map
      (fun i => cargoValue initialEconomy i [5, 0, 0, 0, 2])).dedup.length = 8 := by decide

/-! ## Trading at a port -/

/-- Buying one unit of good `g` at port `i`: the shelf loses a unit, so the
next unit costs more. -/
def econBuy (e : Economy) (i g : Nat) : Economy :=
  { e with stocks := e.stocks.set i (subStock (warehouse e i) g 1) }

/-- Selling one unit of good `g` at port `i`: the shelf gains a unit, so the
next one fetches less. -/
def econSell (e : Economy) (i g : Nat) : Economy :=
  { e with stocks := e.stocks.set i (addStock (warehouse e i) g 1) }

theorem warehouse_set {e : Economy} {i : Nat} (h : i < e.stocks.length) (st : List Nat) :
    warehouse { e with stocks := e.stocks.set i st } i = st := by
  simp [warehouse, List.getD_eq_getElem?_getD, h]

theorem warehouse_set_other {e : Economy} {i j : Nat} (h : i ≠ j) (st : List Nat) :
    warehouse { e with stocks := e.stocks.set i st } j = warehouse e j := by
  simp [warehouse, List.getD_eq_getElem?_getD, h]

/-- Replacing one warehouse by another of the right shape keeps the economy
well formed. -/
theorem econ_set_ok {e : Economy} (h : EconomyOk e) (i : Nat) {st : List Nat}
    (hst : st.length = numGoods) : EconomyOk { e with stocks := e.stocks.set i st } := by
  obtain ⟨h8, h5⟩ := h
  refine ⟨by simpa using h8, ?_⟩
  intro w hw
  rcases mem_of_mem_set _ i st w hw with rfl | hw'
  · exact hst
  · exact h5 _ hw'

/-- Every warehouse of a well-formed economy has one shelf per good. -/
theorem warehouse_length {e : Economy} (h : EconomyOk e) {i : Nat} (hi : i < numPorts) :
    (warehouse e i).length = numGoods := by
  obtain ⟨h8, h5⟩ := h
  have hi' : i < e.stocks.length := by omega
  have : warehouse e i = e.stocks[i] := by
    simp [warehouse, List.getD_eq_getElem?_getD, hi']
  rw [this]
  exact h5 _ (List.getElem_mem hi')

/-- Buying keeps the economy well formed. -/
theorem econBuy_ok {e : Economy} (h : EconomyOk e) (i g : Nat) : EconomyOk (econBuy e i g) := by
  by_cases hi : i < numPorts
  · exact econ_set_ok h i (by rw [subStock_length]; exact warehouse_length h hi)
  · have h8 := h.1
    have : e.stocks.set i (subStock (warehouse e i) g 1) = e.stocks :=
      List.set_eq_of_length_le (by omega)
    unfold econBuy
    simpa [this] using h

/-- Selling keeps the economy well formed. -/
theorem econSell_ok {e : Economy} (h : EconomyOk e) (i g : Nat) : EconomyOk (econSell e i g) := by
  by_cases hi : i < numPorts
  · exact econ_set_ok h i (by rw [addStock_length]; exact warehouse_length h hi)
  · have h8 := h.1
    have : e.stocks.set i (addStock (warehouse e i) g 1) = e.stocks :=
      List.set_eq_of_length_le (by omega)
    unfold econSell
    simpa [this] using h

/-- **Buying pushes the price up.** -/
theorem buy_raises_price (e : Economy) (i g : Nat) (hi : i < e.stocks.length)
    (hg : g < (warehouse e i).length) :
    priceAt e i g ≤ priceAt (econBuy e i g) i g := by
  unfold priceAt stockAt econBuy
  rw [warehouse_set hi, stockOf_sub_self hg]
  exact price_antitone (Nat.sub_le _ _)

/-- **Selling pushes the price down.** -/
theorem sell_lowers_price (e : Economy) (i g : Nat) (hi : i < e.stocks.length)
    (hg : g < (warehouse e i).length) :
    priceAt (econSell e i g) i g ≤ priceAt e i g := by
  unfold priceAt stockAt econSell
  rw [warehouse_set hi, stockOf_add_self hg]
  exact price_antitone (Nat.le_add_right _ _)

/-- Trading at one port does not move another port's prices. -/
theorem buy_other_port (e : Economy) {i j : Nat} (h : i ≠ j) (g g' : Nat) :
    priceAt (econBuy e i g) j g' = priceAt e j g' := by
  unfold priceAt stockAt econBuy
  rw [warehouse_set_other h]

/-- Buying does not touch any other shelf at the same port. -/
theorem buy_other_good (e : Economy) (i : Nat) {g g' : Nat} (h : g ≠ g')
    (hi : i < e.stocks.length) :
    priceAt (econBuy e i g) i g' = priceAt e i g' := by
  unfold priceAt stockAt econBuy
  rw [warehouse_set hi, stockOf_sub_other h]

/-- **Buying strictly moves the price where the shelf is thin**: one CHIP off
MINEHEAD's single-crate shelf takes the quote from 75 to 94. -/
theorem buy_strictly_raises_price :
    priceAt initialEconomy 0 3 < priceAt (econBuy initialEconomy 0 3) 0 3 := by decide

/-! ## The circuit of production and consumption -/

/-- Run one production round at a port: if every input shelf can pay the rate,
the inputs are eaten and the output is made. -/
def portTickStock (p : Port) (st : List Nat) : List Nat :=
  if p.inputs.all (fun g => rate ≤ stockOf st g) then
    addStock (p.inputs.foldl (fun st g => subStock st g rate) st) p.output rate
  else st

/-- **A port that cannot pay for its inputs makes nothing.** -/
theorem portTickStock_needs_inputs (p : Port) (st : List Nat)
    (h : ¬ (p.inputs.all (fun g => rate ≤ stockOf st g)) = true) :
    portTickStock p st = st := by
  simp [portTickStock, h]

/-- **A port that can pay does.** -/
theorem portTickStock_fires (p : Port) (st : List Nat)
    (h : (p.inputs.all (fun g => rate ≤ stockOf st g)) = true) :
    portTickStock p st =
      addStock (p.inputs.foldl (fun st g => subStock st g rate) st) p.output rate := by
  simp [portTickStock, h]

theorem foldl_subStock_length (l : List Nat) (st : List Nat) :
    (l.foldl (fun st g => subStock st g rate) st).length = st.length := by
  induction l generalizing st with
  | nil => rfl
  | cons g gs ih => simp [ih, subStock_length]

/-- A production round never changes the shape of a warehouse. -/
theorem portTickStock_length (p : Port) (st : List Nat) :
    (portTickStock p st).length = st.length := by
  unfold portTickStock
  split
  · rw [addStock_length, foldl_subStock_length]
  · rfl

/-- One production round over the whole map. -/
def tick (e : Economy) : Economy :=
  { stocks := (List.range numPorts).map (fun i => portTickStock (portAt i) (warehouse e i)),
    round := e.round + 1 }

/-- **The market moves on its own.**  Nobody trades; the eight ports simply run
their recipes, and the price board is different on each of the first four
rounds. -/
theorem tick_moves_prices :
    ([priceBoard initialEconomy,
      priceBoard (tick initialEconomy),
      priceBoard (tick (tick initialEconomy)),
      priceBoard (tick (tick (tick initialEconomy)))]).Nodup := by decide

/-- The round counter counts rounds. -/
theorem tick_round (e : Economy) : (tick e).round = e.round + 1 := rfl

/-- A production round keeps the economy well formed. -/
theorem tick_ok {e : Economy} (h : EconomyOk e) : EconomyOk (tick e) := by
  obtain ⟨hlen, hst⟩ := h
  constructor
  · simp [tick]
  · intro st hs
    simp only [tick, List.mem_map, List.mem_range] at hs
    obtain ⟨i, hi, rfl⟩ := hs
    rw [portTickStock_length]
    refine hst _ ?_
    have hi' : i < e.stocks.length := by omega
    have : warehouse e i = e.stocks[i] := by
      simp [warehouse, List.getD_eq_getElem?_getD, hi']
    rw [this]
    exact List.getElem_mem hi'

/-! ### The recipes form a circuit -/

/-- The goods made on the map. -/
def producedGoods : List Nat := (ports.map Port.output).dedup

/-- The goods eaten on the map. -/
def consumedGoods : List Nat := (ports.flatMap Port.inputs).dedup

/-- **Every good is made somewhere.** -/
theorem every_good_produced : ∀ g < numGoods, g ∈ producedGoods := by decide

/-- **Every good is eaten somewhere.** -/
theorem every_good_consumed : ∀ g < numGoods, g ∈ consumedGoods := by decide

/-- One step of the production graph: from the goods in `S`, the goods some
port can make out of them. -/
def flowStep (S : List Nat) : List Nat :=
  (S ++ (ports.filter (fun p => p.inputs.any (fun g => g ∈ S))).map Port.output).dedup

/-- What a good can turn into, in at most `n` conversions. -/
def flowFrom (g : Nat) : Nat → List Nat
  | 0 => [g]
  | n + 1 => flowStep (flowFrom g n)

/-- **The circuit is a circuit.**  Starting from any single good, five
conversions reach every good on the map: nothing is a dead end. -/
theorem circuit_strongly_connected :
    ∀ g < numGoods, ∀ h < numGoods, h ∈ flowFrom g 5 := by decide

/-- The production graph as an edge list, for the page to draw. -/
def circuitEdges : List (Nat × Nat) :=
  ports.flatMap (fun p => p.inputs.map (fun g => (g, p.output)))

/-- Twelve conversions run on the map. -/
theorem circuitEdges_length : circuitEdges.length = 12 := by decide

end Trade
end NixWars
