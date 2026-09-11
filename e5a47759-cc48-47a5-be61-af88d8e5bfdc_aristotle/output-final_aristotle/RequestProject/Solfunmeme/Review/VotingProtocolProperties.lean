/-
  VotingProtocolProperties.lean — what `voteValid` in `lean4/VotingProtocol.lean`
  actually checks.

  The upstream header states the intended invariant:

      a vote is valid iff
        - NFT credential matches a known tier holder at snapshot
        - ZK proof shows balance ≥ tier minimum at vote time
        - Signature matches the NFT owner
        - Vote was cast before deadline

  and the module then proves four hand-picked rejection scenarios.  The theorems
  below give the general characterisation of `voteValid` and isolate the gaps
  between it and the intended invariant:

    1. the `signature` field is never read, so no signature is ever checked;
    2. the ZK `proofHash` field is never read either — nothing links the accepted
       balance to a verified proof;
    3. the snapshot `balance` and `rank` recorded in the credential are unused,
       so a credential's own claim about its tier is never revalidated;
    4. `fresherThanSnapshot` compares a *slot number* with a *day number*, two
       different units, which makes the freshness test pass for votes whose
       "current" slot is years older than the snapshot;
    5. `tallyValid` counts duplicates, so the model contains no replay protection.
-/

import Mathlib.Tactic
import RequestProject.Solfunmeme.Upstream.VotingProtocol

namespace Review.VotingProtocol

/-- Exactly what `voteValid` tests. -/
theorem voteValid_iff (v : SignedVote) :
    voteValid v = true ↔
      v.credential.holder = v.freshness.holder ∧
      tierMinBalance v.credential.chamber ≤ v.freshness.currentBalance ∧
      v.castSlot ≤ v.deadline ∧
      v.credential.snapshotDay < v.freshness.currentSlot := by
  simp [voteValid, holderMatch, balanceSufficient, notExpired, fresherThanSnapshot,
    and_assoc]

/-! ### Fields the validity check ignores -/

/-- The ed25519 signature is never verified: replacing it by any string, including
    the empty one, does not change validity. -/
theorem voteValid_signature_irrelevant (v : SignedVote) (s : String) :
    voteValid { v with signature := s } = voteValid v := rfl

/-- The ZK proof hash is never inspected. -/
theorem voteValid_proofHash_irrelevant (v : SignedVote) (p : String) :
    voteValid { v with freshness := { v.freshness with proofHash := p } } = voteValid v := rfl

/-- The channel the vote arrived on is irrelevant (upstream checks this on four
    concrete votes; it holds for all of them). -/
theorem voteValid_channel_irrelevant (v : SignedVote) (c : String) :
    voteValid { v with channel := c } = voteValid v := rfl

/-- The balance recorded in the credential at snapshot time is never used, so a
    credential claiming a chamber it was not entitled to is not detected. -/
theorem voteValid_snapshotBalance_irrelevant (v : SignedVote) (b : Nat) :
    voteValid { v with credential := { v.credential with balance := b } } = voteValid v := rfl

/-- Likewise the rank recorded in the credential. -/
theorem voteValid_rank_irrelevant (v : SignedVote) (r : Nat) :
    voteValid { v with credential := { v.credential with rank := r } } = voteValid v := rfl

/-! ### The freshness test compares slots with days

    In `proofs/credentials.json` the snapshot is recorded as `snapshot_day = 20537`
    (days since the Unix epoch), while `currentSlot` is a Solana slot height
    (of the order of 10⁸).  `fresherThanSnapshot` compares the two directly, so it
    is satisfied by any slot above 20537 — including slots from 2020, long before
    the snapshot was taken. -/

/-- A vote whose "current" balance proof is anchored at slot 20538 — a slot from
    the first days of the chain, i.e. years *before* the snapshot at day 20537 —
    is nevertheless accepted as fresh. -/
def ancientSlotVote : SignedVote :=
  { credential := ⟨"96TkcBshdHAne6oU", .senate, 1, 36388430323635, 20537⟩
    freshness := ⟨"96TkcBshdHAne6oU", 36388430323635, 20538, "zk_ancient"⟩
    choice := .yea
    signature := ""
    channel := "telegram"
    castSlot := 20538
    deadline := 4436208000 }

theorem ancientSlotVote_accepted : voteValid ancientSlotVote = true := by decide

/-- The freshness test is passed by *every* vote whose freshness slot exceeds the
    published snapshot day, no matter how old that slot really is. -/
theorem fresherThanSnapshot_vacuous (v : SignedVote) (h : v.credential.snapshotDay = 20537)
    (hslot : 20537 < v.freshness.currentSlot) : fresherThanSnapshot v = true := by
  simp [fresherThanSnapshot, h, hslot]

/-! ### The tier minimum balances are off by the token's six decimals

    `tierMinBalance .senate = 1000000` is compared against `currentBalance`, which
    in `proofs/credentials.json` is a raw amount (e.g. `36388430323635`).  With six
    decimals the documented senate threshold of 1,000,000 tokens is 10¹² raw units,
    so the implemented threshold is one token, a factor of 10⁶ too small. -/

/-- A holder of one and a half tokens clears the "1,000,000 token" senate bar. -/
def oneAndAHalfTokenSenator : SignedVote :=
  { credential := ⟨"tiny_holder", .senate, 1, 1500000, 20537⟩
    freshness := ⟨"tiny_holder", 1500000, 408700000, "zk_tiny"⟩
    choice := .yea
    signature := ""
    channel := "direct"
    castSlot := 408700100
    deadline := 4436208000 }

theorem oneAndAHalfTokenSenator_accepted : voteValid oneAndAHalfTokenSenator = true := by
  decide

/-! ### The "stolen NFT" scenario only catches a malformed forgery

    `stolenNftVote` is rejected because its freshness witness names a different
    holder than the credential.  Since no signature is ever verified, an attacker
    who simply copies the credential's holder field into the witness — which is
    public data — produces an accepted vote. -/

def stolenNftReplay : SignedVote :=
  { stolenNftVote with
      freshness := { stolenNftVote.freshness with holder := "real_holder" }
      signature := "forged" }

theorem stolenNftReplay_accepted : voteValid stolenNftReplay = true := by decide

/-! ### No replay protection

    Nothing in the model identifies a vote with its voter, so the same signed vote
    can be tallied any number of times. -/

theorem tally_counts_duplicates :
    tallyValid [exampleSenatorVote, exampleSenatorVote] .senate = (2, 0) := by decide

theorem tally_counts_duplicates_n (n : Nat) :
    (tallyValid (List.replicate n exampleSenatorVote) .senate).1 = n := by
  have h : voteValid exampleSenatorVote = true ∧
      exampleSenatorVote.credential.chamber = Chamber.senate := by decide
  have h' : exampleSenatorVote.choice = BallotChoice.yea := by decide
  simp [tallyValid, h, h']

end Review.VotingProtocol
