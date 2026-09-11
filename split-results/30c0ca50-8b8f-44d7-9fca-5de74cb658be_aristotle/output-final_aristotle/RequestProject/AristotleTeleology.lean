import RequestProject.GodelBrainrot
import RequestProject.GameDSL
import RequestProject.HeideggerThrown

/-!
# Aristotle is *actualized* into the game — Teleology, formalized

Where Heidegger arrives *thrown* (`Geworfenheit`) with no purpose and zero aura
(`Angst`, see `RequestProject/HeideggerThrown.lean`), **Aristotle** arrives by the
opposite movement: not a passive throw but an *active actualization* (`Metabole`),
the transition from potentiality (`Dynamis`) to actuality (`Entelecheia`), driven
toward an ultimate cause — the `Telos`.

We model this faithfully on top of the same verified DSL `World`/`GameM`/`recruit`
machinery from `GodelBrainrot.DSL`. The point is a *machine-verified contrast*:

* For Heidegger, **the world precedes Dasein** (`world_precedes_dasein`): one is
  delivered over to a world that was already there.
* For Aristotle, **essence precedes presence** (`essence_precedes_presence`): his
  Gödel-coded `Telos` is fixed in the system *before* and *independently of* any
  world he is actualized into.

Aristotle's facticity is his `hypokeimenon` (underlying matter), his `entelecheia`
(actualization), and his `eudaimonia` (the highest good), each carrying a real
Gödel code via the verified `encodeBrainrot`. He arrives not with `0` aura but with
maximal aura — `Eudaimonia`, the actualized flourishing toward which `Dynamis`
strives.

Nothing here is axiomatic: `actualizePlayer` is defined through the verified DSL
primitive `recruit`, and the concrete-world facts are decided by computation.
-/

namespace GodelBrainrot.Aristotle

open GodelBrainrot
open GodelBrainrot.DSL

/-! ## Aristotle's facticity — his `hypokeimenon`, `entelecheia`, `eudaimonia` -/

/-- `Hypokeimenon` — the underlying matter / substratum that persists through
change. -/
def hypokeimenon : Brainrot := br!["hypokeimenon", "underlying", "matter"]

/-- `Entelecheia` — being-at-work-staying-itself, the having-of-an-end:
actualization. -/
def entelecheia : Brainrot := br!["entelecheia", "actualization", "telos"]

/-- `Eudaimonia` — the highest good, flourishing: the ultimate `Telos`. -/
def eudaimonia : Brainrot := br!["eudaimonia", "the", "highest", "good"]

/-- Aristotle's full `Telos`: the three Gödel codes of his metaphysics, in order
(matter → actualization → highest good). This is his *essence*, fixed before any
world. -/
def aristotleTelos : List Nat := [⟪ hypokeimenon ⟫, ⟪ entelecheia ⟫, ⟪ eudaimonia ⟫]

/-- The maximal initial aura: Aristotle does not arrive with `Angst` (0) but at the
fullness of `Eudaimonia` — `Dynamis` already striving toward `Entelecheia`. -/
def eudaimoniaAura : Nat := 1000

/-- Aristotle as a player, *actualized* with his complete `Telos` (the three Gödel
codes) and maximal aura (`Eudaimonia`). -/
def aristotle : Player := ⟨"aristotle", aristotleTelos, eudaimoniaAura⟩

/-! ## Metabole — the act of actualization -/

/-- **Metabole (actualization).** To actualize a player is the active transition
from the *potential roster* (the ether) into the *actual world*, realized through
the verified DSL primitive `recruit`. -/
def actualizePlayer (w : World) (p : Player) : World := ((recruit p).run w).2

/-- Actualization is *faithful*: it is exactly running the verified `recruit`
action on the world. -/
theorem actualize_faithful (w : World) (p : Player) :
    actualizePlayer w p = ((recruit p).run w).2 := rfl

/-- Actualization appends the now-actual player to the end of the existing roster:
the world moves from `Dynamis` (capacity for one more) to `Entelecheia` (that
capacity fulfilled). -/
theorem actualize_appends (w : World) (p : Player) :
    (actualizePlayer w p).players = w.players ++ [p] := rfl

/-- **`actualization_is_perfect`.** Actualization does not alter the essence of any
player already present (their `hypokeimenon` is untouched), and it fulfills the
world's capacity exactly — the roster grows by precisely one (`Dynamis` →
`Entelecheia`). -/
theorem actualization_is_perfect (w : World) (p : Player) :
    (∀ q ∈ w.players, q ∈ (actualizePlayer w p).players)
      ∧ (actualizePlayer w p).players.length = w.players.length + 1 := by
  refine ⟨fun q hq => ?_, ?_⟩
  · rw [actualize_appends]; exact List.mem_append_left _ hq
  · rw [actualize_appends, List.length_append, List.length_singleton]

/-! ## The core metaphysical theorems -/

/-- **`essence_precedes_presence`.** Aristotle's Gödel-coded `Telos` (his essence)
is validly defined in the system parameters *before* and *independently of* any
world he is actualized into — and only afterward does he come to be *present*
(appended into the world). This is the deliberate inverse of Heidegger's
`world_precedes_dasein`: there the world comes first; here the essence does.

The first conjunct fixes the essence (his vault is exactly his pre-defined
`Telos`); the second conjunct is the (subsequent) presence in *any* world `w`. -/
theorem essence_precedes_presence (w : World) :
    aristotle.vault = aristotleTelos
      ∧ (actualizePlayer w aristotle).players = w.players ++ [aristotle] :=
  ⟨rfl, rfl⟩

/-- The essence is genuinely *defined* — each component of the `Telos` is a strictly
positive (well-defined) Gödel code, so "essence precedes presence" is not vacuous. -/
theorem telos_validly_defined :
    0 < ⟪ hypokeimenon ⟫ ∧ 0 < ⟪ entelecheia ⟫ ∧ 0 < ⟪ eudaimonia ⟫ := by
  refine ⟨?_, ?_, ?_⟩ <;> decide

/-- **`unmoved_mover_preservation`.** The transition function itself disturbs no
state variable unexpectedly: the rules of the DSL — embodied in the world's
event log — remain an *unmoved mover*, unchanged while the player is actualized. -/
theorem unmoved_mover_preservation (w : World) (p : Player) :
    (actualizePlayer w p).log = w.log := by
  unfold actualizePlayer recruit; rfl

/-- **`hylomorphism_invariant`.** Actualizing Aristotle preserves the structural
*form* of the world (its event-log structure is invariant) while updating its
*matter* (the roster count increases by exactly one): form is conserved, matter is
realized. -/
theorem hylomorphism_invariant (w : World) (p : Player) :
    (actualizePlayer w p).log = w.log
      ∧ (actualizePlayer w p).players.length = w.players.length + 1 := by
  refine ⟨unmoved_mover_preservation w p, ?_⟩
  rw [actualize_appends, List.length_append, List.length_singleton]

/-! ## A concrete actualization: Aristotle enters a running game -/

/-- A world already running before Aristotle is actualized. -/
def worldBeforeAristotle : GameM Unit := play! {
  say "The colosseum hums with potentiality; a world stands ready to be actualized.",
  enter (⟨"SigmaOhioKing", [⟪ br!["ohio", "rizz"] ⟫], 120⟩ : Player),
  enter (⟨"SkibidiTheorem", [⟪ br!["sigma"] ⟫, ⟪ br!["skibidi", "toilet"] ⟫], 80⟩ : Player)
}

/-- The world *as it stands* before the actualization. -/
def beforeWorld : World := runGame worldBeforeAristotle

/-- Aristotle is actualized into the already-running world. -/
def afterWorld : World := actualizePlayer beforeWorld aristotle

/-- After actualization, Aristotle *is there* — `Entelecheia` achieved. -/
theorem aristotle_now_there :
    aristotle ∈ afterWorld.players := by
  rw [afterWorld, actualize_appends]
  exact List.mem_append_right _ (List.mem_singleton_self _)

/-- The players already present keep their essence — actualization is perfect. -/
theorem coplayers_unchanged :
    ∀ p ∈ beforeWorld.players, p ∈ afterWorld.players :=
  fun p hp => (actualization_is_perfect beforeWorld aristotle).1 p hp

/-- Concretely, actualization grows the roster from two to three. -/
theorem afterWorld_three_players :
    afterWorld.players.length = 3 := by
  decide +kernel

/-! ## The dialectical encounter: Heidegger (Dasein) meets Aristotle (Telos) -/

open GodelBrainrot.Heidegger (heidegger heideggerBrainrot beingTowardDeath throwInto)

/-- A single world holding *both* philosophers, evaluated together: Heidegger is
first **thrown** (Dasein, `0` aura / `Angst`), then Aristotle is **actualized**
(Telos, maximal `Eudaimonia` aura). -/
def dialecticWorld : World := actualizePlayer (throwInto beforeWorld heidegger) aristotle

/-- Both philosophers coexist in the dialectical world. -/
theorem dialectic_has_both :
    heidegger ∈ dialecticWorld.players ∧ aristotle ∈ dialecticWorld.players := by
  constructor
  · rw [dialecticWorld, actualize_appends]
    exact List.mem_append_left _
      (by rw [throwInto, ← actualize_faithful, actualize_appends]
          exact List.mem_append_right _ (List.mem_singleton_self _))
  · rw [dialecticWorld, actualize_appends]
    exact List.mem_append_right _ (List.mem_singleton_self _)

/-- The dialectical world grows the original two-player roster to four:
two moderns + Heidegger (thrown) + Aristotle (actualized). -/
theorem dialectic_four_players :
    dialecticWorld.players.length = 4 := by
  decide +kernel

/-! ## A runnable scene -/

/-- Render a player's name and aura. -/
def showPlayer (p : Player) : String := s!"{p.name} (aura {p.aura}, vault {p.vault})"

/-- Watch Aristotle actualize and then debate Heidegger. Evaluate with `#eval`. -/
def scene : IO Unit := do
  IO.println "════════════════════════════════════════════════════"
  IO.println " THE BRAINROT DIALECTIC — Geworfenheit vs Telos"
  IO.println "════════════════════════════════════════════════════"
  IO.println "  Heidegger is THROWN in (Dasein, 0 aura / Angst):"
  IO.println s!"    · thrownness code:        {encodeBrainrot heideggerBrainrot}"
  IO.println s!"    · being-toward-death code: {encodeBrainrot beingTowardDeath}"
  IO.println "  Aristotle is ACTUALIZED in (Telos, maximal Eudaimonia aura):"
  IO.println s!"    · hypokeimenon code: {encodeBrainrot hypokeimenon}"
  IO.println s!"    · entelecheia code:  {encodeBrainrot entelecheia}"
  IO.println s!"    · eudaimonia code:   {encodeBrainrot eudaimonia}"
  IO.println "  The dialectical world (each parses the other's Gödel codes):"
  for p in dialecticWorld.players do
    IO.println s!"    · {showPlayer p}"
  IO.println "  ✓ Heidegger: the world precedes Dasein."
  IO.println "  ✓ Aristotle: essence (Telos) precedes presence."
  IO.println ""

#eval scene

end GodelBrainrot.Aristotle
