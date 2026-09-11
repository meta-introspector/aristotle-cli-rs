/-
  Wire.lean — the canonical, injective text encoding the senators' desk signs.

  Everything a senator publishes from the desk (a social account, a news item,
  an attachment of news to a trade, a comment, a share) is turned into one
  string and signed.  For any of the security statements to mean anything the
  encoding has to be *injective*: two different records must never produce the
  same signed text, or a signature over one would also be a signature over the
  other.

  This file builds the two pieces injectivity rests on, and proves them:

    * `natStr`     — the decimal numeral, with `natStr_injective`;
    * `joinFields` — the `|`-separated join of a list of fields, with
      `joinFields_injective` for separator-free fields, and `joinFields_head`,
      which recovers the first field and so keeps one domain's signatures out
      of another domain.

  The JavaScript in `scripts/desk.js` builds the same string with `String(n)`
  and `fields.join("|")`; the `#guard`s below pin `natStr` to `toString`.
-/

import Mathlib

namespace Senate.Wire

/-! ### Decimal numerals -/

/-- The character of a decimal digit. -/
def digitChar (d : Nat) : Char := Char.ofNat (48 + d)

/-- The decimal numeral of a natural number: `natStr 0 = "0"`, and otherwise
the base-10 digits, most significant first. -/
def natStr (n : Nat) : String :=
  if n = 0 then "0" else String.ofList ((Nat.digits 10 n).reverse.map digitChar)

theorem digitChar_inj {d e : Nat} (hd : d < 10) (he : e < 10)
    (h : digitChar d = digitChar e) : d = e := by
  interval_cases d <;> interval_cases e <;> simp_all [digitChar]

theorem digitChar_ne_zero {d : Nat} (hd : d < 10) (h : d ≠ 0) : digitChar d ≠ '0' := by
  interval_cases d <;> simp_all [digitChar]

/-- `natStr n` begins with a nonzero digit when `n ≠ 0`, so it is never `"0"`:
there are no leading zeros to pad a numeral with. -/
theorem natStr_ne_zero_string {n : Nat} (hn : n ≠ 0) : natStr n ≠ "0" := by
  have hd : Nat.digits 10 n ≠ [] := by
    simpa using Nat.digits_ne_nil_iff_ne_zero.mpr hn
  have hlast : (Nat.digits 10 n).getLast hd ≠ 0 := Nat.getLast_digit_ne_zero 10 hn
  have hlt : (Nat.digits 10 n).getLast hd < 10 :=
    Nat.digits_lt_base (by norm_num) (List.getLast_mem hd)
  intro h
  simp only [natStr, if_neg hn] at h
  have h' : (Nat.digits 10 n).reverse.map digitChar = ['0'] := by
    have hc := congrArg String.toList h
    simp only [String.toList_ofList] at hc
    rw [hc]; rfl
  have hhead : ((Nat.digits 10 n).reverse.map digitChar).head?
      = some (digitChar ((Nat.digits 10 n).getLast hd)) := by
    rw [List.head?_map, List.head?_reverse, List.getLast?_eq_some_getLast hd]
    rfl
  rw [h'] at hhead
  simp at hhead
  exact digitChar_ne_zero hlt hlast hhead.symm

theorem map_digitChar_inj {l m : List Nat} (hl : ∀ d ∈ l, d < 10) (hm : ∀ d ∈ m, d < 10)
    (h : l.map digitChar = m.map digitChar) : l = m := by
  induction l generalizing m with
  | nil => cases m <;> simp_all
  | cons a t ih =>
    cases m with
    | nil => simp at h
    | cons b s =>
      simp only [List.map_cons, List.cons.injEq] at h
      have hab : a = b := digitChar_inj (hl a (by simp)) (hm b (by simp)) h.1
      subst hab
      exact congrArg _ (ih (fun d hd => hl d (by simp [hd])) (fun d hd => hm d (by simp [hd])) h.2)

/-- **The decimal numeral determines the number.** -/
theorem natStr_injective : Function.Injective natStr := by
  intro n m h
  by_cases hn : n = 0
  · subst hn
    by_cases hm : m = 0
    · exact hm.symm
    · exact absurd (h.symm.trans (by simp [natStr])) (natStr_ne_zero_string hm)
  · by_cases hm : m = 0
    · subst hm
      exact absurd (h.trans (by simp [natStr])) (natStr_ne_zero_string hn)
    · simp only [natStr, if_neg hn, if_neg hm] at h
      have h' : (Nat.digits 10 n).reverse.map digitChar
          = (Nat.digits 10 m).reverse.map digitChar := by
        simpa using congrArg String.toList h
      have hrev : (Nat.digits 10 n).reverse = (Nat.digits 10 m).reverse :=
        map_digitChar_inj
          (fun d hd => Nat.digits_lt_base (by norm_num) (List.mem_reverse.mp hd))
          (fun d hd => Nat.digits_lt_base (by norm_num) (List.mem_reverse.mp hd)) h'
      have hdig : Nat.digits 10 n = Nat.digits 10 m := by
        simpa using congrArg List.reverse hrev
      calc n = Nat.ofDigits 10 (Nat.digits 10 n) := (Nat.ofDigits_digits 10 n).symm
        _ = Nat.ofDigits 10 (Nat.digits 10 m) := by rw [hdig]
        _ = m := Nat.ofDigits_digits 10 m

/-! `natStr` is the ordinary decimal printer — this is what pins the Lean
encoding to the `String(n)` the JavaScript side emits. -/

#guard natStr 0 == "0"
#guard natStr 1736974661 == "1736974661"
#guard (List.range 400).all (fun n => natStr n == toString n)

/-! ### Fields and the separator -/

/-- The field separator. -/
def sep : Char := '|'

theorem toList_bar : "|".toList = [sep] := by rfl

/-- A field is well formed when it does not contain the separator. -/
def SepFree (s : String) : Prop := sep ∉ s.toList

instance (s : String) : Decidable (SepFree s) := by unfold SepFree; infer_instance

/-- A decimal numeral never contains the separator. -/
theorem natStr_sepFree (n : Nat) : SepFree (natStr n) := by
  unfold SepFree natStr
  split
  · decide
  · rw [String.toList_ofList]
    intro hmem
    obtain ⟨d, hd, hdc⟩ := List.mem_map.mp hmem
    have hlt : d < 10 := Nat.digits_lt_base (by norm_num) (List.mem_reverse.mp hd)
    interval_cases d <;> simp_all [digitChar, sep]

/-- The `|`-separated join of a list of fields — exactly `fields.join("|")`. -/
def joinFields : List String → String
  | [] => ""
  | [s] => s
  | s :: rest => s ++ "|" ++ joinFields rest

theorem joinFields_toList (l : List String) :
    (joinFields l).toList = List.intercalate [sep] (l.map String.toList) := by
  induction l with
  | nil => simp [joinFields, List.intercalate]
  | cons a t ih =>
    cases t with
    | nil => simp [joinFields, List.intercalate]
    | cons b s =>
      simp only [joinFields, List.map_cons, String.toList_append, toList_bar] at *
      rw [ih]
      simp [List.intercalate, List.append_assoc]

/-- **The join is injective on separator-free fields.**  Two lists of fields,
none of which contains a `|`, joined into the same string, are the same list.
This is what makes a signature over the joined text a signature over exactly
one record. -/
theorem joinFields_injective {l m : List String} (hl : ∀ s ∈ l, SepFree s)
    (hm : ∀ s ∈ m, SepFree s) (hlne : l ≠ []) (hmne : m ≠ [])
    (h : joinFields l = joinFields m) : l = m := by
  have hl' : ∀ c ∈ l.map String.toList, sep ∉ c := by
    intro c hc
    obtain ⟨s, hs, rfl⟩ := List.mem_map.mp hc
    exact hl s hs
  have hm' : ∀ c ∈ m.map String.toList, sep ∉ c := by
    intro c hc
    obtain ⟨s, hs, rfl⟩ := List.mem_map.mp hc
    exact hm s hs
  have hsplit := congrArg (List.splitOn sep) (congrArg String.toList h)
  rw [joinFields_toList, joinFields_toList,
    List.splitOn_intercalate _ _ hl' (by simpa using hlne),
    List.splitOn_intercalate _ _ hm' (by simpa using hmne)] at hsplit
  exact List.map_injective_iff.mpr (fun _ _ hxy => String.toList_inj.mp hxy) hsplit

/-! ### Recovering the first field -/

/-- The predicate `takeWhile` runs to the end of the first field. -/
def notSep (c : Char) : Bool := c != sep

theorem takeWhile_notSep_append {v : List Char} (hv : sep ∉ v) (u : List Char) :
    (v ++ u).takeWhile notSep = v ++ u.takeWhile notSep := by
  induction v with
  | nil => simp
  | cons c t ih =>
    have hc : notSep c = true := by
      simp only [notSep, bne_iff_ne, ne_eq]
      exact fun h => hv (by simp [h])
    have ht : sep ∉ t := fun h => hv (List.mem_cons_of_mem _ h)
    simp [hc, ih ht]

theorem joinFields_cons_toList (a : String) (t : List String) :
    (joinFields (a :: t)).toList
      = a.toList ++ (if t.isEmpty then [] else sep :: (joinFields t).toList) := by
  cases t with
  | nil => simp [joinFields]
  | cons b s => simp [joinFields, toList_bar]

/-- The first field of a join is readable off the joined string. -/
theorem joinFields_head {a : String} {t : List String} (ha : SepFree a) :
    (joinFields (a :: t)).toList.takeWhile notSep = a.toList := by
  rw [joinFields_cons_toList, takeWhile_notSep_append ha]
  cases t with
  | nil => simp
  | cons b s => simp [notSep]

/-- **Domain separation.**  Two joins whose first fields differ are different
strings, whatever follows. -/
theorem joinFields_ne_of_head_ne {a b : String} {t u : List String}
    (ha : SepFree a) (hb : SepFree b) (hab : a ≠ b) :
    joinFields (a :: t) ≠ joinFields (b :: u) := by
  intro h
  apply hab
  apply String.toList_inj.mp
  rw [← joinFields_head (t := t) ha, ← joinFields_head (t := u) hb, h]

end Senate.Wire
