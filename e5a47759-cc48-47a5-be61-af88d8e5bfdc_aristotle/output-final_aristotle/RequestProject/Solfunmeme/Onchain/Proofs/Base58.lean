import Mathlib
import RequestProject.Solfunmeme.Onchain.Base58
import RequestProject.Solfunmeme.Onchain.Proofs.Digits

/-!
Correctness of the base-58 layer.

The headline result is `decode_encode`: `Solana.Base58.encode` is injective with
`decode` as a left inverse, *including* on leading zero bytes, which base-58 has
to special-case (they are written as literal `'1'`s rather than falling out of the
numeral).  This is what makes it safe to round-trip Solana public keys through
their textual form, and what justifies using `isValidPubkey` as a cheap check on
an address before spending a network round trip on it.
-/

namespace Solana.Base58

open Solana.Digits

/-- The alphabet really has 58 characters. -/
theorem alphabetList_length : alphabetList.length = 58 := by decide

/-- The alphabet has no repeats, so `charValue` is unambiguous. -/
theorem alphabetList_nodup : alphabetList.Nodup := by decide

/-- `charValue` inverts `valueChar` on genuine digits. -/
theorem charValue_valueChar {d : Nat} (hd : d < 58) : charValue (valueChar d) = some d := by
  interval_cases d <;> decide

/-- Only the digit `0` is written `'1'`; this is what keeps the leading-zero
prefix of an encoding unambiguous. -/
theorem valueChar_ne_one {d : Nat} (hd : d < 58) (h0 : d ≠ 0) : valueChar d ≠ '1' := by
  interval_cases d <;> simp_all <;> decide

/-! ### Splitting off the `'1'` prefix -/

theorem takeWhile_one_replicate (m : ℕ) (l : List Char) :
    (List.replicate m '1' ++ l).takeWhile (· == '1')
      = List.replicate m '1' ++ l.takeWhile (· == '1') := by
  induction m with
  | zero => simp
  | succ n ih => simp [List.replicate_succ, ih]

theorem dropWhile_one_replicate (m : ℕ) (l : List Char) :
    (List.replicate m '1' ++ l).dropWhile (· == '1') = l.dropWhile (· == '1') := by
  induction m with
  | zero => simp
  | succ n ih => simp [List.replicate_succ, ih]

/-- A numeral with a nonzero leading digit does not start with `'1'`. -/
theorem takeWhile_one_map (ds : List Nat) (hlt : ∀ d ∈ ds, d < 58) (hhd : ds.head? ≠ some 0) :
    (ds.map valueChar).takeWhile (· == '1') = [] := by
  cases ds with
  | nil => simp
  | cons e t =>
      have he : e ≠ 0 := by simpa using hhd
      simp [valueChar_ne_one (hlt e (by simp)) he]

theorem dropWhile_one_map (ds : List Nat) (hlt : ∀ d ∈ ds, d < 58) (hhd : ds.head? ≠ some 0) :
    (ds.map valueChar).dropWhile (· == '1') = ds.map valueChar := by
  cases ds with
  | nil => simp
  | cons e t =>
      have he : e ≠ 0 := by simpa using hhd
      simp [valueChar_ne_one (hlt e (by simp)) he]

/-- Decoding a numeral character list recovers its digits. -/
theorem mapM_charValue (ds : List Nat) (hlt : ∀ d ∈ ds, d < 58) :
    (ds.map valueChar).mapM charValue = some ds := by
  induction ds with
  | nil => simp
  | cons a t ih =>
      have ha := charValue_valueChar (hlt a (by simp))
      have ht := ih (fun d hd => hlt d (by simp [hd]))
      simp [List.mapM_cons, ha, ht]

/-! ### Bytes -/

/-- `dropWhile` really does remove every leading zero byte. -/
theorem head?_dropWhile_zero (l : List UInt8) : (l.dropWhile (· == 0)).head? ≠ some 0 := by
  induction l with
  | nil => simp
  | cons a t ih =>
      by_cases h : a == 0
      · simpa [h] using ih
      · simp only [List.dropWhile_cons, h, Bool.false_eq_true, if_false, List.head?_cons, ne_eq,
          Option.some.injEq]
        simpa using h

/-- Bytes round-trip through their numeric value, provided there is no leading
zero byte (which the numeral could not represent). -/
theorem natToBytes_bytesToNat (bs : List UInt8) (h : bs.head? ≠ some 0) :
    natToBytes (bytesToNat bs) = bs := by
  have hnorm : Normalized 256 (bs.map UInt8.toNat) := by
    refine ⟨?_, ?_⟩
    · intro d hd
      simp only [List.mem_map] at hd
      obtain ⟨b, _, rfl⟩ := hd
      exact b.toNat_lt_size
    · cases bs with
      | nil => simp
      | cons a t =>
          simp only [List.map_cons, List.head?_cons, ne_eq, Option.some.injEq]
          intro hc
          exact h (by simp [UInt8.toNat_inj.mp (by simpa using hc : a.toNat = (0 : UInt8).toNat)])
  rw [natToBytes, bytesToNat, digitsBE_ofDigitsBE 256 (by norm_num) _ hnorm, List.map_map]
  exact List.map_id'' (fun b => by simp) bs

/-! ### The round trip -/

/-- `decode` on an encoding-shaped character list. -/
theorem decode_ofList (m : Nat) (ds : List Nat) (hlt : ∀ d ∈ ds, d < 58)
    (hhd : ds.head? ≠ some 0) :
    decode (String.ofList (List.replicate m '1' ++ ds.map valueChar))
      = some (List.replicate m 0 ++ natToBytes (ofDigitsBE 58 ds)) := by
  simp only [decode, String.toList_ofList, takeWhile_one_replicate, dropWhile_one_replicate,
    takeWhile_one_map ds hlt hhd, dropWhile_one_map ds hlt hhd, List.append_nil,
    mapM_charValue ds hlt, Option.pure_def, Option.bind_eq_bind, Option.bind_some,
    List.map_const', List.length_replicate]

/-- `encode` in the shape `decode_ofList` expects. -/
theorem encode_eq (bs : List UInt8) :
    encode bs = String.ofList (List.replicate (bs.takeWhile (· == 0)).length '1'
      ++ (digitsBE 58 (bytesToNat (bs.dropWhile (· == 0)))).map valueChar) := by
  rw [encode, List.map_const']

/-- `decode` is a left inverse of `encode`. -/
theorem decode_encode (bs : List UInt8) : decode (encode bs) = some bs := by
  have hlt : ∀ d ∈ digitsBE 58 (bytesToNat (bs.dropWhile (· == 0))), d < 58 :=
    digitsBE_lt 58 (by norm_num) _
  have hhd : (digitsBE 58 (bytesToNat (bs.dropWhile (· == 0)))).head? ≠ some 0 :=
    digitsBE_head?_ne_zero 58 (by norm_num) _
  have hzeros : bs.takeWhile (· == 0) = List.replicate (bs.takeWhile (· == 0)).length 0 := by
    refine List.eq_replicate_of_mem ?_
    intro b hb
    simpa using List.mem_takeWhile_imp hb
  rw [encode_eq, decode_ofList _ _ hlt hhd,
    ofDigitsBE_digitsBE 58 (by norm_num) (bytesToNat (bs.dropWhile (· == 0))),
    natToBytes_bytesToNat _ (head?_dropWhile_zero bs), ← hzeros,
    List.takeWhile_append_dropWhile]

/-- Consequently `encode` is injective. -/
theorem encode_injective : Function.Injective encode := by
  intro a b h
  have ha := decode_encode a
  rw [h, decode_encode b] at ha
  exact (Option.some.inj ha).symm

/-- The mint this program was written for really is a syntactically valid
Solana public key. -/
theorem isValidPubkey_solfunmeme :
    isValidPubkey "BwUTq7fS6sfUmHDwAiCQZ3asSiPEapW5zDrsbwtapump" = true := by
  native_decide

end Solana.Base58
