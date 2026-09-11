import Mathlib
import RequestProject.Solfunmeme.Onchain.Decimal
import RequestProject.Solfunmeme.Onchain.Proofs.Digits

/-!
Correctness of the decimal layer.

`Solana.Decimal.render n d` is how a raw base-unit amount is shown to a human,
and the JSON-RPC `"amount"` fields are read back by `Solana.Decimal.parse`.  The
statement that ties the two together is `parse_append_renderParts`: the integer
and fractional digit groups of `render`, concatenated, parse back to exactly the
original `Nat`.  Together with `renderParts_snd_length` — the fractional group has
exactly `decimals` digits — that says `render` loses nothing: a report can always
be read back to the raw amount it came from.
-/

namespace Solana.Decimal

open Solana.Digits

/-- `digitOf` inverts `digitChar` on genuine digits. -/
theorem digitOf_digitChar {d : Nat} (hd : d < 10) : digitOf (digitChar d) = some d := by
  interval_cases d <;> decide

/-- Rendering a whole digit list and reading it back is the identity. -/
theorem mapM_digitOf (ds : List Nat) (hlt : ∀ d ∈ ds, d < 10) :
    (ds.map digitChar).mapM digitOf = some ds := by
  induction ds with
  | nil => simp
  | cons a t ih =>
      have ha := digitOf_digitChar (hlt a (by simp))
      have ht := ih (fun d hd => hlt d (by simp [hd]))
      simp [List.mapM_cons, ha, ht]

/-- `parse` only looks at the character list of its argument. -/
theorem parse_congr {s t : String} (h : s.toList = t.toList) : parse s = parse t := by
  simp [parse, h]

/-- Leading zeros do not change the value of a big-endian numeral. -/
theorem ofDigitsBE_replicate_zero_append (base m : Nat) (ds : List Nat) :
    ofDigitsBE base (List.replicate m 0 ++ ds) = ofDigitsBE base ds := by
  induction m with
  | zero => simp
  | succ n ih =>
      rw [List.replicate_succ, List.cons_append]
      simp only [ofDigitsBE, List.foldl_cons] at *
      simpa using ih

/-- The digit list `renderParts` works from: the base-10 expansion of `n`,
left-padded with zeros to at least `decimals + 1` digits. -/
def renderDigits (n decimals : Nat) : List Nat :=
  padLeft (decimals + 1) (digitsBE 10 n)

/-- There is always at least one integer-part digit. -/
theorem renderDigits_length (n decimals : Nat) :
    decimals < (renderDigits n decimals).length := by
  simp only [renderDigits, padLeft, List.length_append, List.length_replicate]
  omega

theorem renderDigits_lt (n decimals : Nat) : ∀ d ∈ renderDigits n decimals, d < 10 := by
  intro d hd
  simp only [renderDigits, padLeft, List.mem_append, List.mem_replicate] at hd
  rcases hd with ⟨_, rfl⟩ | h
  · omega
  · exact digitsBE_lt 10 (by norm_num) n d h

/-- Padding does not change the value. -/
theorem ofDigitsBE_renderDigits (n decimals : Nat) :
    ofDigitsBE 10 (renderDigits n decimals) = n := by
  rw [renderDigits, padLeft, ofDigitsBE_replicate_zero_append]
  exact ofDigitsBE_digitsBE 10 (by norm_num) n

/-- `parse` reads back any nonempty list of genuine decimal digits. -/
theorem parse_ofList_digitChar (ds : List Nat) (hlt : ∀ d ∈ ds, d < 10) (hne : ds ≠ []) :
    parse (String.ofList (ds.map digitChar)) = some (ofDigitsBE 10 ds) := by
  simp only [parse, String.toList_ofList, mapM_digitOf ds hlt, Option.bind_eq_bind,
    Option.bind_some]
  simp [hne]

/-- `renderParts` in terms of `renderDigits`. -/
theorem renderParts_eq (n decimals : Nat) :
    renderParts n decimals =
      (String.ofList (((renderDigits n decimals).take
          ((renderDigits n decimals).length - decimals)).map digitChar),
       String.ofList (((renderDigits n decimals).drop
          ((renderDigits n decimals).length - decimals)).map digitChar)) := rfl

/-- The fractional group has exactly `decimals` digits. -/
theorem renderParts_snd_length (n decimals : Nat) :
    (renderParts n decimals).2.length = decimals := by
  rw [renderParts_eq]
  have h := renderDigits_length n decimals
  simp only [String.length_ofList, List.length_map, List.length_drop]
  omega

/-- The integer group is never empty. -/
theorem renderParts_fst_length_pos (n decimals : Nat) :
    0 < (renderParts n decimals).1.length := by
  rw [renderParts_eq]
  have h := renderDigits_length n decimals
  simp only [String.length_ofList, List.length_map, List.length_take]
  omega

/-- The two digit groups of `render`, concatenated, parse back to `n`.  In other
words `render` is a lossless presentation of the raw amount. -/
theorem parse_append_renderParts (n decimals : Nat) :
    parse ((renderParts n decimals).1 ++ (renderParts n decimals).2) = some n := by
  set ds := renderDigits n decimals with hds
  set k := ds.length - decimals with hk
  have hne : ds ≠ [] := by
    have := renderDigits_length n decimals
    rw [← hds] at this
    exact List.ne_nil_of_length_pos (by omega)
  have htl : ((renderParts n decimals).1 ++ (renderParts n decimals).2).toList
      = (ds.map digitChar) := by
    rw [renderParts_eq, String.toList_append]
    simp only [String.toList_ofList, ← hds, ← hk, ← List.map_append, List.take_append_drop]
  rw [parse_congr (t := String.ofList (ds.map digitChar)) (by simpa using htl),
    parse_ofList_digitChar ds (renderDigits_lt n decimals) hne, hds, ofDigitsBE_renderDigits]

/-- With no decimal places, `render` is literally a parseable decimal numeral. -/
theorem parse_render_zero (n : Nat) : parse (render n 0) = some n := by
  have h := parse_append_renderParts n 0
  have hf : (renderParts n 0).2 = "" := by
    have := renderParts_snd_length n 0
    exact String.ext (List.eq_nil_of_length_eq_zero (by simpa using this))
  rw [hf] at h
  simpa [render] using h

end Solana.Decimal
