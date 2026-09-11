import RequestProject.Gvcs.Certified.Program
import RequestProject.Gvcs.Certified.Stego

/-!
# Certified mode, layer 4: the protocol end to end

Putting the three layers together.  A player in certified mode:

1. writes a program (`RequestProject/Certified/Program.lean`);
2. encrypts its bytes under a fresh key (`RequestProject/Certified/Crypto.lean`);
3. publishes a market-feed update carrying the ciphertext in its noise floor
   (`RequestProject/Certified/Stego.lean`) — `publish`;
4. the network executes the program under the ordinary rule book and publishes
   a receipt anybody can recompute.

The theorems here are the guarantees of that pipeline:

* `publish_recover` — the round trip is exact: what the executor runs is the
  program the player wrote.
* `publish_preserves_public` — the feed the world downloads carries exactly the
  same information above the noise floor, and the same number of quotes, as if
  nothing had been hidden in it.  The player is paying his way with genuinely
  useful public data.
* `publish_perfect_secrecy` — for any *other* program of the same length there
  is exactly one key that would have produced the very same published feed.
  An observer with unlimited computing power therefore learns nothing about the
  strategy: the feed is consistent with every strategy of that size.
* `feed_score_recover` — the league can evaluate its public linear scoring rule
  directly on the published feed, and the player opens the result with a single
  digit.  Scoring never sees the strategy.
* `certified_run_legal`, `certified_receipt` — whatever is recovered is
  executed by the same rule book as ordinary play, so the game's invariants
  hold for every submission, and the receipt is reproducible by every peer.
-/

namespace LifeTrac
namespace Certified

open Build

/-! ## Publishing -/

/-- What a player broadcasts: his feed update `f`, with his encrypted program
in the noise floor. -/
def publish (f : Feed) (k : List Digit) (p : List CMove) : Feed :=
  embedFeed f (otpEnc k (encodeProg p))

/-- What an executor holding the key reads back out. -/
def recover (S : Feed) (k : List Digit) : Option (List CMove) :=
  decodeProg (otpDec k (extractFeed S k.length))

/-- Reading the ciphertext back out of a published feed. -/
theorem extractFeed_publish {f : Feed} {k : List Digit} {p : List CMove}
    (hk : k.length = 3 * p.length) (hf : 3 * p.length ≤ f.length) :
    extractFeed (publish f k p) k.length = otpEnc k (encodeProg p) := by
  have hlen : (otpEnc k (encodeProg p)).length = k.length := by
    simp [hk]
  rw [publish, ← hlen]
  exact extractFeed_embedFeed (by rw [hlen, hk]; exact hf)

/-- **The round trip is exact.**  The program the network executes is the
program the player wrote. -/
theorem publish_recover {f : Feed} {k : List Digit} {p : List CMove}
    (hk : k.length = 3 * p.length) (hf : 3 * p.length ≤ f.length) :
    recover (publish f k p) k = some p := by
  rw [recover, extractFeed_publish hk hf, otpDec_otpEnc (by simp [hk]),
    decodeProg_encodeProg]

/-- **The public feed keeps all of its value.**  Every quote is published to
the same precision above the noise floor, and the update has the same shape,
whether or not it is carrying a strategy. -/
theorem publish_preserves_public (f : Feed) (k : List Digit) (p : List CMove) :
    (publish f k p).map coarse = f.map coarse ∧ (publish f k p).length = f.length :=
  ⟨coarseFeed_embedFeed _ _, embedFeed_length _ _⟩

/-! ## Secrecy -/

/-- Two payloads that fit in the feed and produce the same published update are
equal. -/
theorem embedFeed_injective {f : Feed} {c c' : List Digit}
    (hc : c.length ≤ f.length) (hc' : c'.length = c.length)
    (h : embedFeed f c = embedFeed f c') : c = c' := by
  have h1 : extractFeed (embedFeed f c) c.length = c := extractFeed_embedFeed hc
  have h2 : extractFeed (embedFeed f c') c'.length = c' := extractFeed_embedFeed (hc' ▸ hc)
  rw [hc'] at h2
  rw [h] at h1
  rw [h1] at h2
  exact h2

/-- **Perfect secrecy of the whole channel.**  Fix the feed the world sees.
For *every* strategy of the same size there is exactly one key that would have
produced that very feed — so the observation rules out nothing, and an observer
learns precisely nothing about which program is being run.  (Perfect secrecy
here is the one-time pad's: a key is used once, which is exactly the discipline
of one fresh key per published round.) -/
theorem publish_perfect_secrecy {f : Feed} {p q : List CMove} {k : List Digit}
    (hk : k.length = 3 * p.length) (hpq : p.length = q.length)
    (hf : 3 * p.length ≤ f.length) :
    ∃! k' : List Digit, k'.length = 3 * q.length ∧ publish f k' q = publish f k p := by
  set c := otpEnc k (encodeProg p) with hc
  have hclen : c.length = 3 * p.length := by simp [hc, hk]
  have hqlen : (encodeProg q).length = c.length := by simp [hclen, hpq]
  obtain ⟨k', ⟨hk'len, hk'enc⟩, huniq⟩ := otp_perfect_secrecy hqlen
  refine ⟨k', ⟨by simpa using hk'len, by rw [publish, publish, ← hc, hk'enc]⟩, ?_⟩
  rintro k'' ⟨hk''len, hk''pub⟩
  refine huniq k'' ⟨by simpa using hk''len, ?_⟩
  have hlen'' : (otpEnc k'' (encodeProg q)).length = c.length := by
    simp [hk''len, hclen, hpq]
  exact embedFeed_injective (c := otpEnc k'' (encodeProg q)) (c' := c)
    (by rw [hlen'', hclen]; exact hf) hlen''.symm hk''pub

/-! ## Scoring what you cannot read -/

/-- The league's public scoring rule, evaluated straight off the published
feed. -/
def feedScore (w : List Digit) (S : Feed) (n : ℕ) : Digit := weightedSum w (extractFeed S n)

/-- **Score a strategy without seeing it.**  The score of the published feed,
opened with the single digit `weightedSum w k`, is exactly the score of the
program — and nothing else about the program has crossed the wire. -/
theorem feed_score_recover {f : Feed} {k w : List Digit} {p : List CMove}
    (hk : k.length = 3 * p.length) (hw : w.length = k.length)
    (hf : 3 * p.length ≤ f.length) :
    feedScore w (publish f k p) k.length - weightedSum w k = weightedSum w (encodeProg p) := by
  rw [feedScore, extractFeed_publish hk hf]
  exact score_recover hw (by simp [hk])

/-! ## Executing what was recovered -/

/-- **Every submission is safe to run.**  Whatever a player hides in the feed,
the executors run it through the ordinary rule book, so the state they reach
obeys the game's invariants — no negative cash, stores or fuel. -/
theorem certified_run_legal {mk : Market} {s : GameState} (hs : s.Legal)
    (S : Feed) (k : List Digit) :
    ∀ p ∈ recover S k, (runProg mk s p).Legal := fun p _ => runProg_legal hs p

/-- **The certified round, end to end.**  A player publishes; the feed the
world reads is as informative as ever; the executor recovers exactly the
submitted program, runs it under the shared rule book, ends in a legal state,
and issues a receipt every other peer can recompute. -/
theorem certified_round {mk : Market} {s : GameState} (hs : s.Legal)
    {f : Feed} {k : List Digit} {p : List CMove}
    (hk : k.length = 3 * p.length) (hf : 3 * p.length ≤ f.length) :
    (publish f k p).map coarse = f.map coarse ∧
      recover (publish f k p) k = some p ∧
      (receiptOf mk s p).final = runProg mk s p ∧
      (receiptOf mk s p).final.Legal :=
  ⟨(publish_preserves_public f k p).1, publish_recover hk hf, rfl, runProg_legal hs p⟩

end Certified
end LifeTrac
