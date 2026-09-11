import Mathlib
import RequestProject.Solfunmeme.Meme.Tape
import RequestProject.Solfunmeme.Meme.Proofs.Share

/-!
# Replay tapes round trip

`decodeTape_encodeTape`: any tape whose length and input codes fit in 64 bits
comes back out of its base-58 string unchanged.  So publishing the string really
does publish the game — a verifier can replay it and recompute the final state,
the badges and the stake for themselves.
-/

namespace Meme.Tape

open Meme.Engine Meme.Share

/-- `decodeInput` inverts `Input.code`. -/
theorem decodeInput_code (i : Input) : decodeInput i.code = some i := by
  cases i with
  | tap => rfl
  | mint => rfl
  | tick => rfl
  | steal n =>
      have h1 : (3 + 3 * n) % 3 = 0 := by omega
      have e2 : 3 + 3 * n ≠ 1 := by omega
      have e3 : 3 + 3 * n ≠ 2 := by omega
      simp [decodeInput, Input.code, h1, e2, e3]
  | build n =>
      have h1 : (4 + 3 * n) % 3 = 1 := by omega
      have e2 : 4 + 3 * n ≠ 1 := by omega
      have e3 : 4 + 3 * n ≠ 2 := by omega
      simp [decodeInput, Input.code, h1, e2, e3]
  | hold n =>
      have h1 : (5 + 3 * n) % 3 = 2 := by omega
      have e2 : 5 + 3 * n ≠ 1 := by omega
      have e3 : 5 + 3 * n ≠ 2 := by omega
      simp [decodeInput, Input.code, h1, e2, e3]

theorem mapM_decodeInput (xs : List Input) :
    (xs.map Input.code).mapM decodeInput = some xs := by
  induction xs with
  | nil => rfl
  | cons a t ih => simp [List.mapM_cons, decodeInput_code, ih]

/-- A tape is safe to serialise when its length and every input code fit in 64
bits — the regime the game and the browser both stay in. -/
def Bounded (xs : List Input) : Prop :=
  xs.length < bound ∧ ∀ i ∈ xs, i.code < bound

theorem decodeBytes_encodeBytes {xs : List Input} (hx : Bounded xs) :
    decodeBytes (encodeBytes xs) = some xs := by
  obtain ⟨hlen, hcode⟩ := hx
  have h8 : (natToLE8 xs.length).length = 8 := natToLE8_length _
  have htake : (encodeBytes xs).take 8 = natToLE8 xs.length :=
    List.take_left' h8
  have hdrop : (encodeBytes xs).drop 8 = (xs.map Input.code).flatMap natToLE8 :=
    List.drop_left' h8
  have hn : leToNat ((encodeBytes xs).take 8) = xs.length := by
    rw [htake]; exact leToNat_natToLE8 hlen
  have hcodes : ∀ n ∈ xs.map Input.code, n < bound := by
    intro n hn'
    simp only [List.mem_map] at hn'
    obtain ⟨i, hi, rfl⟩ := hn'
    exact hcode i hi
  have hlist : decodeNats xs.length ((xs.map Input.code).flatMap natToLE8) = xs.map Input.code := by
    have := decodeNats_flatMap (xs.map Input.code) [] hcodes
    simpa using this
  simp only [decodeBytes, hn, hdrop, hlist]
  exact mapM_decodeInput xs

/-- **Tapes round trip.** -/
theorem decodeTape_encodeTape {xs : List Input} (hx : Bounded xs) :
    decodeTape (encodeTape xs) = some xs := by
  simp [decodeTape, encodeTape, Solana.Base58.decode_encode, decodeBytes_encodeBytes hx]

/-- Consequently a published tape names one play-through only. -/
theorem encodeTape_injective {xs ys : List Input} (hx : Bounded xs) (hy : Bounded ys)
    (h : encodeTape xs = encodeTape ys) : xs = ys := by
  have hx' := decodeTape_encodeTape hx
  have hy' := decodeTape_encodeTape hy
  rw [h, hy'] at hx'
  exact (Option.some.inj hx').symm

end Meme.Tape
