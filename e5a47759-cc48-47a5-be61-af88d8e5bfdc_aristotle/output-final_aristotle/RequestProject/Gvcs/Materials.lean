import Mathlib

/-!
# Bare materials and the bill of materials of the LifeTrac

The other modules of this project describe how the machine behaves.  This one
describes how it is *made*: the catalogue of stock material a builder buys, the
bill-of-materials tree of every piece of the tractor, and the cost, mass and
labour that the tree implies.

Everything here is exact rational arithmetic (`ℚ`), so all of it is computable:
`#eval` gives the numbers and `decide` proves them.

Prices are in a generic currency unit (read them as US dollars) and are
illustrative of the machine class rather than quotations from a supplier.
Masses are kilograms, lengths metres, areas square metres.
-/

namespace LifeTrac
namespace Build

/-- The catalogue of raw stock and bought-in components from which the whole
machine is built.  The unit of measure of each item is given by
`Material.unitName`. -/
inductive Material where
  /-- 4″ × 4″ × ¼″ square steel tube, per metre (main frame members). -/
  | steelTube4 : Material
  /-- 3″ × 3″ × ¼″ square steel tube, per metre (loader arms, cross members). -/
  | steelTube3 : Material
  /-- 2″ × 2″ × ⅛″ square steel tube, per metre (light structure). -/
  | steelTube2 : Material
  /-- 6 mm steel plate, per square metre (gussets, panels). -/
  | steelPlate6 : Material
  /-- 12 mm steel plate, per square metre (bucket, mounts). -/
  | steelPlate12 : Material
  /-- 50 mm round bar, per metre (pins and axles). -/
  | roundBar50 : Material
  /-- M12 bolt, each. -/
  | boltM12 : Material
  /-- M12 nut, each. -/
  | nutM12 : Material
  /-- MIG welding wire, per kilogram. -/
  | weldWire : Material
  /-- Hydraulic hose, per metre. -/
  | hose : Material
  /-- Hose end fitting, each. -/
  | fitting : Material
  /-- Hydraulic fluid, per litre. -/
  | fluid : Material
  /-- Gear pump, each. -/
  | gearPump : Material
  /-- Hydraulic wheel motor, each. -/
  | wheelMotor : Material
  /-- Double-acting hydraulic cylinder, each. -/
  | cylinder : Material
  /-- Spool control valve, each. -/
  | controlValve : Material
  /-- Internal combustion engine, each. -/
  | engine : Material
  /-- Fuel tank, each. -/
  | fuelTank : Material
  /-- Hydraulic reservoir, each. -/
  | hydraulicTank : Material
  /-- Wheel hub with bearings, each. -/
  | wheelHub : Material
  /-- Tire mounted on a rim, each. -/
  | tire : Material
  /-- Operator seat, each. -/
  | seat : Material
  /-- Paint, per litre. -/
  | paint : Material
  /-- Wiring, switches and battery, one kit. -/
  | electricalKit : Material
  deriving DecidableEq, Repr, Fintype, Inhabited

namespace Material

/-- The unit in which a material is bought and counted. -/
def unitName : Material → String
  | steelTube4 | steelTube3 | steelTube2 | roundBar50 | hose => "m"
  | steelPlate6 | steelPlate12 => "m^2"
  | weldWire => "kg"
  | fluid | paint => "L"
  | _ => "each"

/-- Purchase price of one unit of a material. -/
def unitCost : Material → ℚ
  | steelTube4 => 65
  | steelTube3 => 45
  | steelTube2 => 25
  | steelPlate6 => 90
  | steelPlate12 => 180
  | roundBar50 => 30
  | boltM12 => 9/10
  | nutM12 => 3/10
  | weldWire => 6
  | hose => 12
  | fitting => 7
  | fluid => 4
  | gearPump => 220
  | wheelMotor => 320
  | cylinder => 190
  | controlValve => 260
  | engine => 1900
  | fuelTank => 90
  | hydraulicTank => 140
  | wheelHub => 85
  | tire => 210
  | seat => 120
  | paint => 35
  | electricalKit => 150

/-- Mass in kilograms of one unit of a material. -/
def unitMass : Material → ℚ
  | steelTube4 => 23
  | steelTube3 => 17
  | steelTube2 => 9
  | steelPlate6 => 47
  | steelPlate12 => 94
  | roundBar50 => 154/10
  | boltM12 => 1/10
  | nutM12 => 3/100
  | weldWire => 1
  | hose => 9/10
  | fitting => 3/20
  | fluid => 87/100
  | gearPump => 9
  | wheelMotor => 25
  | cylinder => 18
  | controlValve => 12
  | engine => 120
  | fuelTank => 8
  | hydraulicTank => 15
  | wheelHub => 12
  | tire => 45
  | seat => 9
  | paint => 6/5
  | electricalKit => 6

theorem unitCost_pos (m : Material) : 0 < unitCost m := by
  cases m <;> norm_num [unitCost]

theorem unitMass_pos (m : Material) : 0 < unitMass m := by
  cases m <;> norm_num [unitMass]

end Material

open Material

/-! ## Inventories -/

/-- A stock of materials: how many units of each item are on the shelf.  (A
negative entry is meaningless; `Inventory.Sound` rules it out.) -/
abbrev Inventory := Material → ℚ

namespace Inventory

/-- The empty store. -/
def empty : Inventory := fun _ => 0

/-- `single m q` is a store containing `q` units of `m` and nothing else. -/
def single (m : Material) (q : ℚ) : Inventory := fun x => if x = m then q else 0

/-- Pooling two stores. -/
def add (i j : Inventory) : Inventory := fun m => i m + j m

/-- Taking `j` out of `i` (only meaningful when `i` covers `j`). -/
def sub (i j : Inventory) : Inventory := fun m => i m - j m

/-- Pooling a list of stores. -/
def sum (l : List Inventory) : Inventory := l.foldr add empty

/-- Purchase value of a store. -/
def value (i : Inventory) : ℚ := ∑ m, i m * unitCost m

/-- Total mass of a store, in kilograms. -/
def mass (i : Inventory) : ℚ := ∑ m, i m * unitMass m

/-- `i` covers `j` when it contains at least as much of every material. -/
def Covers (i j : Inventory) : Prop := ∀ m, j m ≤ i m

/-- A store is sound when no entry is negative. -/
def Sound (i : Inventory) : Prop := ∀ m, 0 ≤ i m

instance (i j : Inventory) : Decidable (Covers i j) := by
  unfold Covers; infer_instance

instance (i : Inventory) : Decidable (Sound i) := by
  unfold Sound; infer_instance

@[simp] theorem sum_apply (l : List Inventory) (x : Material) :
    sum l x = (l.map (fun i => i x)).sum := by
  induction l with
  | nil => simp [sum, empty]
  | cons a t ih => simp [sum, add] at *; simp [ih]

@[simp] theorem value_empty : value empty = 0 := by simp [value, empty]

@[simp] theorem mass_empty : mass empty = 0 := by simp [mass, empty]

@[simp] theorem value_single (m : Material) (q : ℚ) :
    value (single m q) = q * unitCost m := by
  simp [value, single]

@[simp] theorem mass_single (m : Material) (q : ℚ) :
    mass (single m q) = q * unitMass m := by
  simp [mass, single]

@[simp] theorem value_add (i j : Inventory) : value (i.add j) = value i + value j := by
  simp [value, add, add_mul, Finset.sum_add_distrib]

@[simp] theorem value_sub (i j : Inventory) : value (i.sub j) = value i - value j := by
  simp [value, sub, sub_mul, Finset.sum_sub_distrib]

@[simp] theorem mass_add (i j : Inventory) : mass (i.add j) = mass i + mass j := by
  simp [mass, add, add_mul, Finset.sum_add_distrib]

@[simp] theorem add_sub_cancel' (i j : Inventory) : (i.add j).sub j = i := by
  funext m; simp [add, sub]

theorem sum_nil : sum [] = empty := rfl

theorem sum_cons (a : Inventory) (l : List Inventory) :
    sum (a :: l) = add a (sum l) := rfl

/-- The value of a pool of stores is the sum of their values. -/
theorem value_sum (l : List Inventory) : value (sum l) = (l.map value).sum := by
  induction l with
  | nil => simp [sum_nil]
  | cons a t ih => rw [sum_cons, value_add, ih]; simp

/-- The mass of a pool of stores is the sum of their masses. -/
theorem mass_sum (l : List Inventory) : mass (sum l) = (l.map mass).sum := by
  induction l with
  | nil => simp [sum_nil]
  | cons a t ih => rw [sum_cons, mass_add, ih]; simp

/-- A sound store has non-negative value. -/
theorem value_nonneg {i : Inventory} (h : Sound i) : 0 ≤ value i :=
  Finset.sum_nonneg fun m _ => mul_nonneg (h m) (unitCost_pos m).le

/-- A bigger store is worth more. -/
theorem value_mono {i j : Inventory} (h : Covers i j) : value j ≤ value i :=
  Finset.sum_le_sum fun m _ =>
    mul_le_mul_of_nonneg_right (h m) (unitCost_pos m).le

theorem Covers.rfl' (i : Inventory) : Covers i i := fun _ => le_rfl

theorem Covers.trans' {i j k : Inventory} (h₁ : Covers i j) (h₂ : Covers j k) :
    Covers i k := fun m => (h₂ m).trans (h₁ m)

end Inventory

/-! ## Bills of material

A piece of the machine is described by a tree: a leaf is a quantity of stock
material, a node is a named subassembly with the labour needed to put it
together out of its children. -/

/-- A bill of materials: either a quantity of raw stock, or a named
subassembly with its fabrication labour (in hours) and its components. -/
inductive Assembly where
  /-- `stock m q`: `q` units of the material `m`. -/
  | stock (m : Material) (qty : ℚ) : Assembly
  /-- `part name labor cs`: the subassembly `name`, made from the components
  `cs` with `labor` hours of work. -/
  | part (name : String) (labor : ℚ) (components : List Assembly) : Assembly
  deriving Inhabited

namespace Assembly

/-- Induction over bills of material: nodes may assume the statement for all
their components. -/
@[elab_as_elim]
theorem rec' {P : Assembly → Prop} (hstock : ∀ m q, P (.stock m q))
    (hpart : ∀ n l cs, (∀ c ∈ cs, P c) → P (.part n l cs)) : ∀ a, P a
  | .stock m q => hstock m q
  | .part n l cs => hpart n l cs fun c _ => rec' hstock hpart c

/-- The name of a bill of materials (raw stock is named by its material). -/
def name : Assembly → String
  | .stock m _ => reprStr m
  | .part n _ _ => n

/-- The purchase cost of all the material in a bill of materials. -/
def materialCost : Assembly → ℚ
  | .stock m q => q * unitCost m
  | .part _ _ cs => (cs.map materialCost).sum

/-- The total fabrication labour, in hours. -/
def laborHours : Assembly → ℚ
  | .stock _ _ => 0
  | .part _ l cs => l + (cs.map laborHours).sum

/-- The mass of the finished piece, in kilograms. -/
def mass : Assembly → ℚ
  | .stock m q => q * unitMass m
  | .part _ _ cs => (cs.map mass).sum

/-- The total draw on the stores: how much of each material the piece needs. -/
def requirements : Assembly → Inventory
  | .stock m q => Inventory.single m q
  | .part _ _ cs => Inventory.sum (cs.map requirements)

/-- A bill of materials is well formed when no quantity and no labour time is
negative. -/
def WellFormed : Assembly → Bool
  | .stock _ q => 0 ≤ q
  | .part _ l cs => (0 ≤ l) && (cs.map WellFormed).all (fun b => b)

/-- Total cost of a piece at a shop labour rate of `rate` per hour. -/
def totalCost (rate : ℚ) (a : Assembly) : ℚ := a.materialCost + rate * a.laborHours

@[simp] theorem materialCost_stock (m : Material) (q : ℚ) :
    materialCost (.stock m q) = q * unitCost m := by simp [materialCost]

@[simp] theorem materialCost_part (n : String) (l : ℚ) (cs : List Assembly) :
    materialCost (.part n l cs) = (cs.map materialCost).sum := by simp [materialCost]

@[simp] theorem laborHours_stock (m : Material) (q : ℚ) :
    laborHours (.stock m q) = 0 := by simp [laborHours]

@[simp] theorem laborHours_part (n : String) (l : ℚ) (cs : List Assembly) :
    laborHours (.part n l cs) = l + (cs.map laborHours).sum := by simp [laborHours]

@[simp] theorem mass_stock (m : Material) (q : ℚ) :
    mass (.stock m q) = q * unitMass m := by simp [mass]

@[simp] theorem mass_part (n : String) (l : ℚ) (cs : List Assembly) :
    mass (.part n l cs) = (cs.map mass).sum := by simp [mass]

@[simp] theorem requirements_stock (m : Material) (q : ℚ) :
    requirements (.stock m q) = Inventory.single m q := by simp [requirements]

@[simp] theorem requirements_part (n : String) (l : ℚ) (cs : List Assembly) :
    requirements (.part n l cs) = Inventory.sum (cs.map requirements) := by
  simp [requirements]

@[simp] theorem wellFormed_stock (m : Material) (q : ℚ) :
    WellFormed (.stock m q) = true ↔ 0 ≤ q := by simp [WellFormed]

@[simp] theorem wellFormed_part (n : String) (l : ℚ) (cs : List Assembly) :
    WellFormed (.part n l cs) = true ↔ 0 ≤ l ∧ ∀ c ∈ cs, WellFormed c = true := by
  simp [WellFormed]

/-- The material cost of a piece is the value of the materials it draws from
the stores. -/
theorem materialCost_eq_value_requirements (a : Assembly) :
    a.materialCost = Inventory.value a.requirements := by
  induction a using Assembly.rec' with
  | hstock m q => simp
  | hpart n l cs ih =>
      simp only [materialCost_part, requirements_part, Inventory.value_sum,
        List.map_map]
      refine congrArg List.sum (List.map_congr_left ?_)
      intro c hc
      simpa using ih c hc

/-- The mass of a piece is the mass of the materials it draws. -/
theorem mass_eq_mass_requirements (a : Assembly) :
    a.mass = Inventory.mass a.requirements := by
  induction a using Assembly.rec' with
  | hstock m q => simp
  | hpart n l cs ih =>
      simp only [mass_part, requirements_part, Inventory.mass_sum, List.map_map]
      refine congrArg List.sum (List.map_congr_left ?_)
      intro c hc
      simpa using ih c hc

/-- Every quantity drawn by a well-formed bill of materials is non-negative. -/
theorem requirements_sound {a : Assembly} :
    a.WellFormed = true → Inventory.Sound a.requirements := by
  induction a using Assembly.rec' with
  | hstock m q =>
      intro h x
      have hq : (0:ℚ) ≤ q := (wellFormed_stock m q).1 h
      by_cases hx : x = m <;> simp [Inventory.single, hx, hq]
  | hpart n l cs ih =>
      intro h x
      obtain ⟨-, h2⟩ := (wellFormed_part n l cs).1 h
      simp only [requirements_part, Inventory.sum_apply, List.map_map]
      refine List.sum_nonneg ?_
      intro y hy
      obtain ⟨c, hc, rfl⟩ := List.mem_map.1 hy
      exact ih c hc (h2 c hc) x

theorem materialCost_nonneg {a : Assembly} (h : a.WellFormed = true) :
    0 ≤ a.materialCost := by
  rw [materialCost_eq_value_requirements]
  exact Inventory.value_nonneg (requirements_sound h)

theorem mass_nonneg {a : Assembly} (h : a.WellFormed = true) : 0 ≤ a.mass := by
  rw [mass_eq_mass_requirements]
  exact Finset.sum_nonneg fun m _ =>
    mul_nonneg (requirements_sound h m) (unitMass_pos m).le

theorem laborHours_nonneg {a : Assembly} :
    a.WellFormed = true → 0 ≤ a.laborHours := by
  induction a using Assembly.rec' with
  | hstock m q => intro _; simp
  | hpart n l cs ih =>
      intro h
      obtain ⟨h1, h2⟩ := (wellFormed_part n l cs).1 h
      have hs : (0:ℚ) ≤ (cs.map laborHours).sum := by
        refine List.sum_nonneg ?_
        intro y hy
        obtain ⟨c, hc, rfl⟩ := List.mem_map.1 hy
        exact ih c hc (h2 c hc)
      simp only [laborHours_part]
      linarith

/-- Cost rises with the shop rate. -/
theorem totalCost_mono {a : Assembly} (h : a.WellFormed = true) {r s : ℚ}
    (hrs : r ≤ s) : totalCost r a ≤ totalCost s a := by
  have := laborHours_nonneg h
  simp only [totalCost]
  nlinarith

/-- At rate `0` — the owner-builder doing the work himself — the cost of a
piece is exactly the cost of its materials. -/
@[simp] theorem totalCost_zero (a : Assembly) : totalCost 0 a = a.materialCost := by
  simp [totalCost]

/-- Building `n` copies of a piece costs `n` times as much. -/
theorem materialCost_replicate (n : ℕ) (a : Assembly) (nm : String) (l : ℚ) :
    materialCost (.part nm l (List.replicate n a)) = n * a.materialCost := by
  simp [List.map_replicate, List.sum_replicate, nsmul_eq_mul]

end Assembly

/-! ## The machine, piece by piece

The tractor is a frame carrying four independent wheel modules, a power unit
(engine, pump, tanks), a control station and a front loader.  Each subassembly
lists the stock it consumes and the hours needed to fabricate it. -/

open Assembly

/-- The welded frame: main rails, cross members, gussets and hardware. -/
def frame : Assembly :=
  .part "frame" 24
    [ .stock steelTube4 12
    , .stock steelTube3 8
    , .stock steelPlate6 (3/2)
    , .stock weldWire 6
    , .stock boltM12 40
    , .stock nutM12 40 ]

/-- One of the four wheel modules: hub, tire, hydraulic wheel motor and its
plumbing, bolted to a plate mount. -/
def wheelModule : Assembly :=
  .part "wheel module" 4
    [ .stock wheelHub 1
    , .stock tire 1
    , .stock wheelMotor 1
    , .stock steelPlate12 (1/5)
    , .stock hose 4
    , .stock fitting 4
    , .stock boltM12 8
    , .stock nutM12 8 ]

/-- The power unit: engine, pump, hydraulic reservoir, fuel tank and fluid. -/
def powerUnit : Assembly :=
  .part "power unit" 12
    [ .stock engine 1
    , .stock gearPump 1
    , .stock hydraulicTank 1
    , .stock fuelTank 1
    , .stock fluid 40
    , .stock steelPlate6 (1/2)
    , .stock hose 6
    , .stock fitting 8
    , .stock boltM12 16
    , .stock nutM12 16 ]

/-- The operator's station: two spool valves (drive and loader), seat,
electrics and the light structure carrying them. -/
def controlStation : Assembly :=
  .part "control station" 8
    [ .stock controlValve 2
    , .stock seat 1
    , .stock electricalKit 1
    , .stock steelTube2 6
    , .stock hose 10
    , .stock fitting 12
    , .stock boltM12 12
    , .stock nutM12 12 ]

/-- The front loader: arms, bucket, pins and the two lift cylinders. -/
def loader : Assembly :=
  .part "loader" 16
    [ .stock steelTube3 6
    , .stock steelPlate12 (6/5)
    , .stock roundBar50 (3/2)
    , .stock cylinder 2
    , .stock hose 8
    , .stock fitting 8
    , .stock weldWire 3 ]

/-- Paint and final hardware. -/
def finishing : Assembly :=
  .part "finishing" 6
    [ .stock paint 8
    , .stock boltM12 20
    , .stock nutM12 20 ]

/-- The complete machine: the frame, four wheel modules, the power unit, the
control station, the loader and finishing, plus ten hours of final assembly. -/
def lifeTrac : Assembly :=
  .part "LifeTrac" 10
    [ frame
    , wheelModule, wheelModule, wheelModule, wheelModule
    , powerUnit
    , controlStation
    , loader
    , finishing ]

#eval lifeTrac.materialCost
#eval lifeTrac.laborHours
#eval lifeTrac.mass
#eval Assembly.totalCost 25 lifeTrac

/-- The tractor's bill of materials is well formed. -/
theorem lifeTrac_wellFormed : lifeTrac.WellFormed = true := by
  norm_num [lifeTrac, frame, wheelModule, powerUnit, controlStation, loader,
    finishing]

/-- The bill of materials for the whole tractor comes to 9551 currency units. -/
theorem lifeTrac_materialCost : lifeTrac.materialCost = 9551 := by
  norm_num [lifeTrac, frame, wheelModule, powerUnit, controlStation, loader,
    finishing, Material.unitCost]

/-- Building one takes 92 hours of shop work. -/
theorem lifeTrac_laborHours : lifeTrac.laborHours = 92 := by
  norm_num [lifeTrac, frame, wheelModule, powerUnit, controlStation, loader,
    finishing]

/-- The finished machine masses 1539.7 kg. -/
theorem lifeTrac_mass : lifeTrac.mass = 15397/10 := by
  norm_num [lifeTrac, frame, wheelModule, powerUnit, controlStation, loader,
    finishing, Material.unitMass]

/-- At a shop rate of 25 per hour the machine costs 11 851; built by its owner
(rate 0) it costs only the 9551 of materials. -/
theorem lifeTrac_totalCost_25 : Assembly.totalCost 25 lifeTrac = 11851 := by
  rw [Assembly.totalCost, lifeTrac_materialCost, lifeTrac_laborHours]
  norm_num

theorem lifeTrac_totalCost_self_build :
    Assembly.totalCost 0 lifeTrac = lifeTrac.materialCost := by
  simp

/-- Two thirds of the material cost is bought-in components (engine, pump,
motors, valves, cylinders, tires): the steel is the cheap part. -/
theorem lifeTrac_engine_share :
    lifeTrac.requirements Material.engine = 1 ∧
    lifeTrac.requirements Material.wheelMotor = 4 ∧
    lifeTrac.requirements Material.cylinder = 2 ∧
    lifeTrac.requirements Material.steelTube4 = 12 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;>
    norm_num +decide [lifeTrac, frame, wheelModule, powerUnit, controlStation,
      loader, finishing, Inventory.single]

end Build
end LifeTrac
