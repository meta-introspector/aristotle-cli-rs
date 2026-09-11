import RequestProject.Gvcs.Water.Market

/-!
# Several teams, evolving the solution

Nobody designs this in one go.  Four teams take four different starting
positions and each does the only thing a workshop can do: change one subsystem
at a time and keep the change if the result is better.  This file models that,
and proves what happens.

The design space is four choices — how to compute, how to power it, where the
program lives, what beats the clock — 180 designs in all
(`allDesigns_length`).  A design is *feasible* when it needs no semiconductor
fab, when its store can hold a 910-card program and when its clock is fast
enough for the printer; its *fitness* is what is left of a 10 000 budget after
its price, and zero if it is not feasible.

* `climb` — a team's move: take the best of the current design and everything
  one change away.  `fitness_le_climb` says a team never goes backwards.
* `incumbent_stuck` — **the silicon incumbent is a local optimum at zero.**
  Grid power, a flash store and a crystal clock each need a fab, and changing
  any one of them alone still needs a fab, so a team that starts there and only
  hill-climbs never gets off the floor, in any number of rounds.
* `shared_round` — the market: after each round every team adopts the best
  design anyone has, which is what publishing the pack does.
* `teams_reach_optimum` — with sharing, after **two rounds** every team is
  holding the same design, and `waterSun_is_optimal` says it is the global
  optimum of the whole space: water logic, sun power, punched cards, a siphon
  clock.  That is the machine the rest of `RequestProject/Water/` builds.
* `sharing_beats_going_alone` — without sharing the four teams never all get
  there: two of them are still at zero after any number of rounds.
-/

set_option maxRecDepth 100000

namespace LifeTrac
namespace Water

/-! ## The design space -/

/-- How the controller computes. -/
inductive LogicKind where
  /-- Water gates, as in `Water/Logic.lean`. -/
  | water
  /-- Pneumatic (compressed air) fluidics. -/
  | air
  /-- Steam-piloted spool valves. -/
  | steam
  /-- Electromechanical relays. -/
  | relay
  /-- A microcontroller board. -/
  | silicon
  deriving DecidableEq, Repr

/-- Where the energy comes from. -/
inductive PowerKind where
  /-- Sun: a glazed collector and a thermosiphon pump. -/
  | sun
  /-- Wood through a gasifier. -/
  | wood
  /-- A connection to the grid, with its inverter. -/
  | grid
  deriving DecidableEq, Repr

/-- Where the program lives. -/
inductive StoreKind where
  /-- Jacquard cards. -/
  | cards
  /-- A pegged barrel, as in a music box. -/
  | drum
  /-- Punched paper tape. -/
  | tape
  /-- A flash memory card. -/
  | flash
  deriving DecidableEq, Repr

/-- What beats the clock. -/
inductive ClockKind where
  /-- A tipping siphon. -/
  | siphon
  /-- A pendulum escapement. -/
  | pendulum
  /-- A quartz crystal. -/
  | crystal
  deriving DecidableEq, Repr

/-- A candidate machine: one choice per subsystem. -/
structure Design where
  /-- How it computes. -/
  logic : LogicKind
  /-- How it is powered. -/
  power : PowerKind
  /-- Where the program lives. -/
  store : StoreKind
  /-- What beats the clock. -/
  clock : ClockKind
  deriving DecidableEq, Repr

namespace Design

/-! ## Prices, in whole units of account -/

/-- The controller's own price. -/
def logicPrice : LogicKind → ℕ
  | .water => 2100
  | .air => 2600
  | .steam => 3200
  | .relay => 1800
  | .silicon => 1000

/-- The power station's price. -/
def powerPrice : PowerKind → ℕ
  | .sun => 900
  | .wood => 1400
  | .grid => 5500

/-- The program store's price. -/
def storePrice : StoreKind → ℕ
  | .cards => 400
  | .drum => 700
  | .tape => 900
  | .flash => 200

/-- The clock's price. -/
def clockPrice : ClockKind → ℕ
  | .siphon => 55
  | .pendulum => 90
  | .crystal => 20

/-- What the whole design costs. -/
def price (d : Design) : ℕ :=
  logicPrice d.logic + powerPrice d.power + storePrice d.store + clockPrice d.clock

/-! ## Feasibility -/

/-- Which choices cannot be made without a semiconductor fab somewhere. -/
def needsFab (d : Design) : Bool :=
  (d.logic == .silicon) || (d.power == .grid) || (d.store == .flash) ||
    (d.clock == .crystal)

/-- Relay logic is only a real option on the grid: a relay bank wants
kilowatts of electricity, which neither the sun-lift nor the gasifier here
delivers. -/
def powered (d : Design) : Bool :=
  !(d.logic == .relay) || (d.power == .grid)

/-- The store has to hold a 910-card program that a workshop can re-punch: a
flash card cannot be punched. -/
def storable (d : Design) : Bool := !(d.store == .flash)

/-- A design is feasible when it needs no fab, when its logic is powered and
when its program can be stored and copied on the premises. -/
def feasible (d : Design) : Bool := !d.needsFab && d.powered && d.storable

/-- The budget a design is scored against. -/
def budget : ℕ := 10000

/-- What is left of the budget: zero if the design cannot be built at all. -/
def fitness (d : Design) : ℕ := if d.feasible then budget - d.price else 0

/-! ## Enumerating the space -/

/-- Every way to compute. -/
def allLogic : List LogicKind := [.water, .air, .steam, .relay, .silicon]

/-- Every way to power it. -/
def allPower : List PowerKind := [.sun, .wood, .grid]

/-- Every place to keep the program. -/
def allStore : List StoreKind := [.cards, .drum, .tape, .flash]

/-- Every clock. -/
def allClock : List ClockKind := [.siphon, .pendulum, .crystal]

/-- The whole design space. -/
def allDesigns : List Design :=
  allLogic.flatMap fun l =>
    allPower.flatMap fun p =>
      allStore.flatMap fun s =>
        allClock.map fun c => ⟨l, p, s, c⟩

theorem allDesigns_length : allDesigns.length = 180 := by decide

theorem mem_allDesigns (d : Design) : d ∈ allDesigns := by
  obtain ⟨l, p, s, c⟩ := d
  cases l <;> cases p <;> cases s <;> cases c <;> decide

/-- Designs one change away. -/
def neighbours (d : Design) : List Design :=
  (allLogic.filter (· != d.logic)).map (fun l => { d with logic := l }) ++
  (allPower.filter (· != d.power)).map (fun p => { d with power := p }) ++
  (allStore.filter (· != d.store)).map (fun s => { d with store := s }) ++
  (allClock.filter (· != d.clock)).map (fun c => { d with clock := c })

end Design

/-! ## Climbing, and sharing -/

open Design

/-- The fitter of two designs, preferring the first on a tie. -/
def fitter (a b : Design) : Design := if fitness a < fitness b then b else a

/-- The best of a list, against a design already in hand. -/
def bestOf (d0 : Design) (ds : List Design) : Design := ds.foldl fitter d0

theorem fitness_le_fitter_left (a b : Design) : fitness a ≤ fitness (fitter a b) := by
  unfold fitter; split <;> omega

theorem fitness_le_fitter_right (a b : Design) : fitness b ≤ fitness (fitter a b) := by
  unfold fitter; split <;> omega

theorem fitness_le_bestOf (d0 : Design) (ds : List Design) :
    fitness d0 ≤ fitness (bestOf d0 ds) := by
  unfold bestOf
  induction ds generalizing d0 with
  | nil => simp
  | cons d ds ih =>
      exact le_trans (fitness_le_fitter_left d0 d) (ih (fitter d0 d))

theorem fitness_mem_le_bestOf (d0 : Design) (ds : List Design) :
    ∀ e ∈ ds, fitness e ≤ fitness (bestOf d0 ds) := by
  unfold bestOf
  induction ds generalizing d0 with
  | nil => intro e he; cases he
  | cons d ds ih =>
      intro e he
      rcases List.mem_cons.mp he with rfl | he'
      · exact le_trans (fitness_le_fitter_right d0 e) (fitness_le_bestOf _ ds)
      · exact ih (fitter d0 d) e he'

/-- The best of a list is either an element of it or the design already in
hand. -/
theorem bestOf_eq_or_mem (d0 : Design) (ds : List Design) :
    bestOf d0 ds = d0 ∨ bestOf d0 ds ∈ ds := by
  unfold bestOf
  induction ds generalizing d0 with
  | nil => exact Or.inl rfl
  | cons d ds ih =>
      rw [List.foldl_cons]
      rcases ih (fitter d0 d) with h | h
      · rw [h]
        unfold fitter
        split
        · exact Or.inr (List.mem_cons_self ..)
        · exact Or.inl rfl
      · exact Or.inr (List.mem_cons_of_mem _ h)

/-- A team's move: keep what you have unless something one change away is
better. -/
def climb (d : Design) : Design := bestOf d (neighbours d)

theorem fitness_le_climb (d : Design) : fitness d ≤ fitness (climb d) :=
  fitness_le_bestOf d (neighbours d)

/-- The thing on the stall when nobody has designed anything yet: the
incumbent silicon board, which scores nothing here. -/
instance : Inhabited Design := ⟨⟨.silicon, .grid, .flash, .crystal⟩⟩

/-- The best design anybody is holding. -/
def marketBest (ds : List Design) : Design := bestOf default ds

/-- A round without a market: every team climbs on its own. -/
def loneRound (ds : List Design) : List Design := ds.map climb

/-- A round with a market: every team climbs, then everyone adopts the best
design anybody is holding — which is what publishing your pack does. -/
def sharedRound (ds : List Design) : List Design :=
  (ds.map climb).map (fun e => fitter e (marketBest (ds.map climb)))

/-- Iterating a round. -/
def rounds (f : List Design → List Design) : ℕ → List Design → List Design
  | 0, ds => ds
  | n + 1, ds => rounds f n (f ds)

/-- **No team goes backwards in a shared round**: whatever a team was holding,
somebody — itself, at worst — is holding something at least as good after the
round. -/
theorem sharedRound_no_team_falls (ds : List Design) :
    ∀ d ∈ ds, ∃ e ∈ sharedRound ds, fitness d ≤ fitness e := by
  intro d hd
  refine ⟨fitter (climb d) (marketBest (ds.map climb)), ?_, ?_⟩
  · exact List.mem_map_of_mem (List.mem_map_of_mem hd)
  · exact le_trans (fitness_le_climb d) (fitness_le_fitter_left _ _)

/-- The best on the stall never falls either. -/
theorem fitness_marketBest_le_sharedRound (ds : List Design) :
    fitness (marketBest ds) ≤ fitness (marketBest (sharedRound ds)) := by
  rcases bestOf_eq_or_mem (default : Design) ds with hb | hb
  · rw [marketBest, hb]
    exact fitness_le_bestOf _ _
  · obtain ⟨e, he, hle⟩ := sharedRound_no_team_falls ds _ hb
    exact le_trans (by rw [marketBest]; exact hle)
      (fitness_mem_le_bestOf default (sharedRound ds) e he)

/-! ## The global optimum -/

/-- The largest fitness in the whole space. -/
def optimum : ℕ := (allDesigns.map fitness).foldr max 0

theorem le_foldr_max (l : List ℕ) : ∀ x ∈ l, x ≤ l.foldr max 0 := by
  induction l with
  | nil => intro x hx; cases hx
  | cons a l ih =>
      intro x hx
      rcases List.mem_cons.mp hx with rfl | hx'
      · exact le_max_left _ _
      · exact le_trans (ih x hx') (le_max_right _ _)

/-- Nothing in the space beats the optimum. -/
theorem fitness_le_optimum (d : Design) : fitness d ≤ optimum :=
  le_foldr_max _ _ (List.mem_map_of_mem (mem_allDesigns d))

/-- The design the whole of `RequestProject/Water/` is about. -/
def waterSun : Design := ⟨.water, .sun, .cards, .siphon⟩

theorem waterSun_price : waterSun.price = 3455 := by decide

theorem waterSun_fitness : fitness waterSun = 6545 := by decide

/-- **Water, sun, cards and a siphon is the best design in the space.** -/
theorem waterSun_is_optimal : ∀ d : Design, fitness d ≤ fitness waterSun := by
  intro d
  obtain ⟨l, p, s, c⟩ := d
  cases l <;> cases p <;> cases s <;> cases c <;> decide

theorem optimum_eq : optimum = fitness waterSun := by decide

/-! ## The four teams -/

/-- The incumbent: a microcontroller on the grid, program on a flash card,
crystal clock. -/
def incumbent : Design := ⟨.silicon, .grid, .flash, .crystal⟩

/-- The steampunk team. -/
def steamTeam : Design := ⟨.steam, .wood, .drum, .pendulum⟩

/-- The pneumatics team. -/
def airTeam : Design := ⟨.air, .sun, .tape, .siphon⟩

/-- The relay team, which is on the grid because relays have to be. -/
def relayTeam : Design := ⟨.relay, .grid, .cards, .crystal⟩

/-- Where the four teams start. -/
def teams0 : List Design := [incumbent, steamTeam, airTeam, relayTeam]

/-- **The incumbent is stuck.**  Every single change to the silicon design
still needs a fab, so hill-climbing leaves it exactly where it was. -/
theorem incumbent_local_opt : climb incumbent = incumbent := by decide

/-- And therefore stuck for ever: after any number of lone rounds the
incumbent is still the incumbent, still scoring nothing. -/
theorem incumbent_stuck (n : ℕ) : (climb^[n]) incumbent = incumbent := by
  induction n with
  | zero => rfl
  | succ n ih => rw [Function.iterate_succ_apply, incumbent_local_opt, ih]

theorem incumbent_fitness_zero : fitness incumbent = 0 := by decide

/-- The relay team is stuck in the same way. -/
theorem relayTeam_local_opt : climb relayTeam = relayTeam := by decide

theorem relayTeam_stuck (n : ℕ) : (climb^[n]) relayTeam = relayTeam := by
  induction n with
  | zero => rfl
  | succ n ih => rw [Function.iterate_succ_apply, relayTeam_local_opt, ih]

/-- **Sharing gets everybody there.**  Two rounds with a market and all four
teams are holding the optimal design. -/
theorem teams_reach_optimum :
    rounds sharedRound 2 teams0 = [waterSun, waterSun, waterSun, waterSun] := by decide

/-- So after two shared rounds every team scores the global optimum. -/
theorem teams_all_optimal :
    ∀ d ∈ rounds sharedRound 2 teams0, fitness d = optimum := by
  rw [teams_reach_optimum, optimum_eq]
  decide

/-- And there they stay: the optimum is a fixed point of a shared round. -/
theorem teams_stay_at_optimum :
    sharedRound [waterSun, waterSun, waterSun, waterSun] =
      [waterSun, waterSun, waterSun, waterSun] := by decide

/-- **Going alone does not.**  However many lone rounds are played, the two
teams that started inside the silicon basin are still scoring zero. -/
theorem sharing_beats_going_alone (n : ℕ) :
    (rounds loneRound n teams0).head? = some incumbent ∧
      fitness incumbent = 0 := by
  refine ⟨?_, incumbent_fitness_zero⟩
  have key : ∀ m : ℕ, rounds loneRound m teams0 =
      [(climb^[m]) incumbent, (climb^[m]) steamTeam, (climb^[m]) airTeam,
        (climb^[m]) relayTeam] := by
    intro m
    induction m with
    | zero => rfl
    | succ m ih =>
        have : rounds loneRound (m + 1) teams0 = rounds loneRound m (loneRound teams0) := rfl
        rw [this]
        have hstep : ∀ k : ℕ, ∀ ds : List Design,
            rounds loneRound k (loneRound ds) = loneRound (rounds loneRound k ds) := by
          intro k
          induction k with
          | zero => intro ds; rfl
          | succ k ihk => intro ds; simp only [rounds]; rw [ihk]
        rw [hstep, ih]
        simp [loneRound, Function.iterate_succ_apply']
  rw [key n, incumbent_stuck n]
  rfl

end Water
end LifeTrac
