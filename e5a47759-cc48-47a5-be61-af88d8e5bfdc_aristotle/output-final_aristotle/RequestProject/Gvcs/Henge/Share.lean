import Mathlib
import RequestProject.Gvcs.Henge.Token

/-!
# Sharing a save: codes and hidden bits

Two ways of getting a save out of the page and into someone else's hands, both
with their round trips proved.

* `shareCode` / `readShare` — the save as a short string of digits and dots,
  and `readShare_shareCode`: reading a code gives back exactly the save it was
  written from.
* `embedBits` / `extractBits` — the bits of a code hidden in the low bits of the
  pixels of a picture, and `extractBits_embedBits`: they come back out.
  `embedBits_close` says no pixel moves by more than one, so the picture still
  looks like itself.

Along the way, `splitOnChar_joinWith` proves that the dot-separated format can
be taken apart again, which is the part of a share code that usually goes wrong.
-/

namespace LifeTrac
namespace Henge

/-! ## Digits -/

/-- A digit as a character. -/
def digitChar (d : ℕ) : Char := Char.ofNat (48 + d)

/-- A character as a digit. -/
def charDigit (c : Char) : Option ℕ :=
  if '0' ≤ c ∧ c ≤ '9' then some (c.toNat - 48) else none

theorem charDigit_digitChar {d : ℕ} (h : d < 10) : charDigit (digitChar d) = some d := by
  interval_cases d <;> decide

theorem digitChar_ne_dot {d : ℕ} (h : d < 10) : digitChar d ≠ '.' := by
  interval_cases d <;> decide

theorem digitChar_range {d : ℕ} (h : d < 10) : '0' ≤ digitChar d ∧ digitChar d ≤ '9' := by
  interval_cases d <;> decide

theorem mapM_charDigit {ds : List ℕ} (h : ∀ d ∈ ds, d < 10) :
    (ds.map digitChar).mapM charDigit = some ds := by
  induction ds with
  | nil => rfl
  | cons d ds ih =>
      have hd := charDigit_digitChar (h d (by simp))
      have hrest := ih (fun x hx => h x (by simp [hx]))
      simp only [List.map_cons, List.mapM_cons, hd, hrest]
      rfl

/-- A number as a string of digits. -/
def natToChars (n : ℕ) : List Char :=
  if n = 0 then ['0'] else ((Nat.digits 10 n).map digitChar).reverse

/-- A string of digits as a number. -/
def charsToNat (cs : List Char) : Option ℕ :=
  (cs.reverse.mapM charDigit).map (Nat.ofDigits 10)

theorem natToChars_ne_nil (n : ℕ) : natToChars n ≠ [] := by
  unfold natToChars
  split
  · simp
  · rename_i hn
    simp only [ne_eq, List.reverse_eq_nil_iff, List.map_eq_nil_iff]
    exact Nat.digits_ne_nil_iff_ne_zero.2 hn

/-- A rendered number is made of digits and nothing else. -/
theorem natToChars_digit (n : ℕ) : ∀ c ∈ natToChars n, '0' ≤ c ∧ c ≤ '9' := by
  unfold natToChars
  split
  · intro c hc
    have : c = '0' := by simpa using hc
    subst this
    decide
  · rename_i hn
    intro c hc
    rw [List.mem_reverse, List.mem_map] at hc
    obtain ⟨d, hd, rfl⟩ := hc
    exact digitChar_range (Nat.digits_lt_base (by norm_num) hd)

theorem dot_not_mem_natToChars (n : ℕ) : '.' ∉ natToChars n := by
  unfold natToChars
  split
  · decide
  · rename_i hn
    intro hmem
    rw [List.mem_reverse, List.mem_map] at hmem
    obtain ⟨d, hd, hdc⟩ := hmem
    exact digitChar_ne_dot (Nat.digits_lt_base (by norm_num) hd) hdc

/-- **A number survives the trip to text and back.** -/
theorem charsToNat_natToChars (n : ℕ) : charsToNat (natToChars n) = some n := by
  unfold natToChars charsToNat
  split
  · rename_i hn; subst hn; rfl
  · rename_i hn
    rw [List.reverse_reverse]
    have hlt : ∀ d ∈ Nat.digits 10 n, d < 10 := fun d hd =>
      Nat.digits_lt_base (by norm_num) hd
    rw [mapM_charDigit hlt]
    simp [Nat.ofDigits_digits]

/-! ## Dots -/

/-- Words joined by a separator. -/
def joinWith (sep : Char) : List (List Char) → List Char
  | [] => []
  | [w] => w
  | w :: ws => w ++ sep :: joinWith sep ws

/-- A string cut at every separator. -/
def splitOnChar (sep : Char) : List Char → List (List Char)
  | [] => [[]]
  | c :: cs =>
      if c = sep then [] :: splitOnChar sep cs
      else
        match splitOnChar sep cs with
        | [] => [[c]]
        | w :: ws => (c :: w) :: ws

theorem splitOnChar_of_no_sep {sep : Char} :
    ∀ (w : List Char), sep ∉ w → splitOnChar sep w = [w]
  | [], _ => rfl
  | c :: cs, h => by
      have hc : c ≠ sep := fun hcs => h (by simp [hcs])
      have hrest : splitOnChar sep cs = [cs] :=
        splitOnChar_of_no_sep cs (fun hx => h (List.mem_cons_of_mem c hx))
      rw [splitOnChar, if_neg hc, hrest]

theorem splitOnChar_append_sep {sep : Char} :
    ∀ (w rest : List Char), sep ∉ w →
      splitOnChar sep (w ++ sep :: rest) = w :: splitOnChar sep rest
  | [], rest, _ => by rw [List.nil_append, splitOnChar, if_pos rfl]
  | c :: cs, rest, h => by
      have hc : c ≠ sep := fun hcs => h (by simp [hcs])
      have hrest := splitOnChar_append_sep cs rest (fun hx => h (List.mem_cons_of_mem c hx))
      rw [List.cons_append, splitOnChar, if_neg hc, hrest]

theorem splitOnChar_ne_nil (sep : Char) : ∀ l : List Char, splitOnChar sep l ≠ []
  | [] => by simp [splitOnChar]
  | c :: cs => by
      rw [splitOnChar]
      split
      · simp
      · cases h : splitOnChar sep cs <;> simp

/-- Text with no separator in it stays at the front of the first field. -/
theorem splitOnChar_append_no_sep {sep : Char} :
    ∀ (a b : List Char), sep ∉ a →
      splitOnChar sep (a ++ b) =
        (a ++ (splitOnChar sep b).headI) :: (splitOnChar sep b).tail
  | [], b, _ => by
      cases h : splitOnChar sep b with
      | nil => exact absurd h (splitOnChar_ne_nil sep b)
      | cons w ws => simp [h]
  | c :: cs, b, h => by
      have hc : c ≠ sep := fun hcs => h (by simp [hcs])
      have ih := splitOnChar_append_no_sep cs b (fun hx => h (List.mem_cons_of_mem c hx))
      rw [List.cons_append, splitOnChar, if_neg hc, ih]
      simp

/-- **The dot-separated format can be taken apart again.** -/
theorem splitOnChar_joinWith {sep : Char} :
    ∀ (ws : List (List Char)), ws ≠ [] → (∀ w ∈ ws, sep ∉ w) →
      splitOnChar sep (joinWith sep ws) = ws
  | [], h, _ => absurd rfl h
  | [w], _, h => by
      rw [joinWith, splitOnChar_of_no_sep w (h w (by simp))]
  | w :: v :: ws, _, h => by
      have hw : sep ∉ w := h w (by simp)
      have hrest : splitOnChar sep (joinWith sep (v :: ws)) = v :: ws :=
        splitOnChar_joinWith (v :: ws) (List.cons_ne_nil _ _)
          (fun x hx => h x (List.mem_cons_of_mem w hx))
      rw [joinWith, splitOnChar_append_sep w _ hw, hrest]
      simp

/-! ## The share code -/

/-- The save, as a string of digits and dots. -/
def shareCode (s : Save) : List Char :=
  joinWith '.' ((encodeSave s).map natToChars)

/-- A string of digits and dots, read back as a save. -/
def readShare (cs : List Char) : Option Save :=
  ((splitOnChar '.' cs).mapM charsToNat).bind decodeSave

theorem mapM_charsToNat (ns : List ℕ) : (ns.map natToChars).mapM charsToNat = some ns := by
  induction ns with
  | nil => rfl
  | cons n ns ih =>
      simp only [List.map_cons, List.mapM_cons, charsToNat_natToChars, ih]
      rfl

theorem encodeSave_ne_nil (s : Save) : encodeSave s ≠ [] := by simp [encodeSave]

/-- **A shared code is the save it claims to be.** -/
theorem readShare_shareCode (s : Save) : readShare (shareCode s) = some s := by
  have hne : (encodeSave s).map natToChars ≠ [] := by
    simpa using encodeSave_ne_nil s
  have hno : ∀ w ∈ (encodeSave s).map natToChars, '.' ∉ w := by
    rintro w hw
    obtain ⟨n, _, rfl⟩ := List.mem_map.1 hw
    exact dot_not_mem_natToChars n
  unfold readShare shareCode
  rw [splitOnChar_joinWith _ hne hno, mapM_charsToNat]
  simpa using decodeSave_encodeSave s

/-! ## Hiding a code in a picture -/

/-- Put one bit in the low bit of a pixel value. -/
def setBit (b : Bool) (p : ℕ) : ℕ := 2 * (p / 2) + b.toNat

/-- Read the low bit of a pixel value. -/
def getBit (p : ℕ) : Bool := p % 2 == 1

theorem setBit_mod (b : Bool) (p : ℕ) : setBit b p % 2 = b.toNat := by
  cases b <;> simp only [setBit, Bool.toNat_false, Bool.toNat_true] <;> omega

@[simp] theorem getBit_setBit (b : Bool) (p : ℕ) : getBit (setBit b p) = b := by
  cases b <;> simp [getBit, setBit_mod]

/-- **A hidden bit moves a pixel by at most one.** -/
theorem setBit_close (b : Bool) (p : ℕ) :
    setBit b p = p ∨ setBit b p + 1 = p ∨ setBit b p = p + 1 := by
  cases b <;> simp only [setBit, Bool.toNat_false, Bool.toNat_true] <;> omega

/-- Hide a list of bits in the low bits of the leading pixels. -/
def embedBits : List Bool → List ℕ → List ℕ
  | [], px => px
  | _ :: _, [] => []
  | b :: bs, p :: px => setBit b p :: embedBits bs px

/-- Read `n` bits out of the low bits of the leading pixels. -/
def extractBits (n : ℕ) (px : List ℕ) : List Bool :=
  (px.take n).map getBit

/-- **What was hidden comes back out.** -/
theorem extractBits_embedBits :
    ∀ (bs : List Bool) (px : List ℕ), bs.length ≤ px.length →
      extractBits bs.length (embedBits bs px) = bs
  | [], px, _ => by simp [extractBits]
  | b :: bs, [], h => by simp at h
  | b :: bs, p :: px, h => by
      have hlen : bs.length ≤ px.length := by simpa using h
      have ih := extractBits_embedBits bs px hlen
      simp only [embedBits, extractBits, List.length_cons, List.take_succ_cons, List.map_cons,
        getBit_setBit]
      simpa [extractBits] using ih

/-- The picture is the same size after hiding. -/
theorem length_embedBits :
    ∀ (bs : List Bool) (px : List ℕ), bs.length ≤ px.length →
      (embedBits bs px).length = px.length
  | [], px, _ => rfl
  | _ :: _, [], h => by simp at h
  | b :: bs, p :: px, h => by
      have hlen : bs.length ≤ px.length := by simpa using h
      simp [embedBits, length_embedBits bs px hlen]

/-- **The picture still looks like itself.**  Every pixel is within one of what
it was. -/
theorem embedBits_close :
    ∀ (bs : List Bool) (px : List ℕ) (i : ℕ), i < (embedBits bs px).length →
      i < px.length →
      (embedBits bs px)[i]! = px[i]! ∨ (embedBits bs px)[i]! + 1 = px[i]! ∨
        (embedBits bs px)[i]! = px[i]! + 1
  | [], px, i, _, _ => by simp [embedBits]
  | _ :: _, [], i, h, _ => by simp [embedBits] at h
  | b :: bs, p :: px, 0, _, _ => by
      simpa [embedBits] using setBit_close b p
  | b :: bs, p :: px, (i + 1), h1, h2 => by
      have h1' : i < (embedBits bs px).length := by
        simpa [embedBits] using h1
      have h2' : i < px.length := by simpa using h2
      simpa [embedBits] using embedBits_close bs px i h1' h2'

end Henge
end LifeTrac
