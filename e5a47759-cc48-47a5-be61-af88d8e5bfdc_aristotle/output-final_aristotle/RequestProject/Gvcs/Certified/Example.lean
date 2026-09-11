import RequestProject.Gvcs.Certified.Protocol

/-!
# A certified round, worked out

One concrete pass through the protocol of
`RequestProject/Certified/Protocol.lean`, with every number checked by
evaluation inside Lean rather than asserted.

The player's strategy `sampleProg` is three instructions — buy 40 M12 bolts,
put 200 litres of fuel in the tank, put 20 hectares into wheat — so nine bytes
on the wire.  His feed update `sampleFeed` is twelve quotes of a materials
market, in millionths of a currency unit; the noise floor is the last byte of
each quote, so the update has room for twelve bytes and carries nine.

Checked below: the encoding is nine bytes; the published feed reports exactly
the same twelve prices above the noise floor as the honest feed; every quote is
moved by less than one part in 256 of the noise floor; the executor recovers
the program exactly; and the low-order bytes actually published are the
ciphertext, not the program — the program's own bytes are nowhere in the feed.
-/

namespace LifeTrac
namespace Certified

open Build

/-- Buy 40 bolts, buy 200 litres of fuel, farm 20 hectares of wheat. -/
def sampleProg : List CMove :=
  [ ⟨0, 6, 40⟩      -- opcode 0 = buy, material 6 = M12 bolt, quantity 40
  , ⟨2, 0, 200⟩     -- opcode 2 = refuel, 200 litres
  , ⟨3, 0, 20⟩ ]    -- opcode 3 = farm, 20 hectares

/-- The player's honest market update: twelve quoted prices, in millionths. -/
def sampleFeed : Feed :=
  (([1420993, 986412, 754000, 3120557, 88214, 45390,
     1290, 640, 17855, 9042, 233117, 1550511] : List ℕ).map fun v => (⟨v⟩ : Tick))

/-- The key for this round: nine fresh bytes, one per byte of program. -/
def sampleKey : List Digit := [211, 17, 96, 3, 148, 250, 77, 199, 32]

theorem sampleProg_bytes : encodeProg sampleProg = [0, 6, 40, 2, 0, 200, 3, 0, 20] := by decide

theorem sampleKey_length : sampleKey.length = 3 * sampleProg.length := by decide

theorem sampleProg_fits : 3 * sampleProg.length ≤ sampleFeed.length := by decide

/-- The nine bytes actually published in the noise floor are the ciphertext,
and they are not the program's bytes. -/
theorem sample_cipher :
    otpEnc sampleKey (encodeProg sampleProg) = [211, 23, 136, 5, 148, 194, 80, 199, 52] := by
  decide

theorem sample_cipher_ne_plaintext :
    otpEnc sampleKey (encodeProg sampleProg) ≠ encodeProg sampleProg := by decide

/-- **The executor gets the strategy back.** -/
theorem sample_recover :
    recover (publish sampleFeed sampleKey sampleProg) sampleKey = some sampleProg :=
  publish_recover sampleKey_length sampleProg_fits

/-- **The market data is unharmed**: the same twelve prices, to the precision
the feed is quoted at above its noise floor. -/
theorem sample_public_unchanged :
    (publish sampleFeed sampleKey sampleProg).map coarse = sampleFeed.map coarse :=
  (publish_preserves_public sampleFeed sampleKey sampleProg).1

/-- Concretely, those are the prices readers see, carrier or no carrier. -/
theorem sample_public_prices :
    sampleFeed.map coarse = [5550, 3853, 2945, 12189, 344, 177, 5, 2, 69, 35, 910, 6056] := by
  decide

/-- **Nothing is distorted by more than the noise floor.** -/
theorem sample_distortion (i : ℕ) (t u : Tick)
    (ht : sampleFeed[i]? = some t)
    (hu : (publish sampleFeed sampleKey sampleProg)[i]? = some u) :
    u.value ≤ t.value + 255 ∧ t.value ≤ u.value + 255 :=
  embedFeed_distortion sampleFeed _ i t u ht hu

end Certified
end LifeTrac
