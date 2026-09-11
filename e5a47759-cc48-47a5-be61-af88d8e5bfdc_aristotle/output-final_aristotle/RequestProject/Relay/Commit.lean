import RequestProject.Relay.Core

/-!
# Commitment to the payload, and extraction from a program

Every program of the relay carries the same payload, written in its own
notation.  This file makes that into a *commit-and-open* statement about the
programs, of the kind a proof of possession is built from:

* `digest` is a rolling hash of a text — the commitment;
* `commitment` reads a program's payload region, whatever notation it is in,
  and hashes the digits: `commitment_eq` says every stage of a well-formed relay
  commits to the *same* value, and `commitment_prog` says that value is the hash
  of the relay's payload;
* `respond` answers a challenge — "what is the `k`-th digit of your payload?" —
  and `respond_eq` says every stage answers every challenge identically, while
  `payload_eq_of_respond` is the soundness direction: two texts that answer every
  challenge alike carry the very same payload;
* `openPayload` is the extractor: from the text of a program it recovers the
  payload in full (`openPayload_prog`), so possession is not merely claimed.

What is *not* claimed: nothing here is zero-knowledge, and `digest` is a hash
chosen for being easy to reason about, not a cryptographic one.  These are the
combinatorial facts a protocol would be built on, stated exactly.
-/

namespace RequestProject.Relay

/-- A rolling hash, used as the commitment to a payload. -/
def digest (l : List Char) : Nat :=
  l.foldl (fun h c => (h * 131 + c.toNat) % 1000003) 7

/-- The commitment a program makes: the hash of the digits in its payload
region, read shape-agnostically. -/
def commitment (t : List Char) : Option Nat :=
  (extract t).map fun region => digest (parseDigits region)

/-- The extractor: recover the payload digits from the text of a program. -/
def openPayload (t : List Char) : Option (List Char) :=
  (extract t).map parseDigits

/-- The answer of `t` to the challenge "what is your `k`-th payload digit?". -/
def respond (t : List Char) (k : Nat) : Option Char :=
  (openPayload t).bind fun d => d[k]?

namespace Relay

variable {R : Relay}

/-- **Extraction.** The payload can be read back out of any program of a
well-formed relay, whatever notation that program writes it in. -/
theorem openPayload_prog (h : R.WF) (i : Nat) : openPayload (R.prog i) = some R.digits := by
  simp only [openPayload, extract_prog h i, Option.map_some, parse_prog h i]

/-- Every program commits to the hash of the relay's payload. -/
theorem commitment_prog (h : R.WF) (i : Nat) : commitment (R.prog i) = some (digest R.digits) := by
  simp only [commitment, extract_prog h i, Option.map_some, parse_prog h i]

/-- **The commitment is shared.** Any two stages commit to the same value: one
payload, many notations. -/
theorem commitment_eq (h : R.WF) (i j : Nat) : commitment (R.prog i) = commitment (R.prog j) := by
  rw [commitment_prog h i, commitment_prog h j]

/-- **Every stage answers every challenge alike.** -/
theorem respond_eq (h : R.WF) (i j k : Nat) : respond (R.prog i) k = respond (R.prog j) k := by
  simp only [respond, openPayload_prog h i, openPayload_prog h j]

/-- The answer of stage `i` to challenge `k` is the `k`-th payload digit. -/
theorem respond_prog (h : R.WF) (i k : Nat) : respond (R.prog i) k = R.digits[k]? := by
  simp only [respond, openPayload_prog h i, Option.bind_some]

end Relay

/-- **Soundness of the challenge game.** Two texts that answer every challenge
in the same way, and both of which have a payload region, carry the very same
payload. -/
theorem payload_eq_of_respond {t u : List Char} {a b : List Char}
    (ht : openPayload t = some a) (hu : openPayload u = some b)
    (h : ∀ k, respond t k = respond u k) : a = b := by
  apply List.ext_getElem?
  intro k
  have := h k
  simp only [respond, ht, hu, Option.bind_some] at this
  exact this

end RequestProject.Relay
