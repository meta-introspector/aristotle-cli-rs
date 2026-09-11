import RequestProject.Gvcs.Farm

/-!
# The game: a deterministic build-and-farm simulator

This file turns the bill of materials of `Materials.lean` and the agronomy of
`Farm.lean` into a small, completely deterministic game.

A `GameState` is what the player owns: cash, a store of material, the machines
already fabricated, fuel in the tank, and the calendar.  An `Action` is a legal
move: buy stock, sell surplus stock back at a salvage price, fabricate a
subassembly or a whole machine from the material on the shelf, refuel, or spend
the season farming.  `step` is the rule book — it returns `none` exactly when
the move is not allowed (you cannot buy what you cannot pay for, fabricate what
you have no material for, or farm without a machine), so illegal play is
impossible rather than merely discouraged.

The theorems below are the invariants of the game — cash and stores never go
negative — and its bookkeeping: buying and refuelling are net-worth neutral,
selling loses the dealer's margin, self-fabrication turns material into a
machine of exactly the same value, and a season of farming adds precisely the
crop's gross margin.
-/

namespace LifeTrac
namespace Build

open Material Assembly

/-! ## Market and state -/

/-- The prices the player faces: fuel, the shop rate for hired labour, and the
fraction of the purchase price recovered when selling stock back. -/
structure Market where
  /-- Price of one litre of fuel. -/
  fuelPrice : ℚ
  /-- Hourly rate for fabrication labour (`0` if the player does it himself). -/
  laborRate : ℚ
  /-- Fraction of the purchase price recovered when selling material back. -/
  salvage : ℚ
  fuelPrice_nonneg : 0 ≤ fuelPrice
  laborRate_nonneg : 0 ≤ laborRate
  salvage_nonneg : 0 ≤ salvage
  salvage_le_one : salvage ≤ 1

/-- Everything the player owns. -/
structure GameState where
  /-- Cash in hand. -/
  cash : ℚ
  /-- Material on the shelf. -/
  stock : Inventory
  /-- The machines and subassemblies already fabricated. -/
  built : List Assembly
  /-- Fuel in the tank, in litres. -/
  fuel : ℚ
  /-- Days elapsed. -/
  day : ℚ
  /-- Hectares farmed so far. -/
  hectares : ℚ

namespace GameState

/-- Does the player own a machine of the given name? -/
def hasMachine (s : GameState) (nm : String) : Bool :=
  s.built.any (fun a => a.name == nm)

/-- The value of the machines the player has built, at material cost. -/
def machineValue (s : GameState) : ℚ := (s.built.map Assembly.materialCost).sum

/-- Total net worth: cash, plus the material on the shelf, plus the fuel in the
tank, plus the machines already built. -/
def netWorth (mk : Market) (s : GameState) : ℚ :=
  s.cash + s.stock.value + mk.fuelPrice * s.fuel + s.machineValue

/-- A state is legal when nothing is negative. -/
def Legal (s : GameState) : Prop :=
  0 ≤ s.cash ∧ Inventory.Sound s.stock ∧ 0 ≤ s.fuel

end GameState

/-! ## Moves -/

/-- A legal move of the game. -/
inductive Action where
  /-- Buy `q` units of material `m` at the catalogue price. -/
  | buy (m : Material) (q : ℚ) : Action
  /-- Order in one go every material the bill of materials `a` calls for. -/
  | order (a : Assembly) : Action
  /-- Sell `q` units of material `m` back at the salvage price. -/
  | sell (m : Material) (q : ℚ) : Action
  /-- Fabricate the bill of materials `a` out of the stock on the shelf. -/
  | fabricate (a : Assembly) : Action
  /-- Buy `litres` of fuel. -/
  | refuel (litres : ℚ) : Action
  /-- Farm `area` hectares of `c` with the machine called `machine`. -/
  | farm (machine : String) (c : Crop) (area : ℚ) : Action

open GameState

/-- The rule book.  `step mk s a` is the state after playing `a`, or `none` if
the move is illegal in `s`. -/
def step (mk : Market) (s : GameState) : Action → Option GameState
  | .buy m q =>
      if 0 ≤ q ∧ q * unitCost m ≤ s.cash then
        some { s with cash := s.cash - q * unitCost m,
                      stock := s.stock.add (Inventory.single m q) }
      else none
  | .order a =>
      if a.WellFormed = true ∧ a.materialCost ≤ s.cash then
        some { s with cash := s.cash - a.materialCost,
                      stock := s.stock.add a.requirements }
      else none
  | .sell m q =>
      if 0 ≤ q ∧ q ≤ s.stock m then
        some { s with cash := s.cash + mk.salvage * (q * unitCost m),
                      stock := s.stock.sub (Inventory.single m q) }
      else none
  | .fabricate a =>
      if a.WellFormed = true ∧ Inventory.Covers s.stock a.requirements ∧
          mk.laborRate * a.laborHours ≤ s.cash then
        some { s with cash := s.cash - mk.laborRate * a.laborHours,
                      stock := s.stock.sub a.requirements,
                      built := a :: s.built,
                      day := s.day + a.laborHours / 8 }
      else none
  | .refuel litres =>
      if 0 ≤ litres ∧ mk.fuelPrice * litres ≤ s.cash then
        some { s with cash := s.cash - mk.fuelPrice * litres,
                      fuel := s.fuel + litres }
      else none
  | .farm machine c area =>
      if s.hasMachine machine = true ∧ 0 ≤ area ∧ seasonFuel c area ≤ s.fuel ∧
          area * c.seedCostPerHa ≤ s.cash then
        some { s with cash := s.cash + area * c.revenuePerHa - area * c.seedCostPerHa,
                      fuel := s.fuel - seasonFuel c area,
                      day := s.day + seasonHours c area / 8,
                      hectares := s.hectares + area }
      else none

/-- Playing a whole script of moves. -/
def run (mk : Market) (s : GameState) : List Action → Option GameState
  | [] => some s
  | a :: as => (step mk s a).bind (fun t => run mk t as)

@[simp] theorem run_nil (mk : Market) (s : GameState) : run mk s [] = some s := rfl

@[simp] theorem run_cons (mk : Market) (s : GameState) (a : Action) (as : List Action) :
    run mk s (a :: as) = (step mk s a).bind (fun t => run mk t as) := rfl

/-- Scripts compose. -/
theorem run_append (mk : Market) (s : GameState) (l₁ l₂ : List Action) :
    run mk s (l₁ ++ l₂) = (run mk s l₁).bind (fun t => run mk t l₂) := by
  induction l₁ generalizing s with
  | nil => simp
  | cons a as ih => cases h : step mk s a <;> simp [h, ih]

/-! ## What each move does -/

theorem step_buy {mk : Market} {s : GameState} {m : Material} {q : ℚ}
    (hq : 0 ≤ q) (hc : q * unitCost m ≤ s.cash) :
    step mk s (.buy m q) =
      some { s with cash := s.cash - q * unitCost m,
                    stock := s.stock.add (Inventory.single m q) } := by
  simp [step, hq, hc]

theorem step_buy_none {mk : Market} {s : GameState} {m : Material} {q : ℚ}
    (h : s.cash < q * unitCost m) : step mk s (.buy m q) = none := by
  simp only [step, ite_eq_right_iff]
  intro hh
  exact absurd hh.2 (not_le.2 h)

theorem step_order {mk : Market} {s : GameState} {a : Assembly}
    (hw : a.WellFormed = true) (hc : a.materialCost ≤ s.cash) :
    step mk s (.order a) =
      some { s with cash := s.cash - a.materialCost,
                    stock := s.stock.add a.requirements } := by
  simp [step, hw, hc]

/-- You cannot order a bill of materials you cannot pay for. -/
theorem step_order_none {mk : Market} {s : GameState} {a : Assembly}
    (h : s.cash < a.materialCost) : step mk s (.order a) = none := by
  simp only [step, ite_eq_right_iff]
  intro hh
  exact absurd hh.2 (not_le.2 h)

theorem step_fabricate {mk : Market} {s : GameState} {a : Assembly}
    (hw : a.WellFormed = true) (hs : Inventory.Covers s.stock a.requirements)
    (hc : mk.laborRate * a.laborHours ≤ s.cash) :
    step mk s (.fabricate a) =
      some { s with cash := s.cash - mk.laborRate * a.laborHours,
                    stock := s.stock.sub a.requirements,
                    built := a :: s.built,
                    day := s.day + a.laborHours / 8 } := by
  simp [step, hw, hs, hc]

/-- You cannot build what you have no material for. -/
theorem step_fabricate_none {mk : Market} {s : GameState} {a : Assembly}
    (h : ¬ Inventory.Covers s.stock a.requirements) :
    step mk s (.fabricate a) = none := by
  simp only [step, ite_eq_right_iff]
  intro hh
  exact absurd hh.2.1 h

theorem step_refuel {mk : Market} {s : GameState} {l : ℚ} (hl : 0 ≤ l)
    (hc : mk.fuelPrice * l ≤ s.cash) :
    step mk s (.refuel l) =
      some { s with cash := s.cash - mk.fuelPrice * l, fuel := s.fuel + l } := by
  simp [step, hl, hc]

theorem step_sell {mk : Market} {s : GameState} {m : Material} {q : ℚ} (hq : 0 ≤ q)
    (hs : q ≤ s.stock m) :
    step mk s (.sell m q) =
      some { s with cash := s.cash + mk.salvage * (q * unitCost m),
                    stock := s.stock.sub (Inventory.single m q) } := by
  simp [step, hq, hs]

/-- You cannot farm without a machine. -/
theorem step_farm_none {mk : Market} {s : GameState} {nm : String} {c : Crop} {area : ℚ}
    (h : s.hasMachine nm = false) : step mk s (.farm nm c area) = none := by
  simp only [step, ite_eq_right_iff]
  intro hh
  simp [h] at hh

theorem step_farm {mk : Market} {s : GameState} {nm : String} {c : Crop} {area : ℚ}
    (hm : s.hasMachine nm = true) (ha : 0 ≤ area) (hf : seasonFuel c area ≤ s.fuel)
    (hc : area * c.seedCostPerHa ≤ s.cash) :
    step mk s (.farm nm c area) =
      some { s with cash := s.cash + area * c.revenuePerHa - area * c.seedCostPerHa,
                    fuel := s.fuel - seasonFuel c area,
                    day := s.day + seasonHours c area / 8,
                    hectares := s.hectares + area } := by
  simp [step, hm, ha, hf, hc]

/-! ## The invariants of the game -/

/-- No move can leave the player with negative cash, negative stock or negative
fuel. -/
theorem step_legal {mk : Market} {s t : GameState} {a : Action}
    (hs : s.Legal) (h : step mk s a = some t) : t.Legal := by
  obtain ⟨hcash, hstock, hfuel⟩ := hs
  cases a with
  | buy m q =>
      by_cases hg : 0 ≤ q ∧ q * unitCost m ≤ s.cash
      · rw [step_buy hg.1 hg.2] at h
        cases h
        refine ⟨by simpa using sub_nonneg.2 hg.2, ?_, hfuel⟩
        intro x
        have : 0 ≤ Inventory.single m q x := by
          by_cases hx : x = m <;> simp [Inventory.single, hx, hg.1]
        simpa [Inventory.add] using add_nonneg (hstock x) this
      · simp [step, hg] at h
  | order b =>
      by_cases hg : b.WellFormed = true ∧ b.materialCost ≤ s.cash
      · rw [step_order hg.1 hg.2] at h
        cases h
        refine ⟨by simpa using sub_nonneg.2 hg.2, ?_, hfuel⟩
        intro x
        simpa [Inventory.add] using add_nonneg (hstock x) (requirements_sound hg.1 x)
      · simp [step, hg] at h
  | sell m q =>
      by_cases hg : 0 ≤ q ∧ q ≤ s.stock m
      · simp only [step, if_pos hg] at h
        cases h
        refine ⟨?_, ?_, hfuel⟩
        · have : 0 ≤ mk.salvage * (q * unitCost m) :=
            mul_nonneg mk.salvage_nonneg (mul_nonneg hg.1 (unitCost_pos m).le)
          simpa using add_nonneg hcash this
        · intro x
          by_cases hx : x = m
          · subst hx
            simpa [Inventory.sub, Inventory.single] using hg.2
          · simpa [Inventory.sub, Inventory.single, hx] using hstock x
      · simp [step, hg] at h
  | fabricate b =>
      by_cases hg : b.WellFormed = true ∧ Inventory.Covers s.stock b.requirements ∧
          mk.laborRate * b.laborHours ≤ s.cash
      · rw [step_fabricate hg.1 hg.2.1 hg.2.2] at h
        cases h
        refine ⟨by simpa using sub_nonneg.2 hg.2.2, ?_, hfuel⟩
        intro x
        simpa [Inventory.sub] using sub_nonneg.2 (hg.2.1 x)
      · simp [step, hg] at h
  | refuel l =>
      by_cases hg : 0 ≤ l ∧ mk.fuelPrice * l ≤ s.cash
      · simp only [step, if_pos hg] at h
        cases h
        exact ⟨by simpa using sub_nonneg.2 hg.2, hstock, by simpa using add_nonneg hfuel hg.1⟩
      · simp [step, hg] at h
  | farm nm c area =>
      by_cases hg : s.hasMachine nm = true ∧ 0 ≤ area ∧ seasonFuel c area ≤ s.fuel ∧
          area * c.seedCostPerHa ≤ s.cash
      · rw [step_farm hg.1 hg.2.1 hg.2.2.1 hg.2.2.2] at h
        cases h
        refine ⟨?_, hstock, by simpa using sub_nonneg.2 hg.2.2.1⟩
        have hrev : 0 ≤ area * c.revenuePerHa :=
          mul_nonneg hg.2.1 c.revenuePerHa_nonneg
        have := hg.2.2.2
        simp only
        linarith
      · simp [step, hg] at h

/-- Hence no script can: the invariant holds for the whole game. -/
theorem run_legal {mk : Market} {s t : GameState} {l : List Action}
    (hs : s.Legal) (h : run mk s l = some t) : t.Legal := by
  induction l generalizing s with
  | nil => cases h; exact hs
  | cons a as ih =>
      rw [run_cons] at h
      cases hstep : step mk s a with
      | none => rw [hstep] at h; simp at h
      | some u =>
          rw [hstep] at h
          exact ih (step_legal hs hstep) h

/-! ## Bookkeeping -/

/-- Buying material moves value from the cash box to the shelf and nowhere
else: net worth is unchanged. -/
theorem netWorth_buy {mk : Market} {s t : GameState} {m : Material} {q : ℚ}
    (hq : 0 ≤ q) (hc : q * unitCost m ≤ s.cash) (h : step mk s (.buy m q) = some t) :
    netWorth mk t = netWorth mk s := by
  rw [step_buy hq hc] at h
  cases h
  simp only [netWorth, machineValue]
  simp

/-- Ordering the whole bill of materials is net-worth neutral as well. -/
theorem netWorth_order {mk : Market} {s t : GameState} {a : Assembly}
    (hw : a.WellFormed = true) (hc : a.materialCost ≤ s.cash)
    (h : step mk s (.order a) = some t) : netWorth mk t = netWorth mk s := by
  rw [step_order hw hc] at h
  cases h
  simp only [netWorth, machineValue, Inventory.value_add]
  rw [← materialCost_eq_value_requirements]
  ring

/-- Refuelling is net-worth neutral too. -/
theorem netWorth_refuel {mk : Market} {s t : GameState} {l : ℚ}
    (h : step mk s (.refuel l) = some t) : netWorth mk t = netWorth mk s := by
  by_cases hg : 0 ≤ l ∧ mk.fuelPrice * l ≤ s.cash
  · simp only [step, if_pos hg] at h
    cases h
    simp only [netWorth, machineValue]
    ring
  · simp [step, hg] at h

/-- Selling material back loses the dealer's margin: with a salvage fraction
below one the player is poorer for it. -/
theorem netWorth_sell {mk : Market} {s t : GameState} {m : Material} {q : ℚ}
    (h : step mk s (.sell m q) = some t) :
    netWorth mk t = netWorth mk s - (1 - mk.salvage) * (q * unitCost m) := by
  by_cases hg : 0 ≤ q ∧ q ≤ s.stock m
  · simp only [step, if_pos hg] at h
    cases h
    simp only [netWorth, machineValue]
    simp
    ring
  · simp [step, hg] at h

theorem netWorth_sell_le {mk : Market} {s t : GameState} {m : Material} {q : ℚ}
    (hq : 0 ≤ q) (h : step mk s (.sell m q) = some t) :
    netWorth mk t ≤ netWorth mk s := by
  rw [netWorth_sell h]
  have : 0 ≤ (1 - mk.salvage) * (q * unitCost m) :=
    mul_nonneg (by linarith [mk.salvage_le_one]) (mul_nonneg hq (unitCost_pos m).le)
  linarith

/-- Fabrication is exact: the material that leaves the shelf reappears as the
value of the machine, and the only money that leaves the player's hands is the
wage bill.  In particular an owner-builder (`laborRate = 0`) creates a machine
worth exactly the material he put into it. -/
theorem netWorth_fabricate {mk : Market} {s t : GameState} {a : Assembly}
    (hw : a.WellFormed = true) (hs : Inventory.Covers s.stock a.requirements)
    (hc : mk.laborRate * a.laborHours ≤ s.cash)
    (h : step mk s (.fabricate a) = some t) :
    netWorth mk t = netWorth mk s - mk.laborRate * a.laborHours := by
  rw [step_fabricate hw hs hc] at h
  cases h
  simp only [netWorth, machineValue, List.map_cons, List.sum_cons,
    Inventory.value_sub]
  rw [← materialCost_eq_value_requirements]
  ring

theorem netWorth_fabricate_self {mk : Market} {s t : GameState} {a : Assembly}
    (hw : a.WellFormed = true) (hs : Inventory.Covers s.stock a.requirements)
    (hrate : mk.laborRate = 0) (h : step mk s (.fabricate a) = some t) :
    netWorth mk t = netWorth mk s := by
  have hc : mk.laborRate * a.laborHours ≤ s.cash := by
    rw [hrate]; simp [step, hrate] at h ⊢
    rcases h with ⟨⟨-, -, hcash⟩, -⟩
    exact hcash
  rw [netWorth_fabricate hw hs hc h, hrate]
  ring

/-- A season of farming adds the crop's gross margin (revenue less seed, less
the fuel burnt) to the player's net worth. -/
theorem netWorth_farm {mk : Market} {s t : GameState} {nm : String} {c : Crop} {area : ℚ}
    (hm : s.hasMachine nm = true) (ha : 0 ≤ area) (hf : seasonFuel c area ≤ s.fuel)
    (hc : area * c.seedCostPerHa ≤ s.cash)
    (h : step mk s (.farm nm c area) = some t) :
    netWorth mk t = netWorth mk s + area * c.marginPerHa mk.fuelPrice := by
  rw [step_farm hm ha hf hc] at h
  cases h
  simp only [netWorth, machineValue, Crop.marginPerHa, Crop.costPerHa, seasonFuel]
  ring

/-- The cash a season brings in, before fuel: revenue less seed. -/
theorem cash_farm {mk : Market} {s t : GameState} {nm : String} {c : Crop} {area : ℚ}
    (hm : s.hasMachine nm = true) (ha : 0 ≤ area) (hf : seasonFuel c area ≤ s.fuel)
    (hc : area * c.seedCostPerHa ≤ s.cash)
    (h : step mk s (.farm nm c area) = some t) :
    t.cash = s.cash + area * (c.revenuePerHa - c.seedCostPerHa) := by
  rw [step_farm hm ha hf hc] at h
  cases h
  simp only
  ring

/-- Fabricating puts the piece in the player's shed. -/
theorem built_fabricate {mk : Market} {s t : GameState} {a : Assembly}
    (hw : a.WellFormed = true) (hs : Inventory.Covers s.stock a.requirements)
    (hc : mk.laborRate * a.laborHours ≤ s.cash)
    (h : step mk s (.fabricate a) = some t) : t.hasMachine a.name = true := by
  rw [step_fabricate hw hs hc] at h
  cases h
  simp [hasMachine]

end Build
end LifeTrac
