import RequestProject.Solfunmeme.Meme.Engine

/-!
# Staking memes and held blocks

Off chain, a verified play-through is a *staking position*: the blocks you held,
the number of days you held them, and the memes you minted along the way (each
minted meme is a multiplier, because memes are the point).

    payout = blocks * days * (1 + memes)

The whole payout schedule is `Nat` arithmetic, so a position's value is
recomputable by anyone holding the signed share code — see `Proofs/Stake.lean`
for the properties a staker actually cares about: holding longer never pays
less, holding longer with a nonempty balance pays strictly more, and the
schedule is additive in days, so a position can be settled in instalments
without changing what it pays.
-/

namespace Meme.Stake

open Meme.Engine

/-- A staking position derived from a verified play-through. -/
structure Position where
  /-- SOLFUNMEME blocks held. -/
  blocks : Nat
  /-- Days held. -/
  days : Nat
  /-- Memes minted and staked. -/
  memes : Nat
  deriving DecidableEq, Repr, Inhabited

/-- What the position pays. -/
def payout (p : Position) : Nat := p.blocks * p.days * (1 + p.memes)

/-- The position a finished game hands to the staking pool. -/
def ofState (s : State) : Position :=
  { blocks := s.blocks, days := s.day, memes := s.memes }

end Meme.Stake
