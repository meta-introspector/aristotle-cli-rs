import RequestProject.GodelBrainrot
import RequestProject.GameDSL

/-!
# Heidegger is *thrown* into the game — Geworfenheit, formalized

A new player, **`heidegger`**, is *thrown* (`Geworfenheit`) into the running
Gödel-Brainrot world. Heidegger's existential analytic supplies the perfect
brainrot vocabulary: *Dasein* (being-there), *Geworfenheit* (thrownness),
*In-der-Welt-sein* (being-in-the-world), and *Sein-zum-Tode* (being-toward-death).

Philosophically, to be *thrown* is to find oneself already delivered over to a
world one did not choose and that was running before one arrived. We model this
faithfully on top of the verified DSL `World`/`GameM` machinery from
`GodelBrainrot.DSL`:

* the world **precedes** Dasein — Heidegger is appended to an *already-populated*
  roster (`throw_appends`, `world_precedes_dasein`);
* once thrown, Dasein **is there** — `heidegger` is among the players
  (`thrown_is_there`); *Da-sein* literally means *being-there*;
* throwing **preserves** the others already in the world (`throw_preserves`);
* the roster grows by exactly one (`throw_card`).

Nothing here is axiomatic: `throwInto` is defined through the verified DSL
primitive `recruit`, and the concrete-world facts are decided by computation.
-/

namespace GodelBrainrot.Heidegger

open GodelBrainrot
open GodelBrainrot.DSL

/-! ## Heidegger's brainrot and his entry as Dasein -/

/-- Heidegger's signature brainrot: pure thrownness. -/
def heideggerBrainrot : Brainrot :=
  br!["geworfenheit", "dasein", "in", "der", "welt", "sein"]

/-- Being-toward-death (`Sein-zum-Tode`), the brainrot that gives Dasein its
ownmost possibility. -/
def beingTowardDeath : Brainrot := br!["sein", "zum", "tode"]

/-- Heidegger as a player (Dasein), arriving with only his *facticity*: the
Gödel codes of his thrownness and his being-toward-death, and zero aura
(`Angst` — anxiety in the face of the world he did not choose). -/
def heidegger : Player :=
  ⟨"heidegger", [⟪ heideggerBrainrot ⟫, ⟪ beingTowardDeath ⟫], 0⟩

/-! ## Geworfenheit — the throw -/

/-- **Geworfenheit (thrownness).** To be *thrown* into a world is to be delivered
over to it via the verified DSL primitive `recruit`: the player is appended to a
roster that already exists. -/
def throwInto (w : World) (p : Player) : World := ((recruit p).run w).2

/-- The throw is *faithful*: being thrown is exactly running the verified
`recruit` action on the world. -/
theorem throw_faithful (w : World) (p : Player) :
    throwInto w p = ((recruit p).run w).2 := rfl

/-
**The world precedes Dasein.** A thrown player is appended *to the end* of the
existing roster — the world was there first; Dasein arrives into it.
-/
theorem throw_appends (w : World) (p : Player) :
    (throwInto w p).players = w.players ++ [p] := rfl

/-
Restatement of `throw_appends`: the prior world is an initial segment of the
world after the throw. Dasein does not displace what was already there.
-/
theorem world_precedes_dasein (w : World) (p : Player) :
    ∃ tail, (throwInto w p).players = w.players ++ tail := by
      exact ⟨ [ p ], throw_appends w p ⟩

/-
**Da-sein — being-there.** Once thrown, the player *is there*: it belongs to
the world's roster.
-/
theorem thrown_is_there (w : World) (p : Player) :
    p ∈ (throwInto w p).players := by
      exact List.mem_append_right _ ( List.mem_singleton_self _ )

/-
**Mitsein — being-with.** Throwing one player preserves every player already
in the world: thrownness adds Dasein to a shared world without erasing the
others.
-/
theorem throw_preserves (w : World) (p q : Player) (hq : q ∈ w.players) :
    q ∈ (throwInto w p).players := by
      convert List.mem_append_left _ hq using 1

/-
The roster grows by exactly one when a player is thrown in.
-/
theorem throw_card (w : World) (p : Player) :
    (throwInto w p).players.length = w.players.length + 1 := by
      rw [ throw_appends, List.length_append, List.length_singleton ]

/-
Throwing leaves the event log untouched (the throw itself is silent —
`Angst` precedes speech).
-/
theorem throw_preserves_log (w : World) (p : Player) :
    (throwInto w p).log = w.log := by
      unfold throwInto;
      unfold recruit; aesop;

/-! ## A concrete throw: Heidegger lands in a running game -/

/-- A world that is *already running* before Heidegger arrives. -/
def worldBeforeHeidegger : GameM Unit := play! {
  say "The colosseum is already roaring; the game runs without us.",
  enter (⟨"SigmaOhioKing", [⟪ br!["ohio", "rizz"] ⟫], 120⟩ : Player),
  enter (⟨"SkibidiTheorem", [⟪ br!["sigma"] ⟫, ⟪ br!["skibidi", "toilet"] ⟫], 80⟩ : Player)
}

/-- The world *as it stands* before the throw. -/
def beforeWorld : World := runGame worldBeforeHeidegger

/-- Heidegger is thrown into the already-running world. -/
def afterWorld : World := throwInto beforeWorld heidegger

/-
Before the throw, Heidegger simply is **not there**: Dasein has not yet been
thrown into the world.
-/
theorem heidegger_not_yet_there :
    heidegger ∉ beforeWorld.players := by
      have h_players : beforeWorld.players = [⟨"SigmaOhioKing", [⟪ br!["ohio", "rizz"] ⟫], 120⟩, ⟨"SkibidiTheorem", [⟪ br!["sigma"] ⟫, ⟪ br!["skibidi", "toilet"] ⟫], 80⟩] := by
        rfl;
      simp +decide [ h_players, heidegger ]

/-
After the throw, Heidegger **is there** — Dasein has been delivered over to
the world.
-/
theorem heidegger_now_there :
    heidegger ∈ afterWorld.players :=
  thrown_is_there beforeWorld heidegger

/-
The two players who were already in the world are still there after the
throw: Heidegger is thrown into a *shared* world (Mitsein).
-/
theorem coplayers_remain :
    ∀ p ∈ beforeWorld.players, p ∈ afterWorld.players :=
  fun p hp => throw_preserves beforeWorld heidegger p hp

/-
Concretely, the throw grows the roster from two to three.
-/
theorem afterWorld_three_players :
    afterWorld.players.length = 3 := by
      decide +kernel

/-! ## A runnable scene -/

/-- Render a player's name and aura. -/
def showPlayer (p : Player) : String := s!"{p.name} (aura {p.aura}, vault {p.vault})"

/-- Watch Heidegger get thrown into the game. Evaluate with `#eval`. -/
def scene : IO Unit := do
  IO.println "════════════════════════════════════════════════════"
  IO.println " A NEW PLAYER IS THROWN IN — Geworfenheit"
  IO.println "════════════════════════════════════════════════════"
  IO.println "  The world before the throw (it was already running):"
  for p in beforeWorld.players do
    IO.println s!"    · {showPlayer p}"
  IO.println "  >> heidegger is THROWN into the game (he did not choose this)."
  IO.println s!"  >> his thrownness code: {encodeBrainrot heideggerBrainrot}"
  IO.println s!"  >> his being-toward-death code: {encodeBrainrot beingTowardDeath}"
  let w := afterWorld
  IO.println "  The world after the throw (Dasein is now Being-in-the-world):"
  for p in w.players do
    IO.println s!"    · {showPlayer p}"
  IO.println "  ✓ Da-sein: heidegger is *there*. The others remain (Mitsein)."
  IO.println ""

#eval scene

end GodelBrainrot.Heidegger