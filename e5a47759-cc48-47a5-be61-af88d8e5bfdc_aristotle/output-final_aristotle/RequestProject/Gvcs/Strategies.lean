import RequestProject.Gvcs.Wasm.Shell

/-!
# Five players and a sixth who is refused

`Runtime.lean` is the rule book of the game in machine integers, and
`Tycoon.lean` plays one script through it.  This file plays *several*: a handful
of named players, each with a different strategy for getting a LifeTrac out of
the shed and a wheat crop into the bank, together with the proof that each
script is legal from the first move to the last and lands on exactly the stated
cash, fuel, calendar, acreage and net worth.

The scripts here are the source of the pictures in `media/` and of the figures
in `paper/brochure.tex`: the images are drawn from the states `rrun` actually
passes through, so a picture cannot show a position the rule book does not
allow.

* `ada`   — orders the whole bill of materials, builds, fills the tank, farms 20 ha.
  (This is the script of `Tycoon.lean`.)
* `bo`    — orders the six sub-assembly kits instead, buys only the fuel the
  crop needs, farms the same 20 ha, and ends with *exactly the same net worth*
  as Ada (`bo_netWorth_eq_ada`).
* `cleo`  — picks the 24 raw materials off the shelf one by one; the shop sells
  whole lengths, so the half round bar she cannot avoid buying costs her
  exactly 15 more than the kit (`cleo_cash_add_fifteen`).
* `dan`   — spends every last unit of cash on seed and fuel in the first season
  and puts 37 ha in.
* `eve`   — compounds: 37 ha, then everything the harvest will buy, 201 ha.
* `fay`   — tries to farm before there is a machine, and the rule book refuses
  her (`fay_refused`).
-/

namespace LifeTrac
namespace Strategies

open Runtime Wasm

/-! ## Players -/

/-- A player: a name, a one-line strategy, and the script they play. -/
structure Player where
  /-- A short machine-readable key, used for file names. -/
  key : String
  /-- The player's name. -/
  name : String
  /-- The strategy in one line. -/
  tagline : String
  /-- The moves, in order. -/
  script : List RAction
  deriving Inhabited

/-- The states a script passes through, opening position first; the list stops
at a move the rule book refuses. -/
def traceStates (s : RState) : List RAction → List RState
  | [] => [s]
  | a :: as => match rstep s a with
      | some t => s :: traceStates t as
      | none => [s]

/-- The moves a script actually gets to play (all of them, unless one is
refused). -/
def playedMoves (s : RState) : List RAction → List RAction
  | [] => []
  | a :: as => match rstep s a with
      | some t => a :: playedMoves t as
      | none => []

/-- A trace always starts at the opening position. -/
theorem traceStates_head (s : RState) (l : List RAction) :
    (traceStates s l).head? = some s := by
  cases l with
  | nil => rfl
  | cons a as => cases h : rstep s a <;> simp [traceStates, h]

/-- A trace has one more state than it has moves it got to play. -/
theorem traceStates_length (s : RState) (l : List RAction) :
    (traceStates s l).length = (playedMoves s l).length + 1 := by
  induction l generalizing s with
  | nil => rfl
  | cons a as ih =>
      cases h : rstep s a with
      | none => simp [traceStates, playedMoves, h]
      | some t => simp [traceStates, playedMoves, h, ih t]

/-- A trace is the opening position followed by the rest. -/
theorem traceStates_cons_form (s : RState) (l : List RAction) :
    ∃ r, traceStates s l = s :: r := by
  cases l with
  | nil => exact ⟨[], rfl⟩
  | cons a as =>
      cases h : rstep s a with
      | none => exact ⟨[], by simp [traceStates, h]⟩
      | some t => exact ⟨traceStates t as, by simp [traceStates, h]⟩

/-- **The pictures show the play.**  If the whole script is legal, the last
state of the trace is the position `rrun` ends on. -/
theorem traceStates_getLast (s : RState) (l : List RAction) (t : RState)
    (h : rrun s l = some t) : (traceStates s l).getLast? = some t := by
  induction l generalizing s with
  | nil =>
      have hst : s = t := by simpa [rrun] using h
      subst hst; rfl
  | cons a as ih =>
      rw [rrun] at h
      cases hs : rstep s a with
      | none => rw [hs] at h; exact absurd h (by simp)
      | some u =>
          rw [hs] at h
          have hres := ih u (by simpa using h)
          obtain ⟨r, hr⟩ := traceStates_cons_form u as
          have hstep : traceStates s (a :: as) = s :: traceStates u as := by
            simp [traceStates, hs]
          rw [hstep, hr, List.getLast?_cons_cons]
          rwa [hr] at hres

/-! ## The scripts -/

/-- Ada plays the script of `Tycoon.lean`. -/
def adaScript : List RAction :=
  [ .order RPart.lifeTrac
  , .fabricate RPart.lifeTrac
  , .refuel 400
  , .farm RCrop.wheat 20 ]

/-- Bo orders the six sub-assembly kits — four wheel modules among them —
instead of the whole bill of materials, and buys exactly the fuel 20 ha needs. -/
def boScript : List RAction :=
  [ .order RPart.frame
  , .order RPart.wheelModule
  , .order RPart.wheelModule
  , .order RPart.wheelModule
  , .order RPart.wheelModule
  , .order RPart.powerUnit
  , .order RPart.controlStation
  , .order RPart.loader
  , .order RPart.finishing
  , .fabricate RPart.lifeTrac
  , .refuel 360
  , .farm RCrop.wheat 20 ]

/-- The shopping list Cleo takes to the market: every material the machine
needs, rounded up to whole units, because the shop does not cut lengths. -/
def shoppingList : List RAction :=
  allM.filterMap (fun m =>
    let r := RPart.lifeTrac.req m
    if r = 0 then none
    else some (RAction.buy m ((r + (SCALE - 1)) / SCALE)))

/-- Cleo buys the raw materials one by one, then builds. -/
def cleoScript : List RAction :=
  shoppingList ++
  [ .fabricate RPart.lifeTrac
  , .refuel 400
  , .farm RCrop.wheat 20 ]

/-- Dan puts every unit of cash he has into the first crop. -/
def danScript : List RAction :=
  [ .order RPart.lifeTrac
  , .fabricate RPart.lifeTrac
  , .refuel 666
  , .farm RCrop.wheat 37 ]

/-- Eve does what Dan does and then ploughs the whole harvest back in. -/
def eveScript : List RAction :=
  [ .order RPart.lifeTrac
  , .fabricate RPart.lifeTrac
  , .refuel 666
  , .farm RCrop.wheat 37
  , .refuel 3618
  , .farm RCrop.wheat 201 ]

/-- Fay tries to farm on the first morning, with no machine in the yard. -/
def fayScript : List RAction :=
  [ .farm RCrop.wheat 20
  , .order RPart.lifeTrac ]

/-- Ada: by the book. -/
def ada : Player := ⟨"ada", "Ada", "By the book: one kit, one machine, twenty hectares", adaScript⟩

/-- Bo: the kit-basher. -/
def bo : Player := ⟨"bo", "Bo", "Kit by kit, and only the fuel the crop needs", boScript⟩

/-- Cleo: the parts picker. -/
def cleo : Player := ⟨"cleo", "Cleo", "Twenty-four trips to the market, one for each material", cleoScript⟩

/-- Dan: all in on the first season. -/
def dan : Player := ⟨"dan", "Dan", "Every last unit of cash into the first crop: 37 ha", danScript⟩

/-- Eve: the compounder. -/
def eve : Player := ⟨"eve", "Eve", "Plough the harvest back in: 37 ha, then 201 ha", eveScript⟩

/-- Fay: refused. -/
def fay : Player := ⟨"fay", "Fay", "Farming before there is a tractor — the rules say no", fayScript⟩

/-- The field of players. -/
def players : List Player := [ada, bo, cleo, dan, eve, fay]

/-! ## Every script is legal, and lands where the pictures say it does -/

/-- **Ada's season.**  Legal throughout, and it ends on 18 449 in cash, 40
litres in the tank, day 17.125, twenty hectares, a machine in the shed and a
net worth of 28 060. -/
theorem ada_plays :
    ∃ t, rrun rstart adaScript = some t ∧
      t.cash = 18449 * SCALE ∧ t.fuel = 40 * SCALE ∧ t.day = 17125000 ∧
      t.hect = 20 * SCALE ∧ t.hasTractor = true ∧
      rNetWorth t = 28060 * SCALE * SCALE := by
  refine ⟨_, rfl, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> rfl

/-- **Bo's season.**  Nine kits cost exactly what the one bill of materials
costs, so he too has a machine on day 11.5; buying 360 litres instead of 400
leaves him 18 509 in cash and an empty tank. -/
theorem bo_plays :
    ∃ t, rrun rstart boScript = some t ∧
      t.cash = 18509 * SCALE ∧ t.fuel = 0 ∧ t.day = 17125000 ∧
      t.hect = 20 * SCALE ∧ t.hasTractor = true ∧
      rNetWorth t = 28060 * SCALE * SCALE := by
  refine ⟨_, rfl, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> rfl

/-- **The kits are the machine.**  Ordering the six sub-assemblies — four wheel
modules among them — puts exactly the whole machine's bill of materials on the
shelf, and costs exactly the same. -/
theorem kits_equal_whole_kit :
    ∃ u v, rrun rstart (boScript.take 9) = some u ∧
      rrun rstart [RAction.order RPart.lifeTrac] = some v ∧
      u.cash = v.cash ∧ ∀ m, u.stock m = v.stock m := by
  refine ⟨_, _, rfl, rfl, rfl, ?_⟩
  intro m
  cases m <;> rfl

/-- **The two routes are worth the same.**  Bo's tank is empty and Ada's is
not, but fuel is worth what it costs, so the two players end the season with
identical net worth. -/
theorem bo_netWorth_eq_ada :
    ∃ t u, rrun rstart adaScript = some t ∧ rrun rstart boScript = some u ∧
      rNetWorth t = rNetWorth u := by
  exact ⟨_, _, rfl, rfl, rfl⟩

/-- **Cleo's season.**  Buying the materials one by one works, and gets the
same machine into the same field on the same day. -/
theorem cleo_plays :
    ∃ t, rrun rstart cleoScript = some t ∧
      t.cash = 18434 * SCALE ∧ t.fuel = 40 * SCALE ∧ t.day = 17125000 ∧
      t.hect = 20 * SCALE ∧ t.hasTractor = true := by
  refine ⟨_, rfl, ?_, ?_, ?_, ?_, ?_⟩ <;> rfl

/-- **What the whole lengths cost.**  The machine needs 1.5 round bars and the
shop sells 2, so picking the materials off the shelf costs exactly 15 more than
ordering the kit — and nothing else differs. -/
theorem cleo_cash_add_fifteen :
    ∃ t u, rrun rstart cleoScript = some t ∧ rrun rstart adaScript = some u ∧
      t.cash + 15 * SCALE = u.cash ∧ t.day = u.day ∧ t.hect = u.hect := by
  refine ⟨_, _, rfl, rfl, ?_, ?_, ?_⟩ <;> rfl

/-- **Dan's season.**  37 hectares is the most the opening cash will pay for,
and it ends the season on 29 610. -/
theorem dan_plays :
    ∃ t, rrun rstart danScript = some t ∧
      t.cash = 29610 * SCALE ∧ t.fuel = 0 ∧ t.day = 21906250 ∧
      t.hect = 37 * SCALE ∧ t.hasTractor = true := by
  refine ⟨_, rfl, ?_, ?_, ?_, ?_, ?_⟩ <;> rfl

/-- **Dan cannot do better.**  One more hectare in the first season is refused:
after the machine and the fuel there is not enough cash left for the seed. -/
theorem dan_maximal :
    rrun rstart
      [ .order RPart.lifeTrac, .fabricate RPart.lifeTrac, .refuel 684,
        .farm RCrop.wheat 38 ] = none := by
  rfl

/-- **Eve's two seasons.**  Ploughing the first harvest back in turns 37
hectares into 201, and 29 610 into 160 863, by day 78.4375. -/
theorem eve_plays :
    ∃ t, rrun rstart eveScript = some t ∧
      t.cash = 160863 * SCALE ∧ t.fuel = 0 ∧ t.day = 78437500 ∧
      t.hect = 238 * SCALE ∧ t.hasTractor = true ∧
      rNetWorth t = 170414 * SCALE * SCALE := by
  refine ⟨_, rfl, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> rfl

/-- **Fay is refused.**  There is no machine in the yard, so the first move
does not happen and neither does the script. -/
theorem fay_refused : rrun rstart fayScript = none := rfl

/-- and the refusal is the first move, not the second: Fay never gets to
order. -/
theorem fay_stops_at_once : playedMoves rstart fayScript = [] := rfl

/-- **The scoreboard.**  Patience beats haste beats thrift: Eve ends the
richest, then Dan, then Bo, then Ada, then Cleo, who paid for the half round
bar. -/
theorem scoreboard :
    ∃ ta tb tc td te,
      rrun rstart adaScript = some ta ∧ rrun rstart boScript = some tb ∧
      rrun rstart cleoScript = some tc ∧ rrun rstart danScript = some td ∧
      rrun rstart eveScript = some te ∧
      tc.cash < ta.cash ∧ ta.cash < tb.cash ∧ tb.cash < td.cash ∧
      td.cash < te.cash := by
  refine ⟨_, _, _, _, _, rfl, rfl, rfl, rfl, rfl, ?_, ?_, ?_, ?_⟩ <;> decide

/-- **Nobody goes into debt.**  Every state every player passes through has
non-negative cash. -/
theorem cash_nonneg_along_play (p : Player) (hp : p ∈ players) :
    ∀ s ∈ traceStates rstart p.script, 0 ≤ s.cash := by
  fin_cases hp <;> decide

end Strategies
end LifeTrac
