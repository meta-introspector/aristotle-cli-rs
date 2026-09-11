import RequestProject.Gvcs.Tycoon

/-!
# The user interface of the game, as a machine that cannot lie

`Game.lean` is the rule book: `step` says what a move does and returns `none`
exactly when the move is illegal.  This file is the *front end* — the screens
the player looks at, the buttons on them, the undo stack behind them — modelled
as a deterministic transition system on top of that rule book, and proved to be
a faithful presentation of it.

The design it formalises is the one written up in `docs/ui-design.md`:

* a **screen graph** (`Screen`, `parent`) — a title screen, the yard that is
  the hub of play, and the four working screens (market, workbench, field
  planner, ledger) hanging off it, plus a help book;
* a **panel discipline** (`home`, `offers`) — every move of the game belongs to
  exactly one screen, so the player always knows where a thing is done;
* an **affordance rule** (`enabled`) — a button is live exactly when the move
  behind it is legal, no more and no less;
* an **undo stack** (`UIState.past`) and an **action log** (`UIState.log`).

The theorems are the promises the interface makes.

* `handle_commit_rejected`: pressing a dead button does nothing at all — the
  interface can never enter a state the rule book forbids.
* `enabled_iff`: the greying-out rule is exactly the rule book's own
  admissibility test (`enabled_buy_iff`, `enabled_farm_iff`, … spell it out
  button by button).
* `home_unique`: no move appears on two screens, and every move appears on one.
* `back_reaches_root`, `reachable_all`: the back button always gets you home in
  at most three presses, and every screen can be reached from the title.
* `undo_commit`: undo after an accepted move restores the previous state
  exactly.
* `trace_handleAll` and `session_run_log`: **the replay theorem** — whatever
  the player does with the mouse, the log the interface keeps is a legal script
  of the game and replaying it through `run` reproduces the state on screen.
  The interface is not a second implementation of the rules; it is a view of
  them.
* `legal_of_session`: hence cash, stock and fuel on the HUD are never negative.
* `demoSession_hud`: the verified playthrough of `Tycoon.lean`, driven through
  the interface click by click, ends with the same numbers on the HUD.
-/

namespace LifeTrac
namespace UI

open Build
open Material Assembly GameState

/-! ## The screen graph -/

/-- The screens of the game. -/
inductive Screen where
  /-- The title screen: new game, continue, help. -/
  | title
  /-- The yard — the hub of play, where the machines stand. -/
  | yard
  /-- The market: stock, fuel and the bill-of-materials order desk. -/
  | market
  /-- The workbench: fabricate a subassembly or the machine. -/
  | workbench
  /-- The field planner: choose a crop and an area and work it. -/
  | field
  /-- The ledger: cash, net worth, the log of what has been done. -/
  | ledger
  /-- The help book: the engineering behind the numbers. -/
  | help
  deriving DecidableEq, Repr, Inhabited

namespace Screen

/-- The screen a given screen was opened from; `none` for the root. -/
def parent : Screen → Option Screen
  | title => none
  | yard => some title
  | market => some yard
  | workbench => some yard
  | field => some yard
  | ledger => some yard
  | help => some title

/-- How deep a screen sits in the menu tree. -/
def depth : Screen → ℕ
  | title => 0
  | yard => 1
  | help => 1
  | market => 2
  | workbench => 2
  | field => 2
  | ledger => 2

/-- Going up is always a strict descent, so the back button terminates. -/
theorem depth_parent_lt {s p : Screen} (h : s.parent = some p) : p.depth < s.depth := by
  cases s <;> simp [parent] at h <;> subst h <;> simp [depth]

/-- Only the title screen has no parent. -/
theorem parent_eq_none_iff {s : Screen} : s.parent = none ↔ s = title := by
  cases s <;> simp [parent]

end Screen

open Screen

/-! ## What each screen can do -/

/-- The screen on which a move is made.  Every move of the game lives on
exactly one screen: buying, ordering, selling and refuelling at the market,
fabrication at the workbench, farming at the field planner. -/
def home : Action → Screen
  | .buy _ _ => market
  | .order _ => market
  | .sell _ _ => market
  | .refuel _ => market
  | .fabricate _ => workbench
  | .farm _ _ _ => field

/-- Does this screen carry the control for this move? -/
def offers (s : Screen) (a : Action) : Bool := home a == s

@[simp] theorem offers_home (a : Action) : offers (home a) a = true := by
  simp [offers]

theorem offers_iff {s : Screen} {a : Action} : offers s a = true ↔ home a = s := by
  simp [offers]

/-- A move is on one screen and one screen only. -/
theorem home_unique {s t : Screen} {a : Action}
    (hs : offers s a = true) (ht : offers t a = true) : s = t := by
  rw [offers_iff] at hs ht; rw [← hs, ← ht]

/-- Nothing at all is done on the title screen, in the yard, in the ledger or
in the help book: those screens only navigate and report. -/
theorem no_action_on_passive {a : Action} :
    offers title a = false ∧ offers yard a = false ∧ offers ledger a = false ∧
      offers help a = false := by
  cases a <;> simp [offers, home]

/-! ## When a button is live -/

/-- The greying-out rule: a control is live exactly when the rule book accepts
the move behind it. -/
def enabled (mk : Market) (g : GameState) (a : Action) : Bool := (step mk g a).isSome

theorem enabled_iff {mk : Market} {g : GameState} {a : Action} :
    enabled mk g a = true ↔ ∃ h, step mk g a = some h := by
  simp [enabled, Option.isSome_iff_exists]

/-- The **Buy** button is live exactly when the player can pay for the stock. -/
theorem enabled_buy_iff {mk : Market} {g : GameState} {m : Material} {q : ℚ} :
    enabled mk g (.buy m q) = true ↔ (0 ≤ q ∧ q * unitCost m ≤ g.cash) := by
  by_cases h : 0 ≤ q ∧ q * unitCost m ≤ g.cash <;> simp [enabled, step, h]

/-- The **Order** button is live exactly when the bill of materials is
well formed and affordable. -/
theorem enabled_order_iff {mk : Market} {g : GameState} {a : Assembly} :
    enabled mk g (.order a) = true ↔ (a.WellFormed = true ∧ a.materialCost ≤ g.cash) := by
  by_cases h : a.WellFormed = true ∧ a.materialCost ≤ g.cash <;> simp [enabled, step, h]

/-- The **Sell** button is live exactly when the stock is on the shelf. -/
theorem enabled_sell_iff {mk : Market} {g : GameState} {m : Material} {q : ℚ} :
    enabled mk g (.sell m q) = true ↔ (0 ≤ q ∧ q ≤ g.stock m) := by
  by_cases h : 0 ≤ q ∧ q ≤ g.stock m <;> simp [enabled, step, h]

/-- The **Refuel** button is live exactly when the fuel can be paid for. -/
theorem enabled_refuel_iff {mk : Market} {g : GameState} {l : ℚ} :
    enabled mk g (.refuel l) = true ↔ (0 ≤ l ∧ mk.fuelPrice * l ≤ g.cash) := by
  by_cases h : 0 ≤ l ∧ mk.fuelPrice * l ≤ g.cash <;> simp [enabled, step, h]

/-- The **Fabricate** button is live exactly when the material is on the shelf
and the wage bill can be met. -/
theorem enabled_fabricate_iff {mk : Market} {g : GameState} {a : Assembly} :
    enabled mk g (.fabricate a) = true ↔
      (a.WellFormed = true ∧ Inventory.Covers g.stock a.requirements ∧
        mk.laborRate * a.laborHours ≤ g.cash) := by
  by_cases h : a.WellFormed = true ∧ Inventory.Covers g.stock a.requirements ∧
      mk.laborRate * a.laborHours ≤ g.cash <;> simp [enabled, step, h]

/-- The **Work the field** button is live exactly when there is a machine, fuel
for the season and money for the seed. -/
theorem enabled_farm_iff {mk : Market} {g : GameState} {nm : String} {c : Crop} {area : ℚ} :
    enabled mk g (.farm nm c area) = true ↔
      (g.hasMachine nm = true ∧ 0 ≤ area ∧ seasonFuel c area ≤ g.fuel ∧
        area * c.seedCostPerHa ≤ g.cash) := by
  by_cases h : g.hasMachine nm = true ∧ 0 ≤ area ∧ seasonFuel c area ≤ g.fuel ∧
      area * c.seedCostPerHa ≤ g.cash <;> simp [enabled, step, h]

/-- Without a machine the field planner is completely dead: no crop, no area,
no button. -/
theorem field_dead_without_machine {mk : Market} {g : GameState} {nm : String}
    (h : g.hasMachine nm = false) (c : Crop) (area : ℚ) :
    enabled mk g (.farm nm c area) = false := by
  simp [enabled, step_farm_none h]

/-- The interface is never wholly dead: from any legal position the market
still has a live control. -/
theorem some_control_enabled {mk : Market} {g : GameState} (hg : g.Legal) (m : Material) :
    enabled mk g (.buy m 0) = true := by
  rw [enabled_buy_iff]
  exact ⟨le_refl 0, by simpa using hg.1⟩

/-! ## The interface itself -/

/-- What the player owns *and* what the interface remembers: which screen is
open, the undo stack, and the log of accepted moves (most recent first). -/
structure UIState where
  /-- The screen currently on show. -/
  screen : Screen
  /-- The position of the game. -/
  game : GameState
  /-- The states the player can undo back to, most recent first. -/
  past : List GameState
  /-- The moves accepted so far, most recent first. -/
  log : List Action

/-- Opening the game on the title screen. -/
def boot (g : GameState) : UIState := ⟨title, g, [], []⟩

/-- What the player can do with the mouse. -/
inductive Event where
  /-- Open a submenu. -/
  | nav (target : Screen) : Event
  /-- The back button. -/
  | back : Event
  /-- Press the confirm button of a control. -/
  | commit (a : Action) : Event
  /-- The undo button. -/
  | undo : Event

/-- The event loop.  It is total: an event the interface does not accept simply
leaves the state alone, which is what a dead button does. -/
def handle (mk : Market) (u : UIState) : Event → UIState
  | .nav t => if t.parent = some u.screen then { u with screen := t } else u
  | .back => match u.screen.parent with
      | some p => { u with screen := p }
      | none => u
  | .commit a =>
      if offers u.screen a then
        match step mk u.game a with
        | some g => { u with game := g, past := u.game :: u.past, log := a :: u.log }
        | none => u
      else u
  | .undo => match u.past, u.log with
      | g :: gs, _ :: as => { u with game := g, past := gs, log := as }
      | _, _ => u

/-- A whole session. -/
def handleAll (mk : Market) (u : UIState) : List Event → UIState
  | [] => u
  | e :: es => handleAll mk (handle mk u e) es

@[simp] theorem handleAll_nil (mk : Market) (u : UIState) : handleAll mk u [] = u := rfl

@[simp] theorem handleAll_cons (mk : Market) (u : UIState) (e : Event) (es : List Event) :
    handleAll mk u (e :: es) = handleAll mk (handle mk u e) es := rfl

theorem handleAll_append (mk : Market) (u : UIState) (l₁ l₂ : List Event) :
    handleAll mk u (l₁ ++ l₂) = handleAll mk (handleAll mk u l₁) l₂ := by
  induction l₁ generalizing u with
  | nil => rfl
  | cons e es ih => simp [ih]

/-! ## What the event loop does -/

/-- Navigation never touches the position of the game. -/
@[simp] theorem game_nav (mk : Market) (u : UIState) (t : Screen) :
    (handle mk u (.nav t)).game = u.game := by
  simp only [handle]; split <;> rfl

/-- Nor does the back button. -/
@[simp] theorem game_back (mk : Market) (u : UIState) :
    (handle mk u .back).game = u.game := by
  simp only [handle]; split <;> rfl

/-- Drilling down opens the submenu. -/
theorem handle_nav_ok {mk : Market} {u : UIState} {t : Screen} (h : t.parent = some u.screen) :
    handle mk u (.nav t) = { u with screen := t } := by
  simp [handle, h]

/-- You cannot jump to a screen that is not a submenu of the one you are on. -/
theorem handle_nav_blocked {mk : Market} {u : UIState} {t : Screen}
    (h : t.parent ≠ some u.screen) : handle mk u (.nav t) = u := by
  simp [handle, h]

/-- Back goes up one level. -/
theorem handle_back {mk : Market} {u : UIState} {p : Screen} (h : u.screen.parent = some p) :
    handle mk u .back = { u with screen := p } := by
  simp [handle, h]

/-- Back on the title screen is a no-op: the player cannot fall out of the
interface. -/
theorem handle_back_title {mk : Market} {u : UIState} (h : u.screen = title) :
    handle mk u .back = u := by
  simp [handle, h, parent]

/-- An accepted move: the state advances by the rule book, the previous state
goes on the undo stack and the move goes in the log. -/
theorem handle_commit_ok {mk : Market} {u : UIState} {a : Action} {g : GameState}
    (ho : offers u.screen a) (hstep : step mk u.game a = some g) :
    handle mk u (.commit a) =
      { u with game := g, past := u.game :: u.past, log := a :: u.log } := by
  simp [handle, ho, hstep]

/-- A dead button does nothing: neither an illegal move nor a move made on the
wrong screen changes anything. -/
theorem handle_commit_rejected {mk : Market} {u : UIState} {a : Action}
    (h : offers u.screen a = false ∨ enabled mk u.game a = false) :
    handle mk u (.commit a) = u := by
  rcases h with h | h
  · simp [handle, h]
  · have : step mk u.game a = none := by
      simpa [enabled, Option.isSome_eq_false_iff, Option.isNone_iff_eq_none] using h
    simp [handle, this]

/-- Undo after an accepted move restores the position exactly, and forgets the
move. -/
theorem undo_commit {mk : Market} {u : UIState} {a : Action} {g : GameState}
    (ho : offers u.screen a) (hstep : step mk u.game a = some g) :
    handle mk (handle mk u (.commit a)) .undo = u := by
  rw [handle_commit_ok ho hstep]
  simp [handle]

/-- Undo at the beginning of the game does nothing. -/
theorem undo_boot {mk : Market} {g : GameState} : handle mk (boot g) .undo = boot g := by
  simp [handle, boot]

/-! ## Every screen can be reached, and the back button always gets home -/

/-- The screens the player can navigate to, starting from the title screen. -/
inductive Reachable : Screen → Prop
  | title : Reachable title
  | step {s t : Screen} (hs : Reachable s) (h : t.parent = some s) : Reachable t

theorem reachable_all (s : Screen) : Reachable s := by
  have hy : Reachable yard := .step .title rfl
  cases s
  · exact .title
  · exact hy
  · exact .step hy rfl
  · exact .step hy rfl
  · exact .step hy rfl
  · exact .step hy rfl
  · exact .step .title rfl

/-- Pressing back `depth` times from any screen lands on the title screen, so
the player is never lost: three presses suffice everywhere. -/
theorem back_reaches_title (mk : Market) (u : UIState) :
    (handleAll mk u (List.replicate u.screen.depth .back)).screen = title := by
  cases u with
  | mk s g past log =>
    cases s <;> simp [depth, handleAll, handle, parent, List.replicate]

theorem depth_le_two (s : Screen) : s.depth ≤ 2 := by cases s <;> simp [depth]

/-- Navigation and back never lose the player's progress. -/
theorem game_handleAll_nav (mk : Market) (u : UIState) (n : ℕ) :
    (handleAll mk u (List.replicate n .back)).game = u.game := by
  induction n generalizing u with
  | zero => rfl
  | succ k ih => simp [List.replicate, ih]

/-! ## The replay theorem -/

/-- The interface's memory is *honest*: `Trace mk g₀ log past g` says that the
log really is the list of moves that took the game from `g₀` to `g`, and that
the undo stack really holds the intermediate positions. -/
inductive Trace (mk : Market) (g₀ : GameState) : List Action → List GameState → GameState → Prop
  | nil : Trace mk g₀ [] [] g₀
  | commit {a : Action} {log : List Action} {past : List GameState} {g h : GameState}
      (ht : Trace mk g₀ log past g) (hs : step mk g a = some h) :
      Trace mk g₀ (a :: log) (g :: past) h

/-- A trace really is a run of the rule book. -/
theorem run_of_trace {mk : Market} {g₀ g : GameState} {log : List Action}
    {past : List GameState} (h : Trace mk g₀ log past g) :
    run mk g₀ log.reverse = some g := by
  induction h with
  | nil => rfl
  | commit ht hs ih => rw [List.reverse_cons, run_append, ih]; simpa using hs

/-- Undo keeps the memory honest. -/
theorem trace_tail {mk : Market} {g₀ g : GameState} {a : Action} {log : List Action}
    {p : GameState} {past : List GameState} (h : Trace mk g₀ (a :: log) (p :: past) g) :
    Trace mk g₀ log past p := by
  cases h with
  | commit ht _ => exact ht

/-- Every event of the interface keeps the memory honest. -/
theorem trace_handle {mk : Market} {g₀ : GameState} {u : UIState} (e : Event)
    (h : Trace mk g₀ u.log u.past u.game) :
    Trace mk g₀ (handle mk u e).log (handle mk u e).past (handle mk u e).game := by
  cases e with
  | nav t => simp only [handle]; split <;> exact h
  | back => simp only [handle]; split <;> exact h
  | commit a =>
      simp only [handle]
      split
      · cases hs : step mk u.game a with
        | none => simpa [hs] using h
        | some g => simpa [hs] using Trace.commit h hs
      · exact h
  | undo =>
      cases hp : u.past with
      | nil =>
          have hu : handle mk u .undo = u := by simp [handle, hp]
          rw [hu]; exact h
      | cons p ps =>
          cases hl : u.log with
          | nil =>
              have hu : handle mk u .undo = u := by simp [handle, hp, hl]
              rw [hu]; exact h
          | cons a as =>
              have hu : handle mk u (.undo) =
                  { u with game := p, past := ps, log := as } := by
                simp [handle, hp, hl]
              rw [hu]
              rw [hp, hl] at h
              exact trace_tail h

/-- Hence a whole session does. -/
theorem trace_handleAll {mk : Market} {g₀ : GameState} {u : UIState} (es : List Event)
    (h : Trace mk g₀ u.log u.past u.game) :
    Trace mk g₀ (handleAll mk u es).log (handleAll mk u es).past (handleAll mk u es).game := by
  induction es generalizing u with
  | nil => exact h
  | cons e es ih => exact ih (trace_handle e h)

/-- **The replay theorem.**  Whatever the player clicks, the log the interface
keeps is a legal script of the game, and replaying that script through the rule
book reproduces exactly the position on screen.  The interface is a view of the
rules, not a second copy of them. -/
theorem session_run_log (mk : Market) (g₀ : GameState) (es : List Event) :
    run mk g₀ (handleAll mk (boot g₀) es).log.reverse =
      some (handleAll mk (boot g₀) es).game :=
  run_of_trace (trace_handleAll es (by simpa [boot] using Trace.nil))

/-- Hence the HUD never shows negative cash, negative stock or negative fuel. -/
theorem legal_of_session {mk : Market} {g₀ : GameState} (hg : g₀.Legal) (es : List Event) :
    (handleAll mk (boot g₀) es).game.Legal :=
  run_legal hg (session_run_log mk g₀ es)

/-! ## The head-up display -/

/-- What the interface puts on the status bar. -/
structure Hud where
  /-- Cash in hand. -/
  cash : ℚ
  /-- Value of everything owned. -/
  netWorth : ℚ
  /-- Litres in the tank. -/
  fuel : ℚ
  /-- The calendar. -/
  day : ℚ
  /-- Hectares worked so far. -/
  hectares : ℚ
  /-- Whether the tractor is built. -/
  hasTractor : Bool
  deriving DecidableEq, Repr

/-- Reading the status bar off the state. -/
def hud (mk : Market) (u : UIState) : Hud :=
  { cash := u.game.cash
    netWorth := netWorth mk u.game
    fuel := u.game.fuel
    day := u.game.day
    hectares := u.game.hectares
    hasTractor := u.game.hasMachine "LifeTrac" }

/-- The status bar does not change when the player merely looks around. -/
@[simp] theorem hud_nav (mk : Market) (u : UIState) (t : Screen) :
    hud mk (handle mk u (.nav t)) = hud mk u := by
  simp [hud]

@[simp] theorem hud_back (mk : Market) (u : UIState) : hud mk (handle mk u .back) = hud mk u := by
  simp [hud]

/-- The cash on the status bar is never negative once the game has begun
legally. -/
theorem hud_cash_nonneg {mk : Market} {g₀ : GameState} (hg : g₀.Legal) (es : List Event) :
    0 ≤ (hud mk (handleAll mk (boot g₀) es)).cash :=
  (legal_of_session hg es).1

/-! ## The verified playthrough, driven with the mouse -/

/-- The clicks that play `Tycoon.lean`'s first season: into the yard, into the
market to order the bill of materials, back and into the workbench to weld it
up, back to the market for fuel, and out to the field with twenty hectares of
wheat. -/
def demoSession : List Event :=
  [ .nav yard
  , .nav market
  , .commit (.order lifeTrac)
  , .back
  , .nav workbench
  , .commit (.fabricate lifeTrac)
  , .back
  , .nav market
  , .commit (.refuel 400)
  , .back
  , .nav field
  , .commit (.farm "LifeTrac" wheat 20) ]

/-- Played with the mouse, the demo leaves the player in the field planner with
the whole first season in the log, in the order it was played. -/
theorem demoSession_log :
    (handleAll homestead (boot Build.start) demoSession).log.reverse = firstSeason ∧
      (handleAll homestead (boot Build.start) demoSession).screen = field := by
  obtain ⟨t, ht, -⟩ := run_firstSeason
  rw [firstSeason, run_cons] at ht
  cases h1 : step homestead Build.start (.order lifeTrac) with
  | none => rw [h1] at ht; simp at ht
  | some s1 =>
    rw [h1, Option.bind_some, run_cons] at ht
    cases h2 : step homestead s1 (.fabricate lifeTrac) with
    | none => rw [h2] at ht; simp at ht
    | some s2 =>
      rw [h2, Option.bind_some, run_cons] at ht
      cases h3 : step homestead s2 (.refuel 400) with
      | none => rw [h3] at ht; simp at ht
      | some s3 =>
        rw [h3, Option.bind_some, run_cons] at ht
        cases h4 : step homestead s3 (.farm "LifeTrac" wheat 20) with
        | none => rw [h4] at ht; simp at ht
        | some s4 =>
          have e1 : handle homestead (boot Build.start) (.nav yard) =
              ⟨yard, Build.start, [], []⟩ := by simp [handle, boot, Screen.parent]
          have e2 : handle homestead (⟨yard, Build.start, [], []⟩ : UIState) (.nav market) =
              ⟨market, Build.start, [], []⟩ := by simp [handle, Screen.parent]
          have e3 : handle homestead (⟨market, Build.start, [], []⟩ : UIState)
              (.commit (.order lifeTrac)) =
              ⟨market, s1, [Build.start], [Action.order lifeTrac]⟩ := by
            simp [handle, offers, home, h1]
          have e4 : handle homestead
              (⟨market, s1, [Build.start], [Action.order lifeTrac]⟩ : UIState) .back =
              ⟨yard, s1, [Build.start], [Action.order lifeTrac]⟩ := by
            simp [handle, Screen.parent]
          have e5 : handle homestead
              (⟨yard, s1, [Build.start], [Action.order lifeTrac]⟩ : UIState) (.nav workbench) =
              ⟨workbench, s1, [Build.start], [Action.order lifeTrac]⟩ := by
            simp [handle, Screen.parent]
          have e6 : handle homestead
              (⟨workbench, s1, [Build.start], [Action.order lifeTrac]⟩ : UIState)
              (.commit (.fabricate lifeTrac)) =
              ⟨workbench, s2, [s1, Build.start],
                [Action.fabricate lifeTrac, Action.order lifeTrac]⟩ := by
            simp [handle, offers, home, h2]
          have e7 : handle homestead
              (⟨workbench, s2, [s1, Build.start],
                [Action.fabricate lifeTrac, Action.order lifeTrac]⟩ : UIState) .back =
              ⟨yard, s2, [s1, Build.start],
                [Action.fabricate lifeTrac, Action.order lifeTrac]⟩ := by
            simp [handle, Screen.parent]
          have e8 : handle homestead
              (⟨yard, s2, [s1, Build.start],
                [Action.fabricate lifeTrac, Action.order lifeTrac]⟩ : UIState) (.nav market) =
              ⟨market, s2, [s1, Build.start],
                [Action.fabricate lifeTrac, Action.order lifeTrac]⟩ := by
            simp [handle, Screen.parent]
          have e9 : handle homestead
              (⟨market, s2, [s1, Build.start],
                [Action.fabricate lifeTrac, Action.order lifeTrac]⟩ : UIState)
              (.commit (.refuel 400)) =
              ⟨market, s3, [s2, s1, Build.start],
                [Action.refuel 400, Action.fabricate lifeTrac, Action.order lifeTrac]⟩ := by
            simp [handle, offers, home, h3]
          have e10 : handle homestead
              (⟨market, s3, [s2, s1, Build.start],
                [Action.refuel 400, Action.fabricate lifeTrac,
                  Action.order lifeTrac]⟩ : UIState) .back =
              ⟨yard, s3, [s2, s1, Build.start],
                [Action.refuel 400, Action.fabricate lifeTrac, Action.order lifeTrac]⟩ := by
            simp [handle, Screen.parent]
          have e11 : handle homestead
              (⟨yard, s3, [s2, s1, Build.start],
                [Action.refuel 400, Action.fabricate lifeTrac,
                  Action.order lifeTrac]⟩ : UIState) (.nav field) =
              ⟨field, s3, [s2, s1, Build.start],
                [Action.refuel 400, Action.fabricate lifeTrac, Action.order lifeTrac]⟩ := by
            simp [handle, Screen.parent]
          have e12 : handle homestead
              (⟨field, s3, [s2, s1, Build.start],
                [Action.refuel 400, Action.fabricate lifeTrac,
                  Action.order lifeTrac]⟩ : UIState)
              (.commit (.farm "LifeTrac" wheat 20)) =
              ⟨field, s4, [s3, s2, s1, Build.start],
                [Action.farm "LifeTrac" wheat 20, Action.refuel 400,
                  Action.fabricate lifeTrac, Action.order lifeTrac]⟩ := by
            simp [handle, offers, home, h4]
          simp only [demoSession, handleAll_cons, handleAll_nil, e1, e2, e3, e4, e5, e6,
            e7, e8, e9, e10, e11, e12]
          exact ⟨rfl, trivial⟩

/-- And the numbers on the status bar at the end are exactly the numbers proved
in `Tycoon.lean`: 18 449 in cash, 40 litres left, 17.125 days gone, twenty
hectares worked, a LifeTrac in the shed and a net worth of 28 060. -/
theorem demoSession_hud :
    hud homestead (handleAll homestead (boot Build.start) demoSession) =
      { cash := 18449, netWorth := 28060, fuel := 40, day := 137/8, hectares := 20,
        hasTractor := true } := by
  obtain ⟨t, ht, hcash, -, hfuel, hday, hha, hmach, hnw⟩ := run_firstSeason
  have hlog := (demoSession_log).1
  have hrun := session_run_log homestead Build.start demoSession
  rw [hlog, ht] at hrun
  have : (handleAll homestead (boot Build.start) demoSession).game = t := by
    exact (Option.some.inj hrun).symm
  simp [hud, this, hcash, hfuel, hday, hha, hmach, hnw]

end UI
end LifeTrac
