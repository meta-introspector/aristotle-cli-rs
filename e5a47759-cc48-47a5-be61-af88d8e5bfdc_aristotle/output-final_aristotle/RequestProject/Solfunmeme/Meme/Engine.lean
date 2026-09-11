/-!
# The FHME engine: a Finite Hash-Meme Engine

This is the deterministic core of the *SOLFUNMEME brainrot tycoon* game.  The
whole game — tapping the stickman, stealing brainrot, building tycoon parts,
minting memes, holding blocks and letting days tick by — is a pure function

    step : State → Input → State

folded over a list of inputs.  Nothing in here is random, floating point, or
stateful, which is exactly what makes a play-through *provable*: a run is
determined by its starting state and its input tape, so a player can publish the
tape (or a hash commitment to it) and anybody can recompute — and check — the
final state, the unlocked badges, the meme count and the accrued stake.

The engine is deliberately arithmetic-only (`Nat` everywhere) so that the browser
implementation shipped in `web/game/index.html` can mirror it exactly, and so the
conformance vectors emitted by `solfunmeme-game vectors` pin the two together.
-/

namespace Meme.Engine

/-! ## Economy constants -/

/-- Brainrot cost of one tycoon part. -/
def partCost : Nat := 50

/-- Brainrot cost of minting one meme. -/
def mintCost : Nat := 100

/-! ## Inputs -/

/-- One player action, i.e. one cell of the input tape. -/
inductive Input
  /-- Tap the stickman: one brainrot. -/
  | tap
  /-- "Steal my brainrot": raid the pool for `n` brainrot. -/
  | steal (n : Nat)
  /-- Build `n` tycoon parts, paying `partCost` brainrot each. -/
  | build (n : Nat)
  /-- Mint a meme, paying `mintCost` brainrot. -/
  | mint
  /-- Acquire `n` more SOLFUNMEME blocks to hold. -/
  | hold (n : Nat)
  /-- One day passes: the tycoon produces, and held blocks earn stake. -/
  | tick
  deriving DecidableEq, Repr, Inhabited

/-- An injective numeric code for an input, used when hashing a tape.  The three
parametrised constructors occupy the three residue classes mod 3 above `3`, so
distinct inputs really do get distinct codes (`code_injective`). -/
def Input.code : Input → Nat
  | .tap => 0
  | .mint => 1
  | .tick => 2
  | .steal n => 3 + 3 * n
  | .build n => 4 + 3 * n
  | .hold n => 5 + 3 * n

/-! ## State -/

/-- The full game state.  `commit` is the rolling hash of the tape that produced
this state; `earned`/`spent` are the ledger columns that make the economy
auditable. -/
structure State where
  /-- Days elapsed in game. -/
  day : Nat := 0
  /-- Current spendable brainrot (the score). -/
  brainrot : Nat := 0
  /-- Tycoon parts built; each produces one brainrot per day. -/
  parts : Nat := 0
  /-- Memes minted so far. -/
  memes : Nat := 0
  /-- SOLFUNMEME blocks held. -/
  blocks : Nat := 0
  /-- Stake accrued from holding blocks, one unit per block per day. -/
  stake : Nat := 0
  /-- Total brainrot ever earned. -/
  earned : Nat := 0
  /-- Total brainrot ever spent. -/
  spent : Nat := 0
  /-- Rolling commitment to the tape. -/
  commit : Nat := 0
  deriving DecidableEq, Repr, Inhabited

/-- The state a fresh player starts from, holding `b` blocks. -/
def start (b : Nat) : State := { blocks := b }

/-! ## Hashing

A 64-bit FNV-1a style mix.  `Commit.lean` develops the abstract theory (what a
commitment buys you, and under exactly which hypothesis); this concrete instance
is what the browser and the CLI actually compute. -/

/-- Modulus of the rolling hash. -/
def hashMod : Nat := 18446744073709551616

/-- FNV-1a style mixing step. -/
def mix (h x : Nat) : Nat := (h * 1099511628211 + x * 2654435761 + 12345) % hashMod

/-! ## The step function -/

/-- One tick of the engine.  Actions that cannot be paid for are no-ops on the
economy — they still advance the commitment, so a tape is never silently
rewritten. -/
def step (s : State) (i : Input) : State :=
  let s := { s with commit := mix s.commit i.code }
  match i with
  | .tap => { s with brainrot := s.brainrot + 1, earned := s.earned + 1 }
  | .steal n => { s with brainrot := s.brainrot + n, earned := s.earned + n }
  | .build n =>
      if partCost * n ≤ s.brainrot then
        { s with brainrot := s.brainrot - partCost * n,
                 parts := s.parts + n,
                 spent := s.spent + partCost * n }
      else s
  | .mint =>
      if mintCost ≤ s.brainrot then
        { s with brainrot := s.brainrot - mintCost,
                 memes := s.memes + 1,
                 spent := s.spent + mintCost }
      else s
  | .hold n => { s with blocks := s.blocks + n }
  | .tick =>
      { s with day := s.day + 1,
               brainrot := s.brainrot + s.parts,
               earned := s.earned + s.parts,
               stake := s.stake + s.blocks }

/-- Run a whole tape. -/
def run (s : State) (xs : List Input) : State := xs.foldl step s

/-! ## Badges

Every badge is a threshold on a *monotone* quantity, which is what makes
"unlocked" permanent (`Proofs/Engine.lean`). -/

/-- The unlockable achievements; each one renders as a signed SVG screenshot. -/
inductive Badge
  /-- Minted a meme. -/
  | firstMeme
  /-- Minted ten memes. -/
  | memeLord
  /-- Built twenty-five tycoon parts. -/
  | tycoonist
  /-- Held through thirty in-game days. -/
  | diamondHands
  /-- Accrued a thousand units of stake. -/
  | stakeWhale
  deriving DecidableEq, Repr, Inhabited

/-- Every badge in the game. -/
def allBadges : List Badge := [.firstMeme, .memeLord, .tycoonist, .diamondHands, .stakeWhale]

/-- The unlock condition of a badge: always a threshold on a quantity the engine
can only increase. -/
def Badge.meets (b : Badge) (s : State) : Bool :=
  match b with
  | .firstMeme => 1 ≤ s.memes
  | .memeLord => 10 ≤ s.memes
  | .tycoonist => 25 ≤ s.parts
  | .diamondHands => 30 ≤ s.day
  | .stakeWhale => 1000 ≤ s.stake

/-- The badges a state has unlocked, in a fixed order. -/
def unlocked (s : State) : List Badge := allBadges.filter (fun b => b.meets s)

/-! ## Verification of a claimed play-through -/

/-- A published play-through: where it started, what was played, what is claimed. -/
structure Claim where
  /-- Blocks held at the start. -/
  blocks : Nat
  /-- The input tape. -/
  tape : List Input
  /-- The claimed final state. -/
  final : State
  deriving DecidableEq, Repr, Inhabited

/-- Recompute the claim and compare. -/
def Claim.verify (c : Claim) : Bool := run (start c.blocks) c.tape == c.final

end Meme.Engine
