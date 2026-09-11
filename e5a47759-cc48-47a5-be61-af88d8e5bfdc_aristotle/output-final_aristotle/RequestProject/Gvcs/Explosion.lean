import RequestProject.Gvcs.Fabrication

/-!
# The raw-material content and the labour content of every item

This file works out, for every item of the production system of
`RequestProject/Fabrication.lean`, exactly how much of each of the seven raw
materials goes into it once the whole chain of workflows behind it is
followed, and how many hours of work it takes.  Each statement has the form

  `plant.rawDemand i q x = q * (c₁ · [x = iron ore] + c₂ · [x = coal] + …)`,
  `plant.laborFor i q = q * L`,

so it gives the complete raw-material vector of the item at once, and shows
explicitly that demand and labour are proportional to the size of the order.

The lemmas are in production order: each one is proved by unfolding a single
workflow and quoting the lemmas of the items that workflow consumes.  Nothing
here is postulated — every coefficient is forced by the workflows.

The headline numbers for the tractor itself are collected in
`RequestProject/Bootstrap.lean`.
-/

namespace LifeTrac
namespace Workflow

open Item

set_option maxRecDepth 4000

/-- `ind i x` is `1` when `x` is the item `i` and `0` otherwise: the unit
demand vector of `i`. -/
def ind (i x : Item) : ℚ := if x = i then 1 else 0

@[simp] theorem ind_self (i : Item) : ind i i = 1 := by simp [ind]

/-! ## The raw materials themselves -/

@[simp] theorem rd_ironOre (q : ℚ) (x : Item) : plant.rawDemand ironOre q x = q * ind ironOre x := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, ind]
  by_cases h : x = ironOre <;> simp [h]

@[simp] theorem lf_ironOre (q : ℚ) : plant.laborFor ironOre q = 0 := by
  rw [Plant.laborFor_eq]
  simp [plant_recipe, recipe]

@[simp] theorem rd_coal (q : ℚ) (x : Item) : plant.rawDemand coal q x = q * ind coal x := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, ind]
  by_cases h : x = coal <;> simp [h]

@[simp] theorem lf_coal (q : ℚ) : plant.laborFor coal q = 0 := by
  rw [Plant.laborFor_eq]
  simp [plant_recipe, recipe]

@[simp] theorem rd_limestone (q : ℚ) (x : Item) : plant.rawDemand limestone q x = q * ind limestone x := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, ind]
  by_cases h : x = limestone <;> simp [h]

@[simp] theorem lf_limestone (q : ℚ) : plant.laborFor limestone q = 0 := by
  rw [Plant.laborFor_eq]
  simp [plant_recipe, recipe]

@[simp] theorem rd_silicaSand (q : ℚ) (x : Item) : plant.rawDemand silicaSand q x = q * ind silicaSand x := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, ind]
  by_cases h : x = silicaSand <;> simp [h]

@[simp] theorem lf_silicaSand (q : ℚ) : plant.laborFor silicaSand q = 0 := by
  rw [Plant.laborFor_eq]
  simp [plant_recipe, recipe]

@[simp] theorem rd_crudeOil (q : ℚ) (x : Item) : plant.rawDemand crudeOil q x = q * ind crudeOil x := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, ind]
  by_cases h : x = crudeOil <;> simp [h]

@[simp] theorem lf_crudeOil (q : ℚ) : plant.laborFor crudeOil q = 0 := by
  rw [Plant.laborFor_eq]
  simp [plant_recipe, recipe]

@[simp] theorem rd_latex (q : ℚ) (x : Item) : plant.rawDemand latex q x = q * ind latex x := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, ind]
  by_cases h : x = latex <;> simp [h]

@[simp] theorem lf_latex (q : ℚ) : plant.laborFor latex q = 0 := by
  rw [Plant.laborFor_eq]
  simp [plant_recipe, recipe]

@[simp] theorem rd_copperOre (q : ℚ) (x : Item) : plant.rawDemand copperOre q x = q * ind copperOre x := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, ind]
  by_cases h : x = copperOre <;> simp [h]

@[simp] theorem lf_copperOre (q : ℚ) : plant.laborFor copperOre q = 0 := by
  rw [Plant.laborFor_eq]
  simp [plant_recipe, recipe]

/-! ## Mill goods, shop tools, catalogue stock and the assemblies -/

@[simp] theorem rd_coke (q : ℚ) (x : Item) :
    plant.rawDemand coke q x = q * (3/2 * ind coal x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_coal]
  ring

@[simp] theorem lf_coke (q : ℚ) : plant.laborFor coke q = q * (1/50) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_coal]
  ring

@[simp] theorem rd_pigIron (q : ℚ) (x : Item) :
    plant.rawDemand pigIron q x = q * (8/5 * ind ironOre x + 3/4 * ind coal x + 3/10 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_coke, rd_ironOre, rd_limestone]
  ring

@[simp] theorem lf_pigIron (q : ℚ) : plant.laborFor pigIron q = q * (3/100) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_coke, lf_ironOre, lf_limestone]
  ring

@[simp] theorem rd_steel (q : ℚ) (x : Item) :
    plant.rawDemand steel q x = q * (44/25 * ind ironOre x + 9/10 * ind coal x + 33/100 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_coke, rd_pigIron]
  ring

@[simp] theorem lf_steel (q : ℚ) : plant.laborFor steel q = q * (27/500) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_coke, lf_pigIron]
  ring

@[simp] theorem rd_hotStrip (q : ℚ) (x : Item) :
    plant.rawDemand hotStrip q x = q * (231/125 * ind ironOre x + 189/200 * ind coal x + 693/2000 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steel]
  ring

@[simp] theorem lf_hotStrip (q : ℚ) : plant.laborFor hotStrip q = q * (667/10000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steel]
  ring

@[simp] theorem rd_barStock (q : ℚ) (x : Item) :
    plant.rawDemand barStock q x = q * (231/125 * ind ironOre x + 189/200 * ind coal x + 693/2000 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steel]
  ring

@[simp] theorem lf_barStock (q : ℚ) : plant.laborFor barStock q = q * (667/10000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steel]
  ring

@[simp] theorem rd_wireRod (q : ℚ) (x : Item) :
    plant.rawDemand wireRod q x = q * (1133/625 * ind ironOre x + 927/1000 * ind coal x + 3399/10000 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steel]
  ring

@[simp] theorem lf_wireRod (q : ℚ) : plant.laborFor wireRod q = q * (3281/50000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steel]
  ring

@[simp] theorem rd_castIron (q : ℚ) (x : Item) :
    plant.rawDemand castIron q x = q * (42/25 * ind ironOre x + 63/80 * ind coal x + 63/200 * ind limestone x + 1/5 * ind silicaSand x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_pigIron, rd_silicaSand]
  ring

@[simp] theorem lf_castIron (q : ℚ) : plant.laborFor castIron q = q * (163/2000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_pigIron, lf_silicaSand]
  ring

@[simp] theorem rd_tubeStock (q : ℚ) (x : Item) :
    plant.rawDemand tubeStock q x = q * (11781/6250 * ind ironOre x + 9639/10000 * ind coal x + 35343/100000 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_hotStrip]
  ring

@[simp] theorem lf_tubeStock (q : ℚ) : plant.laborFor tubeStock q = q * (39017/500000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_hotStrip]
  ring

@[simp] theorem rd_plasticStock (q : ℚ) (x : Item) :
    plant.rawDemand plasticStock q x = q * (6/5 * ind crudeOil x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_crudeOil]
  ring

@[simp] theorem lf_plasticStock (q : ℚ) : plant.laborFor plasticStock q = q * (1/100) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_crudeOil]
  ring

@[simp] theorem rd_oilStock (q : ℚ) (x : Item) :
    plant.rawDemand oilStock q x = q * (13/10 * ind crudeOil x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_crudeOil]
  ring

@[simp] theorem lf_oilStock (q : ℚ) : plant.laborFor oilStock q = q * (1/100) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_crudeOil]
  ring

@[simp] theorem rd_rubberStock (q : ℚ) (x : Item) :
    plant.rawDemand rubberStock q x = q * (1/20 * ind coal x + 9/10 * ind latex x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_coal, rd_latex]
  ring

@[simp] theorem lf_rubberStock (q : ℚ) : plant.laborFor rubberStock q = q * (1/50) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_coal, lf_latex]
  ring

@[simp] theorem rd_copperStock (q : ℚ) (x : Item) :
    plant.rawDemand copperStock q x = q * (8 * ind copperOre x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_copperOre]
  ring

@[simp] theorem lf_copperStock (q : ℚ) : plant.laborFor copperStock q = q * (1/20) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_copperOre]
  ring

@[simp] theorem rd_weldingTable (q : ℚ) (x : Item) :
    plant.rawDemand weldingTable q x = q * (39501/250 * ind ironOre x + 32319/400 * ind coal x + 118503/4000 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_hotStrip, rd_tubeStock]
  ring

@[simp] theorem lf_weldingTable (q : ℚ) : plant.laborFor weldingTable q = q * (279057/20000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_hotStrip, lf_tubeStock]
  ring

@[simp] theorem rd_cutoffSaw (q : ℚ) (x : Item) :
    plant.rawDemand cutoffSaw q x = q * (2037/25 * ind ironOre x + 819/20 * ind coal x + 6111/400 * ind limestone x + 2 * ind silicaSand x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock, rd_castIron, rd_hotStrip]
  ring

@[simp] theorem lf_cutoffSaw (q : ℚ) : plant.laborFor cutoffSaw q = q * (26299/2000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock, lf_castIron, lf_hotStrip]
  ring

@[simp] theorem rd_drillPress (q : ℚ) (x : Item) :
    plant.rawDemand drillPress q x = q * (2604/25 * ind ironOre x + 252/5 * ind coal x + 1953/100 * ind limestone x + 8 * ind silicaSand x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock, rd_castIron]
  ring

@[simp] theorem lf_drillPress (q : ℚ) : plant.laborFor drillPress q = q * (8297/500) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock, lf_castIron]
  ring

@[simp] theorem rd_torchTable (q : ℚ) (x : Item) :
    plant.rawDemand torchTable q x = q * (151074/625 * ind ironOre x + 61803/500 * ind coal x + 226611/5000 * ind limestone x + 18/5 * ind crudeOil x + 16 * ind copperOre x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock, rd_copperStock, rd_hotStrip, rd_plasticStock, rd_tubeStock]
  ring

@[simp] theorem lf_torchTable (q : ℚ) : plant.laborFor torchTable q = q * (981359/25000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock, lf_copperStock, lf_hotStrip, lf_plasticStock, lf_tubeStock]
  ring

@[simp] theorem rd_pressBrake (q : ℚ) (x : Item) :
    plant.rawDemand pressBrake q x = q * (7392/25 * ind ironOre x + 756/5 * ind coal x + 1386/25 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock, rd_hotStrip]
  ring

@[simp] theorem lf_pressBrake (q : ℚ) : plant.laborFor pressBrake q = q * (3834/125) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock, lf_hotStrip]
  ring

@[simp] theorem rd_arborPress (q : ℚ) (x : Item) :
    plant.rawDemand arborPress q x = q * (1407/5 * ind ironOre x + 567/4 * ind coal x + 4221/80 * ind limestone x + 6 * ind silicaSand x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock, rd_castIron, rd_hotStrip]
  ring

@[simp] theorem lf_arborPress (q : ℚ) : plant.laborFor arborPress q = q * (13913/400) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock, lf_castIron, lf_hotStrip]
  ring

@[simp] theorem rd_ironworker (q : ℚ) (x : Item) :
    plant.rawDemand ironworker q x = q * (1323/5 * ind ironOre x + 1071/8 * ind coal x + 3969/80 * ind limestone x + 4 * ind silicaSand x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock, rd_castIron, rd_hotStrip]
  ring

@[simp] theorem lf_ironworker (q : ℚ) : plant.laborFor ironworker q = q * (14387/400) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock, lf_castIron, lf_hotStrip]
  ring

@[simp] theorem rd_wireDrawBench (q : ℚ) (x : Item) :
    plant.rawDemand wireDrawBench q x = q * (3402/25 * ind ironOre x + 5481/80 * ind coal x + 5103/200 * ind limestone x + 3 * ind silicaSand x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock, rd_castIron, rd_hotStrip]
  ring

@[simp] theorem lf_wireDrawBench (q : ℚ) : plant.laborFor wireDrawBench q = q * (38449/2000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock, lf_castIron, lf_hotStrip]
  ring

@[simp] theorem rd_blendingTank (q : ℚ) (x : Item) :
    plant.rawDemand blendingTank q x = q * (231/5 * ind ironOre x + 189/8 * ind coal x + 693/80 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_hotStrip]
  ring

@[simp] theorem lf_blendingTank (q : ℚ) : plant.laborFor blendingTank q = q * (2267/400) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_hotStrip]
  ring

@[simp] theorem rd_steelTube4 (q : ℚ) (x : Item) :
    plant.rawDemand steelTube4 q x = q * (553707/12500 * ind ironOre x + 453033/20000 * ind coal x + 1661121/200000 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_tubeStock]
  ring

@[simp] theorem lf_steelTube4 (q : ℚ) : plant.laborFor steelTube4 q = q * (1933799/1000000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_tubeStock]
  ring

@[simp] theorem rd_steelTube3 (q : ℚ) (x : Item) :
    plant.rawDemand steelTube3 q x = q * (1024947/31250 * ind ironOre x + 838593/50000 * ind coal x + 3074841/500000 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_tubeStock]
  ring

@[simp] theorem lf_steelTube3 (q : ℚ) : plant.laborFor steelTube3 q = q * (3644479/2500000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_tubeStock]
  ring

@[simp] theorem rd_steelTube2 (q : ℚ) (x : Item) :
    plant.rawDemand steelTube2 q x = q * (270963/15625 * ind ironOre x + 221697/25000 * ind coal x + 812889/250000 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_tubeStock]
  ring

@[simp] theorem lf_steelTube2 (q : ℚ) : plant.laborFor steelTube2 q = q * (1022391/1250000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_tubeStock]
  ring

@[simp] theorem rd_steelPlate6 (q : ℚ) (x : Item) :
    plant.rawDemand steelPlate6 q x = q * (11088/125 * ind ironOre x + 1134/25 * ind coal x + 2079/125 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_hotStrip]
  ring

@[simp] theorem lf_steelPlate6 (q : ℚ) : plant.laborFor steelPlate6 q = q * (2126/625) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_hotStrip]
  ring

@[simp] theorem rd_steelPlate12 (q : ℚ) (x : Item) :
    plant.rawDemand steelPlate12 q x = q * (22176/125 * ind ironOre x + 2268/25 * ind coal x + 4158/125 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_hotStrip]
  ring

@[simp] theorem lf_steelPlate12 (q : ℚ) : plant.laborFor steelPlate12 q = q * (16633/2500) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_hotStrip]
  ring

@[simp] theorem rd_roundBar50 (q : ℚ) (x : Item) :
    plant.rawDemand roundBar50 q x = q * (36267/1250 * ind ironOre x + 29673/2000 * ind coal x + 108801/20000 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock]
  ring

@[simp] theorem lf_roundBar50 (q : ℚ) : plant.laborFor roundBar50 q = q * (114719/100000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock]
  ring

@[simp] theorem rd_boltM12 (q : ℚ) (x : Item) :
    plant.rawDemand boltM12 q x = q * (693/3125 * ind ironOre x + 567/5000 * ind coal x + 2079/50000 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock]
  ring

@[simp] theorem lf_boltM12 (q : ℚ) : plant.laborFor boltM12 q = q * (4501/250000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock]
  ring

@[simp] theorem rd_nutM12 (q : ℚ) (x : Item) :
    plant.rawDemand nutM12 q x = q * (231/3125 * ind ironOre x + 189/5000 * ind coal x + 693/50000 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock]
  ring

@[simp] theorem lf_nutM12 (q : ℚ) : plant.laborFor nutM12 q = q * (1917/250000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock]
  ring

@[simp] theorem rd_weldWire (q : ℚ) (x : Item) :
    plant.rawDemand weldWire q x = q * (23793/12500 * ind ironOre x + 19467/20000 * ind coal x + 71379/200000 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_wireRod]
  ring

@[simp] theorem lf_weldWire (q : ℚ) : plant.laborFor weldWire q = q * (118901/1000000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_wireRod]
  ring

@[simp] theorem rd_hose (q : ℚ) (x : Item) :
    plant.rawDemand hose q x = q * (1133/3125 * ind ironOre x + 2229/10000 * ind coal x + 3399/50000 * ind limestone x + 27/40 * ind latex x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_rubberStock, rd_wireRod]
  ring

@[simp] theorem lf_hose (q : ℚ) : plant.laborFor hose q = q * (19531/250000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_rubberStock, lf_wireRod]
  ring

@[simp] theorem rd_fitting (q : ℚ) (x : Item) :
    plant.rawDemand fitting q x = q * (2079/6250 * ind ironOre x + 1701/10000 * ind coal x + 6237/100000 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock]
  ring

@[simp] theorem lf_fitting (q : ℚ) : plant.laborFor fitting q = q * (56003/500000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock]
  ring

@[simp] theorem rd_fluid (q : ℚ) (x : Item) :
    plant.rawDemand fluid q x = q * (117/100 * ind crudeOil x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_oilStock]
  ring

@[simp] theorem lf_fluid (q : ℚ) : plant.laborFor fluid q = q * (19/1000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_oilStock]
  ring

@[simp] theorem rd_paint (q : ℚ) (x : Item) :
    plant.rawDemand paint q x = q * (1/10 * ind limestone x + 38/25 * ind crudeOil x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_limestone, rd_oilStock, rd_plasticStock]
  ring

@[simp] theorem lf_paint (q : ℚ) : plant.laborFor paint q = q * (11/500) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_limestone, lf_oilStock, lf_plasticStock]
  ring

@[simp] theorem rd_wheelHub (q : ℚ) (x : Item) :
    plant.rawDemand wheelHub q x = q * (2793/125 * ind ironOre x + 1071/100 * ind coal x + 8379/2000 * ind limestone x + 2 * ind silicaSand x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock, rd_castIron]
  ring

@[simp] theorem lf_wheelHub (q : ℚ) : plant.laborFor wheelHub q = q * (25151/10000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock, lf_castIron]
  ring

@[simp] theorem rd_tire (q : ℚ) (x : Item) :
    plant.rawDemand tire q x = q * (19569/625 * ind ironOre x + 17511/1000 * ind coal x + 58707/10000 * ind limestone x + 27 * ind latex x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_hotStrip, rd_rubberStock, rd_wireRod]
  ring

@[simp] theorem lf_tire (q : ℚ) : plant.laborFor tire q = q * (186533/50000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_hotStrip, lf_rubberStock, lf_wireRod]
  ring

@[simp] theorem rd_seat (q : ℚ) (x : Item) :
    plant.rawDemand seat q x = q * (231/25 * ind ironOre x + 193/40 * ind coal x + 693/400 * ind limestone x + 12/5 * ind crudeOil x + 9/5 * ind latex x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_hotStrip, rd_plasticStock, rd_rubberStock]
  ring

@[simp] theorem lf_seat (q : ℚ) : plant.laborFor seat q = q * (3787/2000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_hotStrip, lf_plasticStock, lf_rubberStock]
  ring

@[simp] theorem rd_fuelTank (q : ℚ) (x : Item) :
    plant.rawDemand fuelTank q x = q * (2079/125 * ind ironOre x + 1701/200 * ind coal x + 6237/2000 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_hotStrip]
  ring

@[simp] theorem lf_fuelTank (q : ℚ) : plant.laborFor fuelTank q = q * (26003/10000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_hotStrip]
  ring

@[simp] theorem rd_hydraulicTank (q : ℚ) (x : Item) :
    plant.rawDemand hydraulicTank q x = q * (7623/250 * ind ironOre x + 6237/400 * ind coal x + 22869/4000 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_hotStrip]
  ring

@[simp] theorem lf_hydraulicTank (q : ℚ) : plant.laborFor hydraulicTank q = q * (82011/20000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_hotStrip]
  ring

@[simp] theorem rd_gearPump (q : ℚ) (x : Item) :
    plant.rawDemand gearPump q x = q * (2604/125 * ind ironOre x + 2019/200 * ind coal x + 1953/500 * ind limestone x + 8/5 * ind silicaSand x + 27/100 * ind latex x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock, rd_castIron, rd_rubberStock]
  ring

@[simp] theorem lf_gearPump (q : ℚ) : plant.laborFor gearPump q = q * (4328/625) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock, lf_castIron, lf_rubberStock]
  ring

@[simp] theorem rd_wheelMotor (q : ℚ) (x : Item) :
    plant.rawDemand wheelMotor q x = q * (6279/125 * ind ironOre x + 607/25 * ind coal x + 18837/2000 * ind limestone x + 4 * ind silicaSand x + 9/20 * ind latex x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock, rd_castIron, rd_rubberStock]
  ring

@[simp] theorem lf_wheelMotor (q : ℚ) : plant.laborFor wheelMotor q = q * (122403/10000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock, lf_castIron, lf_rubberStock]
  ring

@[simp] theorem rd_cylinder (q : ℚ) (x : Item) :
    plant.rawDemand cylinder q x = q * (22176/625 * ind ironOre x + 4541/250 * ind coal x + 4158/625 * ind limestone x + 9/25 * ind latex x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock, rd_rubberStock, rd_tubeStock]
  ring

@[simp] theorem lf_cylinder (q : ℚ) : plant.laborFor cylinder q = q * (39929/6250) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock, lf_rubberStock, lf_tubeStock]
  ring

@[simp] theorem rd_controlValve (q : ℚ) (x : Item) :
    plant.rawDemand controlValve q x = q * (609/25 * ind ironOre x + 4729/400 * ind coal x + 1827/400 * ind limestone x + 9/5 * ind silicaSand x + 9/50 * ind latex x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock, rd_castIron, rd_rubberStock]
  ring

@[simp] theorem lf_controlValve (q : ℚ) : plant.laborFor controlValve q = q * (9071/1000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock, lf_castIron, lf_rubberStock]
  ring

@[simp] theorem rd_electricalKit (q : ℚ) (x : Item) :
    plant.rawDemand electricalKit q x = q * (693/125 * ind ironOre x + 567/200 * ind coal x + 2079/2000 * ind limestone x + 9/5 * ind crudeOil x + 16 * ind copperOre x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_copperStock, rd_hotStrip, rd_plasticStock]
  ring

@[simp] theorem lf_electricalKit (q : ℚ) : plant.laborFor electricalKit q = q * (33151/10000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_copperStock, lf_hotStrip, lf_plasticStock]
  ring

@[simp] theorem rd_engine (q : ℚ) (x : Item) :
    plant.rawDemand engine q x = q * (6321/25 * ind ironOre x + 2459/20 * ind coal x + 18963/400 * ind limestone x + 18 * ind silicaSand x + 24/5 * ind crudeOil x + 9/5 * ind latex x + 40 * ind copperOre x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_barStock, rd_castIron, rd_copperStock, rd_hotStrip, rd_plasticStock, rd_rubberStock]
  ring

@[simp] theorem lf_engine (q : ℚ) : plant.laborFor engine q = q * (142667/2000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_barStock, lf_castIron, lf_copperStock, lf_hotStrip, lf_plasticStock, lf_rubberStock]
  ring

@[simp] theorem rd_frame (q : ℚ) (x : Item) :
    plant.rawDemand frame q x = q * (29695281/31250 * ind ironOre x + 24296139/50000 * ind coal x + 89085843/500000 * ind limestone x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_boltM12, rd_nutM12, rd_steelPlate6, rd_steelTube3, rd_steelTube4, rd_weldWire]
  ring

@[simp] theorem lf_frame (q : ℚ) : plant.laborFor frame q = q * (164276517/2500000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_boltM12, lf_nutM12, lf_steelPlate6, lf_steelTube3, lf_steelTube4, lf_weldWire]
  ring

@[simp] theorem rd_wheelModule (q : ℚ) (x : Item) :
    plant.rawDemand wheelModule q x = q * (451607/3125 * ind ironOre x + 367133/5000 * ind coal x + 1354821/50000 * ind limestone x + 6 * ind silicaSand x + 603/20 * ind latex x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_boltM12, rd_fitting, rd_hose, rd_nutM12, rd_steelPlate12, rd_tire, rd_wheelHub, rd_wheelMotor]
  ring

@[simp] theorem lf_wheelModule (q : ℚ) : plant.laborFor wheelModule q = q * (6195649/250000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_boltM12, lf_fitting, lf_hose, lf_nutM12, lf_steelPlate12, lf_tire, lf_wheelHub, lf_wheelMotor]
  ring

@[simp] theorem rd_powerUnit (q : ℚ) (x : Item) :
    plant.rawDemand powerUnit q x = q * (2341971/6250 * ind ironOre x + 1849399/10000 * ind coal x + 7025913/100000 * ind limestone x + 98/5 * ind silicaSand x + 258/5 * ind crudeOil x + 153/25 * ind latex x + 40 * ind copperOre x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_boltM12, rd_engine, rd_fitting, rd_fluid, rd_fuelTank, rd_gearPump, rd_hose, rd_hydraulicTank, rd_nutM12, rd_steelPlate6]
  ring

@[simp] theorem lf_powerUnit (q : ℚ) : plant.laborFor powerUnit q = q * (50597747/500000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_boltM12, lf_engine, lf_fitting, lf_fluid, lf_fuelTank, lf_gearPump, lf_hose, lf_hydraulicTank, lf_nutM12, lf_steelPlate6]
  ring

@[simp] theorem rd_controlStation (q : ℚ) (x : Item) :
    plant.rawDemand controlStation q x = q * (2792488/15625 * ind ironOre x + 1132461/12500 * ind coal x + 1047183/31250 * ind limestone x + 18/5 * ind silicaSand x + 21/5 * ind crudeOil x + 891/100 * ind latex x + 16 * ind copperOre x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_boltM12, rd_controlValve, rd_electricalKit, rd_fitting, rd_hose, rd_nutM12, rd_seat, rd_steelTube2]
  ring

@[simp] theorem lf_controlStation (q : ℚ) : plant.laborFor controlStation q = q * (12091079/312500) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_boltM12, lf_controlValve, lf_electricalKit, lf_fitting, lf_hose, lf_nutM12, lf_seat, lf_steelTube2]
  ring

@[simp] theorem rd_loader (q : ℚ) (x : Item) :
    plant.rawDemand loader q x = q * (8366171/15625 * ind ironOre x + 6853549/25000 * ind coal x + 25098513/250000 * ind limestone x + 153/25 * ind latex x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_cylinder, rd_fitting, rd_hose, rd_roundBar50, rd_steelPlate12, rd_steelTube3, rd_weldWire]
  ring

@[simp] theorem lf_loader (q : ℚ) : plant.laborFor loader q = q * (61382997/1250000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_cylinder, lf_fitting, lf_hose, lf_roundBar50, lf_steelPlate12, lf_steelTube3, lf_weldWire]
  ring

@[simp] theorem rd_finishing (q : ℚ) (x : Item) :
    plant.rawDemand finishing q x = q * (3696/625 * ind ironOre x + 378/125 * ind coal x + 1193/625 * ind limestone x + 304/25 * ind crudeOil x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_boltM12, rd_nutM12, rd_paint]
  ring

@[simp] theorem lf_finishing (q : ℚ) : plant.laborFor finishing q = q * (41809/6250) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_boltM12, lf_nutM12, lf_paint]
  ring

@[simp] theorem rd_lifeTrac (q : ℚ) (x : Item) :
    plant.rawDemand lifeTrac q x = q * (40985767/15625 * ind ironOre x + 16654149/12500 * ind coal x + 123157301/250000 * ind limestone x + 236/5 * ind silicaSand x + 1699/25 * ind crudeOil x + 567/4 * ind latex x + 56 * ind copperOre x) := by
  rw [Plant.rawDemand_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_controlStation, rd_finishing, rd_frame, rd_loader, rd_powerUnit, rd_wheelModule]
  ring

@[simp] theorem lf_lifeTrac (q : ℚ) : plant.laborFor lifeTrac q = q * (463154719/1250000) := by
  rw [Plant.laborFor_eq]
  simp only [plant_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_controlStation, lf_finishing, lf_frame, lf_loader, lf_powerUnit, lf_wheelModule]
  ring

end Workflow
end LifeTrac
