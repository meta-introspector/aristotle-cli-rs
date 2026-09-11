import Mathlib
import RequestProject.Solfunmeme.Meme.Stego

/-!
# The stego carrier is lossless, and invisible

Two theorems:

* `extractBytes_embedBytes` — if the cover has room (eight bytes per payload
  byte) then what you hid is exactly what you read back.
* `embedBits_preserves_upper` — embedding changes only least significant bits,
  so every byte moves by at most one unit and the meme still looks like the meme.

Plus the bookkeeping (`embedBits_length`) that says the carrier is the same size
as the cover, i.e. the PNG dimensions do not change.
-/

namespace Meme.Stego

/-! ## Bits of a byte -/

@[simp] theorem bitsLE_length (n : Nat) : (bitsLE n).length = 8 := by
  simp [bitsLE]

theorem bitsLE_lt_two {n b : Nat} (hb : b ∈ bitsLE n) : b < 2 := by
  simp only [bitsLE, List.mem_map, List.mem_range] at hb
  obtain ⟨i, _, rfl⟩ := hb
  exact Nat.mod_lt _ (by norm_num)

/-- The eight bits of a byte reassemble to the byte. -/
theorem fromBitsLE_bitsLE {n : Nat} (hn : n < 256) : fromBitsLE (bitsLE n) = n := by
  simp only [bitsLE, fromBitsLE, List.range_succ, List.range_zero]
  norm_num
  omega

/-! ## Bit level embedding -/

@[simp] theorem embedBits_length (cover bits : List Nat) :
    (embedBits cover bits).length = cover.length := by
  induction cover generalizing bits with
  | nil => simp [embedBits]
  | cons c cs ih =>
      cases bits with
      | nil => simp [embedBits]
      | cons b bs => simp [embedBits, ih]

/-- Embedding only rewrites low bits: every carrier byte agrees with its cover
byte above bit zero. -/
theorem embedBits_preserves_upper (cover bits : List Nat) (hb : ∀ b ∈ bits, b < 2) (i : Nat) :
    ((embedBits cover bits)[i]?.map (· / 2)) = (cover[i]?.map (· / 2)) := by
  induction cover generalizing bits i with
  | nil => simp [embedBits]
  | cons c cs ih =>
      cases bits with
      | nil => simp [embedBits]
      | cons b bs =>
          have hb0 : b < 2 := hb b (by simp)
          have hbs : ∀ x ∈ bs, x < 2 := fun x hx => hb x (by simp [hx])
          cases i with
          | zero =>
              simp only [embedBits, List.getElem?_cons_zero, Option.map_some]
              congr 1
              omega
          | succ k => simpa [embedBits] using ih bs hbs k

/-- Reading the hidden bits back. -/
theorem extractBits_embedBits {cover bits : List Nat}
    (hb : ∀ b ∈ bits, b < 2) (hlen : bits.length ≤ cover.length) :
    extractBits bits.length (embedBits cover bits) = bits := by
  induction cover generalizing bits with
  | nil =>
      have : bits = [] := List.eq_nil_of_length_eq_zero (Nat.le_zero.mp (by simpa using hlen))
      simp [this, extractBits]
  | cons c cs ih =>
      cases bits with
      | nil => simp [extractBits]
      | cons b bs =>
          have hb0 : b < 2 := hb b (by simp)
          have hbs : ∀ x ∈ bs, x < 2 := fun x hx => hb x (by simp [hx])
          have hlen' : bs.length ≤ cs.length := by simpa using hlen
          have := ih hbs hlen'
          simp only [extractBits, embedBits, List.length_cons, List.take_succ_cons,
            List.map_cons] at this ⊢
          exact List.cons_eq_cons.mpr ⟨by omega, this⟩

/-! ## Byte level embedding -/

theorem unbits8_flatMap (payload rest : List Nat) (hp : ∀ b ∈ payload, b < 256) :
    unbits8 payload.length (payload.flatMap bitsLE ++ rest) = payload := by
  induction payload with
  | nil => simp [unbits8]
  | cons a t ih =>
      have ha : a < 256 := hp a (by simp)
      have ht : ∀ b ∈ t, b < 256 := fun b hb => hp b (by simp [hb])
      have hlen : (bitsLE a).length = 8 := bitsLE_length a
      simp only [List.flatMap_cons, List.length_cons, unbits8, List.append_assoc]
      refine List.cons_eq_cons.mpr ⟨?_, ?_⟩
      · rw [List.take_append_of_le_length (by omega), List.take_of_length_le (by omega)]
        exact fromBitsLE_bitsLE ha
      · rw [List.drop_append_of_le_length (by omega), List.drop_of_length_le (by omega),
          List.nil_append]
        exact ih ht

/-- **Round trip.** A payload hidden in a large enough cover comes back
unchanged. -/
theorem extractBytes_embedBytes {cover payload : List Nat}
    (hp : ∀ b ∈ payload, b < 256) (hroom : 8 * payload.length ≤ cover.length) :
    extractBytes payload.length (embedBytes cover payload) = payload := by
  have hbits : ∀ b ∈ payload.flatMap bitsLE, b < 2 := by
    intro b hb
    simp only [List.mem_flatMap] at hb
    obtain ⟨a, _, hab⟩ := hb
    exact bitsLE_lt_two hab
  have hlen : (payload.flatMap bitsLE).length = 8 * payload.length := by
    simp [List.length_flatMap, mul_comm]
  have hle : (payload.flatMap bitsLE).length ≤ cover.length := by rw [hlen]; exact hroom
  have hstep : extractBits (8 * payload.length) (embedBits cover (payload.flatMap bitsLE))
      = payload.flatMap bitsLE := by
    have := extractBits_embedBits (cover := cover) hbits hle
    rwa [hlen] at this
  unfold extractBytes embedBytes
  rw [hstep]
  simpa using unbits8_flatMap payload [] hp

end Meme.Stego
