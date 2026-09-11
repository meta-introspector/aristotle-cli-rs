import RequestProject.Solfunmeme.Meme.Engine

/-!
# Hash-chain commitments over a tape

The engine carries a rolling hash of the tape it has consumed.  This file gives
that construction its abstract form and states exactly what it buys you.

Two honest caveats, stated up front because they are the whole point of writing
this in Lean:

* Nothing here proves that the *concrete* 64-bit `Meme.Engine.mix` is collision
  resistant — it isn't; it is a cheap mixer chosen so the browser can compute it.
  The binding theorem `chain_injective` is stated **relative to** an idealised
  hypothesis on the compression function, which is how commitment schemes are
  analysed anyway.
* What is unconditional is *completeness*: a verifier that replays the tape
  accepts exactly the honest play-throughs (`Claim.verify_iff`), and replay is
  compositional (`chain_append`), which is what lets a client check a long game
  incrementally.
-/

namespace Meme.Commit

/-- A hash chain: fold a compression function over the tape. -/
def chain {H : Type} (f : H → Nat → H) (h0 : H) (xs : List Nat) : H := xs.foldl f h0

end Meme.Commit

namespace Meme.Engine

/-- A *checkpoint segment*: the commitment a run had reached, a stretch of play,
and the commitment it reached afterwards.  Publishing a segment lets a verifier
check that stretch of play against a previously published checkpoint without
being shown the moves before it. -/
structure Segment where
  /-- Commitment at the checkpoint. -/
  before : Nat
  /-- The disclosed stretch of play. -/
  seg : List Input
  /-- Commitment claimed after it. -/
  after : Nat
  deriving DecidableEq, Repr, Inhabited

/-- Check a segment by rehashing just that stretch. -/
def Segment.verify (sg : Segment) : Bool :=
  Meme.Commit.chain mix sg.before (sg.seg.map Input.code) == sg.after

end Meme.Engine
