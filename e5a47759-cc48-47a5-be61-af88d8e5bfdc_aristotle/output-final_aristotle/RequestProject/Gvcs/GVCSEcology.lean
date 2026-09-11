import RequestProject.Gvcs.GVCS

/-!
# The product ecology of the Global Village Construction Set

Every machine page on the Open Source Ecology wiki carries a *product ecology*
box which names, for that machine,

* what it is made **from** — the other machines that fabricate it,
* what it **uses** — what it consumes or runs on while working,
* what it **enables** — what becomes possible once it exists.

This file imports those three relations, restricted to edges whose endpoints
are themselves GVCS machines, from the twenty-four machine pages that state
them (`documented`).  The remaining twenty-six pages carry no ecology box; for
those the lists are empty, which records *absence of data*, not absence of
dependencies, and every statement below is careful about the difference.

The results are of three kinds.

**The set is recursive, in the strong sense.**  The `builtFrom` relation has
cycles — the 3D printer is made with the 3D scanner and the 3D scanner is made
with the 3D printer — so there is no way to number the machines so that each
is built only out of lower-numbered ones (`no_build_ranking`).  The tractor
and its power cube stand in the same relation to each other
(`tractor_and_powerCube_need_each_other`).  Nothing in the set can therefore
be reached by starting from nothing: the GVCS has to be entered from outside.

**One machine opens the whole set.**  Take as given the twenty-six machines
whose inputs the wiki does not record, and ask which further machines must be
supplied before every documented machine can be built.  Adding the **3D
printer** — and nothing else — suffices: four rounds of building later, all
fifty machines are in hand (`printer_seed_completes`).  And the printer is the
*only* single machine that does this (`printer_is_the_unique_keystone`): the
proof is not a search but two obstructions, `keystoneCycle` (printer ↔
scanner) and `keystoneLoop` (printer → bioplastic extruder → motor →
battery/power supply → printer), each of which is a set of machines that can
never be built if none of them is given, and whose only common member is the
printer.

**The wiki's cross-references are not symmetric.**  If machine *a* is built
from or runs on machine *b*, one would expect *b*'s page to list *a* under
"enables".  Between documented machines that holds for 24 edges and fails for
26 (`ecology_disagreements`), and in the other direction 18 declared "enables"
edges are not confirmed by the target's own page (`unconfirmed_enables`).  The
relation as published is a useful sketch, not a consistent database.

Source: the OSE wiki machine pages listed in `Machine.wikiPage`, read in
August 2026.
-/

namespace LifeTrac
namespace GVCS

open Machine

/-! ## The three relations, as the wiki states them -/

/-- The machines the wiki says a given machine is **made from**.  Empty for
the twenty-six pages that carry no product ecology box. -/
def builtFrom : Machine → List Machine
  | cebPress => [inductionFurnace, welder, torchTable, ironworker]
  | cementMixer => [multimachine, motorGenerator, tractor, inductionFurnace, torchTable, ironworker]
  | sawmill => [inductionFurnace, welder, multimachine, hydraulicMotor]
  | tractor => [powerCube, hydraulicMotor, inductionFurnace]
  | microcombine => [inductionFurnace, torchTable, multimachine, hydraulicMotor]
  | bakeryOven => [inductionFurnace, torchTable]
  | industrialRobot => [inductionFurnace, motorGenerator, welder, torchTable]
  | printer3D => [scanner3D, laserCutter, bioplasticExtruder]
  | scanner3D => [printer3D, circuitMill]
  | powerCube => [steamEngine, gasifierBurner, pelletizer]
  | gasifierBurner => [inductionFurnace, torchTable]
  | solarConcentrator => [inductionFurnace, motorGenerator, bioplasticExtruder]
  | motorGenerator => [battery, ups, printer3D, rodWireMill]
  | hydraulicMotor => [inductionFurnace, multimachine]
  | steamEngine => [inductionFurnace]
  | heatExchanger => [inductionFurnace]
  | windTurbine => [inductionFurnace, multimachine, motorGenerator, battery]
  | pelletizer => [inductionFurnace, welder, multimachine]
  | ups => [circuitMill, printer3D, rodWireMill]
  | battery => [printer3D, rodWireMill]
  | aluminumExtractor => [inductionFurnace, torchTable]
  | bioplasticExtruder => [inductionFurnace, torchTable, motorGenerator]
  | car => [inductionFurnace, industrialRobot, welder, torchTable, printer3D, multimachine,
      powerCube, hydraulicMotor]
  | truck => [printer3D, inductionFurnace, rodWireMill, multimachine, hydraulicMotor,
      industrialRobot, welder]
  | _ => []

/-- The machines a given machine **uses** while it works — what powers it or
feeds it. -/
def uses : Machine → List Machine
  | cebPress => [powerCube, soilPulverizer, tractor]
  | cementMixer => [powerCube]
  | sawmill => [powerCube]
  | tractor => [powerCube]
  | microcombine => [powerCube, tractor]
  | bakeryOven => [ups]
  | industrialRobot => [welder]
  | scanner3D => [ups]
  | powerCube => [tractor]
  | gasifierBurner => [baler, pelletizer]
  | motorGenerator => [windTurbine, steamEngine]
  | steamEngine => [gasifierBurner, solarConcentrator]
  | pelletizer => [sawmill, baler, hammermill, powerCube]
  | ups => [battery, powerCube]
  | car => [powerCube]
  | truck => [powerCube, steamEngine]
  | _ => []

/-- The machines a given machine's page says it **enables**. -/
def enables : Machine → List Machine
  | cementMixer => [multimachine]
  | sawmill => [pelletizer, hammermill]
  | tractor => [cebPress, soilPulverizer, backhoe, universalRotor, wellDrillingRig, trencher,
      baler, seeder, spader, hayRake, hayCutter]
  | industrialRobot => [car, truck]
  | scanner3D => [printer3D, sawmill, tractor, industrialRobot]
  | powerCube => [tractor, cebPress, bulldozer, microtractor, car, truck, hammermill, drillPress,
      multimachine, welder, ironworker, sawmill, inductionFurnace, torchTable]
  | gasifierBurner => [steamEngine, cementMixer, powerCube, truck, car]
  | solarConcentrator => [steamEngine, ups]
  | motorGenerator => [printer3D, circuitMill, multimachine, torchTable, laserCutter,
      industrialRobot, welder, car]
  | hydraulicMotor => [industrialRobot, bioplasticExtruder, powerCube, cebPress, cementMixer,
      sawmill, tractor, bulldozer, seeder, hayRake, backhoe, microtractor, soilPulverizer,
      spader, hayCutter, trencher, microcombine, baler, wellDrillingRig, multimachine,
      ironworker, metalRoller, rodWireMill, pressForge, universalRotor, drillPress, hammermill,
      pelletizer, car, truck]
  | steamEngine => [motorGenerator]
  | heatExchanger => [steamEngine, powerCube]
  | pelletizer => [gasifierBurner]
  | ups => [motorGenerator, welder, inductionFurnace, plasmaCutter, industrialRobot]
  | battery => [ups]
  | aluminumExtractor => [inductionFurnace]
  | bioplasticExtruder => [printer3D]
  | _ => []

/-- Whether the wiki page of a machine carries a product ecology box at all. -/
def documented : Machine → Bool
  | cebPress | cementMixer | sawmill | tractor | microcombine | bakeryOven | industrialRobot
  | printer3D | scanner3D | powerCube | gasifierBurner | solarConcentrator | motorGenerator
  | hydraulicMotor | steamEngine | heatExchanger | windTurbine | pelletizer | ups | battery
  | aluminumExtractor | bioplasticExtruder | car | truck => true
  | _ => false

/-- Everything a machine depends on: what it is built from together with what
it runs on. -/
def needs (m : Machine) : List Machine := (builtFrom m ++ uses m).dedup

/-! ## What the import contains -/

/-- Half of the fifty machines state their fabrication inputs; the other
twenty-six pages say nothing. -/
theorem card_documented :
    (Finset.univ.filter (fun m : Machine => documented m = true)).card = 24 := by decide

/-- A machine's page carries a product ecology box exactly when it names at
least one machine it is built from. -/
theorem documented_iff_builtFrom_ne_nil (m : Machine) :
    documented m = true ↔ builtFrom m ≠ [] := by
  revert m; decide

/-- Undocumented machines carry no relations at all. -/
theorem undocumented_empty (m : Machine) (h : documented m = false) :
    builtFrom m = [] ∧ uses m = [] := by
  revert h; revert m; decide

/-! ## The tractor in the set -/

/-- The LifeTrac is fabricated with a power cube, a hydraulic motor and an
induction furnace. -/
theorem builtFrom_tractor :
    builtFrom tractor = [powerCube, hydraulicMotor, inductionFurnace] := rfl

/-- It runs on the power cube. -/
theorem uses_tractor : uses tractor = [powerCube] := rfl

/-- Eleven of the fifty machines are, on the tractor's own page, things the
tractor makes possible. -/
theorem enables_tractor_length : (enables tractor).length = 11 := by decide

/-- The power cube is what the set runs on: nine machines name it as their
power source, more than name any other machine. -/
theorem powerCube_is_the_common_power_source :
    (Finset.univ.filter (fun m : Machine => powerCube ∈ uses m)).card = 9 := by decide

theorem powerCube_most_used (m : Machine) (hm : m ≠ powerCube) :
    (Finset.univ.filter (fun a : Machine => m ∈ uses a)).card
      < (Finset.univ.filter (fun a : Machine => powerCube ∈ uses a)).card := by
  revert hm; revert m; decide

/-! ## The set is recursive

There is no order in which the machines could be built one after another, each
out of ones already finished. -/

/-- The dependency relation generated by "is built from". -/
inductive Needs : Machine → Machine → Prop where
  | step {a b : Machine} : b ∈ builtFrom a → Needs a b
  | trans {a b c : Machine} : Needs a b → Needs b c → Needs a c

/-- The 3D printer is built with the 3D scanner, and the 3D scanner is built
with the 3D printer: the printer needs itself. -/
theorem printer_needs_itself : Needs printer3D printer3D :=
  .trans (b := scanner3D) (.step (by decide)) (.step (by decide))

/-- The tractor is built with a power cube; the power cube's page lists the
tractor among what it uses.  Each of the two needs the other. -/
theorem tractor_and_powerCube_need_each_other :
    powerCube ∈ needs tractor ∧ tractor ∈ needs powerCube := by decide

/-- **No build order exists.**  There is no way of ranking the fifty machines
so that every machine is built only out of machines of strictly lower rank —
the fabrication relation is genuinely circular, so the set cannot be
bootstrapped from inside itself. -/
theorem no_build_ranking :
    ¬ ∃ rank : Machine → ℕ, ∀ a : Machine, ∀ b ∈ builtFrom a, rank b < rank a := by
  rintro ⟨rank, h⟩
  have h1 : rank scanner3D < rank printer3D := h printer3D scanner3D (by decide)
  have h2 : rank printer3D < rank scanner3D := h scanner3D printer3D (by decide)
  omega

/-! ## Bootstrapping: what has to be brought in from outside -/

/-- One round of building: everything already available, plus every documented
machine all of whose fabrication inputs are available. -/
def buildStep (avail : List Machine) : List Machine :=
  allMachines.filter fun m =>
    decide (m ∈ avail) || (documented m && (builtFrom m).all (fun b => decide (b ∈ avail)))

/-- `n` rounds of building from a given stock of machines. -/
def buildClosure (seed : List Machine) : ℕ → List Machine
  | 0 => seed
  | n + 1 => buildStep (buildClosure seed n)

/-- The twenty-six machines whose inputs the wiki does not record.  Since
nothing is known about how to make them, a bootstrap analysis has to treat
them as given. -/
def undocumentedSeed : List Machine := allMachines.filter (fun m => !documented m)

theorem undocumentedSeed_length : undocumentedSeed.length = 26 := by decide

/-- A machine is in the seed exactly when the wiki records nothing about how
to make it. -/
theorem mem_undocumentedSeed_iff (m : Machine) :
    m ∈ undocumentedSeed ↔ documented m = false := by
  simp [undocumentedSeed, List.mem_filter, mem_allMachines]

/-- **The 3D printer opens the set.**  Given the twenty-six machines the wiki
says nothing about, plus one 3D printer, four rounds of building produce all
fifty machines. -/
theorem printer_seed_completes (m : Machine) :
    m ∈ buildClosure (printer3D :: undocumentedSeed) 4 := by
  revert m; decide

/-! ### Why the printer, and only the printer

A list of machines is *self-blocking* if each of its members has at least one
fabrication input inside the list.  Nothing in a self-blocking list can ever be
built unless one of its members is supplied from outside. -/

/-- Every member of `P` is built out of something else in `P`. -/
abbrev SelfBlocking (P : List Machine) : Prop := ∀ m ∈ P, ∃ b ∈ builtFrom m, b ∈ P

/-- A self-blocking set, none of whose members is in the seed, is never
built — however many rounds are run. -/
theorem blocked_never_built {P seed : List Machine} (hP : SelfBlocking P)
    (hs : ∀ m ∈ P, m ∉ seed) : ∀ n, ∀ m ∈ P, m ∉ buildClosure seed n := by
  intro n
  induction n with
  | zero => intro m hm; exact hs m hm
  | succ n ih =>
      intro m hm hmem
      simp only [buildClosure, buildStep, List.mem_filter, Bool.or_eq_true, Bool.and_eq_true,
        decide_eq_true_eq, List.all_eq_true] at hmem
      rcases hmem.2 with h | h
      · exact ih m hm h
      · obtain ⟨b, hb, hbP⟩ := hP m hm
        exact ih b hbP (h.2 b hb)

/-- The printer–scanner cycle: each is built with the other. -/
def keystoneCycle : List Machine := [printer3D, scanner3D]

/-- The printer's other loop: the printer is built with the bioplastic
extruder, which is built with the motor/generator, which is built with the
battery and the power supply, both of which are built with the printer. -/
def keystoneLoop : List Machine := [printer3D, bioplasticExtruder, motorGenerator, battery, ups]

theorem keystoneCycle_selfBlocking : SelfBlocking keystoneCycle := by decide

theorem keystoneLoop_selfBlocking : SelfBlocking keystoneLoop := by decide

theorem keystoneCycle_documented : ∀ m ∈ keystoneCycle, documented m = true := by decide

theorem keystoneLoop_documented : ∀ m ∈ keystoneLoop, documented m = true := by decide

/-- Without a printer the set stalls: starting from the twenty-six
undocumented machines alone, no number of rounds ever produces a 3D printer,
and so eleven other machines never appear either. -/
theorem no_printer_without_a_printer (n : ℕ) :
    printer3D ∉ buildClosure undocumentedSeed n := by
  refine blocked_never_built keystoneCycle_selfBlocking ?_ n printer3D (by decide)
  intro m hm hmem
  have h1 := keystoneCycle_documented m hm
  rw [mem_undocumentedSeed_iff] at hmem
  rw [h1] at hmem
  exact Bool.noConfusion hmem

/-- The two obstructions meet only in the 3D printer. -/
theorem keystone_intersection (m : Machine) (h₁ : m ∈ keystoneCycle) (h₂ : m ∈ keystoneLoop) :
    m = printer3D := by
  revert h₁ h₂; revert m; decide

/-- **The 3D printer is the unique keystone.**  If supplying one further
machine on top of the twenty-six undocumented ones is enough to build
everything, that machine is the 3D printer. -/
theorem printer_is_the_unique_keystone (x : Machine) (n : ℕ)
    (h : ∀ m : Machine, m ∈ buildClosure (x :: undocumentedSeed) n) : x = printer3D := by
  have hprinter : printer3D ∈ buildClosure (x :: undocumentedSeed) n := h printer3D
  have hcycle : x ∈ keystoneCycle := by
    by_contra hx
    refine blocked_never_built keystoneCycle_selfBlocking ?_ n printer3D (by decide) hprinter
    intro m hm hmem
    rcases List.mem_cons.1 hmem with rfl | hmem
    · exact hx hm
    · have h1 := keystoneCycle_documented m hm
      rw [mem_undocumentedSeed_iff, h1] at hmem
      exact Bool.noConfusion hmem
  have hloop : x ∈ keystoneLoop := by
    by_contra hx
    refine blocked_never_built keystoneLoop_selfBlocking ?_ n printer3D (by decide) hprinter
    intro m hm hmem
    rcases List.mem_cons.1 hmem with rfl | hmem
    · exact hx hm
    · have h1 := keystoneLoop_documented m hm
      rw [mem_undocumentedSeed_iff, h1] at hmem
      exact Bool.noConfusion hmem
  exact keystone_intersection x hcycle hloop

/-! ## How consistent is the published table?

If `a` is built from or runs on `b`, then `b`'s page ought to list `a` under
"enables".  Between documented machines it often does not. -/

/-- The dependency edges between documented machines. -/
def dependencyEdges : List (Machine × Machine) :=
  allMachines.flatMap fun a =>
    (needs a).filterMap fun b => if documented b then some (a, b) else none

/-- Edges confirmed by the target machine's own "enables" list. -/
def confirmedEdges : List (Machine × Machine) :=
  dependencyEdges.filter fun e => decide (e.1 ∈ enables e.2)

/-- Fifty dependency edges run between documented machines. -/
theorem dependencyEdges_length : dependencyEdges.length = 50 := by decide

/-- Half of them are confirmed by the other page. -/
theorem confirmedEdges_length : confirmedEdges.length = 24 := by decide

/-- The other twenty-six are not: the wiki's cross-references are not
symmetric, and the ecology as published is a sketch rather than a consistent
database. -/
theorem ecology_disagreements :
    dependencyEdges.length - confirmedEdges.length = 26 := by decide

/-- The same gap seen from the other side: eighteen "enables" edges between
documented machines are not matched by anything on the target's own page. -/
theorem unconfirmed_enables :
    ((allMachines.flatMap fun b =>
      (enables b).filterMap fun a => if documented a then some (a, b) else none).filter
        fun e => !decide (e.2 ∈ needs e.1)).length = 18 := by decide

end GVCS
end LifeTrac
