import Mathlib
import RequestProject.Solfunmeme.Meme.Share
import RequestProject.Solfunmeme.Onchain.Proofs.Base58

/-!
# Share codes round trip

`decodeShare (encodeShare s) = some s` for every state whose fields fit in 64
bits — the bound the game keeps by construction, and the one the browser also
enforces.  Consequently the code is a faithful name for the state: two states
with the same share code are the same state (`encodeShare_injective`).

The base-58 layer is reused verbatim from the Solana address code, so the string
that names a play-through is built out of exactly the alphabet the chain uses.
-/

namespace Meme.Share

open Meme.Engine

/-- Every state field fits in 64 bits. -/
def Bounded (s : State) : Prop := ∀ n ∈ fields s, n < bound

@[simp] theorem natToLE8_length (n : Nat) : (natToLE8 n).length = 8 := by
  simp [natToLE8]

/-- Little-endian encoding of a 64-bit number is lossless. -/
theorem leToNat_natToLE8 {n : Nat} (hn : n < bound) : leToNat (natToLE8 n) = n := by
  simp only [leToNat, natToLE8, bound] at hn ⊢
  simp [List.range_succ]
  omega

@[simp] theorem fields_length (s : State) : (fields s).length = 9 := by
  simp [fields]

theorem ofFields_fields (s : State) : ofFields (fields s) = some s := by
  cases s; rfl

/-- Reading fields back off a serialised prefix. -/
theorem decodeNats_flatMap (ns : List Nat) (rest : List UInt8) (hn : ∀ n ∈ ns, n < bound) :
    decodeNats ns.length (ns.flatMap natToLE8 ++ rest) = ns := by
  induction ns with
  | nil => simp [decodeNats]
  | cons a t ih =>
      have ha : a < bound := hn a (by simp)
      have ht : ∀ n ∈ t, n < bound := fun n hn' => hn n (by simp [hn'])
      have hlen : (natToLE8 a).length = 8 := natToLE8_length a
      simp only [List.flatMap_cons, List.length_cons, decodeNats, List.append_assoc]
      refine List.cons_eq_cons.mpr ⟨?_, ?_⟩
      · rw [List.take_append_of_le_length (by omega), List.take_of_length_le (by omega)]
        exact leToNat_natToLE8 ha
      · rw [List.drop_append_of_le_length (by omega), List.drop_of_length_le (by omega),
          List.nil_append]
        exact ih ht

/-- The byte serialisation round trips. -/
theorem decodeBytes_encodeBytes {s : State} (hs : Bounded s) :
    decodeBytes (encodeBytes s) = some s := by
  have h : decodeNats 9 (encodeBytes s) = fields s := by
    have := decodeNats_flatMap (fields s) [] hs
    simpa [encodeBytes] using this
  simp [decodeBytes, h, ofFields_fields]

/-- A serialised state is exactly nine 64-bit fields. -/
theorem encodeBytes_length (s : State) : (encodeBytes s).length = 72 := by
  simp [encodeBytes, fields]

/-- **Share codes round trip.** -/
theorem decodeShare_encodeShare {s : State} (hs : Bounded s) :
    decodeShare (encodeShare s) = some s := by
  simp [decodeShare, encodeShare, Solana.Base58.decode_encode, decodeBytes_encodeBytes hs]

/-- A share code names one state and one state only. -/
theorem encodeShare_injective {s t : State} (hs : Bounded s) (ht : Bounded t)
    (h : encodeShare s = encodeShare t) : s = t := by
  have hs' := decodeShare_encodeShare hs
  have ht' := decodeShare_encodeShare ht
  rw [h, ht'] at hs'
  exact (Option.some.inj hs').symm

end Meme.Share
