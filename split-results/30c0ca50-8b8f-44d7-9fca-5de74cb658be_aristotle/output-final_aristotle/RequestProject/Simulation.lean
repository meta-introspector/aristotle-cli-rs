import RequestProject.GodelBrainrot
import RequestProject.CutColosseum

/-!
# Gödel Brainrot Stealer — a runnable simulation

This module *runs* the Gödel-Brainrot game using the machine-verified game
functions from `GodelBrainrot` and `GodelBrainrot.CutColosseum`
(`encodeBrainrot`, `steal`, `godelSlap`, `fight`, `power`, `cutWeakest`, …).

It is an executable `IO` program: evaluate `#eval GodelBrainrot.Sim.main`
(at the bottom of the file) to watch a full session play out — a heist, the
Cambridge lockdown + Gödel's slap, a Colosseum tournament with plebs betting
ATP drinks, and the cut mechanic trimming the weakest brainrot.

Nothing here is axiomatic: every primitive it calls is a definition that already
ships with proved properties (e.g. `steal_gains`, `fight_winner_strongest`,
`cutWeakest_totalCode_le`, `vault_always_incomplete`).
-/

namespace GodelBrainrot.Sim

open GodelBrainrot
open GodelBrainrot.CutColosseum

/-! ## A tiny reproducible RNG (so the "betting" is deterministic) -/

/-- A linear-congruential generator step. -/
def lcg (seed : Nat) : Nat := (1103515245 * seed + 12345) % 2147483648

/-- `rngRange seed n` returns a pseudo-random value in `[0, n)` and the next seed. -/
def rngRange (seed n : Nat) : Nat × Nat :=
  let s := lcg seed
  (s % (max n 1), s)

/-! ## Pretty-printing helpers -/

/-- Render a brainrot phrase. -/
def showBrainrot (b : Brainrot) : String :=
  "[" ++ String.intercalate " · " b.tokens ++ "]"

/-- Render a brainrot together with its Gödel code. -/
def showCoded (b : Brainrot) : String :=
  showBrainrot b ++ " = " ++ toString (encodeBrainrot b)

/-! ## Sample brainrot corpus -/

def sigma  : Brainrot := ⟨["sigma", "looks", "maxing"]⟩
def fanum  : Brainrot := ⟨["fanum", "tax", "rizzler"]⟩
def skibidi : Brainrot := ⟨["skibidi", "toilet", "incompleteness"]⟩
def ohio   : Brainrot := ⟨["ohio", "rizz"]⟩
def gyatt  : Brainrot := ⟨["gyatt"]⟩
def principia : Brainrot := ⟨["principia", "mathematica", "brainrot"]⟩
def ramanujanBR : Brainrot := ⟨["ramanujan"]⟩

/-! ## Scene 1 — a back-alley heist -/

def sceneHeist : IO Unit := do
  IO.println "════════════════════════════════════════════════════"
  IO.println " SCENE 1 — Back-alley Gödel heist"
  IO.println "════════════════════════════════════════════════════"
  let attacker : Player := ⟨"SigmaOhioKing", [encodeBrainrot ohio], 120⟩
  let victim   : Player := ⟨"SkibidiTheorem",
      [encodeBrainrot sigma, encodeBrainrot skibidi], 80⟩
  IO.println s!"  Attacker {attacker.name}: aura {attacker.aura}, vault {attacker.vault}"
  IO.println s!"  Victim   {victim.name}: aura {victim.aura}, vault {victim.vault}"
  let target := encodeBrainrot skibidi
  IO.println s!"  >> {attacker.name} hacks the vault, targeting {showCoded skibidi}"
  let (a', v') := steal attacker victim target
  IO.println s!"  ✓ Heist! {a'.name}: aura {a'.aura}, vault {a'.vault}"
  IO.println s!"           {v'.name}: aura {v'.aura}, vault {v'.vault}"
  IO.println ""

/-! ## Scene 2 — the Cambridge lockdown and Gödel's slap -/

def sceneCambridge : IO Unit := do
  IO.println "════════════════════════════════════════════════════"
  IO.println " SCENE 2 — The Cambridge Lockdown Incident"
  IO.println "════════════════════════════════════════════════════"
  let vault : CambridgeVault :=
    ⟨["Russell", "Whitehead"], [principia, ramanujanBR, skibidi],
      encodeBrainrot principia⟩
  IO.println s!"  Vault owners: {vault.owners}"
  IO.println s!"  Prisoners:    {vault.prisoners.map showBrainrot}"
  IO.println s!"  Sealed code:  {vault.sealedNumber}"
  IO.println "  >> Hilbert kicks the door: \"We must formalize all brainrot!\""
  IO.println "  >> Gödel walks up and SLAPS Whitehead..."
  let v' := godelSlap vault
  IO.println s!"  ✓ New owners: {v'.owners}"
  IO.println s!"  ✓ Prisoners:  {v'.prisoners.map showBrainrot}   (Ramanujan freed!)"
  IO.println s!"  ✓ New seal:   {v'.sealedNumber}  (= 'this vault is incomplete')"
  IO.println "  (Theorem vault_always_incomplete: no finite vault holds ALL brainrot.)"
  IO.println ""

/-! ## Scene 3 — the Colosseum tournament with ATP betting -/

/-- One bout: the stronger total brainrot code wins. Returns winner + log line. -/
def bout (g1 g2 : Gladiator) : Gladiator × String :=
  let w := fight g1 g2
  (w, s!"    {g1.name} (pow {power g1}) vs {g2.name} (pow {power g2})  →  {w.name} wins")

def sceneColosseum : IO Unit := do
  IO.println "════════════════════════════════════════════════════"
  IO.println " SCENE 3 — Colosseum of Incompleteness (ATP betting)"
  IO.println "════════════════════════════════════════════════════"
  let russell  : Gladiator := ⟨"Russell",  [principia], 100⟩
  let hilbert  : Gladiator := ⟨"Hilbert",  [sigma, ohio], 100⟩
  let godel    : Gladiator := ⟨"Gödel",    [skibidi, fanum], 100⟩
  let ramanujan : Gladiator := ⟨"Ramanujan", [sigma, skibidi, fanum], 100⟩
  let roster := [russell, hilbert, godel, ramanujan]
  IO.println "  Gladiators entering the arena:"
  for g in roster do
    IO.println s!"    {g.name}: power {power g}, aura {g.aura}"
  -- Plebs place ATP bets (deterministic pseudo-random)
  IO.println "  Plebs chug ATP and place their bets:"
  let plebs := ["pleb_gyatt", "pleb_rizz", "pleb_ohio"]
  let mut seed := 271828
  for p in plebs do
    let (pick, s1) := rngRange seed roster.length
    let (amt, s2) := rngRange s1 90
    seed := s2
    let champ := ((roster.map Gladiator.name).getD pick "?")
    IO.println s!"    💰 {p} bets {amt + 10} ATP on {champ}"
  -- Semifinals
  IO.println "  -- Semifinals --"
  let (w1, l1) := bout russell hilbert
  IO.println l1
  let (w2, l2) := bout godel ramanujan
  IO.println l2
  -- Final
  IO.println "  -- Final --"
  let (champ, lf) := bout w1 w2
  IO.println lf
  IO.println s!"  🏆 Champion of the Colosseum: {champ.name} (power {power champ})"
  IO.println ""

/-! ## Scene 4 — the cut mechanic trims the weakest brainrot -/

def sceneCut : IO Unit := do
  IO.println "════════════════════════════════════════════════════"
  IO.println " SCENE 4 — Cut elimination: trim the weakest every round"
  IO.println "════════════════════════════════════════════════════"
  let arena := [sigma, fanum, skibidi, ohio, gyatt]
  IO.println s!"  Arena total power: {totalCode arena}"
  IO.println s!"  Roster: {arena.map showCoded}"
  let mut cur := arena
  let mut round := 1
  while cur ≠ [] do
    let next := cutWeakest cur
    IO.println s!"  Round {round}: cut weakest → total power {totalCode next}, size {next.length}"
    cur := next
    round := round + 1
  IO.println "  (cutWeakest_totalCode_le: total power never increases under cutting.)"
  IO.println ""

/-! ## The full run -/

/-- Run the entire Gödel-Brainrot session. Evaluate with `#eval`. -/
def main : IO Unit := do
  IO.println "╔══════════════════════════════════════════════════╗"
  IO.println "║   GÖDEL BRAINROT STEALER — game simulation run   ║"
  IO.println "╚══════════════════════════════════════════════════╝"
  IO.println ""
  sceneHeist
  sceneCambridge
  sceneColosseum
  sceneCut
  IO.println "════════════════════════════════════════════════════"
  IO.println " GG. The brainrot foundations of mathematics held."
  IO.println "════════════════════════════════════════════════════"

#eval main

end GodelBrainrot.Sim
