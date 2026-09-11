import RequestProject.Gvcs.UI

/-!
# The runtime model: the game in machine integers

`Game.lean` states the rules over exact rationals, which is right for proving
things and impossible for a 64-bit machine.  This file is the bridge: the same
game played on `ℤ`, with every money, fuel, day and stock quantity held in
*micro units* (millionths), and with the quantities the player types restricted
to whole units.  It is this model that `RequestProject/Wasm/Compile.lean`
compiles to WebAssembly.

Two things make the translation exact rather than approximate.

* Every constant of the game — prices, bills of materials, labour hours, crop
  yields — is a multiple of one millionth, so it has an exact integer
  representation (`toQ_costM`, `toQ_partReq`, …).
* Every quantity the runtime computes is a constant times a whole number, so no
  rounding is ever needed.  In particular the salvage fraction (3/5), the
  eight-hour day and the fuel and time a hectare takes are folded into
  constants at compile time (`salvageM`, `partDays`, `cropDays`), so the
  runtime never divides.

The main theorem is `rstep_refines`: the integer rule book is the rational rule
book, move for move, including its refusals.  `runtime_firstSeason` then
replays the verified playthrough of `Tycoon.lean` in integers.
-/

namespace LifeTrac
namespace Runtime

open Build Material Assembly GameState

/-! ## Fixed point -/

/-- One unit of the game is a million units of the runtime. -/
def SCALE : ℤ := 1000000

/-- The rational a runtime integer stands for. -/
def toQ (n : ℤ) : ℚ := (n : ℚ) / 1000000

/-- The runtime integer standing for a rational (exact on every constant of the
game; see the `toQ_*` lemmas). -/
def ofQ (q : ℚ) : ℤ := (q * 1000000).num

@[simp] theorem toQ_zero : toQ 0 = 0 := by simp [toQ]

theorem toQ_inj {a b : ℤ} : toQ a = toQ b ↔ a = b := by
  simp [toQ]

theorem toQ_le {a b : ℤ} : toQ a ≤ toQ b ↔ a ≤ b := by
  simp [toQ, div_le_div_iff_of_pos_right]

theorem toQ_add (a b : ℤ) : toQ (a + b) = toQ a + toQ b := by
  simp [toQ, add_div]

theorem toQ_sub (a b : ℤ) : toQ (a - b) = toQ a - toQ b := by
  simp [toQ, sub_div]

/-- Scaling by a whole number commutes with the fixed-point reading. -/
theorem toQ_intMul (q c : ℤ) : toQ (q * c) = (q : ℚ) * toQ c := by
  simp [toQ, mul_div_assoc]

/-- A whole number of units. -/
theorem toQ_scale (q : ℤ) : toQ (q * SCALE) = (q : ℚ) := by
  simp [toQ, SCALE]

/-- `ofQ` is exact on any rational with a millionth as denominator. -/
theorem toQ_ofQ {q : ℚ} (h : (q * 1000000).den = 1) : toQ (ofQ q) = q := by
  have h' : ((q * 1000000).num : ℚ) = q * 1000000 := by
    conv_rhs => rw [← Rat.num_div_den (q * 1000000), h]
    simp
  simp [toQ, ofQ, h']

/-! ## The constants of the game, in micro units

These tables are the extracted data: the prices, bills of materials, labour and
agronomy of `Materials.lean` and `Farm.lean` written out as machine integers.
Each is followed by the lemma that says the integer is the rational, exactly —
which is what makes the whole pipeline sound. -/

/-- The price of one unit of a material. -/
def costM : Material → ℤ
  | steelTube4 => 65000000
  | steelTube3 => 45000000
  | steelTube2 => 25000000
  | steelPlate6 => 90000000
  | steelPlate12 => 180000000
  | roundBar50 => 30000000
  | boltM12 => 900000
  | nutM12 => 300000
  | weldWire => 6000000
  | hose => 12000000
  | fitting => 7000000
  | fluid => 4000000
  | gearPump => 220000000
  | wheelMotor => 320000000
  | cylinder => 190000000
  | controlValve => 260000000
  | engine => 1900000000
  | fuelTank => 90000000
  | hydraulicTank => 140000000
  | wheelHub => 85000000
  | tire => 210000000
  | seat => 120000000
  | paint => 35000000
  | electricalKit => 150000000

/-- What one unit of a material fetches when sold back to the dealer, at the
homestead's salvage fraction of three fifths. -/
def salvageM : Material → ℤ
  | steelTube4 => 39000000
  | steelTube3 => 27000000
  | steelTube2 => 15000000
  | steelPlate6 => 54000000
  | steelPlate12 => 108000000
  | roundBar50 => 18000000
  | boltM12 => 540000
  | nutM12 => 180000
  | weldWire => 3600000
  | hose => 7200000
  | fitting => 4200000
  | fluid => 2400000
  | gearPump => 132000000
  | wheelMotor => 192000000
  | cylinder => 114000000
  | controlValve => 156000000
  | engine => 1140000000
  | fuelTank => 54000000
  | hydraulicTank => 84000000
  | wheelHub => 51000000
  | tire => 126000000
  | seat => 72000000
  | paint => 21000000
  | electricalKit => 90000000

/-- The price of a litre of fuel. -/
def fuelPriceM : ℤ := 1500000

theorem toQ_costM (m : Material) : toQ (costM m) = unitCost m := by
  cases m <;> norm_num [costM, toQ, unitCost]

theorem toQ_salvageM (m : Material) :
    toQ (salvageM m) = homestead.salvage * unitCost m := by
  cases m <;> norm_num [salvageM, toQ, unitCost, homestead]

theorem toQ_fuelPriceM : toQ fuelPriceM = homestead.fuelPrice := by
  norm_num [fuelPriceM, toQ, homestead]

/-! ## The parts the workbench can build -/

/-- The bills of materials the game offers. -/
inductive RPart where
  /-- The welded frame. -/
  | frame
  /-- One wheel module. -/
  | wheelModule
  /-- The power unit. -/
  | powerUnit
  /-- The operator's station. -/
  | controlStation
  /-- The front loader. -/
  | loader
  /-- Paint and final hardware. -/
  | finishing
  /-- The whole machine. -/
  | lifeTrac
  deriving DecidableEq, Repr, Inhabited, Fintype

namespace RPart

/-- The assembly of `Materials.lean` a menu entry names. -/
def toAssembly : RPart → Assembly
  | frame => Build.frame
  | wheelModule => Build.wheelModule
  | powerUnit => Build.powerUnit
  | controlStation => Build.controlStation
  | loader => Build.loader
  | finishing => Build.finishing
  | lifeTrac => Build.lifeTrac

/-- Every bill of materials on the menu is well formed. -/
theorem wellFormed (a : RPart) : a.toAssembly.WellFormed = true := by
  cases a <;>
    norm_num [toAssembly, Build.frame, Build.wheelModule, Build.powerUnit,
      Build.controlStation, Build.loader, Build.finishing, Build.lifeTrac,
      Assembly.WellFormed]

/-- The name of the assembly. -/
def name (a : RPart) : String := a.toAssembly.name

/-- What the order desk charges for the material of an assembly. -/
def cost : RPart → ℤ
  | frame => 1359000000
  | wheelModule => 736600000
  | powerUnit => 2702200000
  | controlStation => 1158400000
  | loader => 1081000000
  | finishing => 304000000
  | lifeTrac => 9551000000

/-- What the shelf gives up when the assembly is built. -/
def req : RPart → Material → ℤ
  | frame, steelTube4 => 12000000
  | frame, steelTube3 => 8000000
  | frame, steelPlate6 => 1500000
  | frame, boltM12 => 40000000
  | frame, nutM12 => 40000000
  | frame, weldWire => 6000000
  | wheelModule, steelPlate12 => 200000
  | wheelModule, boltM12 => 8000000
  | wheelModule, nutM12 => 8000000
  | wheelModule, hose => 4000000
  | wheelModule, fitting => 4000000
  | wheelModule, wheelMotor => 1000000
  | wheelModule, wheelHub => 1000000
  | wheelModule, tire => 1000000
  | powerUnit, steelPlate6 => 500000
  | powerUnit, boltM12 => 16000000
  | powerUnit, nutM12 => 16000000
  | powerUnit, hose => 6000000
  | powerUnit, fitting => 8000000
  | powerUnit, fluid => 40000000
  | powerUnit, gearPump => 1000000
  | powerUnit, engine => 1000000
  | powerUnit, fuelTank => 1000000
  | powerUnit, hydraulicTank => 1000000
  | controlStation, steelTube2 => 6000000
  | controlStation, boltM12 => 12000000
  | controlStation, nutM12 => 12000000
  | controlStation, hose => 10000000
  | controlStation, fitting => 12000000
  | controlStation, controlValve => 2000000
  | controlStation, seat => 1000000
  | controlStation, electricalKit => 1000000
  | loader, steelTube3 => 6000000
  | loader, steelPlate12 => 1200000
  | loader, roundBar50 => 1500000
  | loader, weldWire => 3000000
  | loader, hose => 8000000
  | loader, fitting => 8000000
  | loader, cylinder => 2000000
  | finishing, boltM12 => 20000000
  | finishing, nutM12 => 20000000
  | finishing, paint => 8000000
  | lifeTrac, steelTube4 => 12000000
  | lifeTrac, steelTube3 => 14000000
  | lifeTrac, steelTube2 => 6000000
  | lifeTrac, steelPlate6 => 2000000
  | lifeTrac, steelPlate12 => 2000000
  | lifeTrac, roundBar50 => 1500000
  | lifeTrac, boltM12 => 120000000
  | lifeTrac, nutM12 => 120000000
  | lifeTrac, weldWire => 9000000
  | lifeTrac, hose => 40000000
  | lifeTrac, fitting => 44000000
  | lifeTrac, fluid => 40000000
  | lifeTrac, gearPump => 1000000
  | lifeTrac, wheelMotor => 4000000
  | lifeTrac, cylinder => 2000000
  | lifeTrac, controlValve => 2000000
  | lifeTrac, engine => 1000000
  | lifeTrac, fuelTank => 1000000
  | lifeTrac, hydraulicTank => 1000000
  | lifeTrac, wheelHub => 4000000
  | lifeTrac, tire => 4000000
  | lifeTrac, seat => 1000000
  | lifeTrac, paint => 8000000
  | lifeTrac, electricalKit => 1000000
  | _, _ => 0

/-- The wage bill of building it (nil at the homestead, which builds its own). -/
def laborCost : RPart → ℤ
  | _ => 0

/-- The days the build takes, at eight hours to the day. -/
def days : RPart → ℤ
  | frame => 3000000
  | wheelModule => 500000
  | powerUnit => 1500000
  | controlStation => 1000000
  | loader => 2000000
  | finishing => 750000
  | lifeTrac => 11500000

end RPart

theorem toQ_partCost (a : RPart) : toQ a.cost = a.toAssembly.materialCost := by
  cases a <;>
    norm_num [RPart.cost, RPart.toAssembly, toQ, Build.frame, Build.wheelModule,
      Build.powerUnit, Build.controlStation, Build.loader, Build.finishing,
      Build.lifeTrac, unitCost]

theorem toQ_partReq (a : RPart) (m : Material) :
    toQ (a.req m) = a.toAssembly.requirements m := by
  cases a <;> cases m <;>
    simp [RPart.req, RPart.toAssembly, toQ, Build.frame, Build.wheelModule,
      Build.powerUnit, Build.controlStation, Build.loader, Build.finishing,
      Build.lifeTrac, Inventory.single]
  all_goals norm_num

theorem toQ_partLabor (a : RPart) :
    toQ a.laborCost = homestead.laborRate * a.toAssembly.laborHours := by
  cases a <;> norm_num [RPart.laborCost, toQ, homestead]

theorem toQ_partDays (a : RPart) : toQ a.days = a.toAssembly.laborHours / 8 := by
  cases a <;>
    norm_num [RPart.days, RPart.toAssembly, toQ, Build.frame, Build.wheelModule,
      Build.powerUnit, Build.controlStation, Build.loader, Build.finishing,
      Build.lifeTrac]

/-! ## The crops the field planner offers -/

/-- The crops on the menu. -/
inductive RCrop where
  /-- Wheat. -/
  | wheat
  deriving DecidableEq, Repr, Inhabited, Fintype

namespace RCrop

/-- The crop of `Farm.lean` a menu entry names. -/
def toCrop : RCrop → Crop
  | wheat => Build.wheat

/-- Seed and fertiliser for a hectare. -/
def seed : RCrop → ℤ
  | wheat => 120000000

/-- What a hectare sells for. -/
def revenue : RCrop → ℤ
  | wheat => 800000000

/-- The fuel a hectare burns. -/
def fuelHa : RCrop → ℤ
  | wheat => 18000000

/-- The days a hectare takes, at eight hours to the day. -/
def daysHa : RCrop → ℤ
  | wheat => 281250

end RCrop

theorem toQ_cropSeed (c : RCrop) : toQ c.seed = c.toCrop.seedCostPerHa := by
  cases c
  norm_num [RCrop.seed, RCrop.toCrop, toQ, Build.wheat]

theorem toQ_cropRevenue (c : RCrop) : toQ c.revenue = c.toCrop.revenuePerHa := by
  cases c
  norm_num [RCrop.revenue, RCrop.toCrop, toQ, Build.wheat, Crop.revenuePerHa]

theorem toQ_cropFuel (c : RCrop) : toQ c.fuelHa = c.toCrop.fuelPerHa := by
  cases c
  norm_num [RCrop.fuelHa, RCrop.toCrop, toQ, Build.wheat, Crop.fuelPerHa,
      Build.ploughing, Build.drilling, Build.harvesting]

theorem toQ_cropDays (c : RCrop) : toQ c.daysHa = c.toCrop.hoursPerHa / 8 := by
  cases c
  norm_num [RCrop.daysHa, RCrop.toCrop, toQ, Build.wheat, Crop.hoursPerHa,
      Build.ploughing, Build.drilling, Build.harvesting]


/-! ## States and moves -/

/-- The position of the game in machine integers. -/
structure RState where
  /-- Cash, in micro units. -/
  cash : ℤ
  /-- Fuel in the tank, in micro litres. -/
  fuel : ℤ
  /-- Days elapsed, in micro days. -/
  day : ℤ
  /-- Hectares farmed, in micro hectares. -/
  hect : ℤ
  /-- The shelf, in micro units of each material. -/
  stock : Material → ℤ
  /-- The parts built, most recent first. -/
  built : List RPart

/-- A move, with whole-number quantities. -/
inductive RAction where
  /-- Buy `q` units of a material. -/
  | buy (m : Material) (q : ℤ)
  /-- Order the whole bill of materials of an assembly. -/
  | order (a : RPart)
  /-- Sell `q` units of a material back. -/
  | sell (m : Material) (q : ℤ)
  /-- Build an assembly out of the shelf. -/
  | fabricate (a : RPart)
  /-- Buy `l` litres of fuel. -/
  | refuel (l : ℤ)
  /-- Work `area` hectares. -/
  | farm (c : RCrop) (area : ℤ)
  deriving DecidableEq, Repr, Inhabited

/-- Does the yard hold a finished machine? -/
def RState.hasTractor (s : RState) : Bool := s.built.any (fun a => a == RPart.lifeTrac)

/-- The rule book in integers. -/
def rstep (s : RState) : RAction → Option RState
  | .buy m q =>
      if 0 ≤ q ∧ q * costM m ≤ s.cash then
        some { s with cash := s.cash - q * costM m,
                      stock := fun x => s.stock x + (if x = m then q * SCALE else 0) }
      else none
  | .order a =>
      if a.cost ≤ s.cash then
        some { s with cash := s.cash - a.cost,
                      stock := fun x => s.stock x + a.req x }
      else none
  | .sell m q =>
      if 0 ≤ q ∧ q * SCALE ≤ s.stock m then
        some { s with cash := s.cash + q * salvageM m,
                      stock := fun x => s.stock x - (if x = m then q * SCALE else 0) }
      else none
  | .fabricate a =>
      if (∀ m, a.req m ≤ s.stock m) ∧ a.laborCost ≤ s.cash then
        some { s with cash := s.cash - a.laborCost,
                      stock := fun x => s.stock x - a.req x,
                      built := a :: s.built,
                      day := s.day + a.days }
      else none
  | .refuel l =>
      if 0 ≤ l ∧ l * fuelPriceM ≤ s.cash then
        some { s with cash := s.cash - l * fuelPriceM, fuel := s.fuel + l * SCALE }
      else none
  | .farm c area =>
      if s.hasTractor = true ∧ 0 ≤ area ∧ area * c.fuelHa ≤ s.fuel ∧
          area * c.seed ≤ s.cash then
        some { s with cash := s.cash + area * c.revenue - area * c.seed,
                      fuel := s.fuel - area * c.fuelHa,
                      day := s.day + area * c.daysHa,
                      hect := s.hect + area * SCALE }
      else none

/-- Playing a script. -/
def rrun (s : RState) : List RAction → Option RState
  | [] => some s
  | a :: as => (rstep s a).bind (fun t => rrun t as)

/-! ## The runtime is the rule book -/

/-- The rational position an integer position stands for. -/
def absState (s : RState) : GameState where
  cash := toQ s.cash
  stock := fun m => toQ (s.stock m)
  built := s.built.map RPart.toAssembly
  fuel := toQ s.fuel
  day := toQ s.day
  hectares := toQ s.hect

/-- The move of `Game.lean` a runtime move stands for. -/
def absAction : RAction → Action
  | .buy m q => .buy m (q : ℚ)
  | .order a => .order a.toAssembly
  | .sell m q => .sell m (q : ℚ)
  | .fabricate a => .fabricate a.toAssembly
  | .refuel l => .refuel (l : ℚ)
  | .farm c area => .farm "LifeTrac" c.toCrop (area : ℚ)

theorem absState_hasMachine (s : RState) :
    (absState s).hasMachine "LifeTrac" = s.hasTractor := by
  simp only [GameState.hasMachine, absState, RState.hasTractor, List.any_map]
  induction s.built with
  | nil => rfl
  | cons a as ih =>
      cases a <;>
        simp_all [Function.comp, RPart.toAssembly, Assembly.name, Build.frame,
          Build.wheelModule, Build.powerUnit, Build.controlStation, Build.loader,
          Build.finishing, Build.lifeTrac]

/-- **The runtime refines the rule book.**  Whatever the player does, the
integer machine accepts exactly the moves the rational rule book accepts, and
lands on exactly the position it lands on. -/
theorem rstep_refines (s : RState) (a : RAction) :
    (rstep s a).map absState = step homestead (absState s) (absAction a) := by
  cases a with
  | buy m q =>
      have hc : ((q : ℚ)) * unitCost m = toQ (q * costM m) := by
        rw [toQ_intMul, toQ_costM]
      by_cases h : 0 ≤ q ∧ q * costM m ≤ s.cash
      · have hq : (0 : ℚ) ≤ (q : ℚ) ∧ ((q : ℚ)) * unitCost m ≤ (absState s).cash :=
          ⟨by exact_mod_cast h.1, by rw [hc]; exact toQ_le.2 h.2⟩
        simp only [rstep, if_pos h, Option.map_some, absAction, step, if_pos hq]
        congr 1
        simp only [absState, GameState.mk.injEq, hc, toQ_sub]
        refine ⟨trivial, ?_, trivial, trivial, trivial, trivial⟩
        funext x
        by_cases hx : x = m <;>
          simp [Inventory.add, Inventory.single, hx, toQ_add, toQ_scale]
      · have hq : ¬ ((0 : ℚ) ≤ (q : ℚ) ∧ ((q : ℚ)) * unitCost m ≤ (absState s).cash) := by
          rintro ⟨ha, hb⟩
          exact h ⟨by exact_mod_cast ha, toQ_le.1 (by rw [← hc]; exact hb)⟩
        simp only [rstep, if_neg h, Option.map_none, absAction, step, if_neg hq]
  | order a =>
      have hc : a.toAssembly.materialCost = toQ a.cost := (toQ_partCost a).symm
      by_cases h : a.cost ≤ s.cash
      · have hq : a.toAssembly.WellFormed = true ∧
            a.toAssembly.materialCost ≤ (absState s).cash :=
          ⟨a.wellFormed, by rw [hc]; exact toQ_le.2 h⟩
        simp only [rstep, if_pos h, Option.map_some, absAction, step, if_pos hq]
        congr 1
        simp only [absState, GameState.mk.injEq, hc, toQ_sub]
        refine ⟨trivial, ?_, trivial, trivial, trivial, trivial⟩
        funext x
        simp [Inventory.add, toQ_add, toQ_partReq]
      · have hq : ¬ (a.toAssembly.WellFormed = true ∧
            a.toAssembly.materialCost ≤ (absState s).cash) := by
          rintro ⟨-, hb⟩
          exact h (toQ_le.1 (by rw [← hc]; exact hb))
        simp only [rstep, if_neg h, Option.map_none, absAction, step, if_neg hq]
  | sell m q =>
      have hq0 : (absState s).stock m = toQ (s.stock m) := rfl
      have hs : homestead.salvage * ((q : ℚ) * unitCost m) = toQ (q * salvageM m) := by
        rw [toQ_intMul, toQ_salvageM]; ring
      by_cases h : 0 ≤ q ∧ q * SCALE ≤ s.stock m
      · have hq : (0 : ℚ) ≤ (q : ℚ) ∧ (q : ℚ) ≤ (absState s).stock m :=
          ⟨by exact_mod_cast h.1, by rw [hq0, ← toQ_scale q]; exact toQ_le.2 h.2⟩
        simp only [rstep, if_pos h, Option.map_some, absAction, step, if_pos hq]
        congr 1
        simp only [absState, GameState.mk.injEq, hs, toQ_add]
        refine ⟨trivial, ?_, trivial, trivial, trivial, trivial⟩
        funext x
        by_cases hx : x = m <;>
          simp [Inventory.sub, Inventory.single, hx, toQ_sub, toQ_scale]
      · have hq : ¬ ((0 : ℚ) ≤ (q : ℚ) ∧ (q : ℚ) ≤ (absState s).stock m) := by
          rintro ⟨ha, hb⟩
          refine h ⟨by exact_mod_cast ha, toQ_le.1 ?_⟩
          rw [toQ_scale]; exact hb
        simp only [rstep, if_neg h, Option.map_none, absAction, step, if_neg hq]
  | fabricate a =>
      have hl : homestead.laborRate * a.toAssembly.laborHours = toQ a.laborCost :=
        (toQ_partLabor a).symm
      have hcov : Inventory.Covers (absState s).stock a.toAssembly.requirements ↔
          ∀ m, a.req m ≤ s.stock m := by
        constructor
        · intro hh m
          have := hh m
          rw [← toQ_partReq a m] at this
          exact toQ_le.1 this
        · intro hh m
          have := toQ_le.2 (hh m)
          rwa [toQ_partReq a m] at this
      by_cases h : (∀ m, a.req m ≤ s.stock m) ∧ a.laborCost ≤ s.cash
      · have hq : a.toAssembly.WellFormed = true ∧
            Inventory.Covers (absState s).stock a.toAssembly.requirements ∧
            homestead.laborRate * a.toAssembly.laborHours ≤ (absState s).cash :=
          ⟨a.wellFormed, hcov.2 h.1, by rw [hl]; exact toQ_le.2 h.2⟩
        simp only [rstep, if_pos h, Option.map_some, absAction, step, if_pos hq]
        congr 1
        simp only [absState, GameState.mk.injEq, hl, toQ_sub, List.map_cons]
        refine ⟨trivial, ?_, trivial, trivial, ?_, trivial⟩
        · funext x
          simp [Inventory.sub, toQ_partReq]
        · rw [toQ_add, toQ_partDays]
      · have hq : ¬ (a.toAssembly.WellFormed = true ∧
            Inventory.Covers (absState s).stock a.toAssembly.requirements ∧
            homestead.laborRate * a.toAssembly.laborHours ≤ (absState s).cash) := by
          rintro ⟨-, hb, hcc⟩
          exact h ⟨hcov.1 hb, toQ_le.1 (by rw [← hl]; exact hcc)⟩
        simp only [rstep, if_neg h, Option.map_none, absAction, step, if_neg hq]
  | refuel l =>
      have hc : homestead.fuelPrice * (l : ℚ) = toQ (l * fuelPriceM) := by
        rw [toQ_intMul, toQ_fuelPriceM]; ring
      by_cases h : 0 ≤ l ∧ l * fuelPriceM ≤ s.cash
      · have hq : (0 : ℚ) ≤ (l : ℚ) ∧ homestead.fuelPrice * (l : ℚ) ≤ (absState s).cash :=
          ⟨by exact_mod_cast h.1, by rw [hc]; exact toQ_le.2 h.2⟩
        simp only [rstep, if_pos h, Option.map_some, absAction, step, if_pos hq]
        congr 1
        simp only [absState, hc, toQ_sub, toQ_add, toQ_scale]
      · have hq : ¬ ((0 : ℚ) ≤ (l : ℚ) ∧
            homestead.fuelPrice * (l : ℚ) ≤ (absState s).cash) := by
          rintro ⟨ha, hb⟩
          exact h ⟨by exact_mod_cast ha, toQ_le.1 (by rw [← hc]; exact hb)⟩
        simp only [rstep, if_neg h, Option.map_none, absAction, step, if_neg hq]
  | farm c area =>
      have hf : seasonFuel c.toCrop (area : ℚ) = toQ (area * c.fuelHa) := by
        rw [toQ_intMul, toQ_cropFuel, seasonFuel]
      have hsd : (area : ℚ) * c.toCrop.seedCostPerHa = toQ (area * c.seed) := by
        rw [toQ_intMul, toQ_cropSeed]
      have hrv : (area : ℚ) * c.toCrop.revenuePerHa = toQ (area * c.revenue) := by
        rw [toQ_intMul, toQ_cropRevenue]
      have hhr : seasonHours c.toCrop (area : ℚ) / 8 = toQ (area * c.daysHa) := by
        rw [toQ_intMul, toQ_cropDays, seasonHours]; ring
      by_cases h : s.hasTractor = true ∧ 0 ≤ area ∧ area * c.fuelHa ≤ s.fuel ∧
          area * c.seed ≤ s.cash
      · have hq : (absState s).hasMachine "LifeTrac" = true ∧ (0 : ℚ) ≤ (area : ℚ) ∧
            seasonFuel c.toCrop (area : ℚ) ≤ (absState s).fuel ∧
            (area : ℚ) * c.toCrop.seedCostPerHa ≤ (absState s).cash :=
          ⟨by rw [absState_hasMachine]; exact h.1, by exact_mod_cast h.2.1,
            by rw [hf]; exact toQ_le.2 h.2.2.1, by rw [hsd]; exact toQ_le.2 h.2.2.2⟩
        simp only [rstep, if_pos h, Option.map_some, absAction, step, if_pos hq]
        congr 1
        simp only [absState, hf, hsd, hrv, hhr, toQ_sub, toQ_add, toQ_scale]
      · have hq : ¬ ((absState s).hasMachine "LifeTrac" = true ∧ (0 : ℚ) ≤ (area : ℚ) ∧
            seasonFuel c.toCrop (area : ℚ) ≤ (absState s).fuel ∧
            (area : ℚ) * c.toCrop.seedCostPerHa ≤ (absState s).cash) := by
          rintro ⟨ha, hb, hcc, hd⟩
          rw [absState_hasMachine] at ha
          exact h ⟨ha, by exact_mod_cast hb, toQ_le.1 (by rw [← hf]; exact hcc),
            toQ_le.1 (by rw [← hsd]; exact hd)⟩
        simp only [rstep, if_neg h, Option.map_none, absAction, step, if_neg hq]


/-- Scripts refine too. -/
theorem rrun_refines (s : RState) (l : List RAction) :
    (rrun s l).map absState = run homestead (absState s) (l.map absAction) := by
  induction l generalizing s with
  | nil => rfl
  | cons a as ih =>
      rw [List.map_cons, run_cons, rrun, ← rstep_refines s a]
      cases h : rstep s a with
      | none => simp
      | some t => simpa using ih t

/-! ## The verified playthrough, in integers -/

/-- The opening position: 15 000 in cash, an empty shelf, nothing built. -/
def rstart : RState where
  cash := 15000 * SCALE
  fuel := 0
  day := 0
  hect := 0
  stock := fun _ => 0
  built := []

/-- The script of `Tycoon.lean`: order the parts, build the tractor, fill the
tank, put twenty hectares into wheat. -/
def rFirstSeason : List RAction :=
  [ .order RPart.lifeTrac
  , .fabricate RPart.lifeTrac
  , .refuel 400
  , .farm RCrop.wheat 20 ]

/-- The integer machine plays the verified season and ends on exactly the
figures of `Tycoon.run_firstSeason`: 18 449 in cash, 40 litres in the tank,
17.125 days gone, 20 hectares worked. -/
theorem runtime_firstSeason :
    ∃ t, rrun rstart rFirstSeason = some t ∧
      t.cash = 18449 * SCALE ∧ t.fuel = 40 * SCALE ∧
      t.day = 17125000 ∧ t.hect = 20 * SCALE ∧ t.hasTractor = true := by
  refine ⟨_, rfl, ?_, ?_, ?_, ?_, ?_⟩ <;> rfl

/-- The opening position of the integer machine is the opening position of the
game. -/
theorem absState_rstart : absState rstart = start := by
  simp only [absState, rstart, start, GameState.mk.injEq]
  refine ⟨by norm_num [toQ, SCALE], ?_, rfl, by norm_num [toQ], by norm_num [toQ],
    by norm_num [toQ]⟩
  funext m
  simp [Inventory.empty, toQ]

/-- and its script is the script of the game. -/
theorem absAction_rFirstSeason : rFirstSeason.map absAction = firstSeason := by
  simp [rFirstSeason, firstSeason, absAction, RPart.toAssembly, RCrop.toCrop]

end Runtime
end LifeTrac
