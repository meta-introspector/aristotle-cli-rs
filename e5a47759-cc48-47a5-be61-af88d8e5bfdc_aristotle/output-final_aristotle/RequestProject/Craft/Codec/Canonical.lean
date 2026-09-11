/-
# Standard Proof Codec — canonical serialization, determinism, round trip

This file discharges the obligations the specification places on the canonical
layer itself:

* SOP §16 (canonical serialization): the normal form is idempotent
  (`normalize_idem`), so canonical bytes are a function of the semantics
  (`encode_congr`), and the content hash therefore is too (`hash_congr`).
* SOP §17 (round-trip requirement) for the canonical codec:
  `decode (encode v) = some (normalize v)`, hence `semantic(X) = semantic(X')`
  (`canonical_roundtrip`).
-/
import RequestProject.Craft.Codec.Value

namespace Codec
namespace CValue

/-! ## Numerals -/

theorem digitChar_toNat (d : Nat) (h : d ≤ 9) : (digitChar d).toNat = 48 + d := by
  rw [digitChar, Char.toNat_ofNat, if_pos]
  unfold Nat.isValidChar
  omega

theorem isDigitC_digitChar (d : Nat) (h : d ≤ 9) : isDigitC (digitChar d) = true := by
  simp [isDigitC, digitChar_toNat d h]
  omega

theorem decNatDigits_encNat (n : Nat) : decNatDigits (encNat n) = n := by
  unfold decNatDigits encNat
  by_cases h : n = 0
  · subst h; simp
  · simp only [if_neg h, List.map_reverse, List.reverse_reverse, List.map_map]
    have hmap : (Nat.digits 10 n).map ((fun c : Char => c.toNat - 48) ∘ digitChar)
        = Nat.digits 10 n := by
      rw [List.map_congr_left (g := id) ?_, List.map_id]
      intro d hd
      have hd9 : d ≤ 9 := by
        have := Nat.digits_lt_base (by norm_num) hd
        omega
      simp [Function.comp, digitChar_toNat d hd9]
    rw [hmap, Nat.ofDigits_digits]

theorem encNat_all_digits (n : Nat) : ∀ c ∈ encNat n, isDigitC c = true := by
  intro c hc
  unfold encNat at hc
  by_cases h : n = 0
  · subst h; simp at hc; subst hc; decide
  · rw [if_neg h] at hc
    simp only [List.mem_reverse, List.mem_map] at hc
    obtain ⟨d, hd, rfl⟩ := hc
    exact isDigitC_digitChar d (by have := Nat.digits_lt_base (by norm_num) hd; omega)

theorem encNat_ne_nil (n : Nat) : encNat n ≠ [] := by
  unfold encNat
  by_cases h : n = 0
  · simp [h]
  · simp only [if_neg h, ne_eq, List.reverse_eq_nil_iff, List.map_eq_nil_iff]
    exact Nat.digits_ne_nil_iff_ne_zero.mpr h

theorem readNat_append (n : Nat) (c : Char) (rest : List Char) (hc : isDigitC c = false) :
    readNat (encNat n ++ c :: rest) = some (n, c :: rest) := by
  have htw : (encNat n).takeWhile isDigitC = encNat n :=
    List.takeWhile_eq_self_iff.mpr (fun x hx => encNat_all_digits n x hx)
  have hdw : (encNat n).dropWhile isDigitC = [] :=
    List.dropWhile_eq_nil_iff.mpr (fun x hx => encNat_all_digits n x hx)
  unfold readNat
  simp only [List.takeWhile_append, List.dropWhile_append, htw, hdw]
  simp [List.takeWhile, hc, encNat_ne_nil n, decNatDigits_encNat]

theorem readInt_append (n : Int) (c : Char) (rest : List Char) (hc : isDigitC c = false) :
    readInt (encInt n ++ c :: rest) = some (n, c :: rest) := by
  obtain ⟨d, ds, hds⟩ : ∃ d ds, encNat n.natAbs = d :: ds := by
    cases h : encNat n.natAbs with
    | nil => exact absurd h (encNat_ne_nil _)
    | cons a as => exact ⟨a, as, rfl⟩
  have hd : isDigitC d = true := encNat_all_digits _ d (by rw [hds]; simp)
  have hdne : d ≠ '-' := by rintro rfl; simp [isDigitC] at hd
  unfold encInt
  by_cases hn : n < 0
  · rw [if_pos hn, List.cons_append, readInt]
    simp only [readNat_append n.natAbs c rest hc, Option.map_some]
    rw [Int.ofNat_natAbs_of_nonpos (le_of_lt hn)]
    simp
  · rw [if_neg hn, hds, List.cons_append, readInt]
    simp only [if_neg hdne]
    rw [show d :: (ds ++ c :: rest) = (d :: ds) ++ c :: rest from rfl, ← hds,
      readNat_append n.natAbs c rest hc]
    simp only [Option.map_some, Int.natAbs_of_nonneg (not_lt.mp hn)]

/-- Read an integer written in canonical decimal form (used by the text-based
codecs). -/
def parseIntText (t : String) : Option Int :=
  match readInt (t.toList ++ [';']) with
  | some (n, [';']) => some n
  | _ => none

theorem parseIntText_encInt (n : Int) :
    parseIntText (String.ofList (encInt n)) = some n := by
  have h : isDigitC ';' = false := by decide
  unfold parseIntText
  rw [String.toList_ofList, readInt_append n ';' [] h]
  rfl

/-- Canonical decimal text of an integer. -/
def intText (n : Int) : String := String.ofList (encInt n)

theorem parseIntText_intText (n : Int) : parseIntText (intText n) = some n :=
  parseIntText_encInt n

/-! ## Round trip of the canonical serialization (SOP §17) -/

theorem cdepth_pos (v : CValue) : 1 ≤ cdepth v := by cases v <;> simp [cdepth]

theorem decVal_enc_str (s : String) (fuel : Nat) (rest : List Char) (h : 1 ≤ fuel) :
    decVal fuel (enc (.str s) ++ rest) = some (.str s, rest) := by
  obtain ⟨f, rfl⟩ : ∃ f, fuel = f + 1 := ⟨fuel - 1, by omega⟩
  have hcol : isDigitC ':' = false := by decide
  simp only [enc, List.cons_append, List.append_assoc, decVal,
    readNat_append s.toList.length ':' (s.toList ++ rest) hcol]
  simp

/-- The canonical parser recovers exactly what the canonical serializer wrote,
leaving the remainder of the input untouched. -/
theorem decVal_enc :
    ∀ (v : CValue) (fuel : Nat) (rest : List Char), cdepth v ≤ fuel →
      decVal fuel (enc v ++ rest) = some (v, rest) := by
  have hsemi : isDigitC ';' = false := by decide
  have hcol : isDigitC ':' = false := by decide
  refine CValue.rec
    (motive_1 := fun v => ∀ fuel rest, cdepth v ≤ fuel →
      decVal fuel (enc v ++ rest) = some (v, rest))
    (motive_2 := fun xs => ∀ fuel rest, cdepthL xs ≤ fuel →
      decList fuel xs.length (encL xs ++ rest) = some (xs, rest))
    (motive_3 := fun fs => ∀ fuel rest, cdepthF fs ≤ fuel →
      decFields fuel fs.length (encF fs ++ rest) = some (fs, rest))
    (motive_4 := fun p => ∀ fuel rest, cdepth p.2 ≤ fuel →
      decVal fuel (enc p.2 ++ rest) = some (p.2, rest))
    ?null ?bool ?int ?str ?list ?obj ?nil ?cons ?fnil ?fcons ?mk
  case null =>
    intro fuel rest h
    obtain ⟨f, rfl⟩ : ∃ f, fuel = f + 1 := ⟨fuel - 1, by have := cdepth_pos (CValue.null); omega⟩
    simp [enc, decVal]
  case bool =>
    intro b fuel rest h
    obtain ⟨f, rfl⟩ : ∃ f, fuel = f + 1 := ⟨fuel - 1, by have := cdepth_pos (CValue.bool b); omega⟩
    cases b <;> simp [enc, decVal]
  case int =>
    intro n fuel rest h
    obtain ⟨f, rfl⟩ : ∃ f, fuel = f + 1 := ⟨fuel - 1, by have := cdepth_pos (CValue.int n); omega⟩
    simp only [enc, List.cons_append, List.append_assoc, List.nil_append, decVal,
      readInt_append n ';' rest hsemi]
    simp
  case str =>
    intro s fuel rest h
    exact decVal_enc_str s fuel rest (le_trans (cdepth_pos _) h)
  case list =>
    intro xs ih fuel rest h
    simp only [cdepth] at h
    obtain ⟨f, rfl⟩ : ∃ f, fuel = f + 1 := ⟨fuel - 1, by omega⟩
    have hf : cdepthL xs ≤ f := by omega
    simp only [enc, List.cons_append, List.append_assoc, decVal,
      readNat_append xs.length ':' (encL xs ++ rest) hcol, ih f rest hf]
    simp
  case obj =>
    intro fs ih fuel rest h
    simp only [cdepth] at h
    obtain ⟨f, rfl⟩ : ∃ f, fuel = f + 1 := ⟨fuel - 1, by omega⟩
    have hf : cdepthF fs ≤ f := by omega
    simp only [enc, List.cons_append, List.append_assoc, decVal,
      readNat_append fs.length ':' (encF fs ++ rest) hcol, ih f rest hf]
    simp
  case nil =>
    intro fuel rest _
    simp [encL, decList]
  case cons =>
    intro x xs ihx ihxs fuel rest h
    simp only [cdepthL, max_le_iff] at h
    simp only [encL, List.length_cons, List.append_assoc, decList,
      ihx fuel (encL xs ++ rest) h.1, ihxs fuel rest h.2]
  case fnil =>
    intro fuel rest _
    simp [encF, decFields]
  case fcons =>
    rintro ⟨k, v⟩ fs ihp ihfs fuel rest h
    simp only [cdepthF, max_le_iff] at h
    have h1 : 1 ≤ fuel := le_trans (cdepth_pos v) h.1
    simp only [encF, List.length_cons, List.append_assoc,
      decFields, decVal_enc_str k fuel (enc v ++ (encF fs ++ rest)) h1,
      ihp fuel (encF fs ++ rest) h.1, ihfs fuel rest h.2]
  case mk =>
    rintro k v ih fuel rest h
    exact ih fuel rest h

/-- The fuel needed by the parser never exceeds the length of the input. -/
theorem cdepth_le_enc_length : ∀ v : CValue, cdepth v ≤ (enc v).length := by
  refine CValue.rec
    (motive_1 := fun v => cdepth v ≤ (enc v).length)
    (motive_2 := fun xs => cdepthL xs ≤ (encL xs).length)
    (motive_3 := fun fs => cdepthF fs ≤ (encF fs).length)
    (motive_4 := fun p => cdepth p.2 ≤ (enc p.2).length)
    ?null ?bool ?int ?str ?list ?obj ?nil ?cons ?fnil ?fcons ?mk
  case null => simp [cdepth, enc]
  case bool => intro b; cases b <;> simp [cdepth, enc]
  case int => intro n; simp [cdepth, enc]
  case str => intro s; simp [cdepth, enc]
  case list => intro xs ih; simp only [cdepth, enc, List.length_cons, List.length_append]; omega
  case obj => intro fs ih; simp only [cdepth, enc, List.length_cons, List.length_append]; omega
  case nil => simp [cdepthL, encL]
  case cons =>
    intro x xs ihx ihxs
    simp only [cdepthL, encL, List.length_append, max_le_iff]
    omega
  case fnil => simp [cdepthF, encF]
  case fcons =>
    rintro ⟨k, v⟩ fs ihp ihfs
    simp only [cdepthF, encF, List.length_append, max_le_iff] at *
    omega
  case mk => rintro k v ih; exact ih

/-- The canonical codec decodes what it encodes, up to normalization. -/
theorem decode_enc (v : CValue) : decode (enc v) = some v := by
  unfold decode
  have h := decVal_enc v (enc v).length [] (cdepth_le_enc_length v)
  rw [List.append_nil] at h
  rw [h]

/-! ## Normalization is idempotent (SOP §16: deterministic serialization) -/

/-- Field lists in normal form are strictly sorted by key. -/
def SortedF (fs : List (String × CValue)) : Prop :=
  List.Pairwise (fun a b : String × CValue => a.1 < b.1) fs

theorem mem_insertField {k : String} {v : CValue} {fs : List (String × CValue)}
    {p : String × CValue} (h : p ∈ insertField k v fs) : p = (k, v) ∨ p ∈ fs := by
  induction fs with
  | nil => simp [insertField] at h; exact Or.inl h
  | cons q r ih =>
      obtain ⟨k', v'⟩ := q
      unfold insertField at h
      by_cases h1 : k = k'
      · rw [if_pos h1] at h
        rcases List.mem_cons.mp h with h2 | h2
        · exact Or.inl h2
        · exact Or.inr (List.mem_cons_of_mem _ h2)
      · rw [if_neg h1] at h
        by_cases h2 : k < k'
        · rw [if_pos h2] at h
          rcases List.mem_cons.mp h with h3 | h3
          · exact Or.inl h3
          · exact Or.inr h3
        · rw [if_neg h2] at h
          rcases List.mem_cons.mp h with h3 | h3
          · exact Or.inr (by simp [h3])
          · rcases ih h3 with h4 | h4
            · exact Or.inl h4
            · exact Or.inr (List.mem_cons_of_mem _ h4)

theorem sortedF_insertField {k : String} {v : CValue} {fs : List (String × CValue)}
    (h : SortedF fs) : SortedF (insertField k v fs) := by
  induction fs with
  | nil => simp [insertField, SortedF]
  | cons q r ih =>
      obtain ⟨k', v'⟩ := q
      rw [SortedF, List.pairwise_cons] at h
      unfold insertField
      by_cases h1 : k = k'
      · rw [if_pos h1, SortedF, List.pairwise_cons]
        exact ⟨fun b hb => by simpa [h1] using h.1 b hb, h.2⟩
      · rw [if_neg h1]
        by_cases h2 : k < k'
        · rw [if_pos h2, SortedF, List.pairwise_cons]
          refine ⟨?_, by rw [← SortedF, SortedF, List.pairwise_cons]; exact ⟨h.1, h.2⟩⟩
          intro b hb
          rcases List.mem_cons.mp hb with rfl | hb'
          · exact h2
          · exact lt_trans h2 (h.1 b hb')
        · rw [if_neg h2, SortedF, List.pairwise_cons]
          have hlt : k' < k := by
            rcases lt_trichotomy k k' with h3 | h3 | h3
            · exact absurd h3 h2
            · exact absurd h3 h1
            · exact h3
          refine ⟨?_, ih h.2⟩
          intro b hb
          rcases mem_insertField hb with rfl | hb'
          · exact hlt
          · exact h.1 b hb'

theorem sortedF_normalizeF : ∀ fs : List (String × CValue), SortedF (normalizeF fs) := by
  intro fs
  induction fs with
  | nil => simp [normalizeF, SortedF]
  | cons p r ih =>
      obtain ⟨k, v⟩ := p
      rw [normalizeF]
      exact sortedF_insertField ih

theorem insertField_of_lt {k : String} {v : CValue} {l : List (String × CValue)}
    (h : ∀ q ∈ l, k < q.1) : insertField k v l = (k, v) :: l := by
  cases l with
  | nil => simp [insertField]
  | cons q r =>
      obtain ⟨k', v'⟩ := q
      have hlt : k < k' := h (k', v') (by simp)
      unfold insertField
      rw [if_neg (ne_of_lt hlt), if_pos hlt]

theorem normalizeF_of_normal {gs : List (String × CValue)} (hs : SortedF gs)
    (hv : ∀ p ∈ gs, normalize p.2 = p.2) : normalizeF gs = gs := by
  induction gs with
  | nil => simp [normalizeF]
  | cons p r ih =>
      obtain ⟨k, v⟩ := p
      rw [SortedF, List.pairwise_cons] at hs
      rw [normalizeF, ih (by rw [SortedF]; exact hs.2) (fun q hq => hv q (by simp [hq])),
        hv (k, v) (by simp)]
      exact insertField_of_lt hs.1

theorem normalizeL_of_normal {xs : List CValue} (hv : ∀ x ∈ xs, normalize x = x) :
    normalizeL xs = xs := by
  induction xs with
  | nil => simp [normalizeL]
  | cons x r ih =>
      rw [normalizeL, hv x (by simp), ih (fun y hy => hv y (by simp [hy]))]

/-- The canonical normal form is idempotent, so canonical serialization is a
function of the semantics of a value (SOP §16). -/
theorem normalize_idem : ∀ v : CValue, normalize (normalize v) = normalize v := by
  refine CValue.rec
    (motive_1 := fun v => normalize (normalize v) = normalize v)
    (motive_2 := fun xs => ∀ x ∈ normalizeL xs, normalize x = x)
    (motive_3 := fun fs => ∀ p ∈ normalizeF fs, normalize p.2 = p.2)
    (motive_4 := fun p => normalize (normalize p.2) = normalize p.2)
    ?null ?bool ?int ?str ?list ?obj ?nil ?cons ?fnil ?fcons ?mk
  case null => simp [normalize]
  case bool => intro b; simp [normalize]
  case int => intro n; simp [normalize]
  case str => intro s; simp [normalize]
  case list =>
    intro xs ih
    rw [normalize, normalize, normalizeL_of_normal ih]
  case obj =>
    intro fs ih
    rw [normalize, normalize, normalizeF_of_normal (sortedF_normalizeF fs) ih]
  case nil => intro x hx; simp [normalizeL] at hx
  case cons =>
    intro x xs ihx ihxs y hy
    rw [normalizeL] at hy
    rcases List.mem_cons.mp hy with rfl | hy'
    · exact ihx
    · exact ihxs y hy'
  case fnil => intro p hp; simp [normalizeF] at hp
  case fcons =>
    rintro ⟨k, v⟩ fs ihp ihfs p hp
    rw [normalizeF] at hp
    rcases mem_insertField hp with rfl | hp'
    · exact ihp
    · exact ihfs p hp'
  case mk => rintro k v ih; exact ih

/-! ## Normalization and field lookup -/

theorem get?_nil (k : String) : (CValue.obj []).get? k = none := rfl

theorem get?_cons (k' : String) (v' : CValue) (r : List (String × CValue)) (k : String) :
    (CValue.obj ((k', v') :: r)).get? k = if k' = k then some v' else (CValue.obj r).get? k := by
  by_cases h : k' = k <;> simp [get?, h]

theorem get?_insertField (a : String) (w : CValue) (l : List (String × CValue)) (k : String) :
    (CValue.obj (insertField a w l)).get? k =
      if a = k then some w else (CValue.obj l).get? k := by
  induction l with
  | nil => simp [insertField, get?_cons, get?_nil]
  | cons q r ih =>
      obtain ⟨k', v'⟩ := q
      unfold insertField
      by_cases h1 : a = k'
      · subst h1
        rw [if_pos rfl, get?_cons, get?_cons]
        by_cases h : a = k <;> simp [h]
      · rw [if_neg h1]
        by_cases h2 : a < k'
        · rw [if_pos h2, get?_cons]
        · rw [if_neg h2, get?_cons, get?_cons, ih]
          by_cases hk : k' = k
          · subst hk
            simp [h1]
          · simp [hk]

/-- Normalization commutes with field lookup: a normalized object has exactly
the same fields, with normalized values. -/
theorem get?_normalize (v : CValue) (k : String) :
    (normalize v).get? k = (v.get? k).map normalize := by
  cases v with
  | obj fs =>
      rw [normalize]
      induction fs with
      | nil => simp [normalizeF, get?_nil]
      | cons q r ih =>
          obtain ⟨k', v'⟩ := q
          rw [normalizeF, get?_insertField, get?_cons, ih]
          by_cases h : k' = k <;> simp [h]
  | _ => simp [normalize, get?]

/-- Semantically equal values agree, field by field, up to normalization. -/
theorem semEq_get? {a b : CValue} (h : semEq a b) (k : String) :
    (a.get? k).map normalize = (b.get? k).map normalize := by
  rw [← get?_normalize, ← get?_normalize, semEq] at *
  rw [h]

/-! ## Consequences: determinism, hashing, round trip -/

/-- Semantically equal values have identical canonical bytes (SOP §16). -/
theorem encode_congr {a b : CValue} (h : semEq a b) : encode a = encode b := by
  unfold encode
  rw [h]

/-- Semantically equal values have the same content hash (SOP §16). -/
theorem hash_congr {a b : CValue} (h : semEq a b) : hash a = hash b := by
  unfold hash
  rw [encode_congr h]

theorem encode_normalize (v : CValue) : encode (normalize v) = encode v := by
  unfold encode
  rw [normalize_idem]

/-- Canonical round trip (SOP §17): decoding the canonical encoding of a value
returns a value with the same semantics. -/
theorem canonical_roundtrip (v : CValue) :
    ∃ w, decode (encode v) = some w ∧ semEq w v := by
  refine ⟨normalize v, decode_enc (normalize v), ?_⟩
  unfold semEq
  exact normalize_idem v

/-- Decoding the canonical serialization returns the normal form. -/
theorem deserialize_serialize_eq (v : CValue) :
    deserialize (serialize v) = some (normalize v) := by
  unfold deserialize serialize
  rw [String.toList_ofList]
  exact decode_enc (normalize v)

/-- String-level canonical round trip. -/
theorem deserialize_serialize (v : CValue) :
    ∃ w, deserialize (serialize v) = some w ∧ semEq w v := by
  unfold deserialize serialize
  rw [String.toList_ofList]
  exact canonical_roundtrip v

end CValue
end Codec
