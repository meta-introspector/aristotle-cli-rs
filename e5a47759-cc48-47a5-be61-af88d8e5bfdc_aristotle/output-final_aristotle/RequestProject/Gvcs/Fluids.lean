import RequestProject.Gvcs.Sources
import RequestProject.Gvcs.Farm
import RequestProject.Gvcs.Circuit

/-!
# Making the fluids on the farm: hydraulic oil, fuel, and the alternatives

Everything else in this project assumes two liquids arrive from somewhere: the
**40 litres of hydraulic fluid** the power unit is charged with
(`RequestProject/Materials.lean`, `powerUnit`) and the **18 litres of fuel a
hectare** a season of wheat burns (`RequestProject/Farm.lean`, `wheat`).  In
the industrial account of `RequestProject/Fabrication.lean` both come out of a
barrel of crude: `fluid` is blended from `oilStock`, and the fuel is bought.
This file asks the open-source-hardware question instead — *can the farm make
them itself, and at what cost in land?* — and answers it with numbers.

## What is modelled

* **Oilseed** (`Oilseed`): seed yield per hectare, oil fraction of the seed and
  the fraction of that oil a cold screw press actually recovers.  Two crops,
  `rapeseed` and `sunflower`.  Everything downstream is litres of pressed oil
  per hectare, `Oilseed.oilPerHa`.
* **Hydraulic fluid**: filtered, degummed vegetable oil — the commercial
  article is an ISO 15380 HETG fluid.  `fluidYield` is the litre-for-litre loss
  in cleaning it up; `fillArea` is the land one 40-litre charge takes.
  `rapeseedOil40` and `mineralISO46` compare the two liquids inside the circuit
  model of `RequestProject/Circuit.lean`.
* **Fuel**, four routes: fatty-acid methyl ester (biodiesel) via
  `biodieselYield`; straight vegetable oil in a heated two-tank system;
  grain ethanol; and wood — either producer gas straight off the hearth or
  charcoal gas off the retort of `RequestProject/Sources.lean`.
* **Electricity**: the same field work done as shaft energy from the
  photovoltaic array of `RequestProject/Sources.lean`.

Every route is reduced to the same currency, **litres of diesel equivalent**
(`dieselLhv`), and then to **hectares**, so that the routes can be compared.

## The answers, in one place

For the 20-hectare, 360-litre season of `RequestProject/Game.lean`:

* one hectare of rapeseed presses 1027 L of oil, which is 986 L of ester, which
  is 909 L of diesel equivalent (`rapeseed_dieselEquivPerHa_bounds`);
* the season therefore needs **0.40 ha** of rapeseed (`season_oilseedArea_bounds`),
  i.e. a farm that fuels itself gives up **under 2 % of its land**
  (`rapeseed_selfFuel_fraction_lt_two_percent`) — and gets the press cake back
  as fodder;
* the 40-litre hydraulic charge takes **under 400 m²** (`fillArea_lt_400_m2`);
* burning the oil straight beats esterifying it, per hectare
  (`svo_beats_biodiesel_per_ha`), and avoids the methanol, which is the one
  input the ester route cannot press: made as wood alcohol it costs another
  **0.28 ha** of coppice (`season_methanolWood_hectareYears_lt`);
* **wood gas is the land-cheapest liquid-free route**: 0.15 ha of coppice
  against 0.40 ha of oilseed (`woodGas_beats_oilseed_on_land`), and going by
  way of charcoal doubles that (`charcoal_costs_more_wood_than_woodGas`);
* and **electric field work is not land-limited at all**: 6.4 m² of panel
  (`season_pvArea_bounds`) — the constraint there is the battery and the
  drive train, not the sun.

Units: kilograms, litres, hectares, kilowatt-hours; energies per litre in
megajoules.  The agronomy is ordinary temperate practice, not a quotation from
a particular farm.
-/

namespace LifeTrac
namespace Fluids

open EnergySupply

/-! ## Oilseed and the press -/

/-- An oilseed crop, from the point of view of the press. -/
structure Oilseed where
  /-- Name of the crop. -/
  name : String
  /-- Seed harvested, kilograms per hectare. -/
  seedYieldPerHa : ℚ
  /-- Oil as a fraction of the mass of the seed. -/
  oilFraction : ℚ
  /-- The fraction of that oil a cold screw press actually gets out; the rest
  stays in the cake. -/
  pressYield : ℚ

/-- Density of vegetable oil, kilograms per litre. -/
def oilDensity : ℚ := 23/25

namespace Oilseed

variable (s : Oilseed)

/-- Oil pressed from a hectare, in kilograms. -/
def oilMassPerHa : ℚ := s.seedYieldPerHa * s.oilFraction * s.pressYield

/-- Oil pressed from a hectare, in litres. -/
def oilPerHa : ℚ := s.oilMassPerHa / oilDensity

/-- Press cake left over from a hectare, in kilograms: high-protein stock feed,
and the reason the land is not really lost. -/
def cakePerHa : ℚ := s.seedYieldPerHa - s.oilMassPerHa

end Oilseed

/-- Winter rapeseed: 3 t/ha of seed at 42 % oil, three quarters of it pressed
out cold. -/
def rapeseed : Oilseed where
  name := "rapeseed"
  seedYieldPerHa := 3000
  oilFraction := 21/50
  pressYield := 3/4

/-- Sunflower: 2.2 t/ha at 44 % oil, same press. -/
def sunflower : Oilseed where
  name := "sunflower"
  seedYieldPerHa := 2200
  oilFraction := 11/25
  pressYield := 3/4

theorem rapeseed_oilMassPerHa : rapeseed.oilMassPerHa = 945 := by
  norm_num [Oilseed.oilMassPerHa, rapeseed]

theorem rapeseed_oilPerHa : rapeseed.oilPerHa = 23625/23 := by
  norm_num [Oilseed.oilPerHa, Oilseed.oilMassPerHa, rapeseed, oilDensity]

/-- A hectare of rapeseed presses out a little over 1027 litres of oil. -/
theorem rapeseed_oilPerHa_bounds : 1027 < rapeseed.oilPerHa ∧ rapeseed.oilPerHa < 1028 := by
  rw [rapeseed_oilPerHa]; constructor <;> norm_num

theorem sunflower_oilPerHa : sunflower.oilPerHa = 18150/23 := by
  norm_num [Oilseed.oilPerHa, Oilseed.oilMassPerHa, sunflower, oilDensity]

/-- Rapeseed out-presses sunflower per hectare, on these yields. -/
theorem rapeseed_beats_sunflower : sunflower.oilPerHa < rapeseed.oilPerHa := by
  rw [rapeseed_oilPerHa, sunflower_oilPerHa]; norm_num

/-- Two tonnes of cake come back off a hectare of rapeseed. -/
theorem rapeseed_cakePerHa : rapeseed.cakePerHa = 2055 := by
  norm_num [Oilseed.cakePerHa, Oilseed.oilMassPerHa, rapeseed]

/-! ## Hydraulic fluid

Degummed, filtered vegetable oil is a real hydraulic fluid: the ISO 15380
HETG class.  Its drawbacks are oxidation in a hot reservoir and pour point in
winter, not its behaviour in the circuit — see `vegOil_thinner_than_mineral`
below.  The blend is 98 % of the pressed oil after degumming and filtration;
the additive package (antioxidant, anti-wear) is the one bought-in part, at a
couple of per cent by volume. -/

/-- Litres of finished fluid per litre of pressed oil. -/
def fluidYield : ℚ := 49/50

/-- The hydraulic charge of the power unit of `RequestProject/Materials.lean`,
in litres. -/
def reservoir : ℚ := 40

/-- Hectares of oilseed behind one full hydraulic charge. -/
def fillArea (s : Oilseed) : ℚ := reservoir / (fluidYield * s.oilPerHa)

/-- **One charge of hydraulic oil is under four hundred square metres of
rape.**  Four hundred square metres is 0.04 hectares. -/
theorem fillArea_lt_400_m2 : fillArea rapeseed < 1/25 := by
  rw [fillArea, rapeseed_oilPerHa, fluidYield, reservoir]; norm_num

/-- Rape oil at working temperature: 35 cSt at 920 kg/m³, so 0.0322 Pa·s. -/
noncomputable def rapeseedOil40 : Fluid where
  visc := 0.0322
  dens := 920
  heatCap := 1900
  visc_pos := by norm_num
  dens_pos := by norm_num
  heatCap_pos := by norm_num

/-- Mineral ISO VG 46 at the same temperature: 46 cSt at 870 kg/m³. -/
noncomputable def mineralISO46 : Fluid where
  visc := 0.04
  dens := 870
  heatCap := 1900
  visc_pos := by norm_num
  dens_pos := by norm_num
  heatCap_pos := by norm_num

/-- **At working temperature the vegetable oil is the thinner of the two**, so
every hose in the machine wastes less pressure on it than on mineral VG 46.
(The cold end is the problem with HETG fluids, not the hot end.) -/
theorem vegOil_thinner_than_mineral (h : Hose) {Q : ℝ} (hQ : 0 < Q) :
    h.pressureDrop rapeseedOil40 Q < h.pressureDrop mineralISO46 Q := by
  have hr := h.radius_pos
  have hl := h.length_pos
  unfold Hose.pressureDrop rapeseedOil40 mineralISO46
  have hden : (0:ℝ) < Real.pi * h.radius ^ 4 := by positivity
  rw [div_lt_div_iff_of_pos_right hden]
  nlinarith [hl, hQ, Real.pi_pos]

/-! ## Fuel: the four routes

Lower heating values, megajoules per litre. -/

/-- Diesel: 35.8 MJ/L. -/
def dieselLhv : ℚ := 179/5
/-- Fatty-acid methyl ester (biodiesel): 33 MJ/L. -/
def biodieselLhv : ℚ := 33
/-- Straight vegetable oil: 34.3 MJ/L. -/
def svoLhv : ℚ := 343/10
/-- Ethanol: 21.2 MJ/L. -/
def ethanolLhv : ℚ := 106/5

/-- Litres of methyl ester per litre of oil transesterified. -/
def biodieselYield : ℚ := 24/25

namespace Oilseed

variable (s : Oilseed)

/-- Litres of biodiesel a hectare yields. -/
def biodieselPerHa : ℚ := biodieselYield * s.oilPerHa

/-- The ester route, in litres of diesel equivalent per hectare. -/
def esterDieselEquivPerHa : ℚ := s.biodieselPerHa * biodieselLhv / dieselLhv

/-- The straight-vegetable-oil route, in litres of diesel equivalent per
hectare. -/
def svoDieselEquivPerHa : ℚ := s.oilPerHa * svoLhv / dieselLhv

end Oilseed

theorem rapeseed_biodieselPerHa : rapeseed.biodieselPerHa = 22680/23 := by
  rw [Oilseed.biodieselPerHa, rapeseed_oilPerHa, biodieselYield]; norm_num

theorem rapeseed_esterDieselEquivPerHa : rapeseed.esterDieselEquivPerHa = 3742200/4117 := by
  rw [Oilseed.esterDieselEquivPerHa, rapeseed_biodieselPerHa, biodieselLhv, dieselLhv]
  norm_num

/-- **A hectare of rape is about 909 litres of diesel.** -/
theorem rapeseed_dieselEquivPerHa_bounds :
    908 < rapeseed.esterDieselEquivPerHa ∧ rapeseed.esterDieselEquivPerHa < 909 := by
  rw [rapeseed_esterDieselEquivPerHa]; constructor <;> norm_num

theorem rapeseed_svoDieselEquivPerHa : rapeseed.svoDieselEquivPerHa = 8103375/8234 := by
  rw [Oilseed.svoDieselEquivPerHa, rapeseed_oilPerHa, svoLhv, dieselLhv]; norm_num

/-- **Burning the oil straight beats making esters of it**, hectare for
hectare: the ester loses 4 % of the volume and 4 % of the heating value, and
neither comes back.  What the ester buys is cold-weather starting and an
engine that needs no second tank. -/
theorem svo_beats_biodiesel_per_ha (s : Oilseed) (h : 0 < s.oilPerHa) :
    s.esterDieselEquivPerHa < s.svoDieselEquivPerHa := by
  rw [Oilseed.esterDieselEquivPerHa, Oilseed.svoDieselEquivPerHa, Oilseed.biodieselPerHa,
    biodieselYield, biodieselLhv, svoLhv, dieselLhv]
  rw [div_lt_div_iff_of_pos_right (by norm_num : (0:ℚ) < 179/5)]
  linarith

/-! ## The season, and how much land fuels it -/

/-- The farm of `RequestProject/Game.lean`: twenty hectares. -/
def farmArea : ℚ := 20

/-- The season's fuel, in litres: twenty hectares of wheat at 18 L/ha. -/
def seasonDiesel : ℚ := farmArea * Build.wheat.fuelPerHa

theorem seasonDiesel_eq : seasonDiesel = 360 := by
  rw [seasonDiesel, Build.wheat_fuelPerHa, farmArea]; norm_num

/-- Hectares of oilseed, on the ester route, behind `litres` of diesel. -/
def oilseedAreaFor (s : Oilseed) (litres : ℚ) : ℚ := litres / s.esterDieselEquivPerHa

/-- **The season runs on two fifths of a hectare of rape.** -/
theorem season_oilseedArea_bounds :
    39/100 < oilseedAreaFor rapeseed seasonDiesel ∧
      oilseedAreaFor rapeseed seasonDiesel < 2/5 := by
  rw [oilseedAreaFor, seasonDiesel_eq, rapeseed_esterDieselEquivPerHa]
  constructor <;> norm_num

/-- The oilseed area a farm of `A` hectares must set aside to fuel *all* `A`
hectares, itself included, at `fuelHa` litres to the hectare. -/
def selfFuelArea (s : Oilseed) (fuelHa A : ℚ) : ℚ := fuelHa * A / s.esterDieselEquivPerHa

/-- The fixed point closes: what that area produces is exactly what the whole
farm burns. -/
theorem selfFuelArea_balances (s : Oilseed) (fuelHa A : ℚ)
    (h : s.esterDieselEquivPerHa ≠ 0) :
    selfFuelArea s fuelHa A * s.esterDieselEquivPerHa = fuelHa * A := by
  rw [selfFuelArea, div_mul_cancel₀ _ h]

/-- **Fuel self-sufficiency costs a wheat farm under 2 % of its land.** -/
theorem rapeseed_selfFuel_fraction_lt_two_percent {A : ℚ} (hA : 0 < A) :
    selfFuelArea rapeseed 18 A / A < 1/50 := by
  rw [selfFuelArea, rapeseed_esterDieselEquivPerHa, div_div,
    div_lt_div_iff₀ (by positivity) (by norm_num)]
  nlinarith

/-! ## Methanol: the one input the press cannot make

Transesterification wants about 0.1 kg of methanol per litre of oil (the
stoichiometric ratio is near 11 % by mass; the working excess is recovered and
recycled).  Methanol is *wood* alcohol: the same retort that makes the charcoal
of `RequestProject/Sources.lean` condenses it out of the pyroligneous acid, at
about 1.5 % of the dry mass of the wood.  Lye for the catalyst comes from wood
ash. -/

/-- Kilograms of methanol per litre of oil esterified. -/
def methanolPerLitreOil : ℚ := 1/10

/-- Kilograms of methanol condensed per kilogram of dry wood in the retort. -/
def woodMethanolYield : ℚ := 3/200

/-- Kilograms of wood behind the methanol for `oilL` litres of oil. -/
def woodForMethanol (oilL : ℚ) : ℚ := oilL * methanolPerLitreOil / woodMethanolYield

/-- Litres of oil the season's fuel takes, by the ester route. -/
def seasonOil : ℚ := seasonDiesel * dieselLhv / biodieselLhv / biodieselYield

theorem seasonOil_eq : seasonOil = 8950/22 := by
  rw [seasonOil, seasonDiesel_eq, dieselLhv, biodieselLhv, biodieselYield]; norm_num

/-- **The methanol is another quarter-hectare of coppice.**  `hectareYields`
here is `EnergySupply.hectareYears`: hectare-years of coppice at 10 t/ha·yr. -/
theorem season_methanolWood_hectareYears_lt :
    hectareYears (woodForMethanol seasonOil) < 7/25 := by
  rw [hectareYears, woodForMethanol, seasonOil_eq, methanolPerLitreOil, woodMethanolYield,
    coppiceYield]
  norm_num

/-- And that is the ester route's whole extra land bill: it is smaller than the
oilseed itself, but it is not nothing, which is the argument for burning the
oil straight. -/
theorem methanolWood_less_land_than_oilseed :
    hectareYears (woodForMethanol seasonOil) < oilseedAreaFor rapeseed seasonDiesel := by
  rw [hectareYears, woodForMethanol, seasonOil_eq, methanolPerLitreOil, woodMethanolYield,
    coppiceYield, oilseedAreaFor, seasonDiesel_eq, rapeseed_esterDieselEquivPerHa]
  norm_num

/-! ## Ethanol from the grain -/

/-- Litres of anhydrous ethanol per tonne of grain. -/
def ethanolPerTonneGrain : ℚ := 370

/-- Litres of ethanol a hectare of the wheat of `RequestProject/Farm.lean`
would make, if the grain went to the still instead of the market. -/
def ethanolPerHa : ℚ := Build.wheat.yieldPerHa * ethanolPerTonneGrain

/-- That ethanol, in litres of diesel equivalent. -/
def ethanolDieselEquivPerHa : ℚ := ethanolPerHa * ethanolLhv / dieselLhv

theorem ethanolPerHa_eq : ethanolPerHa = 1480 := by
  norm_num [ethanolPerHa, ethanolPerTonneGrain, Build.wheat]

theorem ethanolDieselEquivPerHa_eq : ethanolDieselEquivPerHa = 156880/179 := by
  rw [ethanolDieselEquivPerHa, ethanolPerHa_eq, ethanolLhv, dieselLhv]; norm_num

/-- **Grain ethanol is slightly worse land than oilseed**, and worse still than
the comparison suggests: ethanol will not run a compression-ignition engine
without conversion, whereas the oil will.  Its place on this farm is the spark
engine, the solvent bench, and — as ethyl ester — a way out of buying
methanol. -/
theorem oilseed_beats_ethanol : ethanolDieselEquivPerHa < rapeseed.esterDieselEquivPerHa := by
  rw [ethanolDieselEquivPerHa_eq, rapeseed_esterDieselEquivPerHa]; norm_num

/-! ## Wood: producer gas and charcoal gas

No liquid at all.  A hearth gasifier makes producer gas from air-dried wood and
the engine runs on it at the `woodGasSet` efficiency of
`RequestProject/Sources.lean`; the retort route burns charcoal instead, which
stores and filters far better but throws away three quarters of the wood. -/

/-- Efficiency of the diesel engine the fuel figures assume. -/
def dieselEff : ℚ := 7/20

/-- Shaft kilowatt-hours got from burning one litre of diesel. -/
def dieselShaftPerLitre : ℚ := dieselLhv / (18/5) * dieselEff

theorem dieselShaftPerLitre_eq : dieselShaftPerLitre = 1253/360 := by
  rw [dieselShaftPerLitre, dieselLhv, dieselEff]; norm_num

/-- Kilograms of air-dried wood, gasified, that do the work of a litre of
diesel. -/
def woodPerDieselLitre : ℚ := dieselShaftPerLitre / (firewood.lhv * woodGasSet.eff)

theorem woodPerDieselLitre_eq : woodPerDieselLitre = 6265/1512 := by
  rw [woodPerDieselLitre, dieselShaftPerLitre_eq, firewood, woodGasSet]; norm_num

/-- Four kilograms of wood to the litre. -/
theorem woodPerDieselLitre_bounds : 4 < woodPerDieselLitre ∧ woodPerDieselLitre < 42/10 := by
  rw [woodPerDieselLitre_eq]; constructor <;> norm_num

/-- Wood the whole season takes on the gasifier. -/
def seasonWood : ℚ := seasonDiesel * woodPerDieselLitre

theorem seasonWood_bounds : 1491 < seasonWood ∧ seasonWood < 1492 := by
  rw [seasonWood, seasonDiesel_eq, woodPerDieselLitre_eq]; constructor <;> norm_num

/-- **Wood gas is the land-cheapest route of the lot**: 0.15 hectare-years of
coppice against 0.40 hectares of rape. -/
theorem woodGas_beats_oilseed_on_land :
    hectareYears seasonWood < oilseedAreaFor rapeseed seasonDiesel := by
  simp only [hectareYears, coppiceYield, seasonWood, seasonDiesel_eq, woodPerDieselLitre_eq,
    oilseedAreaFor, rapeseed_esterDieselEquivPerHa]
  norm_num

theorem seasonWood_hectareYears_lt : hectareYears seasonWood < 3/20 := by
  rw [hectareYears, coppiceYield, seasonWood, seasonDiesel_eq, woodPerDieselLitre_eq]
  norm_num

/-- Kilograms of charcoal that do the work of a litre of diesel, in the same
engine. -/
def charcoalPerDieselLitre : ℚ := dieselShaftPerLitre / (charcoal.lhv * woodGasSet.eff)

theorem charcoalPerDieselLitre_eq : charcoalPerDieselLitre = 1253/594 := by
  rw [charcoalPerDieselLitre, dieselShaftPerLitre_eq, charcoal, woodGasSet]; norm_num

/-- Wood the season takes if the gas is made from charcoal, at the retort yield
of `RequestProject/Sources.lean`. -/
def seasonCharcoalWood : ℚ := seasonDiesel * charcoalPerDieselLitre / charcoalYield

/-- **The retort doubles the woodpile.**  Charcoal gas is cleaner, stores, and
carries in a sack; direct wood gas is half the wood. -/
theorem charcoal_costs_more_wood_than_woodGas : seasonWood < seasonCharcoalWood := by
  rw [seasonWood, seasonCharcoalWood, seasonDiesel_eq, woodPerDieselLitre_eq,
    charcoalPerDieselLitre_eq, charcoalYield]
  norm_num

/-! ## Electricity -/

/-- Shaft kilowatt-hours of field work in the season. -/
def seasonShaft : ℚ := seasonDiesel * dieselShaftPerLitre

theorem seasonShaft_eq : seasonShaft = 1253 := by
  rw [seasonShaft, seasonDiesel_eq, dieselShaftPerLitre_eq]; norm_num

/-- **Six and a half square metres of panel do the season's work.**  Land is
not what limits the electric route; storage and the drive train are.  `areaFor`
is the array sizing of `RequestProject/Sources.lean`, in square metres of
module for a year's output. -/
theorem season_pvArea_bounds : 6 < areaFor seasonShaft ∧ areaFor seasonShaft < 13/2 := by
  rw [areaFor, seasonShaft_eq, peakSunHours]; constructor <;> norm_num

/-- The panel is a hundredth of the oilseed even after allowing a factor of a
hundred for mounting, battery and conversion losses (`areaFor` is in square
metres; a hectare is ten thousand of them). -/
theorem pv_land_far_below_oilseed :
    100 * (areaFor seasonShaft / 10000) < oilseedAreaFor rapeseed seasonDiesel := by
  simp only [areaFor, seasonShaft_eq, peakSunHours, oilseedAreaFor, seasonDiesel_eq,
    rapeseed_esterDieselEquivPerHa]
  norm_num

/-! ## The ranking

All four routes, in hectares for the same 360-litre season, cheapest land
first: photovoltaic, wood gas, charcoal gas, oilseed. -/

theorem land_ranking :
    areaFor seasonShaft / 10000 < hectareYears seasonWood ∧
      hectareYears seasonWood < hectareYears seasonCharcoalWood ∧
      hectareYears seasonCharcoalWood < oilseedAreaFor rapeseed seasonDiesel := by
  refine ⟨?_, ?_, ?_⟩
  · simp only [areaFor, seasonShaft_eq, peakSunHours, hectareYears, coppiceYield, seasonWood,
      seasonDiesel_eq, woodPerDieselLitre_eq]
    norm_num
  · simp only [hectareYears, coppiceYield]
    have := charcoal_costs_more_wood_than_woodGas
    linarith
  · simp only [hectareYears, coppiceYield, seasonCharcoalWood, seasonDiesel_eq,
      charcoalPerDieselLitre_eq, charcoalYield, oilseedAreaFor,
      rapeseed_esterDieselEquivPerHa]
    norm_num

end Fluids
end LifeTrac
