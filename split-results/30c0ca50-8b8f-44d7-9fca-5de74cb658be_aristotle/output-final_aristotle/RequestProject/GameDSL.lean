import RequestProject.GodelBrainrot
import RequestProject.CutColosseum

/-!
# Gödel Brainrot — layers of syntax sugar (a playable DSL)

This module adds **syntax sugar** on top of the machine-verified game primitives
from `GodelBrainrot` (`encodeBrainrot`, `steal`, `fight`, `power`, `godelSlap`, …).
Nothing here is axiomatic: every notation is *desugared* to the verified core, and
each `theorem` below proves the sugar is faithful (`rfl`), so playing the game
through the pretty syntax is exactly playing it through the proved functions.

Two layers are provided:

* **Term notation** — `br![...]` for brainrot literals, `⟪ b ⟫` for the Gödel code,
  `g₁ ⚔ g₂` for a bout, `𝓟⟦ g ⟧` for raw power, and `a 🥷 t ⊳ v` for a heist.
* **A scripting monad** — `GameM`, a state monad over a `World` of players, driven by
  a `play! { … }` command block (a tiny imperative brainrot language). `play!`
  elaborates a list of `gameCmd`s into a verified `GameM` program.
-/

namespace GodelBrainrot.DSL

open GodelBrainrot
open GodelBrainrot.CutColosseum

/-! ## Layer 1 — term notation -/

/-- `br!["a", "b"]` is sugar for `Brainrot.mk ["a", "b"]`. -/
syntax (name := brLit) "br![" term,* "]" : term
macro_rules | `(br![$ts,*]) => `(Brainrot.mk [$ts,*])

/-- `⟪ b ⟫` is the Gödel code of a brainrot. -/
notation:max "⟪" b "⟫" => encodeBrainrot b

/-- `g₁ ⚔ g₂` is a Colosseum bout (the stronger total brainrot code wins). -/
infixl:65 " ⚔ " => fight

/-- `𝓟⟦ g ⟧` is the raw power (total Gödel code) of a gladiator. -/
notation:max "𝓟⟦" g "⟧" => power g

/-- `a 🥷 t ⊳ v` : attacker `a` heists encoded brainrot `t` from victim `v`. -/
syntax (name := stealStx) term:65 " 🥷 " term:65 " ⊳ " term:66 : term
macro_rules | `($a 🥷 $t ⊳ $v) => `(steal $a $v $t)

/-- `slap! v` applies Gödel's incompleteness slap to a Cambridge vault. -/
macro "slap! " v:term:max : term => `(godelSlap $v)

/-! ### Faithfulness of the term sugar -/

theorem br_faithful (a b : String) : br![a, b] = Brainrot.mk [a, b] := rfl

theorem code_faithful (b : Brainrot) : ⟪ b ⟫ = encodeBrainrot b := rfl

theorem fight_faithful (g₁ g₂ : Gladiator) : g₁ ⚔ g₂ = fight g₁ g₂ := rfl

theorem power_faithful (g : Gladiator) : 𝓟⟦ g ⟧ = power g := rfl

theorem steal_faithful (a v : Player) (t : Nat) : (a 🥷 t ⊳ v) = steal a v t := rfl

theorem slap_faithful (v : CambridgeVault) : slap! v = godelSlap v := rfl

/-! ## Layer 2 — the `play!` scripting monad -/

/-- The game world: a roster of players plus an append-only event log. -/
structure World where
  players : List Player
  log : List String
deriving Repr

/-- The empty world. -/
def World.empty : World := ⟨[], []⟩

/-- Game programs are state transformers over the `World`. -/
abbrev GameM := StateM World

/-- Append a line to the world's event log. -/
def emit (s : String) : GameM Unit :=
  modify fun w => { w with log := w.log ++ [s] }

/-- Add a player to the world. -/
def recruit (p : Player) : GameM Unit :=
  modify fun w => { w with players := w.players ++ [p] }

/-- Look up a player by name. -/
def find? (name : String) : GameM (Option Player) :=
  return (← get).players.find? (fun p => p.name == name)

/-- Overwrite the stored player that shares `p`'s name (if any) with `p`. -/
def update (p : Player) : GameM Unit :=
  modify fun w =>
    { w with players := w.players.map (fun q => if q.name == p.name then p else q) }

/-- Perform a heist *inside the world*: `atk` steals encoded brainrot `t` from
`vic`, both identified by name. Updates both players and logs the outcome, all via
the verified `steal`. -/
def doHeist (atk vic : String) (t : Nat) : GameM Unit := do
  match ← find? atk, ← find? vic with
  | some a, some v =>
      let (a', v') := steal a v t
      update a'; update v'
      if t ∈ v.vault then
        emit s!"🥷 {atk} heisted {t} from {vic} (+100 aura; {vic} loses half)"
      else
        emit s!"… {atk} found no {t} in {vic}'s vault — heist failed"
  | _, _ => emit s!"⚠ heist aborted: unknown player ({atk} or {vic})"

/-- Stage a bout between two named gladiators-as-players (power = total code of a
brainrot list passed explicitly), logging the winner's name. -/
def doFight (g₁ g₂ : Gladiator) : GameM Unit :=
  emit s!"⚔ {g₁.name} ({power g₁}) vs {g₂.name} ({power g₂}) → {(fight g₁ g₂).name} wins"

/-! ### The command grammar -/

declare_syntax_cat gameCmd

/-- `say "…"` — log a free-form line. -/
syntax "say " term : gameCmd
/-- `enter p` — add player `p` to the world. -/
syntax "enter " term : gameCmd
/-- `heist atk ⊳ t ⊳ vic` — `atk` steals encoded brainrot `t` from `vic` (by name). -/
syntax "heist " term " ⊳ " term " ⊳ " term : gameCmd
/-- `bout g₁ vs g₂` — fight two gladiators, logging the winner. -/
syntax "bout " term " vs " term : gameCmd

/-- Translate one `gameCmd` into the `GameM` action it denotes. -/
def transl (c : Lean.TSyntax `gameCmd) : Lean.MacroM (Lean.TSyntax `term) :=
  match c with
  | `(gameCmd| say $s)               => `(emit $s)
  | `(gameCmd| enter $p)             => `(recruit $p)
  | `(gameCmd| heist $a ⊳ $t ⊳ $v)   => `(doHeist $a $v $t)
  | `(gameCmd| bout $a vs $b)        => `(doFight $a $b)
  | _                                => Lean.Macro.throwUnsupported

/-- A `play! { c₁, c₂, … }` block elaborates a comma-separated list of commands into
a single `GameM Unit` program (sequenced left to right). -/
syntax (name := playBlk) "play! " "{" gameCmd,* "}" : term

macro_rules
  | `(play! { $cmds,* }) => do
      let terms ← cmds.getElems.mapM transl
      let mut acc ← `((pure () : GameM Unit))
      for t in terms.reverse do
        acc ← `((($t : GameM Unit) >>= fun _ => $acc))
      return acc

/-- Run a game program from the empty world, returning the final world. -/
def runGame (prog : GameM Unit) : World := (prog.run World.empty).2

/-! ### A worked script and its verified outcome -/

/-- A short demo session written entirely in the sugar. -/
def demo : GameM Unit := play! {
  say "GG: Gödel Brainrot Stealer — DSL demo",
  enter (⟨"SigmaOhioKing", [⟪ br!["ohio", "rizz"] ⟫], 120⟩ : Player),
  enter (⟨"SkibidiTheorem", [⟪ br!["sigma"] ⟫, ⟪ br!["skibidi", "toilet"] ⟫], 80⟩ : Player),
  heist "SigmaOhioKing" ⊳ (⟪ br!["skibidi", "toilet"] ⟫) ⊳ "SkibidiTheorem",
  bout (⟨"Gödel", [br!["incompleteness"]], 100⟩ : Gladiator)
    vs (⟨"Hilbert", [br!["formalize"]], 100⟩ : Gladiator)
}

/-- The demo produces exactly three log lines, opening with the `say` banner. -/
theorem demo_log_shape :
    (runGame demo).log.length = 3 ∧
      (runGame demo).log.head? = some "GG: Gödel Brainrot Stealer — DSL demo" := by
  native_decide

/-- The heist line records the stolen Gödel code. -/
theorem demo_heist_logged :
    ((runGame demo).log[1]?).any (fun s => s.startsWith "🥷 SigmaOhioKing heisted") := by
  native_decide

/-- After the heist, the attacker really owns the stolen brainrot in the world. -/
theorem demo_attacker_owns :
    ∃ p ∈ (runGame demo).players,
      p.name = "SigmaOhioKing" ∧ ⟪ br!["skibidi", "toilet"] ⟫ ∈ p.vault := by
  native_decide

end GodelBrainrot.DSL
